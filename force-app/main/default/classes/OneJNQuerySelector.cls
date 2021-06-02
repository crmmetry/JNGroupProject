/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-26-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNQuerySelector {
  /**
   * @description retrieve accounts
   * @author Remario Richards | 05-26-2021
   **/
  public static List<Account> getAccounts(Set<Id> accountIdSet) {
    List<Account> accountList = [
      SELECT
        RecordType.Name,
        MonthsResidence_Number__c,
        Political_Exposure__pc,
        Premier_Customer_List__c,
        FinServ__NumberOfDependents__pc,
        Name,
        Id
      FROM Account
      WHERE Id IN :accountIdSet
      WITH SECURITY_ENFORCED
    ];
    return accountList;
  }
  /**
   * @description get applicants
   * @author Remario Richards | 05-26-2021
   **/
  public static void getApplicants(Id opportunityId) {
    List<Applicant__c> applicantList = [
      SELECT
        Are_you_currently_in_bankruptcy_list__c,
        Declared_bankrupt_list__c,
        Date_of_Last_Rejection_date__c,
        Joint_Application_flag__c,
        Total_Expenses_Calc__c,
        Total_Expenses_VERIFIED_Calc__c,
        Gross_Monthly_Income__c,
        Gross_Monthly_Income_VERIFIED_Number__c,
        Other_Income__c,
        Other_Income_VERIFIED_Number__c,
        Total_Assets_Calc__c,
        Total_Assets_VERIFIED_Calc__c,
        Total_Amount_Consolidated__c,
        Total_Amount_Consolidation_VERIFIED__c,
        Total_Liabilities_Calc__c,
        Total_Liabilities_VERIFIED_Calc__c,
        Total_Monthly_Loan_Payments_Number__c,
        Total_Monthly_Loan_Payments_VERIFIED__c,
        Net_Worth_Calc__c,
        Net_Worth_VERIFIED_Calc__c,
        Total_Monthly_Payment__c,
        Total_Monthly_Payment_VERIFIED_Number__c,
        Primary_Applicant_Flag__c,
        Id
      FROM Applicant__c
      WHERE Opportunity__c = :opportunityId
      WITH SECURITY_ENFORCED
    ];
  }
  /**
   * @description get  applications
   * @author Remario Richards | 05-26-2021
   **/
  public static Application__c getApplications(Id opportunityId) {
    Application__c application = [
      SELECT Application_ID__c
      FROM Application__c
      WHERE Opportunity_Id__c = :opportunityId
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    return application;
  }

  /**
   * @description get  loan calculations
   * @author Remario Richards | 05-26-2021
   **/
  public static Loan_Calculator__c getLoanCalculations(Id opportunityId) {
    Loan_Calculator__c loanCalculation = [
      SELECT Id
      FROM Loan_Calculator__c
      WHERE Opportunity__c = :opportunityId
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
    return loanCalculation;
  }
  /**
   * @description get  loan calculation products
   * @author Remario Richards | 05-26-2021
   **/
  public static Loan_Calculation_Product__c getLoanCalculationProducts(
    Id loanCalculationId
  ) {
    Loan_Calculation_Product__c loanCalculationProduct = [
      SELECT
        Loan_Amount_Number__c,
        Interest_Rate_Number__c,
        Months_Number__c,
        Loan_Purpose_List__c,
        Method_of_Fee_Payment_List__c,
        Minimum_Payment_per_Credit_Limit_Number__c
      FROM Loan_Calculation_Product__c
      WHERE Loan_Calculation_Id__c = :loanCalculationId
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
    return loanCalculationProduct;
  }
}
