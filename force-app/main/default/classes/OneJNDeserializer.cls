/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public class OneJNDeserializer {
    public Loan_Calculation_Product__c loanCalculationProductRecord{get; set;}
    public Applicant__c primaryApplicantRecord{get; set;}
    public Applicant__c coApplicantRecord{get; set;}
    public Application__c applicationRecord{get; set;}
    public OpportunityLineItem opportunityLineItemRecord{get; set;}
    public Opportunity opportunityRecord{get; set;}

    class ConsolidatedReportWrapper{
        @AuraEnabled
        Public GeneralInformationWrapper generalInformation;
        @AuraEnabled
        Public ApplicantDetailsWrapper applicantDetailsPrimary;
        @AuraEnabled
        Public ApplicantDetailsWrapper[] applicantDetailsCoApplicants;
        @AuraEnabled
        Public LoanRequirementWrapper loanParameters;
        @AuraEnabled
        Public LoanFeesWrapper loanFees;
        @AuraEnabled
        Public String finalAssessmentReport;
        @AuraEnabled
        Public decimal nBrokenRules;

    }
    class GeneralInformationWrapper{
        @AuraEnabled
        Public String applicationID;
        @AuraEnabled
        Public String productType;
        @AuraEnabled
        Public String cardType;
        @AuraEnabled
        Public String preAssessmentDecision;
        @AuraEnabled
        Public String finalAssessmentDecision;
        @AuraEnabled
        Public Date requestDate;
        
    }
    class ApplicantDetailsWrapper{
        @AuraEnabled
        Public String rim;
        @AuraEnabled
        Public String fullName;
        @AuraEnabled
        Public decimal jNRiskScore;
        @AuraEnabled
        Public String jNRiskGrade;
        @AuraEnabled
        Public decimal cRBScore_CIJ;
        @AuraEnabled
        Public String cRBGrade_CIJ;
        @AuraEnabled
        Public decimal cRBScore_CRIF;
        @AuraEnabled
        Public String cRBGrade_CRIF;
        @AuraEnabled
        Public DocumentRequirementsWrapper[] documentRequirements;
    }
    class LoanRequirementWrapper{
        @AuraEnabled
        Public decimal approvedLoanAmount;
        @AuraEnabled
        Public decimal aprrovedCreditCardLimit;
        @AuraEnabled
        Public decimal approvedTenure;
        @AuraEnabled
        Public decimal approvedInterestRate;
        @AuraEnabled
        Public decimal monthlyPrincipalandInterest;
        @AuraEnabled
        Public decimal contractualSavings;
        @AuraEnabled
        Public decimal totalMonthlyPayments;
        @AuraEnabled
        Public decimal estimateOfMinimumPayment;
        @AuraEnabled
        Public decimal requestedLoanAmount;
    }
    class LoanFeesWrapper{
        @AuraEnabled
        Public String financingOption;
        @AuraEnabled
        Public decimal creditReportFee;
        @AuraEnabled
        Public decimal processingFee;
        @AuraEnabled
        Public decimal creditLifeSinglePremium;
        @AuraEnabled
        Public decimal legalFeesandStampduty;
        @AuraEnabled
        Public decimal totalFees;
        
    }
    class DocumentRequirementsWrapper{
        @AuraEnabled
        Public string documents;
        
    }
    /**
    * @description to deserialize the incoming json repsonse
    * @author Trupti Zende (Thinqloud) | 06-03-2021 
    * @param json 
    * @return ConsolidatedReportWrapper 
    **/
    public void parse(String response){
        Type resultType = Type.forName('ConsolidatedReportWrapper');
        ConsolidatedReportWrapper deserializeResults =       (ConsolidatedReportWrapper)JSON.deserialize(response, resultType);
        //return (ConsolidatedReportWrapper) System.JSON.deserialize(response, resultType);

        this.applicationRecord.Application_ID__c = deserializeResults.generalInformation.applicationID;
        this.applicationRecord.IDM_Amount_number__c = deserializeResults.loanParameters.requestedLoanAmount;
        this.applicationRecord.IDM_Number_of_Rules_Breached_Number__c = deserializeResults.nBrokenRules;


        //this.opportunityLineItemRecord.Product_Family__c = deserializeResults.generalInformation.productType; field is not writable
        //this.opportunityLineItemRecord.Name = deserializeResults.generalInformation.cardType;

        this.opportunityRecord.Pre_Approval_list__c = deserializeResults.generalInformation.preAssessmentDecision;
        this.opportunityRecord.Pre_Approval_list__c = deserializeResults.generalInformation.preAssessmentDecision;
        this.opportunityRecord.Final_Assessment_Decision_list__c = deserializeResults.generalInformation.finalAssessmentDecision;

        //deserializeResults.applicantDetailsPrimary.rim;
        this.primaryApplicantRecord.Account__c = deserializeResults.applicantDetailsPrimary.fullName;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.jNRiskGrade;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.jNRiskScore;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.cRBGrade_CIJ;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.cRBScore_CIJ;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.cRBGrade_CRIF;
        //this.primaryApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsPrimary.cRBScore_CRIF;
        // documents 

        //deserializeResults.applicantDetailsPrimary.rim;
        this.coApplicantRecord.Account__c = deserializeResults.applicantDetailsPrimary.fullName;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.jNRiskGrade;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.jNRiskScore;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.cRBGrade_CIJ;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.cRBScore_CIJ;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.cRBGrade_CRIF;
        //this.coApplicantRecord._NewFieldsToBeCreated_ = deserializeResults.applicantDetailsCoApplicants.cRBScore_CRIF;
        // documents 

        //this.requestDate = ;unix system date 


        this.loanCalculationProductRecord.Loan_Amount_Number__c = deserializeResults.loanParameters.approvedLoanAmount;
        this.loanCalculationProductRecord.Requested_Credit_Limit_Number__c = deserializeResults.loanParameters.aprrovedCreditCardLimit;
        this.loanCalculationProductRecord.Months_Number__c = deserializeResults.loanParameters.approvedTenure;
        this.loanCalculationProductRecord.Interest_Rate_Number__c = deserializeResults.loanParameters.approvedInterestRate;
        this.loanCalculationProductRecord.Total_Monthly_PI_Loan_Payment_Number__c = deserializeResults.loanParameters.monthlyPrincipalandInterest;
        this.loanCalculationProductRecord.Monthly_Compulsory_Savings_Number__c	 = deserializeResults.loanParameters.contractualSavings;
        this.loanCalculationProductRecord.Total_Monthly_Loan_Payment_Number__c = deserializeResults.loanParameters.totalMonthlyPayments;
        this.loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c = deserializeResults.loanParameters.estimateOfMinimumPayment;

        this.loanCalculationProductRecord.Method_of_Fee_Payment_List__c = deserializeResults.loanFees.financingOption;
        this.loanCalculationProductRecord.Credit_Report_Fee_Number__c = deserializeResults.loanFees.creditReportFee;
        this.loanCalculationProductRecord.Processing_Fees_including_GCT_Number__c = deserializeResults.loanFees.processingFee;
        this.loanCalculationProductRecord.Creditor_Life_Insurance_Premium_Number__c = deserializeResults.loanFees.creditLifeSinglePremium;
        this.loanCalculationProductRecord.Legal_Fees_including_GCT_Number__c = deserializeResults.loanFees.legalFeesandStampduty;
        this.loanCalculationProductRecord.Total_Closing_Costs_Number__c = deserializeResults.loanFees.totalFees;


        //deserializeResults.finalAssessmentReport;
    }

    
}