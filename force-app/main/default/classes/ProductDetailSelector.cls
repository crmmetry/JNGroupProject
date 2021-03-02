/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     24/11/2020      Ishwari G.(thinqloud)  Selector for the Product Details related Object
 * 2.0  JN1-3969     4/12/2020       Ishwari G.(thinqloud)  Selector for the supplementary card holder object
 **/
public with sharing class ProductDetailSelector {
  /*
   * gives the account details
   * @param {Id} accountId - account Id
   * @return {AccountWrapper} - account details in wrapper format
   */
  public static AccountWrapper getAccount(Id accountId) {
    AccountWrapper accWrapper;
    Account accountObj = [
      SELECT
        Status_of_Address__c,
        Status_of_Address__pc,
        Years_at_Residence__pc,
        Highest_Level_of_Education_attained__pc,
        FinServ__Age__pc,
        PersonBirthdate,
        Name,
        Political_Exposure__pc,
        Jamaican_Tax_Registration_Number__pc
      FROM Account
      WHERE Id = :accountId
    ];
    if (accountObj != null) {
      accWrapper = new AccountWrapper(accountObj);
    }

    return accWrapper;
  }

  /*
   * gives the employment details
   * @param {Id} accountId - account Id
   * @return {EmploymentWrapper} - employment details in wrapper format
   */
  public static EmploymentWrapper getEmployemntDetails(Id accountId) {
    EmploymentWrapper empWrapper;
    FinServ__Employment__c employment = [
      SELECT
        Id,
        FinServ__EmploymentStatus__c,
        Employment_Status__c,
        Industry__c,
        FinServ__LengthOfEmployment__c,
        Professional_Category__c,
        Assessment_of_Business_Working_Capita__c,
        Nature_of_Engagement__c,
        Assessment_of_Business__c,
        Assessment_of_Statement__c,
        Length_of_Trade__c,
        RecordTypeId
      FROM FinServ__Employment__c
      WHERE Account__c = :accountId AND Current_Employment__c = TRUE
    ];
    if (employment != null) {
      empWrapper = new EmploymentWrapper(employment);
    }
    return empWrapper;
  }
  /**
   * gives the applicant details
   * @param {Id} oppId - opportunity Id
   * @return {List<ApplicantWrapper>} - returns list of applicants in wrapper format
   */
  public static List<ApplicantWrapper> getApplicantDetails(Id oppId) {
    List<Applicant__c> applicantList = [
      SELECT
        Id,
        Name,
        Credit_History_in_last_24_Months__c,
        Assessment_of_Applicant_Net_Worth__c,
        Statutory_Deductions_Numbers__c,
        Rent_Strata_Maintenance__c,
        Personal_Expenses_Monthly_Prior_Loan__c,
        Savings_Pension_Insurance_Number__c,
        Real_Estate_Monthly_Payment_Number__c,
        Motor_Vehicle_Monthly_Payment_Number__c,
        Other_Asset_Monthly_Payment_Number__c,
        Other_Loan_Monthly_Payment_Number__c,
        Gross_Monthly_Income__c,
        Account__r.PersonBirthdate,
        Rent_Board_Monthly_Prior_Loan__c,
        Rent_Board_Monthly_After_Loan__c,
        Gross_Monthly_IncomeC__c,
        Strata_Maintenance_Monthly_Prior_Loan__c,
        Strata_Maintenance_Monthly_After_Loan__c,
        (
          SELECT
            Id,
            Minimum_Payment_After_Calc__c,
            Minimum_Payment_Calc__c,
            Monthly_Payment_Prior__c,
            Monthly_Payment_After__c,
            Assets_and_Liabilities__r.Percent_Applicant_Portion__c
          FROM Application_Assets_Liabilities__r
        )
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];
    List<ApplicantWrapper> applicantWrappers = new List<ApplicantWrapper>();
    if (!applicantList.isEmpty() && applicantList.size() > 0) {
      for (Applicant__c applicant : applicantList) {
        ApplicantWrapper appWrapper = new ApplicantWrapper(applicant);
        applicantWrappers.add(appWrapper);
      }
    }

    return applicantWrappers;
  }

  /*
   * gives the loan calculations details
   * @param {Id} oppId - opportunity Id
   * @return {List<LoanCalculationsWrapper>} - returns list of loan calculations in wrapper format
   */
  public static List<LoanCalculationsWrapper> getLoanCalculations(Id oppId) {
    List<Loan_Calculator__c> loanCalculations = [
      SELECT
        Ability_to_Service_CC__c,
        Ability_to_Service_LOC__c,
        Repayment_Method_CC__c,
        Repayment_Method_LOC__c
      FROM Loan_Calculator__c
      WHERE Opportunity__c = :oppId
    ];
    List<LoanCalculationsWrapper> loanCalcWrappers = new List<LoanCalculationsWrapper>();
    if (!loanCalculations.isEmpty() && loanCalculations.size() > 0) {
      for (Loan_Calculator__c loanCalculation : loanCalculations) {
        LoanCalculationsWrapper loanWrapper = new LoanCalculationsWrapper(
          loanCalculation
        );
        loanCalcWrappers.add(loanWrapper);
      }
    }
    return loanCalcWrappers;
  }

  /*
   * gives the opportunity details
   * @param {Id} oppId - opportunity Id
   * @return {OpportunityWrapper} - returns  opportunity details in wrapper format
   */
  public static OpportunityWrapper getOpportunityDetails(Id oppId) {
    OpportunityWrapper oppWrapper;
    Opportunity oppObj = [
      SELECT
        AccountId,
        Collateral_CC__c,
        Collateral_LOC__c,
        Loan_to_ValueCC__c,
        Loan_to_ValueLOC__c,
        Pre_Approval_list__c,
        Final_Assessment_Decision_list__c,
        FinServ__FinancialAccount__r.Name,
        FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c,
        FinServ__FinancialAccount__r.Account_Type_List__c
      FROM Opportunity
      WHERE Id = :oppId
    ];
    if (oppObj != null) {
      oppWrapper = new OpportunityWrapper(oppObj);
    }
    return oppWrapper;
  }

  //JN1-3969
  /** *
   * returns the supplementary Card holder wrapper
   * @param {Id} oppId - opportunity Id
   * @return {List<SupplementaryCardHolderWrapper>} - returns  supplementary card holder details in wrapper format
   */
  public static List<SupplementaryCardHolderWrapper> getSupplementaryCardHolder(
    Id oppId
  ) {
    List<SupplementaryCardHolderWrapper> supplementaryWrapperList = new List<SupplementaryCardHolderWrapper>();
    List<Supplementary_Card_Holders__c> supplementaryCardHolderList = [
      SELECT
        Id,
        Name,
        Opportunity__c,
        Account__c,
        CurrencyIsoCode,
        Card_Holder_Name__c
      FROM Supplementary_Card_Holders__c
      WHERE Opportunity__c = :oppId
    ];
    if (supplementaryCardHolderList.size() > 0) {
      for (Supplementary_Card_Holders__c record : supplementaryCardHolderList) {
        supplementaryWrapperList.add(
          new SupplementaryCardHolderWrapper(record)
        );
      }
    }
    return supplementaryWrapperList;
  }

  /*
   * gets the loan calculation product record related to a rubicon opportunity
   * @param {Id} oppId - opportunity Id
   * @return {LoanCalculationProductWrapper} - returns  opportunity details in wrapper format
   */
  public static LoanCalculationProductWrapper getLoanCalculationRecord(
    Id oppId
  ) {
    LoanCalculationProductWrapper loanWrapper;
    Loan_Calculation_Product__c loanObj = [
      SELECT
        Id,
        Loan_Amount_Market_Percentage_Number__c,
        Approved_Starting_Limit_Number__c,
        Minimum_Payment_per_Credit_Limit_Number__c,
        Total_Loan_Amount_Number__c,
        Monthly_Interest_Rate_Number__c,
        Total_Monthly_Loan_Payment_Number__c,
        Monthly_Compulsory_Savings_Number__c,
        Creditor_Life_Insurance_Premium_Number__c,
        Total_Compulsory_Savings_Balance_Number__c,
        Total_Interest_Payment_Repayment_Number__c,
        Legal_Fees_including_GCT_Number__c,
        Processing_Fees_including_GCT_Number__c,
        Stamp_Duty_Number__c,
        Credit_Report_Fee_Number__c,
        Creditor_Life_Insurance_Rate_Number__c,
        Total_Closing_Costs_Number__c,
        Policy_Limit_Number__c,
        Ability_to_Service_After_Number__c,
        Ability_to_Service_Before_Number__c,
        Monthly_P_I_Life_Insurance_Premium__c
      FROM Loan_Calculation_Product__c
      WHERE Loan_Calculation_Id__r.Opportunity__c = :oppId
      ORDER BY CreatedDate DESC
      LIMIT 1
    ];
    if (loanObj != null) {
      loanWrapper = new LoanCalculationProductWrapper(loanObj);
    }

    return loanWrapper;
  }
}
