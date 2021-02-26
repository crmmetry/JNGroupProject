public class ContentDocTriggerHandler {
    
    public static void CheckIfAllDocumentsAreUploaded(list<ContentDocument> contenDocsList){
        list<Opportunity> oppListToUpdate = new list<Opportunity>();
        list<id> cntDocIds = new list<id>();
        list<ContentDocumentLink> contentDocumentLinkObjLst = new list<ContentDocumentLink>();	
        list<id> contentDocumentLinkObjFilteredList = new list<id>();	
        list<DocumentChecklistItem> docChkListItemObjLst = new list<DocumentChecklistItem>();
        list<id> oppnIds = new list<id>();
        
        for(ContentDocument docObj : contenDocsList){
            cntDocIds.add(docObj.Id);
        }
        //------Step 1 ---From the Root object as ContentDocument get its LinkedEntityId----//
        contentDocumentLinkObjLst = [SELECT LinkedEntityId 
                                     FROM ContentDocumentLink 
                                     WHERE ContentDocumentId IN : cntDocIds];
        
        //---Step 2---Find the Object Type of the LinkedEntityId. It should be DocumentChecklistItem----//
        for(ContentDocumentLink cntDocLnkObj : contentDocumentLinkObjLst){
            if(ParentObjectType(cntDocLnkObj.LinkedEntityId)== Constants.DOCCHKLISTITEM_SOBJECT){
                contentDocumentLinkObjFilteredList.add(cntDocLnkObj.LinkedEntityId);
            }
        }
           
        docChkListItemObjLst = [SELECT ParentRecordId 
                                FROM DocumentChecklistItem 
                                WHERE Id IN : contentDocumentLinkObjFilteredList];
		
        for(DocumentChecklistItem record: docChkListItemObjLst){
            if(ParentObjectType(record.ParentRecordId) == Constants.OPPORTUNITYSTRING){
                Opportunity oppToAddInList = new Opportunity();
                oppToAddInList.id = record.ParentRecordId;
                oppListToUpdate.add(oppToAddInList);
            }
        }
        
        if(oppListToUpdate!=Null){
            if(oppListToUpdate.size()>0){
                for(Opportunity opp : oppListToUpdate){
                    oppnIds.add(opp.Id);
                }
                UpdateOppsFlag(oppnIds);
            }    
        }
    }
    public static void UpdateOppsFlag(list<id> oppObjIds){
        map<id, list<DocumentChecklistItem>> mapOf_OppId_vs_DocChkListItemId = new map<id, list<DocumentChecklistItem>>(); 
        map<id, DocumentChecklistItem> mapOfDocChkListItems; 
        Map<Id, DocumentType> mapDocType = new Map<Id, DocumentType>();
		list<Opportunity> oppListToUpdate = new list<Opportunity>();
        list<Opportunity> oppListToOfSpcificFlag = new list<Opportunity>();
        mapOfDocChkListItems = new map<id, DocumentChecklistItem>
            						([SELECT Id, 
                                      		DocumentTypeId,
                                      		ParentRecordId
                                      FROM DocumentChecklistItem 
                                      WHERE ParentRecordId IN :oppObjIds]);
        //----Step 1 ----Get list of LinkedEntityIds----//
        list<ContentDocumentLink> contentDocLinkObjs = new list<ContentDocumentLink>();
        contentDocLinkObjs = [SELECT LinkedEntityId 
                              FROM ContentDocumentLink 
                              WHERE LinkedEntityId IN : mapOfDocChkListItems.keySet()];    
        
		//----Step 2 ----Get map of Opp Id Vs list of DocumentChecklistItem----//
        mapOf_OppId_vs_DocChkListItemId = prapreMapOfOppIdVsChkListItems(mapOfDocChkListItems);
        
        //----Step 3 ----Get map of Document Type Items----//
        mapDocType = GetMap_DocTypeObject();
        system.debug(' mapDocType '+ mapDocType);
        
        //----Step 4 ----Prepare the list of Opportunity to update----//
        Opportunity oppToAdd = new Opportunity();
        
        //----Step 5 ----Check if all docs are present in Opportunity----//
        for(Id oppId : mapOf_OppId_vs_DocChkListItemId.keySet()){
        	oppToAdd.id = oppId;
            list<DocumentChecklistItem> listOfRecords = new list<DocumentChecklistItem>();
            listOfRecords = mapOf_OppId_vs_DocChkListItemId.get(oppId);
            
            boolean setFlag = false;
            for(id docId : mapDocType.keyset()){
                setFlag = false;
                for(DocumentChecklistItem aRecord : listOfRecords){
                    if(docId == aRecord.DocumentTypeId){
                        for(ContentDocumentLink iterationRecord : contentDocLinkObjs){
                            if(aRecord.Id == iterationRecord.LinkedEntityId){                                
                                setFlag = true;
                            }
                        }
                    }
                }
                if(setFlag == false){
                    oppToAdd.Documents_Complete_flag__c = False;
                    oppListToUpdate.add(oppToAdd);
                    break;
                }
            }
            if(setFlag == true){
                oppToAdd.Documents_Complete_flag__c = True;
                oppListToUpdate.add(oppToAdd);
            }
        }
        update oppListToUpdate;
        
        //----Step 6 ----Check if specific docs are present in Opportunity----//
        for(Id oppId : mapOf_OppId_vs_DocChkListItemId.keySet()){
            list<DocumentChecklistItem> listOfRecords = new list<DocumentChecklistItem>();
            listOfRecords = mapOf_OppId_vs_DocChkListItemId.get(oppId);
            
            oppToAdd.id = oppId;
            oppToAdd.Signing_Legal_Documents_Promissory_flag__c = False;
            boolean setFlagSpc = false;
            for(id docId : mapDocType.keyset()){
                documentType docObj = new documentType();
                docObj = mapDocType.get(docId);
                if(docObj.DeveloperName == Constants.DOCUMENTTYPEPROMISSORYNOTE || 
                   docObj.DeveloperName == Constants.DOCUMENTTYSIGNEDSALARYDED){
                       for(DocumentChecklistItem aRecord : listOfRecords){
                           if(aRecord.DocumentTypeId == docId){
                               for(ContentDocumentLink iterationRecord : contentDocLinkObjs){
                                   if(iterationRecord.LinkedEntityId == aRecord.Id){
                                       if(docObj.DeveloperName == Constants.DOCUMENTTYPEPROMISSORYNOTE){
                                           oppToAdd.Signing_Legal_Documents_Promissory_flag__c = True;    
                                           setFlagSpc = True;
                                       }else if(docObj.DeveloperName == Constants.DOCUMENTTYSIGNEDSALARYDED){
                                           oppToAdd.Submission_Of_Signed_Deduction_of_Salary__c = Constants.YESSTRING;    
                                           setFlagSpc = True;
                                       }
                                   }
                               }
                           }
                       }
                   }
            }
            if (setFlagSpc = True){
                oppListToOfSpcificFlag.add(oppToAdd);
            }
        }
        
        update oppListToOfSpcificFlag;
    }
    
    public static map<id, list<DocumentChecklistItem>> prapreMapOfOppIdVsChkListItems(map<id, DocumentChecklistItem> chkListItem){
        map<id, list<DocumentChecklistItem>> mapOppIdvsChecklistItmId = new map<id, list<DocumentChecklistItem>>();
        
        for(Id docChkLstItemId : chkListItem.keySet()){
            DocumentChecklistItem record = new DocumentChecklistItem();
            record = chkListItem.get(docChkLstItemId);
            
            if(mapOppIdvsChecklistItmId.containskey(record.ParentRecordId)){
                list<DocumentChecklistItem> listOfRecords = new list<DocumentChecklistItem>();
                listOfRecords = mapOppIdvsChecklistItmId.Get(record.ParentRecordId);
                listOfRecords.add(record);
                mapOppIdvsChecklistItmId.put(record.ParentRecordId, listOfRecords);
            }else{
                list<DocumentChecklistItem> listOfRecords = new list<DocumentChecklistItem>();
                listOfRecords.add(record);
            	mapOppIdvsChecklistItmId.put(record.ParentRecordId, listOfRecords);      
            }
        }
        return mapOppIdvsChecklistItmId;
    }
    
    //Get the Object Name of the provided Object Id
    Public Static String ParentObjectType(Id s_ObjectId){
        String s_object_API_Name = s_ObjectId.getSObjectType().getDescribe().getName();
        Return s_object_API_Name;
    }
    
    public static Map<Id, DocumentType> GetMap_DocTypeObject(){
        Map<Id, DocumentType> mapOfDocumentTypeObj = new Map<Id, DocumentType>([SELECT Id, DeveloperName 
                                                                                FROM DocumentType]);    
        return mapOfDocumentTypeObj;
    }
}