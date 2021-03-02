/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Added Fields in wrappper
 **/
public with sharing class ApplicantWrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Date dob;
  @AuraEnabled
  public Integer age;
  @AuraEnabled
  public Decimal rating;
  @AuraEnabled
  public Boolean eligibleForCreditorLife;
  @AuraEnabled
  public Decimal salutaryDeductions;
  @AuraEnabled
  public Decimal rentStrataMaintenance;
  @AuraEnabled
  public Decimal personalMonthlyExpensesPriorLoan;
  @AuraEnabled
  public Decimal savingsPensionInsurance;
  @AuraEnabled
  public Decimal realEstateMonthlyPayment;
  @AuraEnabled
  public Decimal motorVehicleMonthlyRepayment;
  @AuraEnabled
  public Decimal otherAssetMonthlyPayment;
  @AuraEnabled
  public Decimal otherLoanMonthlyPayment;
  @AuraEnabled
  public Decimal grossMonthlyIncome;
  @AuraEnabled
  public String creditHistoryInLast24Month; //JN1-4045
  @AuraEnabled
  public String assessmentOfApplicantNetWorth; //JN1-4045
  @AuraEnabled
  public Decimal rentBoardMonthlyPrior; //JN1-3967
  @AuraEnabled
  public Decimal rentBoardMonthlyAfter; //JN1-3967
  @AuraEnabled
  public Decimal rentStrataMaintenanceFromLongSummaryPrior; //JN1-3967
  @AuraEnabled
  public Decimal rentStrataMaintenanceFromLongSummaryAfter; //JN1-3967
  @AuraEnabled
  public Decimal grossMonthlyIncomeFromLongSummary; //JN1-3967
  @AuraEnabled
  public List<Application_Asset_Liability__c> applicationAssetLiabilities;

  public ApplicantWrapper(Applicant__c record) {
    this.Id = record.Id;
    if (record.Account__r != null) {
      this.dob = record.Account__r.PersonBirthdate;
      this.age = calculateAge(dob);
    }

    this.checkCreditorLifeEligibility();
    if (record.Statutory_Deductions_Numbers__c != null) {
      this.salutaryDeductions = record.Statutory_Deductions_Numbers__c;
    }
    if (record.Rent_Strata_Maintenance__c != null) {
      this.rentStrataMaintenance = record.Rent_Strata_Maintenance__c;
    }
    if (record.Personal_Expenses_Monthly_Prior_Loan__c != null) {
      this.personalMonthlyExpensesPriorLoan = record.Personal_Expenses_Monthly_Prior_Loan__c;
    }
    if (record.Savings_Pension_Insurance_Number__c != null) {
      this.savingsPensionInsurance = record.Savings_Pension_Insurance_Number__c;
    }
    if (record.Real_Estate_Monthly_Payment_Number__c != null) {
      this.realEstateMonthlyPayment = record.Real_Estate_Monthly_Payment_Number__c;
    }
    if (record.Motor_Vehicle_Monthly_Payment_Number__c != null) {
      this.motorVehicleMonthlyRepayment = record.Motor_Vehicle_Monthly_Payment_Number__c;
    }
    if (record.Other_Asset_Monthly_Payment_Number__c != null) {
      this.otherAssetMonthlyPayment = record.Other_Asset_Monthly_Payment_Number__c;
    }
    if (record.Other_Loan_Monthly_Payment_Number__c != null) {
      this.otherLoanMonthlyPayment = record.Other_Loan_Monthly_Payment_Number__c;
    }
    if (record.Gross_Monthly_Income__c != null) {
      this.grossMonthlyIncome = record.Gross_Monthly_Income__c;
    }

    if (record.Credit_History_in_last_24_Months__c != null) {
      this.creditHistoryInLast24Month = record.Credit_History_in_last_24_Months__c; //JN1-4045
    }
    if (record.Assessment_of_Applicant_Net_Worth__c != null) {
      this.assessmentOfApplicantNetWorth = record.Assessment_of_Applicant_Net_Worth__c; //JN1-4045
    }

    if (record.Rent_Board_Monthly_Prior_Loan__c != null) {
      this.rentBoardMonthlyPrior = record.Rent_Board_Monthly_Prior_Loan__c; //JN1-3967
    }
    if (record.Rent_Board_Monthly_After_Loan__c != null) {
      this.rentBoardMonthlyAfter = record.Rent_Board_Monthly_After_Loan__c; //JN1-3967
    }
    if (record.Strata_Maintenance_Monthly_Prior_Loan__c != null) {
      this.rentStrataMaintenanceFromLongSummaryPrior = record.Strata_Maintenance_Monthly_Prior_Loan__c; //JN1-3967
    }
    if (record.Strata_Maintenance_Monthly_After_Loan__c != null) {
      this.rentStrataMaintenanceFromLongSummaryAfter = record.Strata_Maintenance_Monthly_After_Loan__c; //JN1-3967
    }
    if (record.Gross_Monthly_IncomeC__c != null) {
      this.grossMonthlyIncomeFromLongSummary = record.Gross_Monthly_IncomeC__c;
    }
    if (record.Application_Assets_Liabilities__r != null) {
      this.applicationAssetLiabilities = record.Application_Assets_Liabilities__r;
    }
  }

  private Integer calculateAge(Date dob) {
    Integer currentYear = Date.today().year();
    Integer currentMonth = Date.today().month();
    Integer currentDay = Date.today().day();
    if (dob == null) {
      return -1;
    }
    Integer birthYear = dob.year();
    Integer birthMonth = dob.month();
    Integer birthDay = dob.day();
    Integer age = currentYear - birthYear;
    if (!(currentMonth >= birthMonth) && !(currentDay >= birthday)) {
      return age - 1;
    }
    return age;
  }

  private void checkCreditorLifeEligibility() {
    if (this.age > Constants.MAX_CREDITOR_LIFE_AGE) {
      this.eligibleForCreditorLife = false;
    } else {
      this.eligibleForCreditorLife = true;
    }
  }
}
