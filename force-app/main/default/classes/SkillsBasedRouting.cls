Global class SkillsBasedRouting {
    public static void routeUsingSkillsTier1(Set<Id> leads) {
        //get Sales Development queue id
        Group salesDevQueue = [SELECT Id FROM Group WHERE Type='Queue' AND Name='Sales Development Team'];
        for (Lead leadObj : [SELECT Id, Preferred_Location__c,OwnerId FROM Lead 
                             WHERE Id in :leads AND OwnerID =:salesDevQueue.Id]) {
                                 PendingServiceRouting pendingSrvRouting = new PendingServiceRouting(
                                     CapacityWeight = 1,
                                     IsReadyForRouting = FALSE,
                                     RoutingModel  = 'LeastActive',
                                     RoutingPriority = 1,
                                     RoutingType = 'SkillsBased',
                                     ServiceChannelId = getChannelId('New_lead'),
                                     WorkItemId = leadObj.Id
                                 );
                                 System.debug('JNSkillsRouting' + pendingSrvRouting);
                                 INSERT pendingSrvRouting;
                                 pendingSrvRouting = [SELECT Id, IsReadyForRouting FROM 
                                                      PendingServiceRouting WHERE Id = :pendingSrvRouting.id];
                                 
                                 // Now add SkillRequirement(s)
                                 SkillRequirement srObj = new SkillRequirement(
                                     RelatedRecordId = pendingSrvRouting.id,
                                     SkillId = getSkillId(leadObj.Preferred_Location__c ),
                                     SkillLevel = 1
                                 );
                                 insert srObj;
                                 System.debug('Current Skill: ' + srObj);
                                 // Update PendingServiceRouting as IsReadyForRouting
                                 pendingSrvRouting.IsReadyForRouting = TRUE;
                                 update pendingSrvRouting;
                                 
                             }
        return;
    }
    
    private static String getChannelId(String channelName) {
        ServiceChannel channel = [Select Id From ServiceChannel Where DeveloperName = :channelName];
        return channel.Id;
    }
    
    private static String getSkillId(String preferedLocation) {
        Skill skill = [Select Id From Skill Where MasterLabel = :preferedLocation];
        return skill.Id;
    }
    private static Map<Id,Skill> getSkills(List<String> locations) {
        return new Map<Id, Skill>([Select Id From Skill Where MasterLabel in :locations]);
    }
    private static String getQueueId(String name) {
        return [select Id,Name from Group where  Type = 'Queue' AND NAME = :name].Id;
        
    }
    private static void getLocations(String leadLocation,AggregateResult[] aggregateRecords){
        for(AggregateResult record: aggregateRecords){
            Integer total = (Integer)record.get('total');
            String ownerId = (String)record.get('ownerid');
            String location = (String)record.get('Preferred_Location__c');
            if(leadLocation.equals(location)){
                Worker work = new Worker(ownerId, total,location);
            }
        }
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
                    selectedLeads.add(record);
                    locations.add(record.Preferred_Location__c);     
                }
            }
        }
        /*for(Lead record: [SELECT Id, Preferred_Location__c,OwnerId FROM Lead 
                          WHERE Id in :leads AND OwnerID =:salesDevQueue.Id
                          AND Escalate_to_Tier2__c = TRUE]){
                              locations.add(record.Preferred_Location__c);                                     
                          }*/
        
        
        // get all skills that match preferred location
        Map<Id, Skill> mappedSkills = getSkills(locations);
        List<Id> userIds = new List<Id>();
        Map<Id,List<String>> mappedIDLocations = new Map<Id,List<String>>();
        for(GroupMember record: [SELECT 
                                 UserOrGroupId FROM GroupMember 
                                 WHERE Group.Name = :salesTeam 	
                                 AND Group.Type = 'Queue']){
                                     userIds.add(record.UserOrGroupId);
                                 }
        
        //get all service resource with associated users
        for(serviceresource record: [select id,RelatedRecordId,
                                     (Select SkillId from ServiceResourceSkills 
                                      where id in:mappedSkills.keySet()) 
                                     from serviceresource 
                                     where RelatedRecordId 
                                     in :userIds]){
                                         for(ServiceResourceSkill skilRecord: record.ServiceResourceSkills){
                                             if(mappedIDLocations.containsKey(record.RelatedRecordId)){
                                                 List<String> records = mappedIDLocations.get(record.RelatedRecordId);
                                                 records.add(skilRecord.Id);
                                                 mappedIDLocations.put(record.RelatedRecordId,records);
                                             } else {
                                                 mappedIDLocations.put(record.RelatedRecordId, new List<String>());
                                             }
                                         }
                                     }
        //aggregate leads by service resource user id
        
        AggregateResult[] aggregateRecords = [select count(id) total,Preferred_Location__c from lead where Preferred_Location__c in :locations
                                              and ownerId in:mappedIDLocations.keySet()
                                              group by ownerid,Preferred_Location__c order by count(id)];
        if(aggregateRecords.size() > 0){
            AggregateResult record;
            Integer minTotal;
            String ownerId;
            String location;
            for(Lead leadRecord: leads) {
                String leadLocation = leadRecord.Preferred_Location__c;
                for(Integer i = 0; i <aggregateRecords.size();i++ ){
                        record = aggregateRecords[i];
                        minTotal = (Integer)record.get('total');
                        ownerId = (String)record.get('ownerid');
                        location = (String)record.get('Preferred_Location__c');
                        if(leadLocation.equals(location)){
                            
                        }
                     
                    if((Integer)record.get('total') < minTotal ){
                        minTotal = (Integer)record.get('total');
                        ownerId = (String)record.get('ownerid');
                    }
                }
            }
        }
        
                                 
        //update lead with owner id , who has the least amount of work
       // Worker selectedWorker = (Worker)pq.poll();
        
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

        public Integer compareTo(Object work) {
            if(workLoad < ((Worker)work).workLoad) return -1;
            else if(workLoad > ((Worker)work).workLoad) return 1;
            return 0;
        }
    }
    class SkillComparator implements Comparator{ 
        public Integer compare(Object a, Object b){
            return ((worker)a).compareTo(((worker)b));            
        }             
    } 
}