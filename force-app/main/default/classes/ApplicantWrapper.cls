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
  public ApplicantWrapper(Applicant__c record) {
    System.debug(record);
    this.Id = record.Id;
    this.dob = record.Account__r.Date_of_Birth__pc;
    this.age = calculateAge(dob);
    this.checkCreditorLifeEligibility();
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
