global with sharing class LeadTierConversion implements Schedulable {
    global LeadTierConversion() {
        //get Sales Development queue id
        Group queueGroup = [SELECT Id FROM Group WHERE Type='Queue' AND Name='Sales Development Team'];
        //query leads that are tier 1 and not converted
        Map<Id, Lead> leads = new Map<Id, Lead> ([SELECT Id,Last_Contact_Made__c,
                                                  Time_Escalated_tier_one__c,Status
                                                  FROM Lead 
                                                  WHERE IsConverted = False AND OwnerId = :queueGroup.Id
                                                  AND LeadSource in ('Online Application Form','Lead Portal')]);
        //next get elapsed time 
        Map<Id,Long> elapsedHours = new Map<Id,Long>();
        DateTime currentTimeStamp = DateTime.now();
        Map<String, Long> times;
        Set<id> leadsToUpdate = new Set<Id>();
         String tierOne5Uncontacted ='5 Days old';
        
        for(Lead record: leads.values()) {
            if(record.Time_Escalated_tier_one__c == null){
                record.Time_Escalated_tier_one__c = currentTimeStamp; // update lead
                leadsToUpdate.add(record.Id);
            }
            if(record.Last_Contact_Made__c == null){
                times = calculateTimeDiff(record.Time_Escalated_tier_one__c, currentTimeStamp);
                elapsedHours.put(record.Id, times.get('hours'));     
            } 
            else if(record.Last_Contact_Made__c != null){
                times = calculateTimeDiff(record.Time_Escalated_tier_one__c, currentTimeStamp);
                if(times.get('days') >= 5 && record.Status != 'Qualified'){
                    record.Status = 'Disqualified';
                    record.SLA_Violation__c = tierOne5Uncontacted;
                    leadsToUpdate.add(record.Id);
                }
                if(record.Status == 'Qualified'){
                    record.Escalate_to_Tier2__c = true;
                    record.User_who_Converted__c = record.OwnerId;
                    record.Time_Escalated_to_Tier_2__c = Datetime.now();
                    leadsToUpdate.add(record.Id);
                                       
                }
            }
        }
        // some leads were not contacted
        Lead record;
        String tierOne24Uncontacted ='Tier 1 - 24 Hours';
        String tierOne36Uncontacted ='Tier 1 - 36 hours';
        if(elapsedHours.size() > 0){
            Long elapsed;
            for(Id recordId: elapsedHours.keySet()){
                record = leads.get(recordId);
                elapsed = elapsedHours.get(recordId);
                if(elapsed >= 36 && record.SLA_Violation__c == tierOne24Uncontacted){
                    record.SLA_Violation__c = tierOne36Uncontacted;
                    leadsToUpdate.add(record.Id);
                } else if(elapsed >= 24){
                    record.SLA_Violation__c = tierOne24Uncontacted;
                    leadsToUpdate.add(record.Id);                    
                }
                
            }
        }
    }
    global void execute(SchedulableContext ctx){
        //query leads here
    }
    
    private Map<String, Long> calculateTimeDiff(DateTime d1, DateTime d2) {
        Long dt1Long = d1.getTime();
        Long dt2Long = d2.getTime();
        Long milliseconds = dt2Long - dt1Long;
        Map<String, Long> times = new Map<String, Long>();
        times.put('seconds', milliseconds / 1000);
        times.put('minutes', times.get('seconds') / 60);
        times.put('hours', times.get('minutes') / 60);
        times.put('days', times.get('hours') / 24);
        return times;
    }
    
}