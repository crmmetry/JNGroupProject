trigger NewAccountTrigger on Account (after update, before delete, before update, after insert, before insert) {
        NewAccountTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.old);
        NewAccountTriggerHandler.creditscoreonAccount(Trigger.isUpdate, Trigger.isDelete);
        if(Trigger.isUpdate) {
            if(Trigger.isAfter) {
                
            } else {
                NewAccountTriggerHandler.assignMobileNumber();
            }
        } else if( Trigger.isInsert) {        
            if(Trigger.isAfter) {
                
            } else {
                NewAccountTriggerHandler.assignMobileNumber();
            }
        }
}