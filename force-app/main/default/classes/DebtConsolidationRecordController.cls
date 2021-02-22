/**
* Ver  Ticket#      Date            Author                 Purpose
* 1.0  RUB-134     18/02/2021      Tushar C.(thinqloud)  	To Save and get Application Asset/Liability records
**/
public class DebtConsolidationRecordController {
    public static Map<String, Id> recordTypesMap{get;set;}
    @AuraEnabled
    public static Boolean saveAssetLiablityRecords(List<Application_Asset_Liability__c> recordList,Id applId,Decimal totalMonthly,Decimal totalConsolidated){
        List<Application_Asset_Liability__c> applAssetLiabilityRecordList = new List<Application_Asset_Liability__c>([SELECT Id,Assets_and_Liabilities__c FROM Application_Asset_Liability__c WHERE Assets_and_Liabilities__r.Name = 'other loan' limit 1]);
        recordTypesMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        Id recordType = recordTypesMap.get('Debt_Consolidation');
        List<Application_Asset_Liability__c> insertRecordList = new List<Application_Asset_Liability__c>();
        
        Applicant__c applicants = new Applicant__c(Id=applId,Total_Amount_Consolidated__c = totalConsolidated,Total_Monthly_Payment__c = totalMonthly);
        update applicants;
        
        for(Application_Asset_Liability__c assetLibRec : recordList){
            if(assetLibRec.Id == null){
                assetLibRec.Assets_and_Liabilities__c = applAssetLiabilityRecordList[0].Assets_and_Liabilities__c;
            }
            assetLibRec.Application__c=applId;                
            assetLibRec.RecordTypeId=recordType;
            insertRecordList.add(assetLibRec);
        }
        if(!insertRecordList.isEmpty() && insertRecordList.size()>0){
            upsert insertRecordList;
        }
        return true;
    }
    
    @AuraEnabled
    public static List<Application_Asset_Liability__c> getAssetLiabilityRecords(String Id){
        recordTypesMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        Id recordType = recordTypesMap.get('Debt_Consolidation');
        return [SELECT Id,Debt_Type_List__c,Institution_Debt_List__c,Debt_Amount_Number__c,Application__r.Total_Amount_Consolidated__c,Application__r.Total_Monthly_Payment__c FROM Application_Asset_Liability__c WHERE Application__c =:Id AND RecordTypeId =:recordType];
    }
}