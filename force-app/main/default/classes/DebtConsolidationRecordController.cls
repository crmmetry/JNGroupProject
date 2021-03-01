/**
* Ver  Ticket#      Date            Author                 Purpose
* 1.0  RUB-134     18/02/2021      Tushar C.(thinqloud)  	To Save and get Application Asset/Liability records
**/
public class DebtConsolidationRecordController {
    
    public static Map<String, Id> recordTypesMap{get;set;}
    public static Map<String, Id> recordTypeNameVsId{get;set;}
    
/** This method used to save/insert the Application Assets/Liabilities records
* @param {string} recordList
* @param {Id} applId
* @param {Id} accId
* @param {Decimal} totalMonthly
* @param {Decimal} totalConsolidated
*/
    @AuraEnabled
    public static Boolean saveAssetLiablityRecords(List<Application_Asset_Liability__c> recordList,Id applId,Id accId,Decimal totalMonthly,Decimal totalConsolidated){
        recordTypesMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        recordTypeNameVsId = Util.getRecordTypeids('FinServ__AssetsAndLiabilities__c');
        Id recordType = recordTypesMap.get('Debt_Consolidation');
        List<FinServ__AssetsAndLiabilities__c> newRecordsList = new List<FinServ__AssetsAndLiabilities__c>();
        List<Application_Asset_Liability__c> insertRecordList = new List<Application_Asset_Liability__c>();
        Map<Id,List<FinServ__AssetsAndLiabilities__c>> recordTypeIdVsExistingRecordsMap = new Map<Id,List<FinServ__AssetsAndLiabilities__c>>();
        Map<Id,List<FinServ__AssetsAndLiabilities__c>> recordTypeIdVsNewRecordsMap = new Map<Id,List<FinServ__AssetsAndLiabilities__c>>();
        Map<String,FinServ__AssetsAndLiabilities__c> debtTypeNameVsRecordMap = new Map<String,FinServ__AssetsAndLiabilities__c>();
        List<String> debtTypeList = new List<String>();
        List<String> splitDebtTypeList = new List<String>();
        Set<String> debtTypeSet = new Set<String>();
        
        Applicant__c applicants = new Applicant__c(Id=applId,Total_Amount_Consolidated__c = totalConsolidated,Total_Monthly_Payment__c = totalMonthly);
        update applicants;
        
        Map<String, String> debtTypeVsAssetLiabilityRT = new Map<String, String>{
            'Unsecured Loan' => 'Other_Loans', 'Motor Vehicle Loan' => 'Motor_Vehicle',
                'Mortgage/ Home Equity Loan' => 'Real_Estate', 'Credit Card' => 'Credit_Cards',
                'Student Loan' => 'Student', 'Hire Purchase' => 'Hire_Purchase', 'Other' => 'Other_Loans'
                };    
                    
        List<FinServ__AssetsAndLiabilities__c> existingRecordList = [SELECT Id,Name,RecordTypeId FROM FinServ__AssetsAndLiabilities__c WHERE RecordtypeId IN:recordTypeNameVsId.values() AND FinServ__PrimaryOwner__c =:accId];
        if(!existingRecordList.isEmpty() && existingRecordList.size()>0){
            for(FinServ__AssetsAndLiabilities__c existingRecords : existingRecordList){
                if(recordTypeIdVsExistingRecordsMap.containsKey(existingRecords.RecordTypeId)){
                    recordTypeIdVsExistingRecordsMap.get(existingRecords.RecordTypeId).add(existingRecords);
                }
                else{
                    recordTypeIdVsExistingRecordsMap.put(existingRecords.RecordTypeId, new List<FinServ__AssetsAndLiabilities__c> { existingRecords });
                }
            }
        }
        for(Application_Asset_Liability__c assetLibRec : recordList){
            if(assetLibRec.Id == null){
                debtTypeSet.add(assetLibRec.Debt_Type_List__c);
            }
        }
        debtTypeList.addAll(debtTypeSet);
        if(!debtTypeList.isEmpty() && debtTypeList.size()>0){
            for(String debtType : debtTypeList){
                ID debtTypeId = recordTypeNameVsId.get(debtTypeVsAssetLiabilityRT.get(debtType));
                if(debtTypeId !=null){
                    if(recordTypeIdVsExistingRecordsMap.containsKey(debtTypeId)){
                        List<FinServ__AssetsAndLiabilities__c> recList = recordTypeIdVsExistingRecordsMap.get(debtTypeId);
                        if(!recList.isEmpty()){
                            for(FinServ__AssetsAndLiabilities__c rec : recList){
                                String[] splitDebtType = rec.Name.split('\\-');
                                splitDebtTypeList.add(splitDebtType[0]);
                                debtTypeNameVsRecordMap.put(splitDebtType[0],rec);
                            }
                        }
                    }
                }
            }
        }
        if(!debtTypeList.isEmpty() && debtTypeList.size()>0){
            for(String debtType : debtTypeList){
                FinServ__AssetsAndLiabilities__c newRecord = new FinServ__AssetsAndLiabilities__c();
                String dtype = debtTypeVsAssetLiabilityRT.get(debtType);
                ID debtTypeId = recordTypeNameVsId.get(dtype);
                if(debtTypeId !=null){
                    if(!recordTypeIdVsExistingRecordsMap.containsKey(debtTypeId)){
                        newRecord.RecordTypeId = recordTypeNameVsId.get(dtype);
                        newRecord.Name=debtType + '-' + System.now();
                        newRecord.FinServ__PrimaryOwner__c=accId;
                        newRecordsList.add(newRecord);
                    }
                    else if(recordTypeIdVsExistingRecordsMap.containsKey(debtTypeId)){
                        List<FinServ__AssetsAndLiabilities__c>recList=recordTypeIdVsExistingRecordsMap.get(debtTypeId);
                        if(!recList.isEmpty()){
                            if(!splitDebtTypeList.contains(debtType)){
                                newRecord.RecordTypeId = recordTypeNameVsId.get(dtype);
                                newRecord.Name=debtType + '-' + System.now();
                                newRecord.FinServ__PrimaryOwner__c=accId;
                                newRecordsList.add(newRecord);
                            }
                        }
                    }
                }
            }
        }
        if(!newRecordsList.isEmpty() && newRecordsList.size()>0){
            insert newRecordsList;
        }
        if(!newRecordsList.isEmpty() && newRecordsList.size()>0){
            for(FinServ__AssetsAndLiabilities__c newRecords : newRecordsList){
                if(recordTypeIdVsNewRecordsMap.containsKey(newRecords.RecordTypeId)){
                    recordTypeIdVsNewRecordsMap.get(newRecords.RecordTypeId).add(newRecords);
                }
                else{
                    recordTypeIdVsNewRecordsMap.put(newRecords.RecordTypeId, new List<FinServ__AssetsAndLiabilities__c> { newRecords });
                }
            }
        }   
        for(Application_Asset_Liability__c assetLibRec : recordList){
            if(assetLibRec.Id == null){
                if(debtTypeVsAssetLiabilityRT.containsKey(assetLibRec.Debt_Type_List__c)){
                    String type = debtTypeVsAssetLiabilityRT.get(assetLibRec.Debt_Type_List__c);
                    if(recordTypeNameVsId.containsKey(type)){
                        ID id = recordTypeNameVsId.get(type);
                        if(recordTypeIdVsExistingRecordsMap.ContainsKey(id)){
                            List<FinServ__AssetsAndLiabilities__c> assetLiabilityRecords = recordTypeIdVsExistingRecordsMap.get(id);
                            if(debtTypeNameVsRecordMap.containsKey(assetLibRec.Debt_Type_List__c)){
                                FinServ__AssetsAndLiabilities__c assetRecordVariable = debtTypeNameVsRecordMap.get(assetLibRec.Debt_Type_List__c);
                                assetLibRec.Assets_and_Liabilities__c = assetRecordVariable.Id;
                            }
                            else{
                                List<FinServ__AssetsAndLiabilities__c> newDebtTypeRecordList = recordTypeIdVsNewRecordsMap.get(id);
                                assetLibRec.Assets_and_Liabilities__c = newDebtTypeRecordList[0].Id;
                            }
                        }
                        else{
                            ID newAssetLiabilityRecordTypeId = recordTypeNameVsId.get(type);
                            if(recordTypeIdVsNewRecordsMap.ContainsKey(newAssetLiabilityRecordTypeId)){
                                List<FinServ__AssetsAndLiabilities__c> assetLiabilityRecords = recordTypeIdVsNewRecordsMap.get(newAssetLiabilityRecordTypeId);
                                for(FinServ__AssetsAndLiabilities__c sameAssetLibRecordTypes : assetLiabilityRecords){
                                    String[] splitDebtType = sameAssetLibRecordTypes.Name.split('\\-');
                                    if(splitDebtType[0] == assetLibRec.Debt_Type_List__c){
                                        assetLibRec.Assets_and_Liabilities__c = sameAssetLibRecordTypes.Id;
                                    }
                                }
                            }
                        }
                    }
                }
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
    
    /** This method returns the Application Assets//Liabilities records and display on component
* @param {string} Id
*/
    @AuraEnabled
    public static List<Application_Asset_Liability__c> getAssetLiabilityRecords(String Id){
        recordTypesMap = Util.getRecordTypeids('Application_Asset_Liability__c');
        Id recordType = recordTypesMap.get('Debt_Consolidation');
        return [SELECT Id,Debt_Type_List__c,Institution_Debt_List__c,Debt_Amount_Number__c,Application__r.Total_Amount_Consolidated__c,Application__r.Total_Monthly_Payment__c FROM Application_Asset_Liability__c WHERE Application__c =:Id AND RecordTypeId =:recordType];
    }
}