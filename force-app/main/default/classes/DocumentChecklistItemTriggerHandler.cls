public class DocumentChecklistItemTriggerHandler {
  public static void CheckDocumentType(
    list<DocumentChecklistItem> docChkListItems
  ) {
    list<Opportunity> oppListToUpdate = new List<Opportunity>();
    Map<Id, DocumentType> mapOfDocTypeObject = GetMapOfDocTypeObject(
      docChkListItems
    );

    for (DocumentChecklistItem docItem : docChkListItems) {
      if (
        ParentObjectType(docItem.ParentRecordId) == Constants.OPPORTUNITYSTRING
      ) {
        Opportunity oppToAddInList = new Opportunity();
        oppToAddInList.id = docItem.ParentRecordId;

        DocumentType docTypeObj = new DocumentType();
        if (mapOfDocTypeObject != null) {
          docTypeObj = mapOfDocTypeObject.get(docItem.DocumentTypeId);
          if (docTypeObj != null) {
            if (
              docTypeObj.DeveloperName == Constants.DOCUMENTTYPEPROMISSORYNOTE
            ) {
              oppToAddInList.Signing_Legal_Documents_Promissory_flag__c = true;
              oppListToUpdate.Add(oppToAddInList);
            } else if (
              docTypeObj.DeveloperName == Constants.DOCUMENTTYSIGNEDSALARYDED
            ) {
              oppToAddInList.Submission_Of_Signed_Deduction_of_Salary__c = Constants.YESSTRING;
              oppListToUpdate.Add(oppToAddInList);
            }
          }
        }
      }
    }
    if (oppListToUpdate.size() > 0) {
      update oppListToUpdate;
    }
  }

  public static String ParentObjectType(Id s_ObjectId) {
    String s_object_API_Name = s_ObjectId.getSObjectType()
      .getDescribe()
      .getName();
    return s_object_API_Name;
  }

  public static Map<Id, DocumentType> GetMapOfDocTypeObject(
    list<DocumentChecklistItem> docChkListItems
  ) {
    list<Id> docTypeIds = new List<Id>();
    Map<Id, DocumentType> mapOfDocumentTypeObj;
    for (DocumentChecklistItem docItem : docChkListItems) {
      if (docItem.DocumentTypeId != null) {
        docTypeIds.add(docItem.DocumentTypeId);
      }
    }

    if (docTypeIds.size() > 0) {
      mapOfDocumentTypeObj = new Map<Id, DocumentType>(
        [SELECT Id, DeveloperName FROM DocumentType WHERE Id IN :docTypeIds]
      );
    }
    return mapOfDocumentTypeObj;
  }
}
