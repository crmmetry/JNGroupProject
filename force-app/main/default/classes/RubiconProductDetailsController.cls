/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public inherited sharing class RubiconProductDetailsController {
  @AuraEnabled
  public static Object getIDMProductDetails(Id oppId) {
    LoanCalculationProductWrapper loanProductRecord = ProductDetailSelector.getLoanCalculationRecord(
      oppId
    );
    if (loanProductRecord != null) {
      return loanProductRecord;
    }
    return Constants.NONE;
  }

  /**
   * RUB-23
   * return a map of wrapper records belonging to applicant and their assets/liabilities
   * @param {Id} oppId - opportunity Id.
   * @return {List<SupplementaryCardHolderWrapper>} - returns  supplementary card holder details in wrapper format
   */
  @AuraEnabled
  public static List<SupplementaryCardHolderWrapper> getSupplementaryCardHolders(
    Id oppId
  ) {
    try {
      List<SupplementaryCardHolderWrapper> supplementaryWrapperList = ProductDetailSelector.getSupplementaryCardHolder(
        oppId
      );
      return supplementaryWrapperList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  /**
   * Return a Product Selection Object consisting of an opportunity product name and family.
   * @param {Id} - oppId
   * @return Object
   */
  @AuraEnabled
  public static Object getSingleProductFamilySelection(Id oppId) {
    List<OpportunityLineItem> records = Util.getOpportunityProducts(oppId);
    if (records.size() == 1) {
      ProductSelectionWrapper selection = new ProductSelectionWrapper(
        records[0]
      );
      return selection;
    }
    return Constants.NONE;
  }
}
