public with sharing class FinancialDetailsUnwrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Applicant__c record;
  @AuraEnabled
  public Decimal realEstateHoldingsAssets;
  @AuraEnabled
  public Decimal motorVehicles;
  @AuraEnabled
  public Decimal savingsAccountsAndInvestmentsAssets;
  @AuraEnabled
  public Decimal lifeInsuranceAssets;
  @AuraEnabled
  public Decimal pensionAssets;
  @AuraEnabled
  public Decimal otherAssets;
  @AuraEnabled
  public Decimal mortgageBalance;
  @AuraEnabled
  public Decimal outstandingBalanceOnLoans;
  @AuraEnabled
  public Decimal averageCreditBalance;
  @AuraEnabled
  public Decimal averageLineOfCreditBalance;
  @AuraEnabled
  public Decimal totalMonthlyLoanPayments;
  @AuraEnabled
  public Decimal otherDebts;
  @AuraEnabled
  public Decimal mortgagePayment;
  @AuraEnabled
  public Decimal utilitiesAndHouseholdExpenses;
  @AuraEnabled
  public Decimal personalAndFamilyExpenses;
  @AuraEnabled
  public Decimal transportationExpenses;
  @AuraEnabled
  public Decimal otherExpenses;
  @AuraEnabled
  public Decimal totalStatutoryDeductions;
  @AuraEnabled
  public Decimal totalMonthlyExpenses;
  @AuraEnabled
  public String primarySourceOfIncome;
  @AuraEnabled
  public Decimal grossSalaryAllowances;
  @AuraEnabled
  public Decimal otherIncome;
  @AuraEnabled
  public Decimal netBusinessIncomeSoleTrader;
  @AuraEnabled
  public Decimal netBusinessIncomePartnership;
  @AuraEnabled
  public Decimal netBusinessIncomeCompanyShareholding;
  @AuraEnabled
  public Decimal directorEmoluments;
  @AuraEnabled
  public Decimal pensionIncome;
  @AuraEnabled
  public Decimal propertyRental;
  // @AuraEnabled
  // public Decimal totalOtherIncome;
  // @AuraEnabled
  // public Decimal totalMonthlyIncome;
  @AuraEnabled
  public Decimal totalAssets;
  @AuraEnabled
  public Decimal totalLiabilities;
  @AuraEnabled
  public Decimal netWorth;

  public FinancialDetailsUnwrapper(
    FinancialDetailsWrapper wrapper,
    String oppId
  ) {
    Map<String, Id> recordTypesMapForApplicants = Util.getRecordTypeids(
      'Applicant__c'
    );
    String IDMRecordTypeId = Util.getMappedRecordTypeId(
      'Instant_Designing_Module_IDM',
      recordTypesMapForApplicants
    );
    this.record = [
      SELECT
        Id,
        Real_Estate_Holding_s_VERIFIED_Number__c,
        Motor_Vehicle_s_VERIFIED__c,
        Savings_Current_Account_s_Investment_VER__c,
        Life_Insurance_Policy_Cash_Value_VER_Num__c,
        Pension_Contribution_s_VERIFIED_Number__c,
        Other_Asset_s_VERIFIED_Number__c,
        Total_Assets_Verified_Number__c,
        Mortgage_Balance_VERIFIED_Number__c,
        Other_Loan_s_VERIFIED_Number__c,
        Average_Credit_Card_Balances_VERIFIED__c,
        Average_Line_of_Credit_Balance_VERIFIED__c,
        Other_Debt_VERIFIED_Number__c,
        Total_Liabilities_Verified_Number__c,
        Net_Worth_Verified_Number__c,
        Gross_Monthly_Income_VERIFIED_Number__c,
        Other_Income_VERIFIED_Number__c,
        Net_Profit_Sole_Trader_VERIFIED_Number__c,
        Director_s_Emoluments_Director_VERIFIED__c,
        Share_of_Profit_Partnership_VERIFIED__c,
        Share_of_Profit_Shareholder_VERIFIED__c,
        Pension_VERIFIED_Number__c,
        Property_Rental_VERIFIED_Number__c,
        Total_Monthly_Loan_Payments_VERIFIED__c,
        Mortgage_Rent_VERIFIED_Number__c,
        Utilities_Household_Expenses_VERIFIED__c,
        Personal_and_Family_Expenses_VERIFIED__c,
        Transportation_VERIFIED_Number__c,
        Other_Expenses_VERIFIED_Number__c,
        Statutory_Deductions_VERIFIED_Number__c,
        Total_Monthly_Expenses_Verified_Number__c
      FROM Applicant__c
      WHERE Opportunity__c = :oppId AND RecordTypeId = :IDMRecordTypeId
    ];
    record.Real_Estate_Holding_s_VERIFIED_Number__c = wrapper.realEstateHoldingsAssets;
    record.Motor_Vehicle_s_VERIFIED__c = wrapper.motorVehicleAssets;
    record.Savings_Current_Account_s_Investment_VER__c = wrapper.savingsAccountsAndInvestmentsAssets;
    record.Life_Insurance_Policy_Cash_Value_VER_Num__c = wrapper.lifeInsuranceAssets;
    record.Pension_Contribution_s_VERIFIED_Number__c = wrapper.pensionAssets;
    record.Other_Asset_s_VERIFIED_Number__c = wrapper.otherAssets;
    record.Mortgage_Balance_VERIFIED_Number__c = wrapper.mortgageBalance;
    record.Other_Loan_s_VERIFIED_Number__c = wrapper.outstandingBalanceOnLoans;
    record.Average_Credit_Card_Balances_VERIFIED__c = wrapper.averageCreditBalance;
    record.Average_Line_of_Credit_Balance_VERIFIED__c = wrapper.averageLineOfCreditBalance;
    record.Other_Debt_VERIFIED_Number__c = wrapper.otherDebts;
    record.Total_Monthly_Loan_Payments_VERIFIED__c = wrapper.totalMonthlyLoanPayments;
    record.Mortgage_Rent_VERIFIED_Number__c = wrapper.mortgagePayment;
    record.Utilities_Household_Expenses_VERIFIED__c = wrapper.utilitiesAndHouseholdExpenses;
    record.Personal_and_Family_Expenses_VERIFIED__c = wrapper.personalAndFamilyExpenses;
    record.Transportation_VERIFIED_Number__c = wrapper.transportationExpenses;
    record.Other_Expenses_VERIFIED_Number__c = wrapper.otherExpenses;
    record.Statutory_Deductions_VERIFIED_Number__c = wrapper.totalStatutoryDeductions;
    record.Total_Monthly_Expenses_Verified_Number__c = wrapper.totalMonthlyExpenses;
    record.Primary_Source_of_Income_List__c = wrapper.primarySourceOfIncome;
    record.Gross_Monthly_Income_VERIFIED_Number__c = wrapper.grossSalaryAllowances;
    record.Other_Income_VERIFIED_Number__c = wrapper.otherIncome;
    record.Net_Profit_Sole_Trader_VERIFIED_Number__c = wrapper.netBusinessIncomeSoleTrader;
    record.Share_of_Profit_Partnership_VERIFIED__c = wrapper.netBusinessIncomePartnership;
    record.Share_of_Profit_Shareholder_VERIFIED__c = wrapper.netBusinessIncomeCompanyShareholding;
    record.Director_s_Emoluments_Director_VERIFIED__c = wrapper.directorEmoluments;
    record.Pension_VERIFIED_Number__c = wrapper.pensionIncome;
    record.Property_Rental_VERIFIED_Number__c = wrapper.propertyRental;
    record.Total_Assets_Verified_Number__c = wrapper.totalAssets;
    record.Total_Liabilities_Verified_Number__c = wrapper.totalLiabilities;
    record.Net_Worth_Verified_Number__c = wrapper.netWorth;
    System.debug('Applicant Record' + record);
  }
}
