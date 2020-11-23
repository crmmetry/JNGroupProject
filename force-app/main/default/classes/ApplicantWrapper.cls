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

  public ApplicantWrapper(Applicant__c record) {
    System.debug(record);
    this.Id = record.Id;
    if (record.Account__r != null) {
      this.dob = record.Account__r.PersonBirthdate;
      this.age = calculateAge(dob);
    }

    this.checkCreditorLifeEligibility();
    this.salutaryDeductions = record.Statutory_Deductions_Numbers__c;
    this.rentStrataMaintenance = record.Rent_Strata_Maintenance__c;
    this.personalMonthlyExpensesPriorLoan = record.Personal_Expenses_Monthly_Prior_Loan__c;
    this.savingsPensionInsurance = record.Savings_Pension_Insurance_Number__c;
    this.realEstateMonthlyPayment = record.Real_Estate_Monthly_Payment_Number__c;
    this.motorVehicleMonthlyRepayment = record.Motor_Vehicle_Monthly_Payment_Number__c;
    this.otherAssetMonthlyPayment = record.Other_Asset_Monthly_Payment_Number__c;
    this.otherLoanMonthlyPayment = record.Other_Loan_Monthly_Payment_Number__c;
  }

  private Integer calculateAge(Date dob) {
    Integer currentYear = Date.today().year();
    Integer currentMonth = Date.today().month();
    Integer currentDay = Date.today().day();
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
