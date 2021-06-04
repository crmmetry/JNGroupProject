/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-04-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public class OneJNDeserializer {
  public Loan_Calculation_Product__c loanCalculationProductRecord { get; set; }
  public Applicant__c primaryApplicantRecord { get; set; }
  public Applicant__c coApplicantRecord { get; set; }
  public Application__c applicationRecord { get; set; }
  public OpportunityLineItem opportunityLineItemRecord { get; set; }
  public Opportunity opportunityRecord { get; set; }
  @AuraEnabled
  public ConsolidatedReportWrapper consolidatedReport { get; set; }
  class ConsolidatedReportWrapper {
    @AuraEnabled
    public GeneralInformationWrapper generalInformation;
    @AuraEnabled
    public ApplicantDetailsWrapper applicantDetailsPrimary;
    @AuraEnabled
    public ApplicantDetailsWrapper[] applicantDetailsCoApplicants;
    @AuraEnabled
    public LoanRequirementWrapper loanParameters;
    @AuraEnabled
    public LoanFeesWrapper loanFees;
    @AuraEnabled
    public String finalAssessmentReport;
    @AuraEnabled
    public decimal nBrokenRules;
  }
  class GeneralInformationWrapper {
    @AuraEnabled
    public String applicationID;
    @AuraEnabled
    public String productType;
    @AuraEnabled
    public String cardType;
    @AuraEnabled
    public String preAssessmentDecision;
    @AuraEnabled
    public String finalAssessmentDecision;
    @AuraEnabled
    public Date requestDate;
  }
  class ApplicantDetailsWrapper {
    @AuraEnabled
    public String rim;
    @AuraEnabled
    public String fullName;
    @AuraEnabled
    public decimal jNRiskScore;
    @AuraEnabled
    public String jNRiskGrade;
    @AuraEnabled
    public decimal cRBScore_CIJ;
    @AuraEnabled
    public String cRBGrade_CIJ;
    @AuraEnabled
    public decimal cRBScore_CRIF;
    @AuraEnabled
    public String cRBGrade_CRIF;
    @AuraEnabled
    public DocumentRequirementsWrapper[] documentRequirements;
  }
  class LoanRequirementWrapper {
    @AuraEnabled
    public decimal approvedLoanAmount;
    @AuraEnabled
    public decimal aprrovedCreditCardLimit;
    @AuraEnabled
    public decimal approvedTenure;
    @AuraEnabled
    public decimal approvedInterestRate;
    @AuraEnabled
    public decimal monthlyPrincipalandInterest;
    @AuraEnabled
    public decimal contractualSavings;
    @AuraEnabled
    public decimal totalMonthlyPayments;
    @AuraEnabled
    public decimal estimateOfMinimumPayment;
    @AuraEnabled
    public decimal requestedLoanAmount;
  }
  class LoanFeesWrapper {
    @AuraEnabled
    public String financingOption;
    @AuraEnabled
    public decimal creditReportFee;
    @AuraEnabled
    public decimal processingFee;
    @AuraEnabled
    public decimal creditLifeSinglePremium;
    @AuraEnabled
    public decimal legalFeesandStampduty;
    @AuraEnabled
    public decimal totalFees;
  }
  class DocumentRequirementsWrapper {
    @AuraEnabled
    public string documents;
  }
  /**
   * @description to deserialize the incoming json repsonse
   * @author Trupti Zende (Thinqloud) | 06-03-2021
   * @param json
   * @return ConsolidatedReportWrapper
   **/
  public OneJNDeserializer parse(
    OneJNDeserializer oneJNDeserializerVar,
    String eventype,
    String sfRecordId
  ) {
    oneJNDeserializerVar.applicationRecord = new Application__c();
    //Type resultType = Type.forName('ConsolidatedReportWrapper');
    //ConsolidatedReportWrapper deserializeResults =       (ConsolidatedReportWrapper)JSON.deserialize(response, resultType);
    //return (ConsolidatedReportWrapper) System.JSON.deserialize(response, resultType);
    if (eventype == Constants.GET_LOAN_APPLICATION_ID) {
      oneJNDeserializerVar.applicationRecord.Id = sfRecordId;
    }

    oneJNDeserializerVar.applicationRecord.Application_ID__c = oneJNDeserializerVar.consolidatedReport.generalInformation.applicationID;
    //IG::  oneJNDeserializerVar.applicationRecord.IDM_Amount_number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.requestedLoanAmount;
    //IG:: oneJNDeserializerVar.applicationRecord.IDM_Number_of_Rules_Breached_Number__c = oneJNDeserializerVar.consolidatedReport.nBrokenRules;

    //this.opportunityLineItemRecord.Product_Family__c = oneJNDeserializerVar.consolidatedReport.generalInformation.productType; field is not writable
    //this.opportunityLineItemRecord.Name = oneJNDeserializerVar.consolidatedReport.generalInformation.cardType;

    //IG::  oneJNDeserializerVar.opportunityRecord.Pre_Approval_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.preAssessmentDecision;
    //IG::   oneJNDeserializerVar.opportunityRecord.Pre_Approval_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.preAssessmentDecision;
    //IG::  oneJNDeserializerVar.opportunityRecord.Final_Assessment_Decision_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.finalAssessmentDecision;

    //oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.rim;
    //IG::  oneJNDeserializerVar.primaryApplicantRecord.Account__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.fullName;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.jNRiskGrade;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.jNRiskScore;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBGrade_CIJ;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBScore_CIJ;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBGrade_CRIF;
    //this.primaryApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBScore_CRIF;
    // documents

    //oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.rim;
    //IG:: oneJNDeserializerVar.coApplicantRecord.Account__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.fullName;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.jNRiskGrade;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.jNRiskScore;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBGrade_CIJ;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBScore_CIJ;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBGrade_CRIF;
    //this.coApplicantRecord._NewFieldsToBeCreated_ = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBScore_CRIF;
    // documents

    //this.requestDate = ;unix system date

    //commented for testing purpose
    /*  oneJNDeserializerVar.loanCalculationProductRecord.Loan_Amount_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedLoanAmount;
        oneJNDeserializerVar.loanCalculationProductRecord.Requested_Credit_Limit_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.aprrovedCreditCardLimit;
        oneJNDeserializerVar.loanCalculationProductRecord.Months_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedTenure;
        oneJNDeserializerVar.loanCalculationProductRecord.Interest_Rate_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedInterestRate;
        oneJNDeserializerVar.loanCalculationProductRecord.Total_Monthly_PI_Loan_Payment_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.monthlyPrincipalandInterest;
        oneJNDeserializerVar.loanCalculationProductRecord.Monthly_Compulsory_Savings_Number__c	 = oneJNDeserializerVar.consolidatedReport.loanParameters.contractualSavings;
        oneJNDeserializerVar.loanCalculationProductRecord.Total_Monthly_Loan_Payment_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.totalMonthlyPayments;
        oneJNDeserializerVar.loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.estimateOfMinimumPayment;

        oneJNDeserializerVar.loanCalculationProductRecord.Method_of_Fee_Payment_List__c = oneJNDeserializerVar.consolidatedReport.loanFees.financingOption;
        oneJNDeserializerVar.loanCalculationProductRecord.Credit_Report_Fee_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.creditReportFee;
        oneJNDeserializerVar.loanCalculationProductRecord.Processing_Fees_including_GCT_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.processingFee;
        oneJNDeserializerVar.loanCalculationProductRecord.Creditor_Life_Insurance_Premium_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.creditLifeSinglePremium;
        oneJNDeserializerVar.loanCalculationProductRecord.Legal_Fees_including_GCT_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.legalFeesandStampduty;
        oneJNDeserializerVar.loanCalculationProductRecord.Total_Closing_Costs_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.totalFees;
*/
    return oneJNDeserializerVar;
    //oneJNDeserializerVar.consolidatedReport.finalAssessmentReport;
  }
}
