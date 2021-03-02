/**
* Ver  Ticket#      Date            Author                 Purpose
* 1.0  RUB-134     18/02/2021      Tushar C.(thinqloud)  	To Save and get Application Asset/Liability records
**/
public class DebtConsolidationRecordController {
    
public static Map<String, Id> recordTypesMap{get;set;}

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
    Id recordType = recordTypesMap.get('Debt_Consolidation');
    Set<String> recordTypes = new Set<String>();
    Set<Id> insertedIDs = new Set<ID>();
    List<FinServ__AssetsAndLiabilities__c> newRecordsList = new List<FinServ__AssetsAndLiabilities__c>();
    List<Application_Asset_Liability__c> insertRecordList = new List<Application_Asset_Liability__c>();
    Map<String,Id> recordTypeNameVsId = new Map<String,Id>();
    Map<String,FinServ__AssetsAndLiabilities__c> idVsAssetLiabilityMap = new Map<String,FinServ__AssetsAndLiabilities__c>();   
	Map<String,Application_Asset_Liability__c> idVsApplAssetLiabilityMap = new Map<String,Application_Asset_Liability__c>();
    Map<Id,List<FinServ__AssetsAndLiabilities__c>> recordTypeIdVsExistingRecordsMap = new Map<Id,List<FinServ__AssetsAndLiabilities__c>>();
    Map<Id,List<FinServ__AssetsAndLiabilities__c>> recordTypeIdVsNewRecordsMap = new Map<Id,List<FinServ__AssetsAndLiabilities__c>>();
    Map<Id,RecordType> recordTypeIdVsRecordTypeName;

    Applicant__c applicants = new Applicant__c(Id=applId,Total_Amount_Consolidated__c = totalConsolidated,Total_Monthly_Payment__c = totalMonthly);
    update applicants;

    Map<String, String> debtTypeVsAssetLiabilityRT = new Map<String, String>{
        'Unsecured Loan' => 'Other Loans', 'Motor Vehicle Loan' => 'Motor Vehicle',
        'Mortgage/ Home Equity Loan' => 'Real Estate', 'Credit Card' => 'Credit Cards',
        'Student Loan' => 'Student', 'Hire Purchase' => 'Hire Purchase', 'Other' => 'Other Loans'
            };    

    Schema.DescribeFieldResult fieldResult = Application_Asset_Liability__c.Debt_Type_List__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : ple){
        System.debug(pickListVal.getValue());
        recordTypes.add(debtTypeVsAssetLiabilityRT.get(pickListVal.getValue()));

    }
    recordTypeIdVsRecordTypeName = new Map<Id,RecordType>([SELECT Id, Name FROM RecordType WHERE Name IN:recordTypes]);
    for(ID recordTypeId : recordTypeIdVsRecordTypeName.keySet()){
            RecordType recTypes = recordTypeIdVsRecordTypeName.get(recordTypeId);
            recordTypeNameVsId.put(recTypes.Name, recTypes.Id);
    }
    List<FinServ__AssetsAndLiabilities__c> existingRecordList = [SELECT Id,Name,RecordTypeId FROM FinServ__AssetsAndLiabilities__c WHERE RecordtypeId IN:recordTypeIdVsRecordTypeName.keySet() AND FinServ__PrimaryOwner__c =:accId];
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
    List<String> debtTypeList = new List<String>();
    Set<String> debtTypeSet = new Set<String>();

    for(Application_Asset_Liability__c assetLibRec : recordList){
        if(assetLibRec.Id == null){
            debtTypeList.add(assetLibRec.Debt_Type_List__c);
        }
    }

    debtTypeList.addAll(debtTypeSet);
    
    if(!debtTypeList.isEmpty() && debtTypeList.size()>0){
        for(String debtType : debtTypeList){
            FinServ__AssetsAndLiabilities__c newRecord = new FinServ__AssetsAndLiabilities__c();
            String dtype = debtTypeVsAssetLiabilityRT.get(debtType);
            ID debtTypeId = recordTypeNameVsId.get(dtype);
            if(!recordTypeIdVsExistingRecordsMap.containsKey(debtTypeId)){
                newRecord.RecordTypeId = recordTypeNameVsId.get(dtype);
                newRecord.Name=debtType + '-' + System.now();
                newRecord.FinServ__PrimaryOwner__c=accId;
                newRecordsList.add(newRecord);
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
                    for(FinServ__AssetsAndLiabilities__c sameAssetLibRecordTypes : assetLiabilityRecords){
                        String[] splitDebtType = sameAssetLibRecordTypes.Name.split('\\-');
                        if(splitDebtType[0] == assetLibRec.Debt_Type_List__c){
                        	assetLibRec.Assets_and_Liabilities__c = sameAssetLibRecordTypes.Id;
                        }
                    }
                }
                else{
                    ID id1 = recordTypeNameVsId.get(type);
                    if(recordTypeIdVsNewRecordsMap.ContainsKey(id1)){
                        List<FinServ__AssetsAndLiabilities__c> assetLiabilityRecords = recordTypeIdVsNewRecordsMap.get(id1);
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