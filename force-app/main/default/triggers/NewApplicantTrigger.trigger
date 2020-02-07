trigger NewApplicantTrigger on Applicant__c (before insert, After insert, before update, after update, before delete) {
    ApplicantTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.old);
    if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            
        } else {
            //ApplicantTriggerHandler.maximumApplicantsOpportunity();
            ApplicantTriggerHandler.setOverallCreditRating();
        }
    } else if( Trigger.isInsert) {        
        if(Trigger.isAfter) {
            
        } else {
            ApplicantTriggerHandler.maximumApplicantsOpportunity();
            ApplicantTriggerHandler.setOverallCreditRating();
        }
    }
}