public with sharing class FinancialDetailsSelector {
  /**
   * Returns all the unverified fields for an applicant financial details
   * @param {Id} accountId - account Id
   * @return {AccountWrapper} - account details in wrapper format
   */
  public static FinancialDetailsWrapper financialDetailsSelector(Id oppId) {
    FinancialDetailsWrapper financialDetailWrapper;
    Applicant__c applicantObj = [
      SELECT
        Id,
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
        Net_Worth_Calc__c
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];
    System.debug('Applicant Fileds ' + applicantObj);
    if (applicantObj != null) {
      financialDetailWrapper = new FinancialDetailsWrapper(applicantObj);
    }

    return financialDetailWrapper;
  }
}
