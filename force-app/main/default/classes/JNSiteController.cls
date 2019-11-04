public class JNSiteController {
    
    @AuraEnabled
    public static List<String> getPickListValues(String objectApiName, String fieldApiName){
        List<String> pickListValuesList= new List<String>();
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType sObjType = globalDescription.get(objectApiName);
        Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();
        
        Schema.SObjectField field = mapFieldList.get(fieldApiName);
        Schema.DescribeFieldResult fieldResult = field.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        return pickListValuesList;
    }
    @AuraEnabled
    public static Map<String, List<String>> getPickListValuesList(String objectApiName, List<String> fieldApiNames){
        List<String> pickListValuesList= new List<String>();
        Map<String, List<String>> mapFields = new Map<String, List<String>>();
        
        Map<String , Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
        Schema.sObjectType sObjType = globalDescription.get(objectApiName);
        Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
        Map<String , Schema.SObjectField> mapFieldList = r1.fields.getMap();
        
        for(String fieldApiName: fieldApiNames){
            Schema.SObjectField field = mapFieldList.get(fieldApiName);
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            pickListValuesList = new List<String>();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            } 
            mapFields.put(fieldApiName, pickListValuesList);
        }
        
        return mapFields;
    }
    @AuraEnabled
    public static Lead createLeadReferral(String firstName, String lastName, String serviceofInterest,Decimal estimatedAmount ){
        List<Lead> leads = [SELECT Id FROM Lead WHERE  LastName = :lastName AND LastName = :lastName];
        if(leads.isEmpty()){
            Lead newLead = new Lead(FirstName=firstName, LastName=lastName, 
                                    Estimated_Amount__c=estimatedAmount, Service_of_Interest__c =serviceofInterest);
            insert newLead;
            return newLead;
        } else {
            // lead already exist
            throw new AuraHandledException('A lead with the entered first and last name already exists');
        }
        
    }
    @AuraEnabled
    public static Object createPersonAffiliates(Map<String, Object> values , String leadId){
        try {
            
            List<Lead_Related_Person__c> persons = new List<Lead_Related_Person__c>();
            Map<String, Object>  oldPerson;
            for (String key : values.keySet()) {
                String c = JSON.serialize(values.get(key));
                oldPerson = (Map<String, Object>) JSON.deserializeUntyped(c);
                Lead_Related_Person__c newPerson = new Lead_Related_Person__c();
                
                newPerson.First_Name__c = String.valueOf(oldPerson.get('First_Name__c'));
                newPerson.Last_Name__c = String.valueOf(oldPerson.get('Last_Name__c'));
                newPerson.Role__c = String.valueOf(oldPerson.get('Role__c'));
                newPerson.Relationship__c = String.valueOf(oldPerson.get('Relationship__c')); 
                newPerson.Afilliate_Type__c = String.valueOf(oldPerson.get('Afilliate_Type__c'));
                newPerson.JN_Location__c  = String.valueOf(oldPerson.get('JN_Location__c'));
                persons.add(newPerson);
            }
            if(!persons.isEmpty()){
                insert persons;
            }            
            return persons;
        } catch(Exception e){
            return e;
        }
    }
    @AuraEnabled
    public static Object createPersonExtensions(Map<String, Object> values , String leadId){
        try {
            
            List<Lead_Related_Person__c> persons = new List<Lead_Related_Person__c>();
            Map<String, Object>  oldPerson;
            for (String key : values.keySet()) {
                String c = JSON.serialize(values.get(key));
                oldPerson = (Map<String, Object>) JSON.deserializeUntyped(c);
                Lead_Related_Person__c newPerson = new Lead_Related_Person__c();
                
                newPerson.First_Name__c = String.valueOf(oldPerson.get('First_Name__c'));
                newPerson.Last_Name__c = String.valueOf(oldPerson.get('Last_Name__c'));
                newPerson.Middle_Name__c = String.valueOf(oldPerson.get('Middle_Name__c'));
                newPerson.Title__c = String.valueOf(oldPerson.get('Title__c'));
                newPerson.Relationship__c = String.valueOf(oldPerson.get('Relationship__c')); 
                newPerson.TRN__c = Decimal.valueOf(String.valueOf(oldPerson.get('TRN__c')));
                newPerson.Afilliate_Type__c = String.valueOf(oldPerson.get('Afilliate_Type__c'));
                
                persons.add(newPerson);
            }
            if(!persons.isEmpty()){
                insert persons;
            }            
            return persons;
        } catch(Exception e){
            return e;
        }
    }
    @AuraEnabled
    public static Object saveFile(Id parentId, String fileName, String base64Data, String contentType) {
        ContentVersion conVer = new ContentVersion();
        try {
            String extension = fileName.substring(fileName.lastIndexOf('.')+1);
            String name = fileName.substring(0, fileName.lastIndexOf('.'));
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = name; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(base64Data); // converting your binary string to Blog
            insert conVer;
            
            // First get the content document Id from ContentVersion
            List<ContentVersion> contentVersions = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id];
            if(!contentVersions.isEmpty()){
                Id conDoc = contentVersions.get(0).ContentDocumentId;
                //Create ContentDocumentLink
                ContentDocumentLink cDe = new ContentDocumentLink();
                cDe.ContentDocumentId = conDoc;
                cDe.LinkedEntityId = parentId; // you can use objectId,GroupId etc
                cDe.ShareType = 'I'; // Inferred permission, checkout description of ContentDocumentLink object for more details
                
                insert cDe;
                return cDe.Id;
            } 
            return null;
            
        } catch(Exception e) {
            System.debug(e);
            
            return e;
        }
    }
    @AuraEnabled
    public static Object updateLeadInformation(Map<String, String> currentLead){
        try {
            Id leadId = currentLead.get('Id');
            Lead foundLead = [SELECT Id FROM Lead WHERE Id =:leadId];
            if(foundLead != null) {
                for(String field: currentLead.keySet()){
                    foundLead.put(field, currentLead.get(field));
                }
            }
            update foundLead;
            return foundLead;
        } catch(Exception e){
            return e;
        }
    }
}