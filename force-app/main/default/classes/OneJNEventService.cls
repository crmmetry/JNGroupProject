/**
 * @description       : service to coordinate the  selector layer and serialization
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-15-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNEventService {
  /**
   * @description
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param applicationList
   * @param opportunityList
   * @return OneJNSerializer
   **/
  public static String build(
    List<Application__c> applicationList,
    List<Opportunity> opportunityList,
    String eventType
  ) {
    set<Id> opportunityIdSet = new Set<Id>();

    List<Account> accountList = new List<Account>();
    List<Applicant__c> applicantList = new List<Applicant__c>();
    List<Application__c> applicationsList = new List<Application__c>();
    List<Opportunity> opportunitysList = new List<Opportunity>();
    List<FinServ__Employment__c> employmentList = new List<FinServ__Employment__c>();
    List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
    List<Loan_Calculation_Product__c> loanCalcProductList = new List<Loan_Calculation_Product__c>();
    List<Loan_Calculator__c> loanCalculatorList = new List<Loan_Calculator__c>();

    if (!opportunityList.isEmpty()) {
      for (Opportunity app : opportunityList) {
        opportunityIdSet.add(app.Id);
      }
    } else {
      for (Application__c app : applicationList) {
        opportunityIdSet.add(app.Opportunity_Id__c);
      }
    }
    if (opportunityIdSet.size() > 0) {
      opportunitysList = OneJNQuerySelector.getOpportunity(opportunityIdSet);
      oppLineItemList = OneJNQuerySelector.getOpportunityLineItem(
        opportunityIdSet
      );
      applicantList = OneJNQuerySelector.getApplicants(opportunityIdSet);
      applicationsList = OneJNQuerySelector.getApplications(opportunityIdSet);
      if (applicantList.size() > 0) {
        Set<Id> accountIdSet = new Set<Id>();
        for (Applicant__c applicant : applicantList) {
          if (applicant.Primary_Applicant_Flag__c) {
            accountIdSet.add(applicant.Account__c);
          }
        }
        if (accountIdSet.size() > 0) {
          accountList = OneJNQuerySelector.getAccounts(accountIdSet);
          employmentList = OneJNQuerySelector.getEmployment(accountIdSet);
        }
      }

      loanCalculatorList = OneJNQuerySelector.getLoanCalculations(
        opportunityIdSet
      );
      if (loanCalculatorList.size() > 0) {
        Set<Id> loanCalcIdSet = new Set<Id>();
        for (Loan_Calculator__c loanCalc : loanCalculatorList) {
          loanCalcIdSet.add(loanCalc.Id);
        }

        if (loanCalcIdSet.size() > 0) {
          loanCalcProductList = OneJNQuerySelector.getLoanCalculationProducts(
            loanCalcIdSet
          );
        }
      }
    }

    OneJNSerializer serialiser = new OneJNSerializer(
      applicantList.size() > 0 ? applicantList[0] : new Applicant__c(),
      employmentList.size() > 0
        ? employmentList[0]
        : new FinServ__Employment__c(),
      accountList.size() > 0 ? accountList[0] : new Account(),
      applicationsList.size() > 0 ? applicationsList[0] : new Application__c(),
      opportunitysList.size() > 0 ? opportunitysList[0] : new Opportunity(),
      oppLineItemList.size() > 0
        ? oppLineItemList[0]
        : new OpportunityLineItem(),
      loanCalcProductList.size() > 0
        ? loanCalcProductList[0]
        : new Loan_Calculation_Product__c()
    );

    Map<String, Object> serializerMap = OneJNSerializerDecision.setSerializer(
      serialiser,
      eventType
    );

    String JSONString = JSON.serialize(serializerMap);
    return JSONString;
  }
  public class OneJNApplicationIdEvent {
    /**
     * @description deserialize response for event GetAppplicationId
     * @author Trupti Zende (Thinqloud) | 06-14-2021
     * @param oneJNDeserializerVar
     * @param sfRecordId
     * @return OneJNDeserializer
     **/
    public OneJNDeserializer deserialize(
      OneJNDeserializer oneJNDeserializerVar,
      String sfRecordId
    ) {
      oneJNDeserializerVar.ApplicationRecord = new Application__c();
      oneJNDeserializerVar.ApplicationRecord.Id = sfRecordId;
      oneJNDeserializerVar.ApplicationRecord.Application_ID__c = oneJNDeserializerVar.ApplicationId;
      /*oneJNDeserializerVar.ConsolidatedReport.GeneralInformation
       ?.ApplicationID;*/
      return oneJNDeserializerVar;
    }
  }
  public class OneJNPreAssessementEvent {
    /**
     * @description deserialize response for event PreAssessmentEvent
     * @author Trupti Zende (Thinqloud) | 06-14-2021
     * @param oneJNDeserializerVar
     * @param sfRecordId
     * @return OneJNDeserializer
     **/
    public OneJNDeserializer deserialize(
      OneJNDeserializer oneJNDeserializerVar,
      String sfRecordId
    ) {
      String productType = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation.ProductType;
      oneJNDeserializerVar.OpportunityRecord = new Opportunity();
      oneJNDeserializerVar.OpportunityRecord.Id = sfRecordId;
      oneJNDeserializerVar.OpportunityRecord.Pre_Approval_list__c = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation
        ?.PreAssessmentDecision;

      List<Application__c> applist = new List<Application__c>();
      Applist = OneJNQuerySelector.getApplications(new Set<ID>{ sfRecordId });
      if (applist.size() > 0) {
        oneJNDeserializerVar.ApplicationRecord = new Application__c();
        oneJNDeserializerVar.ApplicationRecord.Id = applist[0]?.Id;

        oneJNDeserializerVar.applicationRecord.Application_ID__c = oneJNDeserializerVar.ConsolidatedReport
          ?.GeneralInformation.ApplicationID;
        oneJNDeserializerVar.ApplicationRecord.IDM_Amount_number__c = oneJNDeserializerVar.ConsolidatedReport
          ?.LoanParameters
          ?.RequestedLoanAmount;
        oneJNDeserializerVar.ApplicationRecord.IDM_Number_of_Rules_Breached_Number__c = oneJNDeserializerVar.ConsolidatedReport
          ?.nBrokenRules;
        oneJNDeserializerVar.ApplicationRecord.IDMOutput__c = oneJNDeserializerVar.ConsolidatedReport
          ?.FinalAssessmentReport;
      }

      List<Applicant__c> applicantList = OneJNQuerySelector.getApplicants(
        new Set<ID>{ sfRecordId }
      );
      if (appList.size() > 0) {
        for (Applicant__c applicant : applicantList) {
          if (applicant.Primary_Applicant_Flag__c) {
            oneJNDeserializerVar.PrimaryApplicantRecord = new applicant__c();
            oneJNDeserializerVar.PrimaryApplicantRecord.Id = Applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.PrimaryApplicantRecord.Account__c = Applicant.Account__c;
              oneJNDeserializerVar.PrimaryApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.jNRiskGrade;
              oneJNDeserializerVar.PrimaryApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.jNRiskScore
              );
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.cRBGrade_CIJ;
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.cRBScore_CIJ
              );
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.cRBGrade_CRIF;
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.cRBScore_CRIF
              );
            }
            // documents
          } else {
            oneJNDeserializerVar.CoApplicantRecord = new Applicant__c();
            oneJNDeserializerVar.CoApplicantRecord.Id = Applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.CoApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.jNRiskGrade;
              oneJNDeserializerVar.CoApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.jNRiskScore
              );
              oneJNDeserializerVar.CoApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.cRBGrade_CIJ;
              oneJNDeserializerVar.CoApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.cRBScore_CIJ
              );
              oneJNDeserializerVar.CoApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.cRBGrade_CRIF;
              oneJNDeserializerVar.CoApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.cRBScore_CRIF
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
        oneJNDeserializerVar.OpportunityLineItemRecord = new OpportunityLineItem();
        oneJNDeserializerVar.OpportunityLineItemRecord.Id = opplineitemList[0]
          ?.Id;
        //oneJNDeserializerVar.opportunityLineItemRecord.Product_Family__c = oneJNDeserializerVar.consolidatedReport.generalInformation.productType; field is not writable
        if (ProductType == Constants.CREDITCARD_PRODUCT_FAMILY) {
          //oneJNDeserializerVar.opportunityLineItemRecord.Name = oneJNDeserializerVar.consolidatedReport.generalInformation.cardType;
        }
      }
      //oneJNDeserializerVar.requestDate = ;unix system date
      return oneJNDeserializerVar;
    }
  }
  public class OneJNFinalAssessmentEvent {
    /**
     * @description deserialize response for event FinalAssessmentEvent
     * @author Trupti Zende (Thinqloud) | 06-14-2021
     * @param oneJNDeserializerVar
     * @param sfRecordId
     * @return OneJNDeserializer
     **/
    public OneJNDeserializer deserialize(
      OneJNDeserializer oneJNDeserializerVar,
      String sfRecordId
    ) {
      String productType = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation.ProductType;
      oneJNDeserializerVar.OpportunityRecord = new Opportunity();
      oneJNDeserializerVar.OpportunityRecord.Id = sfRecordId;
      oneJNDeserializerVar.OpportunityRecord.Pre_Approval_list__c = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation
        ?.PreAssessmentDecision;

      List<Application__c> applist = new List<Application__c>();
      Applist = OneJNQuerySelector.getApplications(new Set<ID>{ sfRecordId });
      if (applist.size() > 0) {
        oneJNDeserializerVar.ApplicationRecord = new Application__c();
        oneJNDeserializerVar.ApplicationRecord.Id = applist[0]?.Id;

        oneJNDeserializerVar.applicationRecord.Application_ID__c = oneJNDeserializerVar.ConsolidatedReport
          ?.GeneralInformation.ApplicationID;
        oneJNDeserializerVar.ApplicationRecord.IDM_Amount_number__c = oneJNDeserializerVar.ConsolidatedReport
          ?.LoanParameters
          ?.RequestedLoanAmount;
        oneJNDeserializerVar.ApplicationRecord.IDM_Number_of_Rules_Breached_Number__c = oneJNDeserializerVar.ConsolidatedReport
          ?.nBrokenRules;
        oneJNDeserializerVar.ApplicationRecord.IDMOutput__c = oneJNDeserializerVar.ConsolidatedReport
          ?.FinalAssessmentReport;
      }

      List<Applicant__c> applicantList = OneJNQuerySelector.getApplicants(
        new Set<ID>{ sfRecordId }
      );
      if (appList.size() > 0) {
        for (Applicant__c applicant : applicantList) {
          if (applicant.Primary_Applicant_Flag__c) {
            oneJNDeserializerVar.PrimaryApplicantRecord = new applicant__c();
            oneJNDeserializerVar.PrimaryApplicantRecord.Id = Applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.PrimaryApplicantRecord.Account__c = Applicant.Account__c;
              oneJNDeserializerVar.PrimaryApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.jNRiskGrade;
              oneJNDeserializerVar.PrimaryApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.jNRiskScore
              );
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.cRBGrade_CIJ;
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.cRBScore_CIJ
              );
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                ?.cRBGrade_CRIF;
              oneJNDeserializerVar.PrimaryApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsPrimary
                  ?.cRBScore_CRIF
              );
            }
            // documents
          } else {
            oneJNDeserializerVar.CoApplicantRecord = new Applicant__c();
            oneJNDeserializerVar.CoApplicantRecord.Id = Applicant.Id;

            if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
              oneJNDeserializerVar.CoApplicantRecord.JNRiskGrade__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.jNRiskGrade;
              oneJNDeserializerVar.CoApplicantRecord.JNRiskScore__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.jNRiskScore
              );
              oneJNDeserializerVar.CoApplicantRecord.CRBGradeCIJ__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.cRBGrade_CIJ;
              oneJNDeserializerVar.CoApplicantRecord.CRBScoreCIJ__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.cRBScore_CIJ
              );
              oneJNDeserializerVar.CoApplicantRecord.CRBGradeCRIF__c = oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                ?.cRBGrade_CRIF;
              oneJNDeserializerVar.CoApplicantRecord.CRBScoreCRIF__c = String.valueOf(
                oneJNDeserializerVar.ConsolidatedReport.ApplicantDetailsCoApplicants
                  ?.cRBScore_CRIF
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
        oneJNDeserializerVar.OpportunityLineItemRecord = new OpportunityLineItem();
        oneJNDeserializerVar.OpportunityLineItemRecord.Id = opplineitemList[0]
          ?.Id;
        //oneJNDeserializerVar.opportunityLineItemRecord.Product_Family__c = oneJNDeserializerVar.consolidatedReport.generalInformation.productType; field is not writable
        if (ProductType == Constants.CREDITCARD_PRODUCT_FAMILY) {
          //oneJNDeserializerVar.opportunityLineItemRecord.Name = oneJNDeserializerVar.consolidatedReport.generalInformation.cardType;
        }
      }
      oneJNDeserializerVar.OpportunityRecord.Final_Assessment_Decision_list__c = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation
        ?.FinalAssessmentDecision;
      List<Loan_Calculator__c> loancalculatorList = new List<Loan_Calculator__c>();
      loancalculatorList = OneJNQuerySelector.getLoanCalculations(
        new Set<ID>{ sfRecordId }
      );

      if (LoanCalculatorList.size() > 0) {
        Id loanCalculatorId = loancalculatorList[0]?.Id;
        List<Loan_Calculation_Product__c> loanappproductList = new List<Loan_Calculation_Product__c>();
        loanappproductList = OneJNQuerySelector.getLoanCalculationProducts(
          new Set<ID>{ loanCalculatorId }
        );
        if (LoanAppProductList.size() > 0) {
          oneJNDeserializerVar.LoanCalculationProductRecord = new Loan_Calculation_Product__c();
          oneJNDeserializerVar.LoanCalculationProductRecord.Id = loanappproductList[0]
            ?.Id;

          if (productType == Constants.CREDITCARD_PRODUCT_FAMILY) {
            oneJNDeserializerVar.LoanCalculationProductRecord.Requested_Credit_Limit_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.AprrovedCreditCardLimit;
            oneJNDeserializerVar.LoanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.EstimateOfMinimumPayment;
          }
          if (productType == Constants.UNSECURED_PRODUCT_FAMILY) {
            oneJNDeserializerVar.LoanCalculationProductRecord.Loan_Amount_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.ApprovedLoanAmount;
            oneJNDeserializerVar.LoanCalculationProductRecord.Months_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.ApprovedTenure;
            oneJNDeserializerVar.LoanCalculationProductRecord.Interest_Rate_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.ApprovedInterestRate;
            oneJNDeserializerVar.LoanCalculationProductRecord.Total_Monthly_PI_Loan_Payment_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.MonthlyPrincipalandInterest;
            oneJNDeserializerVar.LoanCalculationProductRecord.Monthly_Compulsory_Savings_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.ContractualSavings;
            oneJNDeserializerVar.LoanCalculationProductRecord.Total_Monthly_Loan_Payment_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanParameters
              ?.TotalMonthlyPayments;
          }

          oneJNDeserializerVar.LoanCalculationProductRecord.Method_of_Fee_Payment_List__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.FinancingOption;
          oneJNDeserializerVar.LoanCalculationProductRecord.Credit_Report_Fee_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.CreditReportFee;
          oneJNDeserializerVar.LoanCalculationProductRecord.Processing_Fees_including_GCT_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.processingFee;
          oneJNDeserializerVar.LoanCalculationProductRecord.Creditor_Life_Insurance_Premium_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.creditLifeSinglePremium;
          oneJNDeserializerVar.LoanCalculationProductRecord.Legal_Fees_including_GCT_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.LegalFeesandStampduty;
          oneJNDeserializerVar.LoanCalculationProductRecord.Total_Closing_Costs_Number__c = oneJNDeserializerVar.ConsolidatedReport.LoanFees
            ?.TotalFees;
        }
      }

      //oneJNDeserializerVar.requestDate = ;unix system date
      return oneJNDeserializerVar;
    }
  }
  public class OneJNManualDecisionEvent {
    /**
     * @description deserialize response for event Manual Decision Event
     * @author Trupti Zende (Thinqloud) | 06-14-2021
     * @param oneJNDeserializerVar
     * @param sfRecordId
     * @return OneJNDeserializer
     **/
    public OneJNDeserializer deserialize(
      OneJNDeserializer oneJNDeserializerVar,
      String sfRecordId
    ) {
      List<Application__c> applicationList = OneJNQuerySelector.getApplicationRecord(
        sfRecordId
      );
      if (applicationList.size() > 0) {
        oneJNDeserializerVar.OpportunityRecord = new Opportunity();
        oneJNDeserializerVar.OpportunityRecord.Id = applicationList[0]
          .Opportunity_Id__c;
        oneJNDeserializerVar.OpportunityRecord.Final_Assessment_Decision_list__c = oneJNDeserializerVar.ConsolidatedReport.GeneralInformation
          ?.FinalAssessmentDecision;
      }
      return oneJNDeserializerVar;
    }
  }
}
