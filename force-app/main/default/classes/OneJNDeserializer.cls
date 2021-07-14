/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-01-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public class OneJNDeserializer {
  @AuraEnabled
  public String ApplicationId;
  public Loan_Calculation_Product__c LoanCalculationProductRecord { get; set; }
  public Applicant__c PrimaryApplicantRecord { get; set; }
  public Applicant__c CoApplicantRecord { get; set; }
  public Application__c ApplicationRecord { get; set; }
  public OpportunityLineItem OpportunityLineItemRecord { get; set; }
  public Opportunity OpportunityRecord { get; set; }
  public List<Document_Instruction__c> documentInstructions { get; set; }
  @AuraEnabled
  public ConsolidatedReportWrapper ConsolidatedReport { get; set; }
  public class ConsolidatedReportWrapper {
    @AuraEnabled
    public GeneralInformationWrapper GeneralInformation;
    @AuraEnabled
    public ApplicantDetailsWrapper ApplicantDetailsPrimary;
    @AuraEnabled
    public List<ApplicantDetailsWrapper> ApplicantDetailsCoApplicants;
    @AuraEnabled
    public LoanRequirementWrapper LoanParameters;
    @AuraEnabled
    public LoanFeesWrapper LoanFees;
    @AuraEnabled
    public String FinalAssessmentReport;
  }
  public class GeneralInformationWrapper {
    @AuraEnabled
    public String ApplicationID;
    @AuraEnabled
    public String ProductType;
    @AuraEnabled
    public String CardType;
    @AuraEnabled
    public String PreAssessmentDecision;
    @AuraEnabled
    public String FinalAssessmentDecision;
    @AuraEnabled
    public Date RequestDate;
    @AuraEnabled
    public decimal nBrokenRules;
  }
  public class ApplicantDetailsWrapper {
    @AuraEnabled
    public String PhoenixId;
    @AuraEnabled
    public String FullName;
    @AuraEnabled
    public decimal JNRiskScore;
    @AuraEnabled
    public String JNRiskGrade;
    @AuraEnabled
    public decimal CRBScore_CIJ;
    @AuraEnabled
    public String CRBGrade_CIJ;
    @AuraEnabled
    public decimal CRBScore_CRIF;
    @AuraEnabled
    public String CRBGrade_CRIF;
    @AuraEnabled
    public List<String> DocumentRequirements;
  }
  public class LoanRequirementWrapper {
    @AuraEnabled
    public decimal ApprovedLoanAmount;
    @AuraEnabled
    public decimal AprrovedCreditCardLimit;
    @AuraEnabled
    public decimal ApprovedTenure;
    @AuraEnabled
    public decimal ApprovedInterestRate;
    @AuraEnabled
    public decimal MonthlyPrincipalandInterest;
    @AuraEnabled
    public decimal ContractualSavings;
    @AuraEnabled
    public decimal TotalMonthlyPayments;
    @AuraEnabled
    public decimal EstimateOfMinimumPayment;
    @AuraEnabled
    public decimal RequestedLoanAmount;
  }
  public class LoanFeesWrapper {
    @AuraEnabled
    public String FinancingOption;
    @AuraEnabled
    public decimal CreditReportFee;
    @AuraEnabled
    public decimal ProcessingFee;
    @AuraEnabled
    public decimal CreditLifeSinglePremium;
    @AuraEnabled
    public decimal LegalFeesandStampduty;
    @AuraEnabled
    public decimal TotalFees;
  }
  /*
  public class DocumentRequirementsWrapper {
    @AuraEnabled
    public string Documents;
  }*/
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
    if (eventype == Constants.RETURN_LOAN_APPLICATION_ID) {
      OneJNEventService.OneJNApplicationIdEvent reference = new OneJNEventService.OneJNApplicationIdEvent();
      oneJNDeserializerVar = reference.deserialize(
        oneJNDeserializerVar,
        sfRecordId,
        eventype
      );
    } else if (
      eventype == Constants.RETURN_CREDITCARD_PRE_ASSESSMENT ||
      eventype == Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT
    ) {
      OneJNEventService.OneJNPreAssessementEvent reference = new OneJNEventService.OneJNPreAssessementEvent();
      oneJNDeserializerVar = reference.deserialize(
        oneJNDeserializerVar,
        sfRecordId,
        eventype
      );
    } else if (
      eventype == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      eventype == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      OneJNEventService.OneJNFinalAssessmentEvent reference = new OneJNEventService.OneJNFinalAssessmentEvent();
      oneJNDeserializerVar = reference.deserialize(
        oneJNDeserializerVar,
        sfRecordId,
        eventype
      );
    } else if (
      eventype == Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE ||
      eventype == Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE
    ) {
      OneJNEventService.OneJNManualDecisionEvent reference = new OneJNEventService.OneJNManualDecisionEvent();
      oneJNDeserializerVar = reference.deserialize(
        oneJNDeserializerVar,
        sfRecordId,
        eventype
      );
    }
    return oneJNDeserializerVar;
  }
}
