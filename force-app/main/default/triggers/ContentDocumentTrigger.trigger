/*
*Name  :  ContentDocumentTrigger
*Author:  Thinqloud Solutions
*Date  :  Mar 03, 2021
*Purpose : This trigger is triggered when ContentDocument file is uploaded.
*/
trigger ContentDocumentTrigger on ContentDocument (After Update){
        
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            ContentDocTriggerHandler.CheckIfAllDocumentsAreUploaded(Trigger.New);
        }
    }
}