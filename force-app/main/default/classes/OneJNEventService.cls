/**
 * @description       : service to coordinate the  selector layer and serialization
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
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
    List<Opportunity> opportunityList
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

    if (!opportunityList.isEmpty() && opportunityList.size() > 0) {
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
      applicationsList = OneJNQuerySelector.getApplications(opportunityIdSet);
      applicantList = OneJNQuerySelector.getApplicants(opportunityIdSet);
      if (applicantList.size() > 0) {
        Set<Id> accountIdSet = new Set<Id>();
        for (Applicant__c applicant : applicantList) {
          accountIdSet.add(applicant.Account__c);
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
      applicantList[0],
      employmentList[0],
      accountList[0],
      applicationsList[0],
      opportunitysList[0],
      oppLineItemList[0],
      loanCalcProductList[0]
    );
    String JSONString = JSON.serialize(serialiser);
    return JSONString;
  }
}
