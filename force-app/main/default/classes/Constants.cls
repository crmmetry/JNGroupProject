/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     25/11/2020      Ishwari G.(thinqloud)  Added constants to refere values from custom metadata
 **/
public class Constants {
  public static final String NONE = 'None';
  public static final String SUCCESS = 'Success';
  public static final String FAILED = 'Failed';
  public static final String DEFAULT_METADATA_LABEL = 'Default';
  public static final String INVALID_TENURE = 'Sorry an invalid tenure has been entered. Please be reminded a tenure has to be greater than 0 and less than 10.';
  public static final Integer MAX_CREDITOR_LIFE_AGE = 64;
  public static final String APPLICANT_WRAPPER = 'Applicant Wrapper';
  public static final String APPLICANT_ASSETS_AND_LIABILITIES_WRAPPER = 'Assets and Liabiltiy Wrapper';
  //JN1-4045
  public static final String AGE = 'Age';
  public static final String EDUCATION = 'Highest Level of Education attained';
  public static final String STATUS_OF_ADDRESS = 'Status of Address';
  public static final String YEARS_AT_RESIDENCE = 'Years at Residence';
  public static final String CREDIT_HISTORY = 'Credit History over the last 24 months';
  public static final String NET_WORTH = 'Assessment of Applicant Net Worth';
  public static final String EMPLOYMENT_STATUS = 'Employment Status';
  public static final String INDUSTRY = 'Industry';
  public static final String LENGTH_OF_EMPLOYMENT = 'Length of Employment';
  public static final String PROFESSIONAL_CATEGORY = 'Professional Category';
  public static final String WORKING_CAPITA = 'Working Capital';
  public static final String NATURE_OF_ENGAGEMENT = 'Nature of Engagement';
  public static final String FINANCIAL_PERFORMANCE = 'Assessment of Business Fin Performance';
  public static final String FINACIAL_STATEMENT = 'Assessment of Business Fin Statement';
  public static final String LENGTH_OF_TRADE = 'Length of trade';
  public static final String COLLATERAL = 'Collateral CC / Collateral LOC';
  public static final String LOAN_TO_VALUE = 'Loan to Value CC / Loan to Value LOC';
  public static final String LOAN_TO_VALUE_STRING = 'Loan to Value';
  public static final String ABILITY_TO_SERVICE = 'Ability to Service CC / Ability to Service LOC';
  public static final String REPAYMENT_METHOD = 'Repayment Method CC / Repayment Method LOC';

  public static final String LESS_THAN_YEAR = 'Less than a 1 year';
  public static final String BETWEEN_1_3_YEARS = 'Between 1-3 years';
  public static final String BETWEEN_3_5_YEARS = 'Between 3-5 years';
  public static final String LT_1_YEAR = '<1 year';
  public static final String ONE_TO_THREE_YEARS = '1-3 years';
  public static final String THREE_TO_FIVE_YEARS = '3-5 years';
  public static final String GT_5_YEARS = '>5 years';
  public static final String EMPLOYED = 'Employed';
  public static final String YEARS = 'years';
  public static final String YEAR = 'year';
  public static final String OWN = 'Own';
  public static final String POST_GRADUATE = 'University: Post Graduate';
  public static final String UNDERGRADUATE_GRADUATE = 'Undergraduate';
  public static final String VOCATIONAL = 'Vocational';

  public static final String THREE_TO_FOUR_YEARS_AND_OR = 'Good growth and or profit trends for 3 - 4 years';
  public static final String UP_TO_TWO_YEARS_AND_OR = 'Good growth and or profit trends for up to 2 years';
  public static final String INADEQUATE_AND_OR = 'Inadequate growth and or profit trends';
  public static final String INCONSISTANT_AND_OR = 'Inconsistent profit/growth trends';

  public static final String THREE_TO_FOUR_YEARS = 'Good growth and profit trends for 3 - 4 years';
  public static final String UP_TO_TWO_YEARS = 'Good growth and or profit trends for up to 2 years';
  public static final String INADEQUATE = 'Inconsistent profit/growth trends';
  public static final String INCONSISTANT = 'Inadequate growth and/or profit trends';
  public static final Integer STATUS_SUCCESS_CODE = 200;

  public static final String AUTO_PRODUCT_FAMILY = 'JN Bank Auto Loan';
  public static final String CREDITCARD_PRODUCT_FAMILY = 'JN Bank Credit Card';
  public static final String UNSECURED_PRODUCT_FAMILY = 'JN Bank Unsecured Loan';
  public static final String LINEOFCREDIT_PRODUCT_FAMILY = 'JN Bank Line Of Credit';

  public static final String DEFAULT_BUSINESS_HOURS_NAME = 'JN Default Business Hours';
  public static final String CLOSED_WON_STATUS = 'Closed Won';
  public static final String CLOSED_LOST_STATUS = 'Closed Lost';
  public static final String CLOSE_DATE_ERR1 = 'The Closed Date cannot be this far back in the past for this month. Please contact Sales Support.';
  public static final String CLOSE_DATE_ERR2 = 'The Closed Date cannot be this far back in the past. Please contact Sales Support.';
  public static final String CLOSE_DATE_ERR3 = 'The Closed Date cannot be greater than today. Please contact Sales Support.';
  public static final String CLOSE_DATE_ERR4 = 'The Closed Date year cannot be less this year. Please contact Sales Support.';
  public static final String CLOSE_DATE_ERR5 = 'The Closed Date cannot be a holiday. Please contact Sales Support.';
  public static final String NO_APPLICANTS_FOUND = 'Please ensure that an Applicant has been created for the current Opportunity before proceeding.';
  public static final String FINACIAL_VERIFICATION_CUSTOM_PERMISSION_ERROR = 'Sorry, you do not have the correct permissions to edit this page. Please contact your System Administrator for more information.';

  public static final String AUTO_PRODUCT_FAMILY_FOR_DISPLAY = 'Auto Loan';
  public static final String CREDITCARD_PRODUCT_FAMILY_FOR_DISPLAY = 'Credit Card';
  public static final String UNSECURED_PRODUCT_FAMILY_FOR_DISPLAY = 'Unsecured Loan';
  public static final String LINEOFCREDIT_PRODUCT_FAMILY_FOR_DISPLAY = 'Line Of Credit';

  public static final String STARTINGLIMITNUMBER_C = 'Starting_Limit_Number__c';
  public static final String MARKETVALUEOFVEHICLENUMBER_C = 'Market_Value_of_Vehicle_Number__c';
  public static final String MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C = 'Monthly_Payment_Prior_Calc_App_Portion__c';
  public static final String MINIMUM_PAYMNT_CALC_C = 'Minimum_Payment_Calc__c';
  public static final String TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C = 'Total_Monthly_Loan_Payment_Number__c';
  public static final String MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C = 'Minimum_Payment_per_Credit_Limit_Number__c';
  public static final String MONTHLY_PAYMENT_AFTER_C = 'Monthly_Payment_After__c';
  public static final String MINIMUM_PAYMENT_AFTER_C = 'Minimum_Payment_After__c';
  public static final String OVERDRAFTLIMITNUMBER_C = 'Overdraft_Limit_Number__c';
  public static final String LOANBALANCEPRIOR_C = 'Loan_Balance_Prior__c';

  public static final String WILL_REMAIN_STRING = 'Will Remain';
  public static final String REPAY_FACILITY_STRING = 'Repay Facility';

  public static final String YESSTRING = 'Yes';
  public static final String NOSTRING = 'No';

  public static final String OPPORTUNITYSTRING = 'Opportunity';
  public static final String OPPORTUNITY_PRE_ASSESSMENT_STAGE = 'Submitting for Pre-Assessment';
  public static final String DOCUMENTTYPEPROMISSORYNOTE = 'Promissory_Note';
  public static final String DOCUMENTTYSIGNEDSALARYDED = 'Signed_Salary_Deduction';
  public static final String DOCUMENT_PROOF_OF_INCOME_AUDITEDFINSTATEMENT = 'Proof_of_income_Audited_Financial_Statements';
  public static final String DOCUMENT_PROOF_OF_INCOME_BNKSTATEMENT = 'Proof_of_income_Bank_Statements';
  public static final String DOCUMENT_PROOF_OF_INCOME_OTHER = 'Proof_of_income_Other';
  public static final String DOCUMENT_PROOF_OF_INCOME_PAYSLIP = 'Proof_of_income_Payslips';
  public static final String DOCUMENT_PROOF_OF_INCOME_UNAUDITED_FINSTATEMENT = 'Proof_of_income_Unaudited_Financial_Statements';

  public static final String DOCCHKLISTITEM_SOBJECT = 'DocumentChecklistItem';

  public static final List<String> SKILL_PRODUCTS = new List<String>{
    'JN Bank 12 to 1 Loan (Supersize Loan)',
    'JN Bank Auto Loan',
    'JN Bank Cash Secured Loan',
    'JN Bank Commercial Auto Loan',
    'JN Bank Credit Card',
    'JN Bank Deposit Account',
    'JN Bank Insurance Premium Financing',
    'JN Bank Line Of Credit',
    'JN Bank Mortgage Loan',
    'JN Bank Unsecured Loan',
    'JN Bank Insurance Premium Financing',
    'JN Bank Term Share Loan'
  };
  public static final String ONLY_ONE_APPLICATION = 'Sorry, you cannot add any more than one application for this opportunity. Contact your administrator.';

  public static final String BYPASS_CLOSED_DATE_PERMISSIONS = 'Bypass_Closed_Date';

  public static final String CASH_COLLATERAL = 'Cash/Investments';
  public static final String UNSECURED_COLLATERAL = 'Unsecured (None)';
  public static final String JN_BANK_FINANCIAL_INSTITUTION = 'JN Bank Ltd.';
  public static final String FUND_MANAGER_FINANCIAL_INSTITUTION = 'JN Fund Managers Ltd';
}
