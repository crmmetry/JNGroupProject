trigger NewOpportunityTrigger on Opportunity (before insert, after insert,after update, before update) {

        OpportunityTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
        System.debug('System debug opport');
        Set<id> oppid = new set<id>(); 
        if(Trigger.isUpdate) {
            if(Trigger.isAfter) {
                for(Opportunity opp : Trigger.new){
                    oppid.add(opp.ID);
                }
            } else {
                System.debug('Before updating opportunity');
                OpportunityTriggerHandler.lockRecordsForEditing();
                OpportunityTriggerHandler.assignOpportunityRecordTypeName();
                //OpportunityTriggerHandler.validateApplicantProfileCompletion();
                OpportunityTriggerHandler.validateCloseBackDate(2, 7, System.now());
                OpportunityTriggerHandler.ProductsFamiliyValidation();
            }
        } else if( Trigger.isInsert) {
            if(Trigger.isAfter) {
                for(Opportunity opp : Trigger.new){
                    oppid.add(opp.ID);
                }       
            } else if(Trigger.isBefore){
                OpportunityTriggerHandler.assignOpportunityRecordTypeName();
            }
        }
        OpportunityTriggerHandler.setOpportunityAmountOnLead(Trigger.isAfter, Trigger.isUpdate, Trigger.isInsert);// causing last contact made issues
        /*if(oppid.size()>0){
            if(CreditScoreHelper.FirstRun)
                return;
            CreditScoreHelper cs = new CreditScoreHelper();
            cs.CreditScoreFromOpp(oppid);
        }*/
    
}