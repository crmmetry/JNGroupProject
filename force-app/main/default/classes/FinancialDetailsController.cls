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
}
