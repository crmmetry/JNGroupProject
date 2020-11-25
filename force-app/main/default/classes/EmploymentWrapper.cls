/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper for Employment Object  
**/
public with sharing class EmploymentWrapper {

    @AuraEnabled
    public String EmploymentStatus;
    @AuraEnabled
    public String industry;
    @AuraEnabled
    public Decimal lengthOfEmployment;
    @AuraEnabled
    public String professionalCategory;
    @AuraEnabled
    public String assessmentOfBusinessWorkingCapita;
    @AuraEnabled
    public String natureOfEngagement;
    @AuraEnabled
    public String assessmentOfBusiness;
    @AuraEnabled
    public String assessmentOfStatement;
    @AuraEnabled
    public String lengthOfTrade;
    @AuraEnabled
    public String employmentType;

    public EmploymentWrapper(FinServ__Employment__c employment) {
        this.EmploymentStatus = employment.FinServ__EmploymentStatus__c;
        this.industry = employment.Industry__c;
        this.lengthOfEmployment = employment.FinServ__LengthOfEmployment__c;
        this.professionalCategory = employment.Professional_Category__c;
        this.assessmentOfBusinessWorkingCapita = employment.Assessment_of_Business_Working_Capita__c;
        this.natureOfEngagement = employment.Nature_of_Engagement__c;
        this.assessmentOfBusiness = employment.Assessment_of_Business__c;
        this.assessmentOfStatement = employment.Assessment_of_Statement__c;
        this.lengthOfTrade = employment.Length_of_Trade__c;
        this.employmentType = Schema.getGlobalDescribe().get('FinServ__Employment__c').getDescribe().getRecordTypeInfosById().get(employment.RecordTypeId).getName();
    }
}