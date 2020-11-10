public with sharing class ApplicantWrapper {
  @AuraEnabled
  public String Id;
  @AuraEnabled
  public Date dob;
  @AuraEnabled
  public Integer age;
  @AuraEnabled
  public Decimal rating;
  public ApplicantWrapper(Applicant__c record) {
    this.Id = record.Id;
    this.dob = record.Account__r.Date_of_Birth__pc;
    this.age = calculateAge(dob);
  }

  private Integer calculateAge(Date dob) {
    Integer currentYear = Date.today().year();
    Integer currentMonth = Date.today().month();
    Integer birthYear = dob.year();
    Integer birthMonth = dob.month();
    Integer age = currentYear - birthYear;
    if (currentMonth > birthMonth) {
      return age + 1;
    }
    return age;
  }
}
