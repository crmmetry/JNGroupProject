public with sharing class FinancialDetailsSelector {
  /**
   * Returns all the unverified fields for an applicant financial details
   * @param {Id} oppId - Opportunity Id
   * @return {AccountWrapper} - account details in wrapper format
   */
  public static FinancialDetailsWrapper financialDetailsSelector(Id oppId) {
    FinancialDetailsWrapper financialDetailWrapper;
    Map<String, Id> recordTypesMapForApplicants = Util.getRecordTypeids(
      'Applicant__c'
    );
    String IDMRecordTypeId = Util.getMappedRecordTypeId(
      'Instant_Designing_Module_IDM',
      recordTypesMapForApplicants
    );
    Applicant__c applicantObj = [
      SELECT
        Id,
        Total_Amount_Consolidated__c,
        Total_Amount_Consolidation_VERIFIED__c,
        Real_Estate_Market_Value_Number__c,
        Motor_Vehicle_Market_Value_Number__c,
        Savings_Deposit_Investments__c,
        Life_Insurance_Cash_Value__c,
        Pension_IRS_Total_Contribution__c,
        Other_Asset_Market_Value_Number__c,
        Mortgage_Balance_Number__c,
        Other_Loan_Loan_Balance_Number__c,
        Average_Credit_Card_Balances_Number__c,
        Average_Line_of_Credit_Balance_Number__c,
        Other_Debt_Number__c,
        Mortgage_Rent_Number__c,
        Utilties_and_Household_Expenses_Number__c,
        Personal_and_Family_Expenses_Number__c,
        Transportation_Number__c,
        Other_Expenses_Number__c,
        Statutory_Deductions_Numbers__c,
        Total_Expenses_Calc__c,
        Applicable_sources_of_income__c,
        Gross_Monthly_Income__c,
        Other_Income__c,
        Net_Profit_Sole_Trader__c,
        Share_of_Profit_Partnership__c,
        Share_of_Profit_Shareholder__c,
        Director_s_Emoluments_Director__c,
        Pension__c,
        Existing_Real_Estate_Rental_I__c,
        Total_Assets_Calc__c,
        Total_Liabilities_Calc__c,
        Net_Worth_Calc__c,
        Real_Estate_Holding_s_VERIFIED_Number__c,
        Motor_Vehicle_s_VERIFIED__c,
        Savings_Current_Account_s_Investment_VER__c,
        Life_Insurance_Policy_Cash_Value_VER_Num__c,
        Pension_Contribution_s_VERIFIED_Number__c,
        Other_Asset_s_VERIFIED_Number__c,
        Total_Assets_Verified_Number__c,
        Mortgage_Balance_VERIFIED_Number__c,
        Other_Loan_s_VERIFIED_Number__c,
        Average_Credit_Card_Balances_VERIFIED__c,
        Average_Line_of_Credit_Balance_VERIFIED__c,
        Other_Debt_VERIFIED_Number__c,
        Total_Liabilities_Verified_Number__c,
        Net_Worth_Verified_Number__c,
        Gross_Monthly_Income_VERIFIED_Number__c,
        Other_Income_VERIFIED_Number__c,
        Net_Profit_Sole_Trader_VERIFIED_Number__c,
        Director_s_Emoluments_Director_VERIFIED__c,
        Share_of_Profit_Partnership_VERIFIED__c,
        Share_of_Profit_Shareholder_VERIFIED__c,
        Pension_VERIFIED_Number__c,
        Property_Rental_VERIFIED_Number__c,
        Total_Monthly_Loan_Payments_VERIFIED__c,
        Mortgage_Rent_VERIFIED_Number__c,
        Utilities_Household_Expenses_VERIFIED__c,
        Personal_and_Family_Expenses_VERIFIED__c,
        Transportation_VERIFIED_Number__c,
        Other_Expenses_VERIFIED_Number__c,
        Statutory_Deductions_VERIFIED_Number__c,
        Total_Monthly_Expenses_Verified_Number__c,
        Primary_Source_of_Income_List__c
      FROM Applicant__c
      WHERE Opportunity__c = :oppId AND RecordTypeId = :IDMRecordTypeId
    ];
    if (applicantObj != null) {
      financialDetailWrapper = new FinancialDetailsWrapper(applicantObj);
    }

    return financialDetailWrapper;
  }

  /**
   * Returns all the unverified fields for an applicant's debts to be consolidated
   * @param {Id} oppId - opportunity Id
   * @return {AccountWrapper} - account details in wrapper format
   */
  public static List<DebtsConsolidatedWrapper> debtsConsolidatedSelector(
    Id oppId
  ) {
    DebtsConsolidatedWrapper debtsWrapper;
    List<DebtsConsolidatedWrapper> debtWrapperList = new List<DebtsConsolidatedWrapper>();
    Map<String, Id> recordTypesMapForApplicantsAssetsAndLiabilities = Util.getRecordTypeids(
      'Application_Asset_Liability__c'
    );
    String debtConsolidationId = Util.getMappedRecordTypeId(
      'Debt_Consolidation',
      recordTypesMapForApplicantsAssetsAndLiabilities
    );
    List<Application_Asset_Liability__c> consolidatedDebts = [
      SELECT
        Id,
        Account_Number__c,
        Debt_Type_List__c,
        Debt_Amount_Number__c,
        Institution_Debt_List__c,
        Life_Insurance_Cash_Value_Number__c,
        Debt_Type_VERIFIED_List__c,
        Debt_Amount_VERIFIED_Number__c,
        Institution_Debt_is_with_VERIFIED_list__c
      FROM Application_Asset_Liability__c
      WHERE
        Application__r.Opportunity__c = :oppId
        AND RecordTypeId = :debtConsolidationId
    ];
    if (consolidatedDebts != null) {
      for (Application_Asset_Liability__c debt : consolidatedDebts) {
        debtsWrapper = new DebtsConsolidatedWrapper(debt);
        debtWrapperList.add(debtsWrapper);
      }
    }
    return debtWrapperList;
  }
}
