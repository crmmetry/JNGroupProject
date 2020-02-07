trigger NewEmploymentTrigger on FinServ__Employment__c (before insert, before delete, after insert, before update, after update) {
        EmploymentTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.old);
        EmploymentTriggerHandler.creditScoreOnEmployment(Trigger.isDelete, Trigger.isUpdate);
        
        if(Trigger.isUpdate) {
            if(Trigger.isAfter) {
                
            } else {
                EmploymentTriggerHandler.checkCurrentEmployments();
            }
        } else if( Trigger.isInsert) {        
            if(Trigger.isAfter) {
                
            } else {
                EmploymentTriggerHandler.checkCurrentEmployments();
            }
        }
}