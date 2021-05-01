/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 04-30-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-26-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
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
    record.Applicable_Processing_Fee_Number__c = serializer.processingFeePercentagePerAnum;
    record.Repayment_Method_List__c = serializer.repaymentMethod;
    record.Desired_Monthly_Repayment_Date__c = serializer.repaymentDate;
    record.Proposed_Savings_Number__c = serializer.proposedSavingsAmount;
    record.Proposed_Savings_Percentage_Number__c = serializer.proposedSavingsPercentage;
    record.Processing_Fees_including_GCT_Number__c = serializer.processingFeesGCT;
    record.Monthly_PI_Processing_Fee_Number__c = serializer.monthlyPrincipalInterestProcessingFee;
    record.Legal_Fees_including_GCT_Number__c = serializer.legalFee;
    record.Processing_Fees_Closing_Cost_GCT_Number__c = serializer.processingFeeClosingCost;
    record.Monthly_Compulsory_Savings_Number__c = serializer.monthlyCompulsorySavings;
    record.Total_Compulsory_Savings_Balance_Number__c = serializer.totalCompulsorySavingsBalance;
    record.Total_Monthly_Loan_Payment_Number__c = serializer.totalMonthlyLoanPayment;
    record.Total_Monthly_PI_Loan_Payment_Number__c = serializer.totalMonthly_PI_LoanPayment;
    record.Total_Interest_Payment_Repayment_Number__c = serializer.totalInterestPaymentBalance;
    record.Total_Monthly_Saving_Loan_Payment_Number__c = serializer.totalMonthlyLoanPaymentAndSavings;
    record.Monthly_P_I_Life_Insurance_Premium__c = serializer.monthlyJnLifeCreditor_PI_Premium;
    record.Ability_to_Service_After_Number__c = serializer.TDSRAfter;
    record.Ability_to_Service_Before_Number__c = serializer.TDSRBefore;
    record.Policy_Limit_Number__c = serializer.policyLimit;
    record.Monthly_PI_Loan_Amount_Number__c = serializer.monthly_PI_LoanAmount;
    record.JN_Life_Creditor_Life_Premium_Number__c = serializer.jnCLPremiumFeesAndCharges;
    record.Collateral_Type_List__c = serializer.collateralType;
    record.Coverage_Type_List__c = serializer.coverageType;
    record.Annual_Membership_Primary_Number__c = serializer.primaryApplicantAnnualMembership;
    record.Annual_Membership_Supplementary_Number__c = serializer.supplementaryApplicantAnnualMembership;
    record.Supplementary_Card_Holder_Count_Number__c = serializer.numberOfSupplementaryCardHolders;
    record.Annual_Creditor_Life_Fee_Number__c = serializer.creditorLifeAnnualFee;
    record.Minimum_Payment_per_Credit_Limit_Number__c = serializer.minimumPayment;
    record.Starting_Limit_Number__c = serializer.approvedStartingLimit;
    record.Motor_Vehicle_Deposit_Number__c = serializer.autoCollateralDeposit;
    record.Motor_Vehicle_Deposit_Percentage_Number__c = serializer.autoCollateralDepositPercentage;
    record.Computed_Auto_Collateral_Deposit_Number__c = serializer.computedAutoCollateralDepositFromPercentage;
    record.Loan_Purpose_List__c = serializer.loanPurpose;
    record.Account_Type_List__c = serializer.accountType;
    record.Stamp_Duty_Number__c = serializer.stampDuty;
    record.Total_Closing_Costs_Financed_Number__c = serializer.totalFinancedByJN;
    record.Total_Closing_Costs_By_Client_Number__c = serializer.totalPayableByApplicant;
    record.Total_Closing_Costs_Number__c = serializer.totalClosingCost;
    record.Loan_Amount_Number__c = serializer.loanAmount;
    record.Waive_Processing_Fee_Flag__c = serializer.waiveProcessingFeeFlag;
    record.Include_in_Loan_Amount_Processing_Flag__c = serializer.includeInLoanAmountFlag;
    record.Interested_in_Creditor_Life_Flag__c = serializer.interestedInCreditorLife;
    record.Include_in_Loan_Amount_Flag__c = serializer.includeCreditorLifeInLoanAmount;
    record.Deduct_1st_month_Payment_from_Loan_Flag__c = serializer.deductRepayment;
    record.JNGI_Motor_Premium_1st_Year_during_Numbe__c = serializer.jngiMotorPremium;
    record.JN_Motor_Premium_Closing_Cost_Number__c = serializer.jngiMotorPremiumFeesAndCharges;
    record.Monthly_P_I_JNGI_Motor_Premium_Number__c = serializer.monthlyPIJNGIMotorPremium;
    record.NSIPP_Registration_Fees_Number__c = serializer.nsipp;
    record.Market_Value_of_Vehicle_Number__c = serializer.marketValue;
    record.Purchase_Price_of_Vehicle_Number__c = serializer.purchasePrice;
    record.Minimum_of_Purchase_Price_Market_Number__c = serializer.minimumOfPurchaseMarketValue;
    record.Year_of_Motor_Vehicle_Number__c = serializer.yearOfVehicle;
    record.Vehicle_Classification_list__c = serializer.vehicleClassification;
    record.Make_and_Model_of_Motor_Vehicle_text__c = serializer.makeAndModelOfVehicle;
    record.Monthly_JNGI_Motor_Premium_Number__c = serializer.jngiMonthlyPremium;
    record.Include_in_Loan_Amount_JNGI_list__c = serializer.jngiIncludeInLoan;
    record.Interest_Rate_Number__c = serializer.market;
    record.Total_Loan_Amount_Number__c = serializer.totalLoanAmount;
    record.Interested_in_JNGI_SureCover_flag__c = serializer.interested;
    record.Requested_Credit_Limit_Number__c = serializer.requestedCreditLimit;
    record.Financial_Institution_List__c = serializer.financialInstitution;
    record.Deposit_Account_Number_Number__c = serializer.jnBankAccountNumber;
    record.X1st_Month_s_Instalment_Payable_Number__c = serializer.firstPaymentInstallable;
    record.Deposit_Account_Number_Prefix_text__c = serializer.jnBankAccountNumberPrefix;
    record.Account_Holder_s_text__c = serializer.accountHolder;
    record.Annual_Interest_Rate_Deposit_Acct_Number__c = serializer.annualInterestRate;
    record.Deposit_Account_Balance_Number__c = serializer.depositBalance;
    record.Life_Insurance_Coverage_List__c = serializer.lifeInsuranceCoverage;
    record.Desired_Statement_Date__c = serializer.repaymentDate;
    record.Loan_to_Value_Number__c = serializer.LTVValue;
    record.Account_Hypothecated_list__c = serializer.hypothecatedLoan;
    record.Monthly_Creditor_Life_Premium_Number__c = serializer.creditorLifePremiumForNonRevolvingLoan;
    record.Creditor_Life_Insurance_Premium_Number__c = serializer.jnLifeCreditorPremium;
    if (!String.isBlank(serializer.policyProvider)) {
      record.Assignment_Fee_Number__c = serializer.assignmentFee;
      record.Estimated_Stamp_Duty_Admin_Charges_Numb__c = serializer.estimatedStampDutyAndAdminFee;
    } else {
      record.Assignment_Fee_Number__c = 0;
      record.Estimated_Stamp_Duty_Admin_Charges_Numb__c = 0;
    }
    if (
      serializer.jnBankAccountNumber == '' ||
      serializer.jnBankAccountNumber == null
    ) {
      record.Deposit_Account_Number_Number__c = serializer.depositAccountNumber;
    }
    if (serializer.hypothecatedLoan == 'Yes') {
      record.Existing_Loan_Balance_Number__c = serializer.existingBalance;
    } else {
      record.Existing_Loan_Balance_Number__c = 0;
    }
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
