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
