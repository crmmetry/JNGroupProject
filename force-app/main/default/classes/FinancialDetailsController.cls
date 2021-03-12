/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-11-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-24-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class FinancialDetailsController {
  /**
   * RUB-63
   * return a map of wrapper records belonging to applicant's financial details
   * @param {Id} oppId - opportunity Id.
   * @return {FinancialDetailsWrapper} - returns  applicant financial details in wrapper format
   */
  @AuraEnabled
  public static FinancialDetailsWrapper getApplicantFinancialDetails(Id oppId) {
    try {
      FinancialDetailsWrapper financialDetails = FinancialDetailsSelector.financialDetailsSelector(
        oppId
      );
      return financialDetails;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  /**
   * RUB-63
   * return a list containing all the debts belonging to an Applicant to be consolidated
   * @param {Id} oppId - opportunity Id.
   */
  @AuraEnabled
  public static void updateFieldOnOpportunity(
    Id oppId,
    String fieldAPIName,
    Object value
  ) {
    try {
      Opportunity oppRecord = new Opportunity(Id = oppId);
      oppRecord.put(fieldAPIName, value);
      update oppRecord;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  /**
   * RUB-193
   * updates opportunity record
   * @param {Id} oppId - opportunity Id.
   * @return {List<DebtConsolidatedWrapper>} - returns  applicant financial details in wrapper format
   */
  @AuraEnabled
  public static List<DebtsConsolidatedWrapper> getApplicantConsolidatedDebts(
    Id oppId
  ) {
    try {
      List<DebtsConsolidatedWrapper> consolidatedDebts = FinancialDetailsSelector.debtsConsolidatedSelector(
        oppId
      );
      return consolidatedDebts;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  @AuraEnabled
  public static Object getPickListValuesList(
    String objectApiName,
    List<String> fieldApiNames
  ) {
    String recordTypeId;
    List<String> pickListValuesList = new List<String>();
    Map<String, List<String>> mapFields = new Map<String, List<String>>();
    List<String> specificValues;
    Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();
    Schema.sObjectType sObjType = globalDescription.get(objectApiName);
    Schema.DescribeSObjectResult r1 = sObjType.getDescribe();
    Map<String, Schema.SObjectField> mapFieldList = r1.fields.getMap();

    for (String fieldApiName : fieldApiNames) {
      Schema.SObjectField field = mapFieldList.get(fieldApiName);
      Schema.DescribeFieldResult fieldResult = field.getDescribe();
      List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
      pickListValuesList = new List<String>();
      for (Schema.PicklistEntry pickListVal : ple) {
        pickListValuesList.add(pickListVal.getLabel());
      }
      mapFields.put(fieldApiName, pickListValuesList);
    }

    return mapFields;
  }

  /** *
   * Saves financial details information
   * @param {Id} opportunityId
   * @param {List<String>} productRecordTypes
   * @return {Integer}
   */
  @AuraEnabled
  public static Integer saveFinancialDetailsAndConsolidatedDebts(
    Map<String, Object> financialDetailsMap,
    String oppId,
    List<Map<String, Object>> consolidatedDebts
  ) {
    Boolean hasCustomPermission = FeatureManagement.checkPermission(
      'Financial_Verification_Permission'
    );
    if (!hasCustomPermission) {
      throw new AuraException(
        Constants.FINACIAL_VERIFICATION_CUSTOM_PERMISSION_ERROR
      );
    }
    List<SObject> recordsToBeUpdated = new List<SObject>();
    List<Applicant__c> applicantRecords = new List<Applicant__c>();
    List<Application_Asset_Liability__c> debtRecords = new List<Application_Asset_Liability__c>();
    try {
      //Serializing Applicant Details Object
      String jsonValuesForFinancialDetails = json.serialize(
        financialDetailsMap
      );
      FinancialDetailsWrapper financialWrapper = (FinancialDetailsWrapper) json.deserialize(
        jsonValuesForFinancialDetails,
        FinancialDetailsWrapper.class
      );
      FinancialDetailsUnwrapper financialUnwrapper = new FinancialDetailsUnwrapper(
        financialWrapper,
        oppId
      );
      Applicant__c applicantDetails = financialUnwrapper.record;
      applicantRecords.add(applicantDetails);
      //Serializing Debt Consolidation Objects
      for (Map<String, Object> debts : consolidatedDebts) {
        String jsonValuesForDebtConsolidations = json.serialize(debts);
        DebtsConsolidatedWrapper debtWrapper = (DebtsConsolidatedWrapper) json.deserialize(
          jsonValuesForDebtConsolidations,
          DebtsConsolidatedWrapper.class
        );
        DebtConsolidationUnwrapper debtUnwrapper = new DebtConsolidationUnwrapper(
          debtWrapper
        );
        Application_Asset_Liability__c debtRecord = debtUnwrapper.record;
        debtRecords.add(debtRecord);
      }
      recordsToBeUpdated.addAll(applicantRecords);
      recordsToBeUpdated.addAll(debtRecords);
      update recordsToBeUpdated;
      return Constants.STATUS_SUCCESS_CODE;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
