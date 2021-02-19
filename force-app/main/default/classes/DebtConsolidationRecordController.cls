public class DebtConsolidationRecordController {
    
    public static Map<String, Id> recordTypesMap{get;set;}
    
    @AuraEnabled
    public static Boolean saveAssetLiablityRecords(List<Application_Asset_Liability__c> recordList,Decimal totalMonthly,Decimal totalConsolidated){
        System.debug('recordList::'+recordList);
        recordTypesMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        Id recordType = recordTypesMap.get('Debt_Consolidation');
        List<Application_Asset_Liability__c> insertRecordList = new List<Application_Asset_Liability__c>();
        
        Applicant__c applicants = new Applicant__c(Id=recordList[0].Application__c,Total_Amount_Consolidated__c = totalConsolidated,Total_Monthly_Payment__c = totalMonthly);
        update applicants;
        
        for(Application_Asset_Liability__c assetLibRec : recordList){
            if(assetLibRec.Id == null){
                assetLibRec.Assets_and_Liabilities__c='a02f000000Bvq47AAB';
            }
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