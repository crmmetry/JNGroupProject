/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-21-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-08-2021   Travis Allen   Initial Version
 **/
@isTest
public class TestSimpleLoanCalculationController {
  /**
   * Data setip for test class.
   * @author Travis Allen | 06-21-2021
   **/
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

  /**
   * Scenario 1: Lead with only 1 Loan Cal record created before save
   * @author Travis Allen | 06-21-2021
   **/
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
    loanCal.Proposed_Starting_Limit__c = 1000.00;

    String recordTypeName = 'InstallmentPayment';

    String Calculation = JSON.serialize(loanCal);
    System.assert(Calculation != null, 'Calculation data is null.');

    SimpleLoanCalculationController.SaveLoanCalculation(
      Calculation,
      recordTypeName,
      newLead.Id
    );
    Test.stopTest();
    Loan_Calculator__c savedCalculation = [
      SELECT
        Id,
        Lead_and_Referral__c,
        Opportunity__c,
        Reqeusted_Limit__c,
        Interest_Rate__c,
        Monthly_Gross_Income__c,
        Existing_Monthly_Credit_Payment__c,
        Proposed_Starting_Limit__c
      FROM Loan_Calculator__c
      LIMIT 1
    ];
    System.assertEquals(
      newLead.Id,
      savedCalculation.Lead_and_Referral__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      opp.Id,
      savedCalculation.Opportunity__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      loanCal.Reqeusted_Limit__c,
      savedCalculation.Reqeusted_Limit__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      loanCal.Interest_Rate__c,
      savedCalculation.Interest_Rate__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      loanCal.Monthly_Gross_Income__c,
      savedCalculation.Monthly_Gross_Income__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      loanCal.Existing_Monthly_Credit_Payment__c,
      savedCalculation.Existing_Monthly_Credit_Payment__c,
      'Loan Calculation record did not save.'
    );
    System.assertEquals(
      loanCal.Proposed_Starting_Limit__c,
      savedCalculation.Proposed_Starting_Limit__c,
      'Loan Calculation record did not save.'
    );
  }

  /**
   * Scenario 2: Lead when no loan cal object saved prior
   * @author Travis Allen | 06-21-2021
   **/
  @isTest
  public static void shouldUpdateRunLoanScenarios() {
    List<Lead> leads = [SELECT Id FROM Lead];

    Lead newLead = leads[0];

    List<Opportunity> opportunities = [SELECT Id FROM Opportunity];

    Opportunity opp = opportunities[0];
    Test.startTest();

    Loan_Calculator__c loanCal = TestDataFactory.CreateLoanCalculation(1)[0];
    loanCal.Lead_and_Referral__c = newLead.Id;
    loanCal.Opportunity__c = opp.Id;
    loanCal.Reqeusted_Limit__c = 10000.00;
    loanCal.Interest_Rate__c = 15.0;
    loanCal.Monthly_Gross_Income__c = 3000.00;
    loanCal.Existing_Monthly_Credit_Payment__c = 500.00;
    loanCal.Proposed_Starting_Limit__c = 1000.00;

    String recordTypeName = 'InstallmentPayment';

    String Calculation = JSON.serialize(loanCal);
    System.assert(Calculation != null, 'Calculation data is null.');

    SimpleLoanCalculationController.SaveLoanCalculation(
      Calculation,
      recordTypeName,
      newLead.Id
    );
    Test.stopTest();
    System.assertEquals(
      1,
      [
        SELECT Id, Number_of_Loans_Scenerios_Run__c
        FROM Lead
        WHERE Id = :newLead.Id
      ]
      .Number_of_Loans_Scenerios_Run__c
    );
  }
}
