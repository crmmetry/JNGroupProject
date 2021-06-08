/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-04-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
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
        Politically_Affiliated__c,
        JN_Bank_Affiliation__pc,
        Premier_Customer_List__c,
        FinServ__NumberOfDependents__pc,
        Name,
        Id,
        Highest_level_of_Education_attained__pc
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
  public static List<Applicant__c> getApplicants(Set<Id> opportunityIdSet) {
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
        Account__c,
        Number_of_Rejected_Applications_Number__c,
        Public_Sector_or_Civil_Servant_List__c,
        Id
      FROM Applicant__c
      WHERE
        Opportunity__c IN :opportunityIdSet
        AND Primary_Applicant_Flag__c = TRUE
      WITH SECURITY_ENFORCED
    ];
    return applicantList;
  }
  /**
   * @description get  applications
   * @author Remario Richards | 05-26-2021
   **/
  public static List<Application__c> getApplications(Set<Id> opportunityIdSet) {
    List<Application__c> applicationList = [
      SELECT
        Application_ID__c,
        IDM_Loan_Amount_Number__c,
        IDM_Tenure_Date__c,
        Adjudication_Decision_picklist__c,
        IDM_Interest_Rate_Number__c
      FROM Application__c
      WHERE Opportunity_Id__c IN :opportunityIdSet
      WITH SECURITY_ENFORCED
    ];
    return applicationList;
  }

  /**
   * @description get  loan calculations
   * @author Remario Richards | 05-26-2021
   **/
  public static List<Loan_Calculator__c> getLoanCalculations(
    Set<Id> opportunityIdSet
  ) {
    List<Loan_Calculator__c> loanCalculationList = [
      SELECT Id
      FROM Loan_Calculator__c
      WHERE Opportunity__c IN :opportunityIdSet
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
    ];
    return loanCalculationList;
  }
  /**
   * @description get  loan calculation products
   * @author Remario Richards | 05-26-2021
   **/
  public static List<Loan_Calculation_Product__c> getLoanCalculationProducts(
    Set<Id> loanCalculationIdSet
  ) {
    List<Loan_Calculation_Product__c> loanCalculationProductList = [
      SELECT
        Loan_Amount_Number__c,
        Interest_Rate_Number__c,
        Months_Number__c,
        Loan_Purpose_List__c,
        Method_of_Fee_Payment_List__c,
        Minimum_Payment_per_Credit_Limit_Number__c
      FROM Loan_Calculation_Product__c
      WHERE Loan_Calculation_Id__c IN :loanCalculationIdSet
      WITH SECURITY_ENFORCED
      ORDER BY CreatedDate DESC
    ];
    return loanCalculationProductList;
  }

  /**
   * @description get opportunity details
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param opportunityIdSet
   * @return List<Opportunity>
   **/
  public static List<Opportunity> getOpportunity(Set<Id> opportunityIdSet) {
    List<Opportunity> oppList = [
      SELECT Preferred_Location__c, CurrencyIsoCode, Id, AccountId, Name
      FROM Opportunity
      WHERE Id IN :opportunityIdSet
      WITH SECURITY_ENFORCED
    ];
    return oppList;
  }

  /**
   * @description get opportunity line items details
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param opportunityIdSet
   * @return List<OpportunityLineItem>
   **/
  public static List<OpportunityLineItem> getOpportunityLineItem(
    Set<Id> opportunityIdSet
  ) {
    List<OpportunityLineItem> oppLineItemList = [
      SELECT Product_Family__c, Name, Id
      FROM OpportunityLineItem
      WHERE OpportunityId IN :opportunityIdSet
      WITH SECURITY_ENFORCED
    ];
    return oppLineItemList;
  }

  /**
   * @description get the employment details for account
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param accountIdSet
   * @return List<FinServ__Employment__c>
   **/
  public static List<FinServ__Employment__c> getEmployment(
    Set<Id> accountIdSet
  ) {
    List<FinServ__Employment__c> employmentList = [
      SELECT
        Professional_Category__c,
        Position_List__c,
        Industry__c,
        Name,
        FinServ__EmploymentStatus__c,
        Time_Employed_in_Present_Employer_M__c,
        Time_Employed_with_Previous_Employer_M__c,
        Id
      FROM FinServ__Employment__c
      WHERE Account__c IN :accountIdSet AND Current_Employment__c = TRUE
      WITH SECURITY_ENFORCED
    ];
    return employmentList;
  }

  /**
   * @description get applicants
   * @author Remario Richards | 05-26-2021
   **/
  public static List<Applicant__c> getCoApplicants(Set<Id> opportunityIdSet) {
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
        Account__c,
        Number_of_Rejected_Applications_Number__c,
        Public_Sector_or_Civil_Servant_List__c,
        Id
      FROM Applicant__c
      WHERE
        Opportunity__c IN :opportunityIdSet
        AND Primary_Applicant_Flag__c = FALSE
      WITH SECURITY_ENFORCED
    ];
    return applicantList;
  }
}
