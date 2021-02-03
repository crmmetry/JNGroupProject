public with sharing class FinancialDetailsUnwrapper {
  @AuraEnabled
  public Applicant__c record;
  @AuraEnabled
  public Id applicantId;

  public FinancialDetailsUnwrapper(Applicant__c wrapper) {
    this.applicantId = wrapper.Id;
    this.record = [
      SELECT
        Id,
        Real_Estate_Holding_s_VERIFIED_Number__c,
        Motor_Vehicle_s_VERIFIED__c,
        Savings_Current_Account_s_Investment_VER__c,
        Life_Insurance_Policy_Cash_Value_VER_Num__c,
        Pension_Contribution_s_VERIFIED_Number__c,
        Other_Asset_s_VERIFIED_Number__c,
        Total_Assets_VERIFIED_Calc__c,
        Debt_Type_VERIFIED_List__c,
        Mortgage_Balance_VERIFIED_Number__c,
        Other_Loan_s_VERIFIED_Number__c,
        Average_Credit_Card_Balances_VERIFIED__c,
        Average_Line_of_Credit_Balance_VERIFIED__c,
        Other_Debt_VERIFIED_Number__c,
        Total_Liabilities_VERIFIED_Calc__c,
        Debt_Amount_VERIFIED_Number__c,
        Net_Worth_VERIFIED_Calc__c,
        Gross_Monthly_Income_VERIFIED_Number Other_Income_VERIFIED_Number,
        Net_Profit_Sole_Trader_VERIFIED_Number,
        Director_s_Emoluments_Director_VERIFIED,
        Share_of_Profit_Partnership_VERIFIED,
        Share_of_Profit_Shareholder_VERIFIED,
        Pension_VERIFIED_Number,
        Property_Rental_VERIFIED_Number,
        Total_Monthly_Loan_Payments_VERIFIED Mortgage_Rent_VERIFIED_Number,
        Utilities_Household_Expenses_VERIFIED,
        Personal_and_Family_Expenses_VERIFIED,
        Transportation_VERIFIED_Number,
        Other_Expenses_VERIFIED_Number,
        Statutory_Deductions_VERIFIED_Number,
        Total_Expenses_VERIFIED_Calc__c
      FROM Applicant__c
      WHERE Id = :wrapper.Id
    ];
    record.Real_Estate_Holding_s_VERIFIED_Number = serializer.realEstateHoldings;
    record.Motor_Vehicle_s_VERIFIED = serializer.motorVehicles;
    record.Savings_Current_Account_s_Investment_VER = serializer.savingsAccountsAndInvestments;
    record.Life_Insurance_Policy_Cash_Value_VER_Num = serializer.lifeInsuranceAssets;
    record.Pension_Contribution_s_VERIFIED_Number = serializer.pensionAssets;
    record.Other_Asset_s_VERIFIED_Number = serializer.otherAssets;
    record.Mortgage_Balance_VERIFIED_Number = serializer.mortgageBalance;
    record.Other_Loan_s_VERIFIED_Number = serializer.outstandingBalanceOnLoans;
    record.Average_Credit_Card_Balances_VERIFIED = serializer.averageCreditBalance;
    record.Average_Line_of_Credit_Balance_VERIFIED = serializer.averageLineOfCreditBalance;
    record.Other_Debt_VERIFIED_Number = serializer.otherDebts;
    record.Total_Monthly_Loan_Payments_VERIFIED = serializer.totalMonthlyLoanPayments;
    record.Mortgage_Rent_VERIFIED_Number = serializer.mortgagePayment;
    record.Utilities_Household_Expenses_VERIFIED = serializer.utilitiesAndHouseholdExpenses;
    record.Personal_and_Family_Expenses_VERIFIED = serializer.personalAndFamilyExpenses;
    record.Transportation_VERIFIED_Number = serializer.transportationExpenses;
    record.Other_Expenses_VERIFIED_Number = serializer.otherExpenses;
    record.Statutory_Deductions_VERIFIED_Number = serializer.totalStatutoryDeductions;
    record.Total_Expenses_VERIFIED_Calc__c = serializer.totalMonthlyExpenses;
    record.Primary_Source_of_Income_List = serializer.primarySourceOfIncome;
    record.Gross_Monthly_Income_VERIFIED_Number = serializer.grossSalaryAllowances;
    record.Other_Income_VERIFIED_Number = serializer.otherIncome;
    record.Net_Profit_Sole_Trader_VERIFIED_Number = serializer.netBusinessIncomeSoleTrader;
    record.Share_of_Profit_Partnership_VERIFIED = serializer.netBusinessIncomePartnership;
    record.Share_of_Profit_Shareholder_VERIFIED = serializer.netBusinessIncomeCompanyShareholding;
    record.Director_s_Emoluments_Director_VERIFIED = serializer.directorEmoluments;
    record.Pension_VERIFIED_Number = serializer.pensionIncome;
    record.Property_Rental_VERIFIED_Number = serializer.propertyRental;
    record.Total_Assets_VERIFIED_Calc = serializer.totalAssets;
    record.Total_Liabilities_VERIFIED_Calc = serializer.totalLiabilities;
    record.Net_Worth_VERIFIED_Calc = serializer.netWorth;
  }

  /**
   * updates and existing applicant with verified financial details
   * @param {Id} opportunityId
   * @return {Id}
   */
  public Id updateApplicantFinancialDetails(Id opportunityId) {
    try {
      Map<String, Id> recordTypeIds = Util.getRecordTypeids('Applicant__c');
      update this.record;
      return this.record.Id;
    } catch (Exception e) {
      System.debug(TAG + ' ' + e.getMessage());
      throw new StringException(e.getMessage());
    }
  }
}
