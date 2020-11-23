public with sharing class ApplicantAssetsAndLiabilitiesWrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Decimal minimumPayment;

  public ApplicantAssetsAndLiabilitiesWrapper(
    Application_Asset_Liability__c record
  ) {
    //System.debug(record);
    this.Id = record.Id;
    this.minimumPayment = record.Minimum_Payment__c;
  }
}
