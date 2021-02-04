public with sharing class DebtConsolidationUnwrapper {
  @AuraEnabled
  public Application_Asset_Liability__c record;
  @AuraEnabled
  public Id oppId;

  public DebtConsolidationUnwrapper(DebtsConsolidatedWrapper wrapper) {
    this.record = [
      SELECT
        Id,
        Debt_Amount_VERIFIED_Number__c,
        Institution_Debt_is_with_VERIFIED_list__c,
        Debt_Type_VERIFIED_List__c
      FROM Application_Asset_Liability__c
      WHERE Id = :wrapper.Id
    ];
    record.Debt_Amount_VERIFIED_Number__c = wrapper.debtAmount;
    record.Institution_Debt_is_with_VERIFIED_list__c = wrapper.institutionDebt;
    record.Debt_Type_VERIFIED_List__c = wrapper.debtType;
  }
}
