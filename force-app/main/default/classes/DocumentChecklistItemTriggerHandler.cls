public class DocumentChecklistItemTriggerHandler {
   
    public static void CheckDocumentType(list<DocumentChecklistItem> docChkListItems){
        list<Opportunity> oppListToUpdate = new list<Opportunity>();
        Map<Id, DocumentType> mapOfDocTypeObject = GetMapOfDocTypeObject(docChkListItems);
        
        
        for(DocumentChecklistItem docItem : docChkListItems){
            if(ParentObjectType(docItem.ParentRecordId) == Constants.OPPORTUNITYSTRING){
                
                Opportunity oppToAddInList = new Opportunity();
                oppToAddInList.id = docItem.ParentRecordId;
                
                DocumentType docTypeObj = new DocumentType();
                if(mapOfDocTypeObject!=Null){
                    docTypeObj = mapOfDocTypeObject.get(docItem.DocumentTypeId);    
                    if(docTypeObj!=Null){
                        if(docTypeObj.DeveloperName == Constants.DOCUMENTTYPEPROMISSORYNOTE){
                
                            oppToAddInList.Signing_Legal_Documents_Promissory_flag__c = True;
                            oppListToUpdate.Add(oppToAddInList);
                        }else if(docTypeObj.DeveloperName == Constants.DOCUMENTTYSIGNEDSALARYDED){
                
                            oppToAddInList.Submission_Of_Signed_Deduction_of_Salary__c = Constants.YESSTRING;
                            oppListToUpdate.Add(oppToAddInList);
                        }    
                    }
                }                
            }
        }
        if(oppListToUpdate.size() > 0){
            update oppListToUpdate;    
        }
    }
    
    Public Static String ParentObjectType(Id s_ObjectId){
        String s_object_API_Name = s_ObjectId.getSObjectType().getDescribe().getName();
        Return s_object_API_Name;
    }
    
    public static Map<Id, DocumentType> GetMapOfDocTypeObject(list<DocumentChecklistItem> docChkListItems){
        list<Id> docTypeIds = new list<Id>();
        Map<Id, DocumentType> mapOfDocumentTypeObj; 
        for(DocumentChecklistItem docItem : docChkListItems){
            if(docItem.DocumentTypeId !=Null){
                docTypeIds.add(docItem.DocumentTypeId);
            }
        }
        
        if(docTypeIds.size()>0){
	        mapOfDocumentTypeObj = new Map<Id, DocumentType>([SELECT Id, DeveloperName 
                                                              FROM DocumentType 
                                                              WHERE Id IN: docTypeIds]);
        }
        return mapOfDocumentTypeObj;
    }
}