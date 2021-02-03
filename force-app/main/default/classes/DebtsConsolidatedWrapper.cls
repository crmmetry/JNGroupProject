public with sharing class DebtsConsolidatedWrapper {
  @AuraEnabled
  public Id Id;
  @AuraEnabled
  public String debtType;
  @AuraEnabled
  public Decimal debtAmount;
  @AuraEnabled
  public String institutionDebt;

  public DebtsConsolidatedWrapper(Application_Asset_Liability__c record) {
    this.Id = record.Id;
    this.debtType = record.Debt_Type_List__c;
    this.debtAmount = record.Debt_Amount_Number__c;
    this.institutionDebt = record.Institution_Debt_List__c;
  }
}
