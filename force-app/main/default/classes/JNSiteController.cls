public class JNSiteController {
    
    @AuraEnabled
    public static List<String> getPickListValues(String objectApiName, String fieldApiName){
        String recordTypeId;
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
    public static Object getPickListValuesList(String objectApiName, List<String> fieldApiNames){
        String recordTypeId;
        List<String> pickListValuesList= new List<String>();
        Map<String, List<String>> mapFields = new Map<String, List<String>>();
        List<String> specificValues;
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
    public static Object updateApplicantTextInfo(Map<String, String> applicantDetails ,  String leadId ){
        try {
            Map<String, String> booleanFields = new Map<String, String>{
                'Different_Mailing_Address__c' => 'Different_Mailing_Address__c',
                'JN_Site_Form_Completed_Flag__c' =>'JN_Site_Form_Completed_Flag__c'
                    };
            Map<String, String> decimalFields = new Map<String, String>{
                	'Mailing_Years_at_Residence__c' => 'Mailing_Years_at_Residence__c',
                    'Years_at_Residence__c' => 'Years_at_Residence__c',
                    'Time_with_Current_Employer__c' => 'Time_with_Current_Employer__c',
                    'Time_in_Industry__c' => 'Time_in_Industry__c'
                    };
                        Map<String, String> dateFields = new Map<String, String>{
                            'Preferred_Date_of_Contact__c' => 'Preferred_Date_of_Contact__c',
                                'Date_of_Birth__c' => 'Date_of_Birth__c',
                                'Identification_Type_Expiration__c' => 'Identification_Type_Expiration__c',
                                'Date_of_Incorporation__c' => 'Date_of_Incorporation__c'
                                };
            Lead newLead = new Lead(Id=leadId);
            for(String field: applicantDetails.keySet()){ 
                if(dateFields.containsKey(field)){
                    newLead.put(field, Date.valueOf(applicantDetails.get(field)));
                } else if(decimalFields.containsKey(field)){
                    newLead.put(field, Decimal.valueOf(applicantDetails.get(field)));
                } else if(booleanFields.containsKey(field)){
                     newLead.put(field, Boolean.valueOf(applicantDetails.get(field)));
                }else {
                    newLead.put(field, applicantDetails.get(field));
                }
                
            }
            update newLead;
            return newLead;
        } catch(Exception e) {
            return e;            
        }
    }
    @AuraEnabled
    public static Lead createLeadReferral(Map<String, String> applicantDetails ){
        
        List<Lead> leads = [SELECT Id FROM Lead WHERE  
                            FirstName = :applicantDetails.get('FirstName')
                            AND MiddleName = :applicantDetails.get('MiddleName')
                            AND LastName = :applicantDetails.get('LastName')];
        Id leadId;
        if(!leads.isEmpty()){
            throw new AuraHandledException('A user already exist with the supplied first and last name');
            //return error
        }
        Lead newLead = new Lead();
        newLead.LeadSource = 'Online Application Form';
        newLead.FirstName=applicantDetails.get('FirstName');
        newLead.LastName=applicantDetails.get('LastName');
        newLead.Estimated_Amount__c = Decimal.valueOf(applicantDetails.get('Estimated_Amount__c')); 
        newLead.Service_of_Interest__c = applicantDetails.get('Service_of_Interest__c');
        newLead.Lead_Title__c =  applicantDetails.get('Lead_Title__c');
        newLead.MiddleName = applicantDetails.get('MiddleName');
        newLead.Suffix__c= applicantDetails.get('Suffix__c');
        newLead.Gender__c= applicantDetails.get('Gender__c');
        newLead.Marital_Status__c =applicantDetails.get('Marital_Status__c');
        newLead.Date_of_Birth__c = Date.valueOf(applicantDetails.get('Date_of_Birth__c'));
        newLead.Place_of_Birth__c= applicantDetails.get('Place_of_Birth__c');
        newLead.Mother_s_Maiden_Name__c= applicantDetails.get('Mother_s_Maiden_Name__c');
        newLead.Number_of_Dependent_Adults__c= Decimal.valueOf(applicantDetails.get('Number_of_Dependent_Adults__c'));
        newLead.Number_of_Dependent_Children__c= Decimal.valueOf(applicantDetails.get('Number_of_Dependent_Children__c'));
        newLead.Country_of_Citizenship__c = applicantDetails.get('Country_of_Citizenship__c');
        newLead.Country_of_Residence__c = applicantDetails.get('Country_of_Residence__c');
        newLead.Highest_Level_of_Education_Attained__c = applicantDetails.get('Highest_Level_of_Education_Attained__c');
        newLead.Jamaican_Tax_Registration_Number__c = applicantDetails.get('Jamaican_Tax_Registration_Number__c');
        newLead.Service_of_Interest__c = applicantDetails.get('Service_of_Interest__c');
        
        Map<String,Id> recordTypes = util.getRecordTypeids('Lead');
        if(newLead.Service_of_Interest__c == 'JN Bank Credit Card'){ //credit_card
            newLead.RecordTypeId = recordTypes.get('Credit_Card_Super_Lead');
        } else {
            newLead.RecordTypeId = recordTypes.get('Unsecured_Loan_Super_Lead');
        }
        newLead.Preferred_Date_of_Contact__c = Date.valueOf(applicantDetails.get('Preferred_Date_of_Contact__c'));
        newLead.Preferred_Time_of_Contact__c= updateTime(applicantDetails.get('Preferred_Time_of_Contact__c'));
        newLead.Preferred_Location__c = applicantDetails.get('Preferred_Location__c');
        newLead.Loan_Purpose_UL__c = applicantDetails.get('Loan_Purpose_UL__c');
        newLead.Gross_Monthly_Income__c = Decimal.valueOf(applicantDetails.get('Gross_Monthly_Income__c'));
        newLead.Gross_Monthly_Expenses__c = Decimal.valueOf(applicantDetails.get('Gross_Monthly_Expenses__c'));
        insert newLead; //return a error duplicate
        return newLead;
        
        
    }
    @AuraEnabled
    public static Object createPersonAffiliates(Map<String, Object> values , String leadId){
        try {
            
            List<Lead_Related_Person__c> persons = new List<Lead_Related_Person__c>();
            Map<String, Object>  oldPerson;
            Lead leadRecord = new Lead(Id=leadId);
            for (String key : values.keySet()) {
                String c = JSON.serialize(values.get(key));
                oldPerson = (Map<String, Object>) JSON.deserializeUntyped(c);
                Lead_Related_Person__c newPerson = new Lead_Related_Person__c();
                newPerson.First_Name__c = String.valueOf(oldPerson.get('First_Name__c'));
                newPerson.Last_Name__c = String.valueOf(oldPerson.get('Last_Name__c'));
                newPerson.Role__c = String.valueOf(oldPerson.get('Role__c'));
                newPerson.Relationship__c = String.valueOf(oldPerson.get('Relationship__c')); 
                String afilliateType = String.valueOf(oldPerson.get('Afilliate_Type__c'));
                newPerson.Afilliate_Type__c = afilliateType;
                
                if(afilliateType == 'JN Bank'){
                    leadRecord.JN_Bank_Affiliation__c = true;
                } else if (afilliateType == 'Political'){
                    leadRecord.Political_Affiliation__c = true;
                }
                newPerson.JN_Location__c  = String.valueOf(oldPerson.get('JN_Location__c'));
                newPerson.Mobile_Number__c  = String.valueOf(oldPerson.get('Mobile_Number__c'));
				newPerson.Lead_and_Referral__c  = String.valueOf(oldPerson.get('Lead_and_Referral__c'));
                persons.add(newPerson);
            }
            if(!persons.isEmpty()){
                insert persons;
                update leadRecord;
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
                newPerson.TRN__c = String.valueOf(oldPerson.get('TRN__c'));
                newPerson.Afilliate_Type__c = String.valueOf(oldPerson.get('Afilliate_Type__c'));
                newPerson.Lead_and_Referral__c = leadId;
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
    public static Object saveFile(Id parentId, String fileName, String base64Data, String contentType, String tabTitle) {
        ContentVersion conVer = new ContentVersion();
        try {
            String extension = fileName.substring(fileName.lastIndexOf('.')+1);
            String name = fileName.substring(0, fileName.lastIndexOf('.'));
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = fileName; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = tabTitle; // Display name of the files
            //conVer.Description = description;
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
    @AuraEnabled public String value;
    public static Time updateTime(String strTimeChange){
        
        String[] strTimeSplit = strTimeChange.split(':');
        return Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                ,Integer.valueOf(strTimeSplit[1]) //min
                                ,0                                //sec
                                ,0);  
        
    }

    @AuraEnabled 
    public static String getRecordTypeId(String recordTypeName) {
        return [SELECT id FROM RecordType WHERE DeveloperName = :recordTypeName].Id;
    }
}