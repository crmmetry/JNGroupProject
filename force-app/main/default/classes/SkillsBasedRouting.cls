Global class SkillsBasedRouting {
    public static final String TAG = 'SkillsBasedRouting';

    private static Map<Id,Skill> getSkills(List<String> locations) {
        return new Map<Id, Skill>([Select Id From Skill Where MasterLabel in :locations]);
    }

    private static PriorityQueue getLocations(String leadLocation, List<Worker> workers){
        PriorityQueue pq = new PriorityQueue(new SkillComparator(), SkillsBasedRouting.Worker.class);
        System.debug('All Workers: ' + workers);
        for(Worker record: workers){          
            if(leadLocation.equals(record.location)){
                pq.offer(record);   
            }
        }
        return pq;
    }
    public static void routeUsingSkillsTier2(List<Lead> leads) {
        //PriorityQueue pq = new PriorityQueue(new SkillComparator(), Worker.class);
        List<String> locations = new List<String>();
        List<Lead> selectedLeads = new List<Lead>();
        String salesTeam = 'Sales Team';
        Group salesDevQueue = [SELECT Id FROM Group WHERE Type='Queue' AND Name=:salesTeam];
        for(Lead record: leads){
            if(record.OwnerId.equals(salesDevQueue.Id)){
                if(record.Escalate_to_Tier2__c == True){
                    System.debug(TAG + ' Lead Selected for tier 2 routing');
                    selectedLeads.add(record);
                    record.Time_Escalated_to_Tier_2__c = Date.today();
                    locations.add(record.Preferred_Location__c);     
                }
            }
        }
        
        // if(locations.size() >= 1){
        
        // get all skills that match preferred location
        Map<Id, Skill> mappedSkills = getSkills(locations);
        List<Id> userIds = new List<Id>();
        Set<Id> skilledUsers = new Set<Id>(); //users found with the skill
        List<Worker> workers = new  List<Worker>();
        for(GroupMember record: [SELECT 
                                 UserOrGroupId FROM GroupMember 
                                 WHERE Group.Name = :salesTeam 	
                                 AND Group.Type = 'Queue']){
                                     System.debug(TAG + ' User is a tier 2 member');
                                     userIds.add(record.UserOrGroupId);
                                 }
        
        //get all service resource with associated users hascode
        Map<String,Worker> mappedLocationSkills = new Map<String,Worker>();
        String generatedHash;
        for(serviceresource record: [SELECT Id,RelatedRecordId,
                                     (SELECT SkillId,Skill.MasterLabel FROM ServiceResourceSkills WHERE SKill.Id in:mappedSkills.keySet()) 
                                     FROM serviceresource WHERE RelatedRecordId IN :userIds]){
                                         System.debug(record.RelatedRecordId + ' User is a matched skilled tier 2 member');
                                         skilledUsers.add(record.RelatedRecordId);
                                         
                                         for(ServiceResourceSkill skillRecord: record.ServiceResourceSkills){
                                             System.debug('------ServiceResourceSkill-----');
                                             generatedHash = Util.GenerateHash(new List<String>{record.RelatedRecordId, skillRecord.Skill.MasterLabel});
                                             mappedLocationSkills.put(generatedHash, new Worker(record.RelatedRecordId, 0, skillRecord.Skill.MasterLabel));
                                         }
                                     }
        
        //aggregate leads by service resource user id   
        Integer total;
        String userID,location;
        System.debug('Skilled Workers: ' +skilledUsers );
        System.debug('Skilled Locations: ' +locations );
        for(AggregateResult record: [SELECT COUNT(Id) total,Preferred_Location__c,OwnerId FROM Lead
                                     WHERE Preferred_Location__c IN :locations
                                     AND OwnerId IN :skilledUsers
                                     GROUP BY OwnerId,Preferred_Location__c ORDER BY COUNT(Id)]){
                                         total = (Integer)record.get('total');
                                         userID = (String)record.get('OwnerId');
                                         location = (String)record.get('Preferred_Location__c');                                         
                                         generatedHash = Util.GenerateHash(new List<String>{userID, location});
                                         if(mappedLocationSkills.containsKey(generatedHash)){
                                             mappedLocationSkills.get(generatedHash).setWorkLoad(total);
                                         }
                                         System.debug(TAG + ' Worker ' + new Worker(userId, total, location));
                                     }
        
        //add all the workers
        workers.addAll(mappedLocationSkills.values());
        
        //assign the selected leads if aggregations were found
        String leadLocation;
        PriorityQueue pq;
        Worker selectedWorker;
        if(workers.size() > 0) {           
            for(Lead selectedLead: selectedLeads) { //can optimize by using a set
                leadLocation = selectedLead.Preferred_Location__c;
                //search aggregate results to match the best record based on lowest capacity and actual location
                pq = getLocations(leadLocation, workers);
                if(pq.size() > 0){                    
                    selectedWorker = (Worker)pq.poll();
                    System.debug(TAG + ' Found work ' + selectedWorker);
                    selectedWorker.updateWorkLoad();
                    //update lead with owner id , who has the least amount of work
                    selectedLead.OwnerId = selectedWorker.userId;   
                }
            }            
        } 
        //}
    }

    class Worker implements Comparable {
        public Id userId;
        public Integer workLoad;
        public String location;
        public Worker(Id userId, Integer workLoad,String location){
            this.location = location;            
            this.workLoad = workLoad;
            this.userId = userId;
        }
        public void updateWorkLoad(){
            this.workLoad = this.workLoad + 1;
        }
        public void setWorkLoad(Integer value){
            this.workLoad = value;
        }
        public Integer compareTo(Object work) {
            if(workLoad < ((Worker)work).workLoad) return -1;
            else if(workLoad > ((Worker)work).workLoad) return 1;
            return 0;
        }
    }
    class SkillComparator implements Comparator { 
        public Integer compare(Object a, Object b){
            return ((worker)a).compareTo((worker)b);            
        }             
    } 
}