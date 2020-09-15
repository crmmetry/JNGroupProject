public with sharing class TrackLeadCallsController implements Queueable {
    public void execute(QueueableContext context) {
        Map<Id,Lead> mappedLeadsToUpdate = new Map<Id,Lead>();
        List<Lead> leads = [SELECT Id, Assignment_Timestamp__c FROM Lead WHERE Disqualified_Flag = false AND Disqualified_Timestamp = null]; 
        mappedLeadsToUpdate = updateDisqualifiedLeads(leads);
        try{
            if(!mappedLeadsToUpdate.isEmpty()){
                update mappedLeadsToUpdate.values();
            }
        }catch(Exception e) {

        }
    }

    private Map<Id,Lead> updateDisqualifiedLeads(List<Lead> leads){
        Map<Id,Lead> mappedLeads = new Map<Id,Lead>();
        Map<Id,Lead> mappedDisqualifiedLeads = new Map<Id, Lead>();
        Boolean validAssignmentTime;
        Map<Lead,Integer> mappedCalls = new Map<Lead,Integer>();
        for(Lead leadRecord : leads){
            mappedLeads.put(leadRecord.Id, leadRecord);
        }
        for(AggregateResult ar: [SELECT Result__c, WhoId, count(Id)numberOfCalls 
                                FROM Task GROUP BY WHoId,Result__c HAVING WhoId 
                                IN :mappedLeads.keySet() AND Result__C IN ('No Contact','No Contact - Left Voicemail',null)
                                AND numberOfCalls >= 3]) {
            Id leadId = (Id)ar.get('WhoId');
            Lead disqualifiedLead = mappedLeads.get(leadId);
            validAssignmentTime = Util.LeadWithinTimeLimit(8, disqualifiedLead.Assignment_Timestamp__c, System.now(), 'JN Default Business Hours');
            if(validAssignmentTime == false){
                disqualifiedLead.Disqualified_Flag__c = true;
                disqualifiedLead.Disqualified_Timestamp__c = Datetime.now();
                mappedDisqualifiedLeads.put(leadId, disqualifiedLead);
            }
        }

        return mappedDisqualifiedLeads;
    }
}
