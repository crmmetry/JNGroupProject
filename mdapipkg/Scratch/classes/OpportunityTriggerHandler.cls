public class OpportunityTriggerHandler {
    private static String Tag = 'OpportunityTriggerHandler';
    private static List<Opportunity> newRecords;
    private static Map<Id, Opportunity> oldMap;
    private static Map<Id, Opportunity> newMap;
    private static Map<Id,Opportunity> mappedRecords;
    private static boolean FirstRun = true;
    private static Map<String,String> excludedFields = new Map<String, String>
    {
        'Id' => 'Id',
            'IsDeleted' => 'IsDeleted',
            'CreatedById' => 'CreatedDate',
            'LastModifiedById' => 'LastModifiedById',
            'LastModifiedDate' => 'SystemModstamp'
            };
    public static void init(List<Opportunity> newRecords, Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap){
                    OpportunityTriggerHandler.newRecords = newRecords;
                    OpportunityTriggerHandler.oldMap = oldMap;
                    OpportunityTriggerHandler.newMap = newMap;
                    
    }

    public static void setOpportunityAmountOnLead(Boolean isAfter, Boolean isUpdate, Boolean isInsert){
                // can only execute only per execution context
        if(!Util.IsExecuted('setOpportunityAmountOnLead')){
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
        if(!Util.IsExecuted('creditScoreOppHandler')){
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
         if(!Util.IsExecuted('validateApplicantProfileCompletion')){
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
            if(record.Loan_Path__c != null){
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
         }
    }
    public static void validateCloseBackDate(Integer backdatedDays, Integer maxPrevDays, DateTime now){
        String err1 = 'The Closed Date cannot be this far back in the past. Please contact Sales Support.';
        String err2 = 'The Closed Date cannot be greater than this record created date. Please contact Sales Support.';
        String err3 = 'The Closed Date cannot be greater than today. Please contact Sales Support.';
        
        Date minDate = date.newinstance(now.year(), now.month(), now.day());
        Date todayDate = date.newinstance(now.year(), now.month(), now.day());
        Integer currentMonth = minDate.month();
        minDate = Util.GetBackDatedDate(minDate, maxPrevDays);
        System.debug('Min date: ' + minDate);
        
        for(Opportunity record: newRecords ) {
            if(record.StageName == 'Closed Lost' || record.StageName == 'Closed Won' ) {
                //if(oldMap.get(record.Id).StageName != 'Closed Lost' || oldMap.get(record.Id).StageName != 'Closed Won'){
                    date closeDate = date.newinstance(record.CloseDate.year(), record.CloseDate.month(), record.CloseDate.day());
                    date createdDate = date.newinstance(record.CreatedDate.year(), record.CreatedDate.month(), record.CreatedDate.day());
                    Integer prevMonth = record.CloseDate.month();

                    if(closeDate > todayDate){
                        record.CloseDate.addError(err3);
                        System.debug('closedate greater than today');
                    } else if((record.CloseDate <= minDate.addDays(-1))){
                        record.CloseDate.addError(err1);   
                        System.debug('closedate greater than 7 days in the past');
                    } else {
                        
                        if(prevMonth != currentMonth){
                            System.debug('closedate in different month');
                            now = System.now();
                            Date acceptedDate = Util.GetBackDatedDate(date.newinstance(now.year(), now.month(), now.day()), backdatedDays);
                            if(closeDate > acceptedDate){
                                System.debug('closedate in different month greater than max 2 days');
                                record.CloseDate.addError(err1);  
                            }
                        }
                    }            
                //}
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
                    if (Util.DidFieldChange(v1, v2)) {
                        changedFields.add(field);
                    }
                }
            }
        }        
        return changedFields;
    } 
    public static void ProductsFamiliyValidation(){
         if(!Util.IsExecuted('ProductsFamiliyValidation')){
        OpportunityTriggerHandler.mappedRecords = new Map<Id, Opportunity>(newRecords);

        Opportunity updatedOpportunity;
        for(Opportunity newRecord: [Select Id, (Select Id,Product_Family__c From OpportunityLineItems) From Opportunity Where Id in :newRecords]) {
                    Boolean autoLoan = false;
                    Boolean lineOfCredit = false;
                    Boolean unsecureLoan = false;
                    Boolean creditCard = false;
                    Boolean mortgage = false;
            		Boolean savingsChequing = false;
            for(OpportunityLineItem lineItem: newRecord.OpportunityLineItems) {
                System.debug('Familiy: ' + lineItem.Product_Family__c);
                switch on lineItem.Product_Family__c {
                    when 'JN Bank Auto Loan','JN Bank Commercial Auto Loan' {
                        System.debug('auto loan');
                        autoLoan = true;
                    }
                    when 'JN Bank Line Of Credit','JN Bank Cash Secured Loan'{
                        System.debug('line of credit');
                        lineOfCredit = true;
                    }
                    when 'JN Bank Term Share Loan','JN Bank Unsecured Loan','JN Bank 12 to 1 Loan (Supersize Loan)'{
                        System.debug('Unsecure Loan');
                        unsecureLoan = true;
                    }
                    when 'JN Bank Credit Card'{
                        System.debug('Credit Card');
                        creditCard = true;
                    }

                    when 'JN Bank Deposit Account'{
                        savingsChequing = true;
                    }
                }
                if(lineItem.Product_Family__c.contains('JN Bank Mortgage')){
                    mortgage = true;
                }
                
            }
            updatedOpportunity = mappedRecords.get(newRecord.Id);
            System.debug('updatedOpportunity ' + updatedOpportunity);
            if(autoLoan) {
                System.debug(' Updating Auto_Loan__c ');
                updatedOpportunity.Auto_Loan__c = true;
            } else {
                System.debug('NOT Updating Auto_Loan__c ');
                updatedOpportunity.Auto_Loan__c = false;
            } if(lineOfCredit){
                System.debug(' Updating Line_Of_Credit__c ');
                updatedOpportunity.Line_Of_Credit__c  = true;
            } else {
                updatedOpportunity.Line_Of_Credit__c  = false;
                System.debug('NOT Updating Line_Of_Credit__c ');
            } if(unsecureLoan){
                updatedOpportunity.Unsecure_Loan__c   = true;
                System.debug('Updating unsecured loan');
            } else {
                updatedOpportunity.Unsecure_Loan__c   = false;
                System.debug('NOT Updating unsecured loan');
            } if(creditCard){
                System.debug('Updating credit card');
                updatedOpportunity.Credit_Card__c   = true;
            } else {
                System.debug('NOT Updating credit card');
                updatedOpportunity.Credit_Card__c   = false;
            } if(savingsChequing){
                updatedOpportunity.Savings_and_Chequing__c = true;
            } else {
                updatedOpportunity.Savings_and_Chequing__c = false;
            } if(mortgage) {
                updatedOpportunity.Mortgage__c = true;
            } else {
                updatedOpportunity.Mortgage__c = false;
            }
        }
        
    }
    }
}