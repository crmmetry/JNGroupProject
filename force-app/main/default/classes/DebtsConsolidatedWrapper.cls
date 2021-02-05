public with sharing class DebtsConsolidatedWrapper {
  @AuraEnabled
  public Id Id;
  @AuraEnabled
  public String debtType;
  @AuraEnabled
  public Decimal debtAmount;
  @AuraEnabled
  public String institutionDebt;
  @AuraEnabled
  public String debtTypeVerified;
  @AuraEnabled
  public Decimal debtAmountVerified;
  @AuraEnabled
  public String institutionDebtVerified;

  public DebtsConsolidatedWrapper(Application_Asset_Liability__c record) {
    this.Id = record.Id;
    this.debtType = record.Debt_Type_List__c;
    this.debtAmount = record.Debt_Amount_Number__c;
    this.institutionDebt = record.Institution_Debt_List__c;
    this.debtTypeVerified = record.Debt_Type_VERIFIED_List__c;
    this.debtAmountVerified = record.Debt_Amount_VERIFIED_Number__c;
    this.institutionDebtVerified = record.Institution_Debt_is_with_VERIFIED_list__c;
  }
}
