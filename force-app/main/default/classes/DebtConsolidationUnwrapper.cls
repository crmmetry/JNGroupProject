public with sharing class DebtConsolidationUnwrapper {
  @AuraEnabled
  public Application_Asset_Liability__c record;
  @AuraEnabled
  public Id oppId;

  public DebtConsolidationUnwrapper(DebtsConsolidatedWrapper wrapper) {
    this.record = [
      SELECT
        Id,
        Account_Number__c,
        Debt_Amount_VERIFIED_Number__c,
        Institution_Debt_is_with_VERIFIED_list__c,
        Debt_Type_VERIFIED_List__c
      FROM Application_Asset_Liability__c
      WHERE Id = :wrapper.Id
    ];
    record.Debt_Amount_VERIFIED_Number__c = wrapper.debtAmountVerified;
    record.Institution_Debt_is_with_VERIFIED_list__c = wrapper.institutionDebtVerified;
    record.Debt_Type_VERIFIED_List__c = wrapper.debtTypeVerified;
    record.Account_Number__c = wrapper.accountNumber;
  }
}
