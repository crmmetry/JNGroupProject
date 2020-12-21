public with sharing class ApplicantAssetsAndLiabilitiesWrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Decimal monthlyLoanPaymentPrior; //JN1-3967
  @AuraEnabled
  public Decimal monthlyLoanPaymentAfter; //JN1-3967
  @AuraEnabled
  public Decimal minimumPaymentPrior; //JN1-3967
  @AuraEnabled
  public Decimal minimumPaymentAfter; //JN1-3967
  @AuraEnabled
  public Decimal percentApplicantPortion; //JN1-4231
  @AuraEnabled
  public Decimal monthlyLoanApplicantPortionPrior; //JN1-4231
  @AuraEnabled
  public Decimal monthlyLoanApplicantPortionAfter; //JN1-4231

  public ApplicantAssetsAndLiabilitiesWrapper(
    Application_Asset_Liability__c record
  ) {
    //System.debug(record);
    this.Id = record.Id;
    this.monthlyLoanPaymentPrior = record.Monthly_Payment_Prior__c; //JN1-3967
    this.monthlyLoanPaymentAfter = record.Monthly_Payment_After__c; //JN1-3967
    this.minimumPaymentPrior = record.Minimum_Payment_Calc__c; //JN1-3967
    this.minimumPaymentAfter = record.Minimum_Payment_After_Calc__c; //JN1-3967
    this.percentApplicantPortion = record.Assets_and_Liabilities__r.Percent_Applicant_Portion__c; //JN1-4231
    this.monthlyLoanApplicantPortionPrior = CalcualteApplicantLoanPortionPrior(
      monthlyLoanPaymentPrior,
      percentApplicantPortion
    );
    this.monthlyLoanApplicantPortionAfter = CalcualteApplicantLoanPortionPrior(
      monthlyLoanPaymentAfter,
      percentApplicantPortion
    );
  }
  private Decimal CalcualteApplicantLoanPortionPrior(
    Decimal amount,
    Decimal percentage
  ) {
    Decimal applicantPortion;
    if (amount != null && percentage != null) {
      applicantPortion = amount * (percentage / 100);
      return applicantPortion;
    }
    return 0;
  }
}
