public with sharing class TrackLeadCallsController implements Queueable {
    public static final String TAG = 'TrackLeadCallsController';
    public void execute(QueueableContext context) {
        Map<Id,Lead> mappedLeadsToUpdate = new Map<Id,Lead>();
        List<Lead> leads = [SELECT Id, Assignment_Timestamp__c FROM Lead WHERE Disqualified_Flag__C = false AND Disqualified_Timestamp__c = null]; 
        mappedLeadsToUpdate = updateDisqualifiedLeads(leads);
        try{
            if(!mappedLeadsToUpdate.isEmpty()){
                update mappedLeadsToUpdate.values();
            }
        }catch(Exception e) {
            System.debug(TAG + ' ' + e.getMessage());
        }

        Id jobID = System.enqueueJob(new TrackLeadCallsController());
    }

    // private Map<Id,Lead> updateDisqualifiedLeads(List<Lead> leads){
    //     Map<Id,Lead> mappedLeads = new Map<Id,Lead>();
    //     Map<Id,Lead> mappedDisqualifiedLeads = new Map<Id, Lead>();
    //     Boolean validAssignmentTime;
    //     Map<Lead,Integer> mappedCalls = new Map<Lead,Integer>();
    //     for(Lead leadRecord : leads){
    //         mappedLeads.put(leadRecord.Id, leadRecord);
    //     }
    //     for(AggregateResult ar: [SELECT Result__c, WhoId, count(Id)numberOfCalls 
    //                             FROM Task GROUP BY WHoId,Result__c HAVING WhoId 
    //                             IN :mappedLeads.keySet() AND Result__C IN ('No Contact','No Contact - Left Voicemail',null)
    //                             AND numberOfCalls >= 3]) {
    //         Id leadId = (Id)ar.get('WhoId');
    //         Lead disqualifiedLead = mappedLeads.get(leadId);
    //         validAssignmentTime = Util.LeadWithinTimeLimit(8, disqualifiedLead.Assignment_Timestamp__c, System.now(), 'JN Default Business Hours');
    //         if(validAssignmentTime == false){
    //             disqualifiedLead.Disqualified_Flag__c = true;
    //             disqualifiedLead.Disqualified_Timestamp__c = Datetime.now();
    //             mappedDisqualifiedLeads.put(leadId, disqualifiedLead);
    //         }
    //     }

    //     return mappedDisqualifiedLeads;
    // }

    private Map<Id,Lead> updateDisqualifiedLeads(List<Lead> leads){
        Integer hours = 8;
        String bhName = 'JN Default Business Hours';
        Map<Id,Lead> mappedLeads = new Map<Id,Lead>();
        Map<Id,Lead> mappedDisqualifiedLeads = new Map<Id, Lead>();
        Map<Id, Lead> mappedLeadsWithTask = new Map<Id,Lead>();
        //Map<Id, Lead> mappedLeadsWithNoTask = new Map<Id,Lead>();
        Boolean validAssignmentTime;
        //Map<Lead,Integer> mappedCalls = new Map<Lead,Integer>();
        for(Lead leadRecord : leads){
            mappedLeads.put(leadRecord.Id, leadRecord);
        }
        List<AggregateResult> ar = [SELECT Result__c, WhoId, count(Id)numberOfCalls 
                                     FROM Task GROUP BY WhoId,Result__c HAVING WhoId 
                                     IN :mappedLeads.keySet() AND Result__C IN ('No Contact','No Contact - Left Voicemail',null)];
        for(AggregateResult record: ar){
            Lead leadWithTask = mappedLeads.get((Id)record.get('WhoId'));
            mappedLeadsWithTask.put(leadWithTask.Id, leadWithTask); 
            validAssignmentTime = Util.LeadWithinTimeLimit(hours, leadWithTask.Assignment_Timestamp__c, System.now(), bhName);
            if(validAssignmentTime && (Integer)record.get('numberOfCalls') >= 3){
                leadWithTask.Disqualified_Flag__c = true;
                leadWithTask.Disqualified_Timestamp__c = Datetime.now();
                mappedDisqualifiedLeads.put(leadWithTask.Id, leadWithTask);
            }            
        }
        for(Id id : mappedLeads.keySet()){
            if(!mappedLeadsWithTask.containsKey(id)){
                Lead leadWithNoTask = mappedLeads.get(id);
                validAssignmentTime = Util.LeadWithinTimeLimit(hours, leadWithNoTask.Assignment_Timestamp__c, System.now(), bhName);
                if(validAssignmentTime){
                    leadWithNoTask.Disqualified_Flag__c = true;
                    leadWithNoTask.Disqualified_Timestamp__c = Datetime.now();
                    mappedDisqualifiedLeads.put(leadWithNoTask.Id, leadWithNoTask);
                }   
            }
        }                    
    return mappedDisqualifiedLeads;
    }
}
