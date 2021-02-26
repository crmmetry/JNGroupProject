trigger ContentDocumentTrigger on ContentDocument (After Update){
   
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            ContentDocTriggerHandler.CheckIfAllDocumentsAreUploaded(Trigger.New);
        }
    }
}