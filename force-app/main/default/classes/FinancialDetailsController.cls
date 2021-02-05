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
    List<SObject> recordsToBeUpdated = new List<SObject>();
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
      recordsToBeUpdated.add(applicantDetails);
      System.debug('Applicant records' + recordsToBeUpdated);
      //Serializing Debt Consolidation Objects
      // for (Map<String, Object> debts : consolidatedDebts) {
      //   String jsonValuesForDebtConsolidations = json.serialize(debts);
      //   DebtsConsolidatedWrapper debtWrapper = (DebtsConsolidatedWrapper) json.deserialize(
      //     jsonValuesForDebtConsolidations,
      //     DebtsConsolidatedWrapper.class
      //   );
      //   DebtConsolidationUnwrapper debtUnwrapper = new DebtConsolidationUnwrapper(
      //     debtWrapper
      //   );
      //   Application_Asset_Liability__c debtRecord = debtUnwrapper.record;
      //   recordsToBeUpdated.add(debtRecord);
      // }
      System.debug('Aplicant Details: ' + applicantDetails);
      update recordsToBeUpdated;
      return Constants.STATUS_SUCCESS_CODE;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
