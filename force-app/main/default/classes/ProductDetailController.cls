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
   * retrieves default Jn custom meta data configuration
   * @return {JNConfiguration}
   */
  @AuraEnabled
  public static JNConfiguration GetJNConfigs(){
    try {
      return JNConfigurations.GetDefaultConfiguration();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
