/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper For Loan Calculations
 **/
public with sharing class LoanCalculationsWrapper {
  @AuraEnabled
  public String repaymentMethod;
  @AuraEnabled
  public Decimal abilityToServiceCC;

  public LoanCalculationsWrapper(Loan_Calculator__c loanCalculations) {
    this.repaymentMethod = loanCalculations.Repayment_Method_CC__c;
    this.abilityToServiceCC = loanCalculations.Ability_to_Service_CC__c;
  }
}
