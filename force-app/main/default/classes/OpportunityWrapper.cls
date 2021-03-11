/***
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper for Opportunity Object
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
    this.collateralCC = opp.Collateral_CC__c;
    this.loanToValueCC = opp.Loan_to_ValueCC__c;
    this.accountId = opp.AccountId;
    this.preAssessmentDecision = opp.Pre_Approval_list__c;
    this.finalAssessmentDecision = opp.Final_Assessment_Decision_list__c;
    this.financialAccountName = opp.FinServ__FinancialAccount__r.Name;
    this.financialAccountNumber = opp.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c;
    this.financialAccountType = opp.FinServ__FinancialAccount__r.Account_Type_List__c;
  }
}