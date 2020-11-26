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
  public String creditHistoryInLast24Month; //JN1-4045
  @AuraEnabled
  public String assessmentOfApplicantNetWorth; //JN1-4045

  public ApplicantWrapper(Applicant__c record) {
    System.debug(record);
    this.Id = record.Id;
    this.dob = record.Account__r.PersonBirthdate;
    this.age = calculateAge(dob);
    this.checkCreditorLifeEligibility();
    this.creditHistoryInLast24Month = record.Credit_History_in_last_24_Months__c; //JN1-4045
    this.assessmentOfApplicantNetWorth = record.Assessment_of_Applicant_Net_Worth__c; //JN1-4045
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
