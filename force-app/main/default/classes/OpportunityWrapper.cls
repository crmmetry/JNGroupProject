/***
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper for Opportunity Object
 * 2.0  JN1 - 4359   12/03/2021      Sunil                  Null Condition check is added
 **/
public with sharing class OpportunityWrapper {
  @AuraEnabled
  public String collateralCC;
  @AuraEnabled
  public Decimal loanToValueCC;
  @AuraEnabled
  public Id accountId;
  @AuraEnabled
  public String preAssessmentDecision;
  @AuraEnabled
  public String finalAssessmentDecision;
  @AuraEnabled
  public String financialAccountName;
  @AuraEnabled
  public String financialAccountNumber;
  @AuraEnabled
  public String financialAccountType;

  public OpportunityWrapper(Opportunity opp) {
    if (opp != null) {
      if (opp.Collateral_CC__c != null) {
        this.collateralCC = opp.Collateral_CC__c;
      }
      if (opp.Loan_to_ValueCC__c != null) {
        this.loanToValueCC = opp.Loan_to_ValueCC__c;
      }
      if (opp.AccountId != null) {
        this.accountId = opp.AccountId;
      }
      if (opp.Pre_Approval_list__c != null) {
        this.preAssessmentDecision = opp.Pre_Approval_list__c;
      }
      if (opp.Final_Assessment_Decision_list__c != null) {
        this.finalAssessmentDecision = opp.Final_Assessment_Decision_list__c;
      }
      if (opp.FinServ__FinancialAccount__r.Name != null) {
        this.financialAccountName = opp.FinServ__FinancialAccount__r.Name;
      }
      if (
        opp.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c !=
        null
      ) {
        this.financialAccountNumber = opp.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c;
      }
      if (opp.FinServ__FinancialAccount__r.Account_Type_List__c != null) {
        this.financialAccountType = opp.FinServ__FinancialAccount__r.Account_Type_List__c;
      }
    }
  }
}
