public class ProductSelectionWrapper {
  @AuraEnabled
  public String productFamily;
  @AuraEnabled
  public String productName;
  @AuraEnabled
  public Decimal productPrice;

  public ProductSelectionWrapper(OpportunityLineItem record) {
    this.productFamily = record.Product_Family__c;
    this.productName = record.Name;
    this.productPrice = record.UnitPrice;
  }
}
