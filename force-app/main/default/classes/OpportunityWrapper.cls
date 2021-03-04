/**
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

  public OpportunityWrapper(Opportunity opp) {
    this.collateralCC = opp.Collateral_CC__c;
    this.loanToValueCC = opp.Loan_to_ValueCC__c;
    this.accountId = opp.AccountId;
  }
}