@isTest
public class TestSimpleLoanCalculationController {
  @isTest
  public static void shouldSaveLoanCalculation() {
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'hayley')[0];
    insert acc;

    Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
    opp.AccountId = acc.Id;
    insert opp;

    Lead newLead = TestDataFactory.CreateLeads(1)[0];
    insert newLead;

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
      recordTypeName
    );
  }
}
