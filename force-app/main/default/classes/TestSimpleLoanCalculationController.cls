/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-08-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-08-2021   Travis Allen   Initial Version
 **/
@isTest
public class TestSimpleLoanCalculationController {
  @TestSetup
  public static void makeData() {
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'hayley')[0];
    insert acc;

    Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
    opp.AccountId = acc.Id;
    insert opp;

    Lead newLead = TestDataFactory.CreateLeads(1)[0];
    insert newLead;
  }
  //Scenario 1: Lead with only 1 Loan Cal record created before save
  @isTest
  public static void shouldSaveLoanCalculation() {
    List<Lead> leads = [SELECT Id FROM Lead];

    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

    Opportunity opp = opportunities[0];

    Lead newLead = leads[0];
    Test.startTest();
    Loan_Calculator__c loanCal = TestDataFactory.CreateLoanCalculation(1)[0];
    loanCal.Lead_and_Referral__c = newLead.Id;
    loanCal.Opportunity__c = opp.Id;
    loanCal.Reqeusted_Limit__c = 10000.00;
    loanCal.Interest_Rate__c = 15.0;
    loanCal.Monthly_Gross_Income__c = 3000.00;
    loanCal.Existing_Monthly_Credit_Payment__c = 500.00;
    loanCal.Total_Monthly__c = 1000.00;
    insert loanCal;

    String recordTypeName = 'InstallmentPayment';

    String Calculation = JSON.serialize(loanCal);
    System.assert(Calculation != null, 'Calculation data is null.');

    SimpleLoanCalculationController.SaveLoanCalculation(
      Calculation,
      recordTypeName,
      newLead.Id
    );
    Test.stopTest();
  }
  //Scenario 2: Lead when no loan cal object saved prior
  @isTest
  public static void shouldSaveLoanCalculationWhenNoneExists() {
    List<Lead> leads = [SELECT Id FROM Lead];

    Lead newLead = leads[0];

    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

    Opportunity opp = opportunities[0];
    Test.startTest();
    // Map<String,Object> calculationData = new Map<String,Object>{
    //       'sObject' => 'Loan_Calculator__c',
    //       'Lead_and_Referral__c' => newLead.Id,
    //       'Opportunity__c' => opp.Id,
    //       'Interest_Rate__c' => 15.0,
    //       'Total_Monthly__c' => 1000.00,
    //       'Reqeusted_Limit__c' => 10000.00,
    //       'Monthly_Gross_Income__c' => 3000.00,
    //       'Existing_Monthly_Credit_Payment__c' => 500.00,
    //       'Total_Monthly__c' => 1000.00
    // };

    Loan_Calculator__c loanCal = TestDataFactory.CreateLoanCalculation(1)[0];
    loanCal.Lead_and_Referral__c = newLead.Id;
    loanCal.Opportunity__c = opp.Id;
    loanCal.Reqeusted_Limit__c = 10000.00;
    loanCal.Interest_Rate__c = 15.0;
    loanCal.Monthly_Gross_Income__c = 3000.00;
    loanCal.Existing_Monthly_Credit_Payment__c = 500.00;
    loanCal.Total_Monthly__c = 1000.00;

    String recordTypeName = 'InstallmentPayment';

    String Calculation = JSON.serialize(loanCal);
    System.assert(Calculation != null, 'Calculation data is null.');

    SimpleLoanCalculationController.SaveLoanCalculation(
      Calculation,
      recordTypeName,
      newLead.Id
    );
    Test.stopTest();
  }
}
