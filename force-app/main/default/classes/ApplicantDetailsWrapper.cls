public with sharing class ApplicantDetailsWrapper {

    @AuraEnabled
    public String creditHistoryInLast24Month;
    @AuraEnabled
    public String assessmentOfApplicantNetWorth; 

    public ApplicantDetailsWrapper(Applicant__c applicant) {
        this.creditHistoryInLast24Month = applicant.Credit_History_in_last_24_Months__c;
        this.assessmentOfApplicantNetWorth = applicant.Assessment_of_Applicant_Net_Worth__c;
    }
}
