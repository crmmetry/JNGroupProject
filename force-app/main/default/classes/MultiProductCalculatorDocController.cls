public class MultiProductCalculatorDocController {
  public List<Loan_Calculator__c> ProductDetails { get; set; }
  public Boolean isAutoFound { get; set; }
  public Boolean isUnFound { get; set; }
  public Boolean isCcFound { get; set; }
  public Boolean isLocFound { get; set; }
  public string productName { get; set; }
  public Date currentDate { get; set; }
  public String officername { get; set; }
  public string ApplicantCount { get; set; }
  public string Applicant1last { get; set; }
  public string Applicant1first { get; set; }
  public string Applicant2last { get; set; }
  public string Applicant2first { get; set; }
  public string Applicant3last { get; set; }
  public string Applicant3first { get; set; }
  public string OfficeLocation { get; set; }
  public MultiProductCalculatorDocController() {
    ProductDetails = new List<Loan_Calculator__c>();
    isAutoFound = false;
    isUnFound = false;
    isCcFound = false;
    isLocFound = false;
    currentDate = system.today();
    officername = UserInfo.getName();
    ApplicantCount = '';
    productName = '';
    if (ApexPages.currentPage().getParameters().containsKey('loanid')) {
      string loanid = ApexPages.currentPage().getParameters().get('loanid');
      fillProductDetailsFromOppAndLead(loanid);
    }
    if (ApexPages.currentPage().getParameters().containsKey('location'))
      OfficeLocation = ApexPages.currentPage().getParameters().get('location');
  }

  public void fillProductDetailsFromOppAndLead(string loanid) {
    system.debug('loanid=====' + loanid);
    ProductDetails = [
      SELECT
        id,
        Monthly_JN_Life_Creditor_Life_Premium_M__c,
        Monthly_JNGI_Motor_Premium_1st_Year__c,
        Monthly_Loan_Payment_after_moratorium__c,
        Monthly_loan_Payment_Monthly_Savings_M__c,
        Unsecure_Monthly_Processing_Fees__c,
        Total_Monthly__c,
        Unsecure_Monthly_Loan_Payment_Market__c,
        Unsecure_Monthly_JN_Life_Premium__c,
        Staff_1_Loan_amount_and_calculations__c,
        JN_Staff2_interest_rate__c,
        Staff_1_Loan_term__c,
        Staff_2_Loan_amount_and_calculations__c,
        JN_Staff3_Interest_rate__c,
        Staff_3_Loan_term__c,
        Staff_3_Loan_amount_and_calculations__c,
        Unsecure_JN_Staff_1_Loan_Amount__c,
        unsecure_JN_Staff2_Loan_Amount__c,
        unsecure_JN_Staff_3_Loan_Amount__c,
        Monthly_Processing_Fees_During_moratoriu__c,
        unsecure_JN_Life_Creditor_Life_Premium__c,
        Unsecure_Monthly_Loan_Payment_staff1__c,
        unsecure_JN_Staff_2_Monthly_Loan_Payment__c,
        unsecure_JN_Staff_3_Monthly_Loan_Payment__c,
        Annual_Facility_Fee__c,
        Policy_Limit__c,
        Pior_to_Proposed_Credit__c,
        After_Proposed_Credit__c,
        Type_of_Card__c,
        Applicant_1_Name__c,
        Applocant_2_Name__c,
        Applicant_3_Name__c,
        Applicant_1_Date_of_Birth__c,
        Applicant_1_Gross_Monthly_Income__c,
        Applicant_1_Existing_Monthly_Payment__c,
        Applicant_1_Jn_Employee__c,
        Applicant_2_Date_of_Birth__c,
        Applicant_2_Gross_Monthly_income__c,
        Applicant_2_existing_monthly_credit__c,
        Applicant_2_JN_Employee__c,
        Applicant_3_Date_of_Birth__c,
        Applicant_3_Gross_Monthly_income__c,
        Applicant_3_Existing_Monthly__c,
        Applicant_3_Jn_Employee__c,
        Nick_Name_Of_Calculation__c,
        Lead_and_Referral__c,
        Opportunity__c,
        Monthly_Gross_Income__c,
        Existing_Monthly_Credit_Payment__c,
        Auto_Loan_Purpose__c,
        Market_Value_of_Vehicle__c,
        Motor_Vehicle_Deposit__c,
        Motor_Vehicle_Deposit_Percentage__c,
        Interested_in_programme__c,
        Include_first_year_premium_in_loan_amt__c,
        Monthly_Premium__c,
        Interested_in_Creditor_Life__c,
        Coverage_Type__c,
        Include_in_Loan_Amount_jnlife__c,
        Waive_Process_Fee__c,
        Include_in_Loan_Amount_Processing_Fee__c,
        Indicate_applicable_process_fee_percent__c,
        Include_a_moratorium_of_Loan_Payment__c,
        Moratorium_Indicate_Term__c,
        Proposed_Savings__c,
        Proposed_SavingsPercentage__c,
        Interest_Rate__c,
        Years__c,
        Months__c,
        Loan_Amount__c,
        Deduct_1st_moth_Payment_from_Loan__c,
        unsecure_Loan_Purpose__c,
        unsecure_Jn_Life_Creditor_Life_Insurance__c,
        Unsecure_Coverage_Type__c,
        Unsecure_Include_in_Loan_Amount__c,
        Unsecure_Waive_Processing_Fee__c,
        Unsecure_Indcate_applicable_process_fee__c,
        Unsecure_Loan_Savings_currency__c,
        Unsecure_Proposed_Savings__c,
        Unsecure_Proposed_Savings_percentage__c,
        Unsecure_Market_Per_Annum__c,
        Unsecure_Years__c,
        Unsecure_Months__c,
        PC_Credit_Limit__c,
        PC_Credit_Limit_Amount__c,
        Reqeusted_Limit__c,
        PC_Interest_Rate__c,
        Number_of_Supplementary_Applicant__c,
        PC_Collateral_Type__c,
        PC_Type_of_Cash_Secured_Collateral__c,
        PC_Deposit_Account_Balance__c,
        PC_Account_Hypothecated_for_another_Loan__c,
        PC_Total_existing_Loan_Balance__c,
        Proposed_Starting_Limit__c,
        PCL_Requested_Credit_Limit__c,
        PLC_Credit_Limit_Currency__c,
        PCL_Interest_Rate__c,
        PCL_Collateral_Type__c,
        PCL_Type_of_Cash_Secured_Collateral__c,
        PCL_Deposit_Account_Balance__c,
        PCL_Account_Hypothecated_another_Loan__c,
        PCL_Total_Existing_Loan_Balance__c,
        Purchase_Price_of_Vehicle__c,
        Processing_Fees_including_GCT__c,
        Total_Loan_Amount__c,
        Monthly_Loan_Savings__c,
        Monthly_loan_Payment_Monthly_Savings__c,
        Total_Loan_Savings_Balance__c,
        Total_Interest_Payment__c,
        Legal_Fees_Including_GCT__c,
        Stamp_Duty__c,
        Total_Auto_Loan_Fees_Charges__c,
        Indicate_Type__c,
        JN_Staff1_intereste_rate__c,
        JN_Staff1_loan_term__c,
        JN_Life_Creditor_Life_Premium__c,
        JN_life_Creditor_Life_Premium_moratorium__c,
        Monthly_JNGI_Motor_Premium_moratorium__c,
        Monthly_JNGI_Motor_Premium_1_12_Pay__c,
        Monthly_JN_Life_Creditor_Life_Premium__c,
        Monthly_Processing_Fees_moratorium__c,
        Monthly_Loan_Payment__c,
        Unsecured_Loan_Amount__c,
        Unsecure_Fee_Include_in_Loan_Amount__c,
        unsecure_Total_Loan_Amount__c,
        Unsecure_Monthly_Loan_Payment__c,
        unsecure_Monthly_Loan_Savings__c,
        unsecure_Total_Loan_Savings_Balance__c,
        unsecure_Total_Interest_Payment__c,
        unsecure_Legal_Fees_Including_GCT__c,
        Stamp_Duty_Security_Documents__c,
        Total_unsecured_Loan_Fee_Charges__c,
        JNGI_Motor_Premium_1st_Year__c,
        Staff1_Mthly_Loan_Payment_D_Moratorium__c,
        Staff1_Mthly_Loan_Payment_A_Moratorium__c,
        Staff2_Mthly_Loan_Payment_D_Moratorium__c,
        Staff2_Mthly_Loan_Payment_A_Moratorium__c,
        Staff3_Mthly_Loan_Payment_D_Moratorium__c,
        Staff3_Mthly_Loan_Payment_A_Moratorium__c,
        App_1_Loan_Amount_A__c,
        App_2_Loan_Amount_A__c,
        App_3_Loan_Amount_A__c,
        App1_Monthly_Payment_A__c,
        App_2_Monthly_Payment_A__c,
        App_3_Monthly_Payment_A__c,
        App_1_LOC_limit__c,
        App_2_LOC_Limit__c,
        App_3_LOC_Limit__c,
        App_1_Min_Payment__c,
        App_2_Min_Payment_LOC__c,
        App_3_Min_Payment_LOC__c,
        App_1_Loan_Amount_UL__c,
        App_2_Loan_Amount_UL__c,
        App_3_Loan_Amount_UL__c,
        App_1_Monthly_Payment_UL__c,
        App_2_Monthly_Payment_UL__c,
        App_3_Monthly_Payment_UL__c,
        App1_Loan_Amt_Alloc_UL__c,
        App2_Loan_Amt_Alloc_UL__c,
        App3_Loan_Amt_Alloc_UL__c,
        App1_Mnthly_Pmt_Alloc_UL__c,
        App2_Mnthly_Pmt_Alloc_UL__c,
        App3_Mnthly_Pmt_Alloc_UL__c,
        App1_Loan_Amt_Alloc__c,
        App2_Loan_Amt_Alloc__c,
        App3_Loan_Amt_Alloc__c,
        App1_Mnthly_Pmt_Alloc__c,
        App2_Mnthly_Pmt_Alloc__c,
        App3_Mnthly_Pmt_Alloc__c,
        App1_Portion_LOC_Lim__c,
        App2_Portion_LOC_Lim__c,
        App3_Portion_LOC_Lim__c,
        App1_Portion_Min_Pay_LOC__c,
        App2_Portion_Min_Pay_LOC__c,
        App3_Portion_Min_Pay_LOC__c,
        Make_and_Model_of_Motor_Vehicle__c,
        Repayment_Method_Auto__c,
        Vehicle_Classification__c,
        Repayment_Method_UL__c,
        interest_in_JN_Life_CC_Creditor_Life_iIn__c,
        Account_Number__c,
        Account_Holders__c,
        Account_Type__c,
        Annual_Interest_Rate_on_Deposit_Account__c,
        Financial_Institution__c,
        Financial_Institution_LOC__c,
        Account_Holders_LOC__c,
        Annual_Interest_Rate_on_Deposit_Acc_LOC__c,
        Name_of_Valuer__c,
        Occupancy_Type__c,
        Property_Classification__c,
        Property_Title_Information_Folio__c,
        Property_Title_information_Vol__c,
        Forced_Sale_Value__c,
        Insurer__c,
        Is_a_Lien_on_Property__c,
        Is_Property_a_Strata__c,
        Replacement_Value__c,
        Security_Address__c,
        Market_Value_of_Property__c,
        JN_Promotion_Auto__r.name,
        JN_Promotion_UL__r.name,
        JN_Promotion_CC__r.name,
        JN_Promotion_LOC__r.name,
        Othee_post_moratorium__c,
        unsecure_Monthly_n_Loan_Savings__c,
        Minimum_Payment__c,
        Annual_Membership__c,
        Annual_Membership_Per_sulpplementary__c,
        Line_of_Credit_Starting_Limit__c,
        Minimum_Payment_as_per_Credit_Limit__c
      FROM Loan_Calculator__c
      WHERE id = :loanid AND RecordType.Name = 'Multi Product'
      LIMIT 1
    ];
    if (ProductDetails.size() > 0) {
      System.debug('---' + ProductDetails[0].Stamp_Duty__c);

      isAutoFound = (ProductDetails[0].Auto_Loan_Purpose__c != null)
        ? true
        : false;
      isUnFound = (ProductDetails[0].unsecure_Loan_Purpose__c != null)
        ? true
        : false;
      isCcFound = (ProductDetails[0].PC_Credit_Limit_Amount__c != null)
        ? true
        : false;
      isLocFound = (ProductDetails[0].PCL_Requested_Credit_Limit__c != null)
        ? true
        : false;
      if (string.isNotEmpty(ProductDetails[0].Applicant_1_Name__c)) {
        ApplicantCount = 'One (1)';
        string[] app1lst = (ProductDetails[0].Applicant_1_Name__c).split(' ');
        Applicant1last = app1lst[0];
        Applicant1first = app1lst[1];
      }
      if (string.isNotEmpty(ProductDetails[0].Applocant_2_Name__c)) {
        ApplicantCount = 'Two (2)';
        string[] app2lst = (ProductDetails[0].Applocant_2_Name__c).split(' ');
        Applicant2last = app2lst[0];
        Applicant2first = app2lst[1];
      }
      if (string.isNotEmpty(ProductDetails[0].Applicant_3_Name__c)) {
        ApplicantCount = 'Three (3)';
        string[] app3lst = (ProductDetails[0].Applicant_3_Name__c).split(' ');
        Applicant3last = app3lst[0];
        Applicant3first = app3lst[1];
      }
      if (ApplicantCount == '')
        ApplicantCount = 'One (1)';
    }
    string str = '';
    if (isAutoFound) {
      productName = 'Auto Loan';
    }
    if (isUnFound) {
      if (string.isEmpty(productName))
        productName += 'Unsecured Loan';
      else
        productName += ', Unsecured Loan';
    }
    if (isCcFound) {
      if (string.isEmpty(productName))
        productName += 'Credit Card';
      else
        productName += ', Credit Card';
    }
    if (isLocFound) {
      if (string.isEmpty(productName))
        productName += 'Line of Credit';
      else
        productName += ' & Line of Credit';
    }

    system.debug('ProductDetails=====' + ProductDetails);
    system.debug('isAutoFound=====' + isAutoFound);
    system.debug('isUnFound=====' + isUnFound);
    system.debug('isCcFound=====' + isCcFound);
    system.debug('isLocFound=====' + isLocFound);
    system.debug('ApplicantCount=====' + ApplicantCount);
  }
}
