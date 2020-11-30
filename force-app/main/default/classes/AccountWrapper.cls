/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper for Account
 **/
public class AccountWrapper {
  @AuraEnabled
  public String statusOfAddress;
  @AuraEnabled
  public Decimal yearsAtResident;
  @AuraEnabled
  public Decimal age;
  @AuraEnabled
  public String highestLevelOfEducation;

  public AccountWrapper(Account accountObj) {
    this.age = Decimal.valueOf(calculateAge(accountObj.PersonBirthdate));
    this.statusOfAddress = accountObj.Status_of_Address__pc;
    this.yearsAtResident = accountObj.Years_at_Residence__pc;
    this.highestLevelOfEducation = accountObj.Highest_Level_of_Education_attained__pc;
  }
  /**
   * calculates age
   * @param {Date} dob
   * @return {Integer}
   */
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
}
