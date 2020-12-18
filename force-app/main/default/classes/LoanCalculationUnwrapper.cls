public class LoanCalculationUnwrapper {
  private static final String TAG = 'LoanCalculationUnwrapper';
  @AuraEnabled
  public Loan_Calculator__c record;
  public LoanCalculationUnwrapper(ProductDetailsSerializer serializer) {
    this.record = new Loan_Calculator__c();
    record.Loan_Amount__c = serializer.loanAmount;
    record.Interested_in_programme__c = serializer.interestedInPremiumFlag;
    record.Include_first_year_premium_in_loan_amt__c = serializer.jngiIncludeInLoan;
    record.Monthly_Premium__c = serializer.jngiMonthlyPremium;
    record.Waive_Process_Fee__c = serializer.waiveProcessingFeeFlag;
    record.Include_in_Loan_Amount_Processing_Fee__c = serializer.includeInLoanAmountFlag;
    record.Coverage_Type__c = serializer.coverageType;
    record.Type_of_Card__c = serializer.cardType;
    record.Purchase_Price_of_Vehicle__c = serializer.purchasePrice;
    record.Market_Value_of_Vehicle__c = serializer.marketValue;
    record.Minimum_PurchasePrice_MarketValue_Number__c = serializer.minimumOfPurchaseMarketValue;
    record.JNGI_Motor_Premium_1st_Year__c = serializer.jngiMotorPremium;
    record.Monthly_JNGI_Motor_Premium_1st_Year__c = serializer.monthlyPIJNGIMotorPremium;
    record.NSIPP_Registration_Fees_Number__c = serializer.nsipp;
    record.Assignment_Fee_Number__c = serializer.assignmentFee;
    record.Total_Closing_Costs_Number__c = serializer.totalClosingCost;
    record.Estimated_Stamp_Duty_AdminCharges_Number__c = serializer.stampDutyAndAdminCharges;
    record.Total_Closing_Costs_Financed_JN_Number__c = serializer.totalFinancedByJN;
    record.TotalClosingCost_PayableApplicant_Number__c = serializer.totalClosingCostsApplicantPayable;
    record.Stamp_Duty__c = serializer.stampDuty;
    record.Creditor_Life_Denial_Reason_Text__c = serializer.noCreditorLifeReason;
  }
  /**
   * save loan calculations oject
   * @param {Id} opportunityId
   * @return {Id}
   */
  public Id save(Id opportunityId) {
    try {
      this.record.Opportunity__c = opportunityId;
      insert this.record;
      return this.record.Id;
    } catch (Exception e) {
      System.debug(TAG + ' ' + e.getMessage());
      throw new StringException(e.getMessage());
    }
  }
}