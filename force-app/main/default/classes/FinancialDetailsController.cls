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
    Map<String, String> financialDetailsMap,
    List<Map<String, String>> consolidatedDebts
  ) {
    try {
      return Constants.STATUS_SUCCESS_CODE;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
