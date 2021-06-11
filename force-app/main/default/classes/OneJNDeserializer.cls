/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
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
    public ApplicantDetailsWrapper applicantDetailsCoApplicants;
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
    String productType = oneJNDeserializerVar.consolidatedReport.generalInformation.productType;
    if (eventype == Constants.RETURN_LOAN_APPLICATION_ID) {
      // Application Object Id
      oneJNDeserializerVar.applicationRecord = new Application__c();
      oneJNDeserializerVar.applicationRecord.Id = sfRecordId;
      oneJNDeserializerVar.applicationRecord.Application_ID__c = oneJNDeserializerVar.consolidatedReport.generalInformation.applicationID;
    } else if (
      eventype == Constants.RETURN_CREDITCARD_PRE_ASSESSMENT ||
      eventype == Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT ||
      eventype == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      eventype == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      // SFrecord opportunity id
      oneJNDeserializerVar.opportunityRecord = new Opportunity();
      oneJNDeserializerVar.opportunityRecord.Id = sfRecordId;
      oneJNDeserializerVar.opportunityRecord.Pre_Approval_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.preAssessmentDecision;

      List<Application__c> applist = new List<Application__c>();
      applist = OneJNQuerySelector.getApplications(new Set<ID>{ sfRecordId });
      if (applist.size() > 0) {
        oneJNDeserializerVar.applicationRecord = new Application__c();
        oneJNDeserializerVar.applicationRecord.Id = applist[0]?.Id;

        oneJNDeserializerVar.applicationRecord.Application_ID__c = oneJNDeserializerVar.consolidatedReport.generalInformation.applicationID;
        oneJNDeserializerVar.applicationRecord.IDM_Amount_number__c = oneJNDeserializerVar.consolidatedReport.loanParameters
          ?.requestedLoanAmount;
        oneJNDeserializerVar.applicationRecord.IDM_Number_of_Rules_Breached_Number__c = oneJNDeserializerVar.consolidatedReport.nBrokenRules;
        oneJNDeserializerVar.applicationRecord.IDMOutput__c = oneJNDeserializerVar.consolidatedReport.finalAssessmentReport;
      }

      List<Applicant__c> applicantList = OneJNQuerySelector.getApplicants(
        new Set<ID>{ sfRecordId }
      );
      if (appList.size() > 0) {
        for (Applicant__c applicant : applicantList) {
          if (applicant.Primary_Applicant_Flag__c) {
            oneJNDeserializerVar.primaryApplicantRecord = new Applicant__c();
            oneJNDeserializerVar.primaryApplicantRecord.Id = applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.primaryApplicantRecord.Account__c = applicant.Account__c;
              oneJNDeserializerVar.primaryApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.jNRiskGrade;
              oneJNDeserializerVar.primaryApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.jNRiskScore
              );
              oneJNDeserializerVar.primaryApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBGrade_CIJ;
              oneJNDeserializerVar.primaryApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBScore_CIJ
              );
              oneJNDeserializerVar.primaryApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBGrade_CRIF;
              oneJNDeserializerVar.primaryApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsPrimary.cRBScore_CRIF
              );
            }
            // documents
          } else {
            oneJNDeserializerVar.coApplicantRecord = new Applicant__c();
            oneJNDeserializerVar.coApplicantRecord.Id = applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.coApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.jNRiskGrade;
              oneJNDeserializerVar.coApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.jNRiskScore
              );
              oneJNDeserializerVar.coApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBGrade_CIJ;
              oneJNDeserializerVar.coApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBScore_CIJ
              );
              oneJNDeserializerVar.coApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBGrade_CRIF;
              oneJNDeserializerVar.coApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.consolidatedReport.applicantDetailsCoApplicants.cRBScore_CRIF
              );
            }
            // documents
          }
        }
      }

      List<OpportunityLineItem> opplineitemList = new List<OpportunityLineItem>();
      opplineitemList = OneJNQuerySelector.getOpportunityLineItem(
        new Set<ID>{ sfRecordId }
      );
      if (opplineitemList.size() > 0) {
        oneJNDeserializerVar.opportunityLineItemRecord = new OpportunityLineItem();
        oneJNDeserializerVar.opportunityLineItemRecord.Id = opplineitemList[0]
          ?.Id;
        //oneJNDeserializerVar.opportunityLineItemRecord.Product_Family__c = oneJNDeserializerVar.consolidatedReport.generalInformation.productType; field is not writable
        if (productType == Constants.CREDITCARD_PRODUCT_FAMILY) {
          //oneJNDeserializerVar.opportunityLineItemRecord.Name = oneJNDeserializerVar.consolidatedReport.generalInformation.cardType;
        }
      }

      if (
        eventype == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
        eventype == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
      ) {
        oneJNDeserializerVar.opportunityRecord.Final_Assessment_Decision_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.finalAssessmentDecision;
        List<Loan_Calculator__c> loancalculatorList = new List<Loan_Calculator__c>();
        loancalculatorList = OneJNQuerySelector.getLoanCalculations(
          new Set<ID>{ sfRecordId }
        );

        if (loancalculatorList.size() > 0) {
          Id loanCalculatorId = loancalculatorList[0]?.Id;
          List<Loan_Calculation_Product__c> loanappproductList = new List<Loan_Calculation_Product__c>();
          loanappproductList = OneJNQuerySelector.getLoanCalculationProducts(
            new Set<ID>{ loanCalculatorId }
          );
          if (loanappproductList.size() > 0) {
            oneJNDeserializerVar.loanCalculationProductRecord = new Loan_Calculation_Product__c();
            oneJNDeserializerVar.loanCalculationProductRecord.Id = loanappproductList[0]
              ?.Id;

            if (productType == Constants.CREDITCARD_PRODUCT_FAMILY) {
              oneJNDeserializerVar.loanCalculationProductRecord.Requested_Credit_Limit_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.aprrovedCreditCardLimit;
              oneJNDeserializerVar.loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.estimateOfMinimumPayment;
            }
            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.loanCalculationProductRecord.Loan_Amount_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedLoanAmount;
              oneJNDeserializerVar.loanCalculationProductRecord.Months_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedTenure;
              oneJNDeserializerVar.loanCalculationProductRecord.Interest_Rate_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.approvedInterestRate;
              oneJNDeserializerVar.loanCalculationProductRecord.Total_Monthly_PI_Loan_Payment_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.monthlyPrincipalandInterest;
              oneJNDeserializerVar.loanCalculationProductRecord.Monthly_Compulsory_Savings_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.contractualSavings;
              oneJNDeserializerVar.loanCalculationProductRecord.Total_Monthly_Loan_Payment_Number__c = oneJNDeserializerVar.consolidatedReport.loanParameters.totalMonthlyPayments;
            }

            oneJNDeserializerVar.loanCalculationProductRecord.Method_of_Fee_Payment_List__c = oneJNDeserializerVar.consolidatedReport.loanFees.financingOption;
            oneJNDeserializerVar.loanCalculationProductRecord.Credit_Report_Fee_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.creditReportFee;
            oneJNDeserializerVar.loanCalculationProductRecord.Processing_Fees_including_GCT_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.processingFee;
            oneJNDeserializerVar.loanCalculationProductRecord.Creditor_Life_Insurance_Premium_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.creditLifeSinglePremium;
            oneJNDeserializerVar.loanCalculationProductRecord.Legal_Fees_including_GCT_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.legalFeesandStampduty;
            oneJNDeserializerVar.loanCalculationProductRecord.Total_Closing_Costs_Number__c = oneJNDeserializerVar.consolidatedReport.loanFees.totalFees;
          }
        }
      }
      //oneJNDeserializerVar.requestDate = ;unix system date
    } else if (
      eventype == Constants.RETURN_MANUAL_DESICION_APPROVED ||
      eventype == Constants.RETURN_MANUAL_DESICION_REJECT
    ) {
      List<Application__c> applicationList = OneJNQuerySelector.getApplicationRecord(
        sfRecordId
      );
      if (applicationList.size() > 0) {
        oneJNDeserializerVar.opportunityRecord = new Opportunity();
        oneJNDeserializerVar.opportunityRecord.Id = applicationList[0]
          .Opportunity_Id__c;
        oneJNDeserializerVar.opportunityRecord.Final_Assessment_Decision_list__c = oneJNDeserializerVar.consolidatedReport.generalInformation.finalAssessmentDecision;
      }
    }
    return oneJNDeserializerVar;
  }
}
