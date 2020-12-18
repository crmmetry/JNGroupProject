public class LoanCalculationProductUnwrapper {
  private static final String TAG = 'LoanCalculationUnwrapper';
  @AuraEnabled
  public Loan_Calculation_Product__c record;
  public LoanCalculationProductUnwrapper(
    ProductDetailsSerializer serializer,
    List<String> recordTypes
  ) {
    this.record = new Loan_Calculation_Product__c();
    this.record.recordTypeId = assignRecordType(recordTypes);
    record.Years_Number__c = serializer.years;
    record.Months_Number__c = serializer.months;
    record.Loan_Amount_Market_Percentage_Number__c = serializer.market;
    record.Applicable_Processing_Fee_Number__c = serializer.processingFeePercentagePerAnum;
    record.Repayment_Method_List__c = serializer.repaymentMethod;
    record.Desired_Monthly_Repayment_Date__c = serializer.repaymentDate;
    record.Proposed_Savings_Number__c = serializer.proposedSavingsAmount;
    record.Proposed_Savings_Percentage_Number__c = serializer.proposedSavingsPercentage;
    record.Processing_Fees_including_GCT_Number__c = serializer.processingFeesGCT;
    record.Monthly_PI_Processing_Fee_Number__c = serializer.monthlyPrincipalInterestProcessingFee;
    record.Legal_Fees_including_GCT_Number__c = serializer.legalFee;
    record.Processing_Fees_Closing_Cost_GCT_Number__c = serializer.processingFeeClosingCost;
    record.JN_Life_Creditor_Life_Premium_Number__c = serializer.jnLifeCreditorPremium;
    record.Monthly_Compulsory_Savings_Number__c = serializer.monthlyCompulsorySavings;
    record.Total_Compulsory_Savings_Balance_Number__c = serializer.totalCompulsorySavingsBalance;
    record.Monthly_Creditor_Life_Premium_Number__c = serializer.monthlyJnLifeCreditor_PI_Premium;
    record.Total_Loan_Amount_Number__c = serializer.totalLoanAmount;
    record.Total_Monthly_Loan_Payment_Number__c = serializer.totalMonthlyLoanPayment;
    record.Total_Monthly_PI_Loan_Payment_Number__c = serializer.totalMonthly_PI_LoanPayment;
    record.Total_Interest_Payment_Repayment_Number__c = serializer.totalInterestPaymentBalance;
    record.Total_Monthly_Saving_Loan_Payment_Number__c = serializer.totalMonthlyLoanPaymentAndSavings;
    record.Monthly_P_I_Life_Insurance_Premium__c = serializer.monthlyJnLifeCreditor_PI_Premium;
    record.Ability_to_Service_After_Number__c = serializer.TDSRAfter;
    record.Ability_to_Service_Before_Number__c = serializer.TDSRBefore;
    record.Policy_Limit_Number__c = serializer.policyLimit;
    record.Monthly_PI_Loan_Amount_Number__c = serializer.monthly_PI_LoanAmount;
    record.Creditor_Life_Insurance_Premium_Number__c = serializer.jnCLPremiumFeesAndCharges;
  }
  /**
   * save loan calculation product object
   * @param {Id} loanCalculationId
   * @return {Id}
   */
  public Id save(Id loanCalculationId) {
    try {
      this.record.Loan_Calculation_Id__c = loanCalculationId;
      insert this.record;
      return this.record.Id;
    } catch (Exception e) {
      System.debug(TAG + ' ' + e.getMessage());
      throw new StringException(e.getMessage());
    }
  }
  /** *
   * assigns record type
   * @param {List<String>} recordTypes
   * @return {Id} recordTypeId
   */
  private Id assignRecordType(List<String> recordTypes) {
    Map<String, Id> recordTypeIds = Util.getRecordTypeids(
      'Loan_Calculation_Product__c'
    );
    Id recordTypeId;
    if (recordTypes != null) {
      for (String recordType : recordTypes) {
        if (recordType == Constants.AUTO_PRODUCT_FAMILY) {
          recordTypeId = recordTypeIds.get('Auto');
        } else if (recordType == Constants.LINEOFCREDIT_PRODUCT_FAMILY) {
          recordTypeId = recordTypeIds.get('Line_of_Credit');
        } else if (recordType == Constants.CREDITCARD_PRODUCT_FAMILY) {
          recordTypeId = recordTypeIds.get('Credit_Card');
        } else if (recordType == Constants.UNSECURED_PRODUCT_FAMILY) {
          recordTypeId = recordTypeIds.get('Unsecured');
        }
      }
    }
    return recordTypeId;
  }
}
