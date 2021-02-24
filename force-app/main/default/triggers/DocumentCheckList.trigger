trigger DocumentCheckList on DocumentChecklistItem (before insert, after insert, 
                                                    before update, after update)
{
    if(Trigger.isInsert){
        if(Trigger.isAfter){
            DocumentChecklistItemTriggerHandler.CheckDocumentType(Trigger.New);
        }else if(Trigger.isBefore){
            
            
        }
    }else if(Trigger.isUpdate){
        if(Trigger.isAfter){
            
        }else if(Trigger.isBefore){
            
        }
    }
}