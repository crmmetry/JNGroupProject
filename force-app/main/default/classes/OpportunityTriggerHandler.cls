public class OpportunityTriggerHandler {
    private static String Tag = 'OpportunityTriggerHandler';
    private static List<Opportunity> newRecords;
    private static Map<Id, Opportunity> oldMap;
    private static Map<Id, Opportunity> newMap;
    private static Map<String,String> excludedFields = new Map<String, String>
    		{
       		'Id' => 'Id',
            'IsDeleted' => 'IsDeleted',
            'CreatedById' => 'CreatedDate',
            'LastModifiedById' => 'LastModifiedById',
            'LastModifiedDate' => 'SystemModstamp'
            };
                public static void init(List<Opportunity> newRecords, 
                                        Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap){
                    OpportunityTriggerHandler.newRecords = newRecords;
                    OpportunityTriggerHandler.oldMap = oldMap;
                    OpportunityTriggerHandler.newMap = newMap;
                }
    public static void setOpportunityAmountOnLead(Boolean isAfter, Boolean isUpdate, Boolean isInsert){
        Set<id> oppid = new set<id>();
        Map<id,Double> oppMap = new Map<id,Double>();
        String oppsID;
        Double oppAMT;
        system.debug('Trigger called=====================>');
        if(isAfter){
            if(isInsert){
                for(Opportunity opp : newRecords){
                    if(opp.StageName=='Closed Won' ){
                        oppid.add(opp.ID);
                        oppMap.put(opp.id,opp.Amount);
                        oppsID = opp.ID;
                        oppAMT = opp.Amount;
                    }                            
                }  
            }
            if(isUpdate){
                system.debug('oppid=====================>'+Trigger.new);
                for(Opportunity opp : newRecords){
                    Opportunity oppOld=oldMap.get(opp.id);
                    if((oppOld.StageName != opp.StageName && opp.StageName=='Closed Won' ) ) {
                        oppid.add(opp.ID);
                        oppMap.put(opp.id,opp.Amount);
                        oppsID = opp.ID;
                        oppAMT = opp.Amount;
                    }
                }  
            }
            system.debug('oppid=====>'+oppid);
            
            if(oppAMT>0) {
                List<Lead> lstlead = [select id,Actual_Amount_From_Opportunity__c,Opportunity__c , ConvertedAccountId from lead where ConvertedAccountId IN (select accountId from opportunity where Id =:oppsID )];
                if(lstlead.size()>0){
                    for(lead l:lstlead){
                        l.Actual_Amount_From_Opportunity__c = oppAMT;
                    }
                    update lstlead;
                    system.debug('lstlead=====>'+lstlead);
                }
            }
            
            
            
        }
    }
    public static void assignOpportunityRecordTypeName(){
        List<Id> ids = new List<Id>();
        Boolean match = false;
        String recordTypeName = '';
        for(Opportunity opp: newRecords){
            ids.add(opp.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account WHERE Id IN :ids]);
        
        for(Opportunity opp: newRecords){
            recordTypeName = getRecordTypeDeveloperName(getRecordTypeName(opp));
            switch on recordTypeName {
                when 'Credit_Facility' {
                    match = true;
                }
                when 'Mortgage' {
                    match = true;
                }
                when 'Savings_Chequing' {
                    match = true;
                }               
            }
            if(match == true){
                opp.Name = accountMap.get(opp.AccountId).Name + ' - '+ getRecordTypeName(opp);
                match = false;
            }
        }
        
    }
    public static void creditScoreOppHandler() {
        system.debug('Trigger called=====================>');
        CreditScoreHelper cs = new CreditScoreHelper();
        Set<id> oppid = new set<id>();   
        if(Trigger.isAfter){      
            for(Opportunity opp : newRecords){
                oppid.add(opp.ID);
            }        
        }
        if(oppid.size()>0){
            cs.CreditScoreFromOpp(oppid);
        }
    }
    public static void lockRecordsForEditing(){
        
        String errMsg = 'This record is currently LOCKED due to it being in the stage of "Closed Won" or "Closed Lost". Click Reactivate button to enable record edit.';
        
        List<String> changedFields = getChangedFields();
        System.debug('Changed Fields' + changedFields);
        for(Opportunity opp : newRecords) {
            if(!changedFields.isEmpty() && changedFields.get(0) != 'Record_Lock__c'){                                
                if(opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won' ) {
                    if(oldMap.get(opp.Id).StageName == 'Closed Lost' || oldMap.get(opp.Id).StageName == 'Closed Won'){
                        if(opp.Record_Lock__c) {
                            opp.addError(errMsg);
                        }
                    }
                }  
            }
            if(opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won' && !changedFields.isEmpty() && changedFields.get(0) != 'Record_Lock__c'){
                if(oldMap.get(opp.Id).StageName != 'Closed Lost' || oldMap.get(opp.Id).StageName != 'Closed Won'){
                    opp.Record_Lock__c = true;
                }
            }
        }
        
    }        
    private static String getRecordTypeName(Opportunity opp){
        return Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordTypeId).getname();
    }
    private static String getRecordTypeDeveloperName(String name) {
        return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(name).getDeveloperName();
    }
    public static void validateApplicantProfileCompletion(){
        List<String> changedFields = getChangedFields();
        Map<Id,Opportunity> mappedRecords = new Map<Id,Opportunity>(newRecords);
        List<Applicant__c> applicants = [SELECT Id,Opportunity__c FROM Applicant__c WHERE Opportunity__c IN :mappedRecords.keySet()];
        Map<Id,Applicant__c> mappedApplicants = new Map<Id,Applicant__c>(applicants);
        List<Application_Asset_Liability__c> applicantAssets = [SELECT Id FROM Application_Asset_Liability__c 
                                                                      WHERE Application__c IN :mappedApplicants.keySet() 
                                                                      AND Assets_and_Liabilities__c != NULL ];
        String err1 = 'You must complete the Create Application flow before selecting "Yes" for this field';
        String err2 = 'You must complete the Financial Information flow before selecting "Yes" for this field';

            for(Opportunity record : newRecords) {
                if(record.Loan_Path__c.equals('Complete Applicant Profile(s)')){
                    if(record.Personal_Details_Complete_PK__c != null && record.Personal_Details_Complete_PK__c.equals('Yes') && applicants.isEmpty()){
                        record.Personal_Details_Complete_PK__c.addError(err1);
                    }
                    if(record.Financial_Information_Complete_PK__c != null && record.Financial_Information_Complete_PK__c.equals('Yes') && applicantAssets.isEmpty()){
                        record.Financial_Information_Complete_PK__c.addError(err2);
                    }
                }
            }
        
    }
    public static List<String> getChangedFields() {
        List<String> changedFields = new List<String>();        
        for(Opportunity opp: newRecords ){
            SObject o1 = oldMap.get(opp.id);
            SObject o2 = newMap.get(opp.Id);
            Map<String, Object> fieldList = o2.getPopulatedFieldsAsMap();
            for (String field : fieldList.keySet()) {
                if(!excludedFields.containsKey(field)){
                    Object v1 = o1.get(field);
                    Object v2 = o2.get(field);
                    if (didFieldChange(v1, v2)) {
                        changedFields.add(field);
                    }
                }
            }
        }        
        return changedFields;
    }
    
    private static Boolean didFieldChange(Object v1, Object v2) {
        if (v1 == null && v2 == null) {
            return false;
        }
        if (v1 != v2) {
            return true;
        }
        return false;
    }
    
    
}