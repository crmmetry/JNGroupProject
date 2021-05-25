/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 05-24-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public with sharing class FinancialDetailsWrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Decimal realEstateHoldingsAssets;
  @AuraEnabled
  public Decimal motorVehicleAssets;
  @AuraEnabled
  public Decimal savingsAccountInvestmentAssets;
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
  @AuraEnabled
  public Decimal realEstateHoldingsAssetsVerified;
  @AuraEnabled
  public Decimal motorVehicleAssetsVerified;
  @AuraEnabled
  public Decimal savingsAccountInvestmentAssetsVerified;
  @AuraEnabled
  public Decimal lifeInsuranceAssetsVerified;
  @AuraEnabled
  public Decimal pensionAssetsVerified;
  @AuraEnabled
  public Decimal otherAssetsVerified;
  @AuraEnabled
  public Decimal mortgageBalanceVerified;
  @AuraEnabled
  public Decimal outstandingBalanceOnLoansVerified;
  @AuraEnabled
  public Decimal averageCreditBalanceVerified;
  @AuraEnabled
  public Decimal averageLineOfCreditBalanceVerified;
  @AuraEnabled
  public Decimal totalMonthlyLoanPaymentsVerified;
  @AuraEnabled
  public Decimal otherDebtsVerified;
  @AuraEnabled
  public Decimal mortgagePaymentVerified;
  @AuraEnabled
  public Decimal utilitiesAndHouseholdExpensesVerified;
  @AuraEnabled
  public Decimal personalAndFamilyExpensesVerified;
  @AuraEnabled
  public Decimal transportationExpensesVerified;
  @AuraEnabled
  public Decimal otherExpensesVerified;
  @AuraEnabled
  public Decimal totalStatutoryDeductionsVerified;
  @AuraEnabled
  public Decimal totalMonthlyExpensesVerified;
  @AuraEnabled
  public String primarySourceOfIncomeVerified;
  @AuraEnabled
  public Decimal grossSalaryAllowancesVerified;
  @AuraEnabled
  public Decimal otherIncomeVerified;
  @AuraEnabled
  public Decimal netBusinessIncomeSoleTraderVerified;
  @AuraEnabled
  public Decimal netBusinessIncomePartnershipVerified;
  @AuraEnabled
  public Decimal netBusinessIncomeCompanyShareholdingVerified;
  @AuraEnabled
  public Decimal directorEmolumentsVerified;
  @AuraEnabled
  public Decimal pensionIncomeVerified;
  @AuraEnabled
  public Decimal propertyRentalVerified;
  @AuraEnabled
  public Decimal totalOtherIncome;
  @AuraEnabled
  public Decimal totalMonthlyIncome;
  @AuraEnabled
  public Decimal totalOtherIncomeVerified;
  @AuraEnabled
  public Decimal totalMonthlyIncomeVerified;
  @AuraEnabled
  public Decimal totalAssetsVerified;
  @AuraEnabled
  public Decimal totalLiabilitiesVerified;
  @AuraEnabled
  public Decimal netWorthVerified;
  @AuraEnabled
  public Decimal totalDebtConsolidated;
  @AuraEnabled
  public Decimal totalDebtConsolidatedVerified;
  @AuraEnabled
  public Decimal totalMonthlyPayment;
  @AuraEnabled
  public Decimal totalMonthlyPaymentVerified;

  public FinancialDetailsWrapper(Applicant__c record) {
    this.Id = record.Id;
    this.realEstateHoldingsAssets = record.Real_Estate_Market_Value_Number__c;
    this.motorVehicleAssets = record.Motor_Vehicle_Market_Value_Number__c;
    this.savingsAccountInvestmentAssets = record.Savings_Deposit_Investments__c;
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
    this.primarySourceOfIncome = record.Primary_Source_of_Income_List__c;
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
    this.realEstateHoldingsAssetsVerified = record.Real_Estate_Holding_s_VERIFIED_Number__c;
    this.motorVehicleAssetsVerified = record.Motor_Vehicle_s_VERIFIED__c;
    this.savingsAccountInvestmentAssetsVerified = record.Savings_Current_Account_s_Investment_VER__c;
    this.lifeInsuranceAssetsVerified = record.Life_Insurance_Policy_Cash_Value_VER_Num__c;
    this.pensionAssetsVerified = record.Pension_Contribution_s_VERIFIED_Number__c;
    this.otherAssetsVerified = record.Other_Asset_s_VERIFIED_Number__c;
    this.mortgageBalanceVerified = record.Mortgage_Balance_VERIFIED_Number__c;
    this.outstandingBalanceOnLoansVerified = record.Other_Loan_s_VERIFIED_Number__c;
    this.averageCreditBalanceVerified = record.Average_Credit_Card_Balances_VERIFIED__c;
    this.averageLineOfCreditBalanceVerified = record.Average_Line_of_Credit_Balance_VERIFIED__c;
    this.otherDebtsVerified = record.Other_Debt_VERIFIED_Number__c;
    this.mortgagePaymentVerified = record.Mortgage_Rent_VERIFIED_Number__c;
    this.utilitiesAndHouseholdExpensesVerified = record.Utilities_Household_Expenses_VERIFIED__c;
    this.personalAndFamilyExpensesVerified = record.Personal_and_Family_Expenses_VERIFIED__c;
    this.transportationExpensesVerified = record.Transportation_VERIFIED_Number__c;
    this.otherExpensesVerified = record.Other_Expenses_VERIFIED_Number__c;
    this.totalStatutoryDeductionsVerified = record.Statutory_Deductions_VERIFIED_Number__c;
    this.totalMonthlyExpensesVerified = record.Total_Monthly_Expenses_Verified_Number__c;
    this.primarySourceOfIncomeVerified = record.Primary_Source_of_Income_VERIFIED_list__c;
    this.grossSalaryAllowancesVerified = record.Gross_Monthly_Income_VERIFIED_Number__c;
    this.otherIncomeVerified = record.Other_Income_VERIFIED_Number__c;
    this.netBusinessIncomeSoleTraderVerified = record.Net_Profit_Sole_Trader_VERIFIED_Number__c;
    this.netBusinessIncomePartnershipVerified = record.Share_of_Profit_Partnership_VERIFIED__c;
    this.netBusinessIncomeCompanyShareholdingVerified = record.Share_of_Profit_Shareholder_VERIFIED__c;
    this.directorEmolumentsVerified = record.Director_s_Emoluments_Director_VERIFIED__c;
    this.pensionIncomeVerified = record.Pension_VERIFIED_Number__c;
    this.propertyRentalVerified = record.Property_Rental_VERIFIED_Number__c;
    this.totalAssetsVerified = record.Total_Assets_Verified_Number__c;
    this.totalLiabilitiesVerified = record.Total_Liabilities_Verified_Number__c;
    this.netWorthVerified = record.Net_Worth_Verified_Number__c;
    this.totalDebtConsolidated = record.Total_Amount_Consolidated__c;
    this.totalDebtConsolidatedVerified = record.Total_Amount_Consolidation_VERIFIED__c;
    this.totalMonthlyPayment = record.Total_Monthly_Payment__c;
    this.totalMonthlyPaymentVerified = record.Total_Monthly_Payment_VERIFIED_Number__c;
    this.totalMonthlyLoanPaymentsVerified = record.Total_Monthly_Loan_Payments_VERIFIED__c;
    this.totalOtherIncome = record.Total_Other_Income_Calc__c;
    this.totalMonthlyIncome = record.Total_Monthly_Income_Calc__c;
    this.totalOtherIncomeVerified = record.Total_Other_Income_Verified__c;
    this.totalMonthlyIncomeVerified = record.Total_Monthly_Income_Verified__c;
  }
}
