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
        this.age = accountObj.FinServ__Age__pc;
        this.statusOfAddress = accountObj.Status_of_Address__c;
        this.yearsAtResident = accountObj.Years_at_Residence__c;
        this.highestLevelOfEducation = accountObj.Highest_Level_of_Education__c;
    }
}
