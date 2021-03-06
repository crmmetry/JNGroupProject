trigger NewOpportunityTrigger on Opportunity (before insert, after insert,after update, before update) {
    OpportunityTriggerHandler.init(Trigger.new, Trigger.oldMap);
    Set<id> oppid = new set<id>(); 
    if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            for(Opportunity opp : Trigger.new){
                oppid.add(opp.ID);
            } 
        } else {
            OpportunityTriggerHandler.lockRecordsForEditing();
        }
    } else if( Trigger.isInsert) {
         System.debug('NewOpportunityTrigger');
        if(Trigger.isAfter) {
            for(Opportunity opp : Trigger.new){
                oppid.add(opp.ID);
            }       
        } else if(Trigger.isBefore){
                  System.debug('NewOpportunityTrigger BEFPRE');
            OpportunityTriggerHandler.assignOpportunityRecordTypeName(); 
        }
    }
    OpportunityTriggerHandler.setOpportunityAmountOnLead(Trigger.isAfter, Trigger.isUpdate, Trigger.isInsert);
    /*if(oppid.size()>0){ //NEED TO SYNC WITH DEVS
         if(CreditScoreHelper.FirstRun)
            return;
        System.debug('CreditScore called=====>');
        CreditScoreHelper cs = new CreditScoreHelper();
        cs.CreditScoreFromOpp(oppid);
    }*/
}