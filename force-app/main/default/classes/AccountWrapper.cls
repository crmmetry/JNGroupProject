/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper for Account  
**/
public class AccountWrapper {

    @AuraEnabled
    public String statusOfAddress;
    @AuraEnabled
    public Integer yearsAtResident;
    @AuraEnabled
    public Integer age;
    @AuraEnabled
    public String highestLevelOfEducation;

    public AccountWrapper(Account accountObj) {
        this.age = accountObj.FinServ__Age__pc.intValue();
        this.statusOfAddress = accountObj.Status_of_Address__c;
        this.yearsAtResident = accountObj.Years_at_Residence__c.intValue();
        this.highestLevelOfEducation = accountObj.Highest_Level_of_Education__c;
    }
}