/**
 * Ver  Ticket#      Date            Author                  Purpose
 * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)   Wrapper for Supplementary Card Holder
 **/
public with sharing class SupplementaryCardHolderWrapper {
  @AuraEnabled
  public String cardHolderName;
  @AuraEnabled
  public Id opportunityId;
  @AuraEnabled
  public Id accountId;
  @AuraEnabled
  public String currencyCode;
  @AuraEnabled
  public String supplementaryCardHolderName;
  public SupplementaryCardHolderWrapper(Supplementary_Card_Holders__c record) {
    this.accountId = record.Account__c;
    this.opportunityId = record.Opportunity__c;
    this.cardHolderName = record.Card_Holder_Name__c;
    this.currencyCode = record.CurrencyIsoCode;
    this.supplementaryCardHolderName = record.Name;
  }
}
