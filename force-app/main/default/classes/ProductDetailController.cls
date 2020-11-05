public with sharing class ProductDetailController {
  /**
   * Return a Product Selection Object consisting of an opportunity product name and family.
   * @param {Id} - oppId
   * @return Object
   */
  @AuraEnabled
  public static Object getSingleProductFamilySelection(Id oppId) {
    System.debug('Controller');
    OpportunityLineItem oppProduct = Util.getOpportunityProducts(oppId);
    if (oppProduct != null) {
      Wrappers.ProductSelectionWrapper selection = new Wrappers.ProductSelectionWrapper(
        oppProduct
      );
      return selection;
    }
    return Constants.NONE;
  }

  /**
   * Return appropriate creditor rate from creditor life matrix metadata for an applicant
   * @param {Id} - oppId
   * @return Object
   */

  @AuraEnabled
  public static Deciaml getCreditorRating(String oppId) {
    Opportunity oppRecord = [
      SELECT Id, (SELECT Id, Account__r.Age__c FROM Applicants__c)
      FROM Opportunity
      WHERE Id = :oppId
    ];
  }
}
