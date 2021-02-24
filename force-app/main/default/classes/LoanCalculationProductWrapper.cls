/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-24-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public inherited sharing class LoanCalculationProductWrapper {
  @AuraEnabled
  public Decimal market;
  @AuraEnabled
  public Decimal startingLimit;
  @AuraEnabled
  public Decimal minimumPayment;
  @AuraEnabled
  public Decimal monthlyInterestRate;
  @AuraEnabled
  public Decimal totalLoanAmount;
  @AuraEnabled
  public Decimal totalMonthlyLoanPayment;
  @AuraEnabled
  public Decimal monthlyCompulsorySavings;
  @AuraEnabled
  public Decimal jnCreditorLifePremium;
  @AuraEnabled
  public Decimal totalLoanSavingsBalance;
  @AuraEnabled
  public Decimal totalInterestPayment;
  @AuraEnabled
  public Decimal legalFees;
  @AuraEnabled
  public Decimal stampDuty;
  @AuraEnabled
  public Decimal processingFees;
  @AuraEnabled
  public Decimal creditReportFee;
  @AuraEnabled
  public Decimal creditorLifeInsuranceRate;
  @AuraEnabled
  public Decimal monthlyJNLifePremium;
  @AuraEnabled
  public Decimal totalFees;
  @AuraEnabled
  public Decimal policyLimit;
  @AuraEnabled
  public Decimal tdsrAfter;
  @AuraEnabled
  public Decimal tdsrBefore;

  public LoanCalculationProductWrapper(Loan_Calculation_Product__c record) {
    this.market = record.Loan_Amount_Market_Percentage_Number__c;
    this.startingLimit = record.Approved_Starting_Limit_Number__c;
    this.minimumPayment = record.Minimum_Payment_per_Credit_Limit_Number__c;
    this.monthlyInterestRate = record.Monthly_Interest_Rate_Number__c;
    this.totalLoanAmount = record.Total_Loan_Amount_Number__c;
    this.totalMonthlyLoanPayment = record.Total_Monthly_Loan_Payment_Number__c;
    this.monthlyCompulsorySavings = record.Monthly_Compulsory_Savings_Number__c;
    this.jnCreditorLifePremium = record.Creditor_Life_Insurance_Premium_Number__c;
    this.totalLoanSavingsBalance = record.Total_Compulsory_Savings_Balance_Number__c;
    this.totalInterestPayment = record.Total_Interest_Payment_Repayment_Number__c;
    this.legalFees = record.Legal_Fees_including_GCT_Number__c;
    this.processingFees = record.Processing_Fees_including_GCT_Number__c;
    this.stampDuty = record.Stamp_Duty_Number__c;
    this.creditReportFee = record.Credit_Report_Fee_Number__c;
    this.creditorLifeInsuranceRate = record.Creditor_Life_Insurance_Rate_Number__c;
    this.monthlyJNLifePremium = record.Monthly_P_I_Life_Insurance_Premium__c;
    this.totalFees = record.Total_Closing_Costs_Number__c;
    this.policyLimit = record.Policy_Limit_Number__c;
    this.tdsrAfter = record.Ability_to_Service_After_Number__c;
    this.tdsrBefore = record.Ability_to_Service_Before_Number__c;
  }
}
