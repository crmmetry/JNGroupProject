/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-22-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-22-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public class ProductSelectionWrapper {
  @AuraEnabled
  public String productFamily;
  @AuraEnabled
  public String productName;
  @AuraEnabled
  public Decimal productPrice;
  @AuraEnabled
  public String product;

  public ProductSelectionWrapper(OpportunityLineItem record) {
    this.productFamily = record.Product_Family__c;
    this.productName = record.Name;
    this.productPrice = record.UnitPrice;
    this.product = record.Product2.Name;
  }
}
