public with sharing class FinancialDetailsWrapper {
  @AuraEnabled
  public Id Id;
  @AuraEnabled
  public Decimal realEstateHoldings;
  @AuraEnabled
  public Decimal motorVehicles;
  @AuraEnabled
  public Decimal savingsAccountsAndInvestments;
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

  public FinancialDetailsWrapper(Applicant__c record) {
    this.Id = record.Id;
    this.realEstateHoldings = record.Real_Estate_Market_Value_Number__c;
    this.motorVehicles = record.Motor_Vehicle_Market_Value_Number__c;
    this.savingsAccountsAndInvestments = record.Savings_Deposit_Investments__c;
    this.lifeInsuranceAssets = record.Life_Insurance_Cash_Value__c;
    this.pensionAssets = record.Pension_IRS_Total_Contribution__c;
    this.otherAssets = record.Other_Asset_Market_Value_Number__c;
    this.mortgageBalance = record.Mortgage_Balance_Number__c;
    this.outstandingBalanceOnLoans = record.Other_Loan_Loan_Balance_Number__c;
    this.averageCreditBalance = record.Average_Credit_Card_Balances_Number__c;
    this.averageLineOfCreditBalance = record.Average_Line_of_Credit_Balance_Number__c;
    this.otherDebts = record.Other_Debt_Number__c;
    this.totalMonthlyLoanPayments = record.Total_Liabilities_Calc__c;
    this.mortgagePayment = record.Mortgage_Rent_Number__c;
    this.utilitiesAndHouseholdExpenses = record.Utilties_and_Household_Expenses_Number__c;
    this.personalAndFamilyExpenses = record.Personal_and_Family_Expenses_Number__c;
    this.transportationExpenses = record.Transportation_Number__c;
    this.otherExpenses = record.Other_Expenses_Number__c;
    this.totalStatutoryDeductions = record.Statutory_Deductions_Numbers__c;
    this.totalMonthlyExpenses = record.Total_Expenses_Calc__c;
    this.primarySourceOfIncome = record.Applicable_sources_of_income__c;
    this.grossSalaryAllowances = record.Gross_Monthly_Income__c;
    this.otherIncome = record.Other_Income__c;
    this.netBusinessIncomeSoleTrader = record.Net_Profit_Sole_Trader__c;
    this.netBusinessIncomePartnership = record.Share_of_Profit_Partnership__c;
    this.netBusinessIncomeCompanyShareholding = record.Share_of_Profit_Shareholder__c;
    this.directorEmoluments = record.Director_s_Emoluments_Director__c;
    this.pensionIncome = record.Pension__c;
    this.propertyRental = record.Existing_Real_Estate_Rental_I__c;
    this.totalAssets = record.Total_Assets_Calc__c;
    this.totalLiabilities = record.Total_Liabilities_Calc__c;
    this.netWorth = record.Net_Worth_Calc__c;
  }
}
