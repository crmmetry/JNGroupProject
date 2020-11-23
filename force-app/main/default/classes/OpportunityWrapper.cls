public with sharing class OpportunityWrapper {

    @AuraEnabled
    public String collateralCC;
    @AuraEnabled
    public Decimal loanToValueCC;

    public OpportunityWrapper(Opportunity opp) {
        this.collateralCC = opp.Collateral_CC__c;
        this.loanToValueCC = opp.Loan_to_Value_CC__c;
    }
}
