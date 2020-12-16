public class LoanCalculationProductWrapper {
  /**
   * Story #: JN1-4001
   */
  @AuraEnabled
  public Decimal loanAmount;
  @AuraEnabled
  public Decimal startingLimit;
  @AuraEnabled
  public Decimal assignmentFee;
  @AuraEnabled
  public Decimal years;
  @AuraEnabled
  public Decimal months;
  public LoanCalculationProductWrapper(Loan_Calculation_Product__c record) {
    this.loanAmount = record.Loan_Amount__c;
    this.startingLimit = record.Starting_Limit__c;
    this.assignmentFee = record.Assignment_Fee_Number__c;
    this.years = record.Years_Number__c;
    this.months = record.Months_Number__c;
  }
}
