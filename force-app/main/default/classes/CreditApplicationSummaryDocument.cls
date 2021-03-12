/*
 *Name  :  CreditApplicationSummaryDocument
 *Author:  Thinqloud Solutions
 *Date  :  Mar 03, 2021
 *Purpose : This class is to prepare the data to be displayed on the CreditApplicationSummaryDocument.vfp page.
 */
public class CreditApplicationSummaryDocument {
  public Id opportunityId { get; set; }
  public Opportunity opportunityObj { get; set; }
  public list<Applicant__c> applicanList { get; set; }
  public list<ApplicantAndEmployementWrapper> applicantAndEmplWrapperList {
    get;
    set;
  }
  public list<Id> applicantIds = new List<Id>();
  public Loan_Calculation_Product__c loanCalculationProduct { get; set; }
  public map<string, Id> loanCalculationProductIds;
  public Loan_Calculation_Product__c auto_LoanCalculationProduct { get; set; }
  public Loan_Calculation_Product__c CreditCard_LoanCalculationProduct {
    get;
    set;
  }
  public Loan_Calculation_Product__c LineofCredit_LoanCalculationProduct {
    get;
    set;
  }
  public Loan_Calculation_Product__c Unsecured_LoanCalculationProduct {
    get;
    set;
  }

  public Loan_Calculation_Applicant_Product__c loan_Cal_App_Prdct { get; set; }

  public Loan_Calculation_Applicant_Product__c auto_LoanCalculationApplProduct {
    get;
    set;
  }
  public Loan_Calculation_Applicant_Product__c CreditCard_LoanCalculationApplProduct {
    get;
    set;
  }
  public Loan_Calculation_Applicant_Product__c LineofCredit_LoanCalculationApplProduct {
    get;
    set;
  }
  public Loan_Calculation_Applicant_Product__c Unsecured_LoanCalculationApplProduct {
    get;
    set;
  }

  public String Auto_Request_ADJ_Exception_for_Credit { get; set; }
  public String Unsecured_Loan_Request_ADJ_Exception_for_Credit { get; set; }
  public String Credit_Card_Request_ADJ_Exception_for_Credit { get; set; }
  public String Line_of_Credit_Request_ADJ_Exception_for_Credit { get; set; }

  public String Auto_Exception_Approved_by { get; set; }
  public String Unsecured_Loan_Exception_Approved_by { get; set; }
  public String Credit_Card_Exception_Approved_by { get; set; }
  public String Line_of_Credit_Exception_Approved_by { get; set; }

  public String Auto_Date_of_Approval { get; set; }
  public String Unsecured_Loan_Date_of_Approval { get; set; }
  public String Credit_Card_Date_of_Approval { get; set; }
  public String Line_of_Credit_Date_of_Approval { get; set; }

  /*
   *Name  :  CreditApplicationSummaryDocument
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : This is class constructor and it prepares the data to be displayed on the CreditApplicationSummaryDocument.vfp page.
   */
  public CreditApplicationSummaryDocument() {
    applicantAndEmplWrapperList = new List<ApplicantAndEmployementWrapper>();
    //Get the Opportunity id from URL
    opportunityId = ApexPages.currentPage().getParameters().get('Id');
    //Get the list of Applicants of the provided Opportunity Id
    applicanList = getListOfApplicants(opportunityId);
    list<id> applIds = new List<id>();
    if (applicanList != null) {
      if (applicanList.size() > 0) {
        for (Applicant__c record : applicanList) {
          applIds.add(record.Id);
        }
      }
    }

    //Get the opportunity object
    opportunityObj = getOpportunityObj(opportunityId);
    //Get the list of Loan Calculation Product
    list<Loan_Calculation_Product__c> loanCalculationProductList = new List<Loan_Calculation_Product__c>();

    if (opportunityObj != null) {
      loanCalculationProductList = getListOfLoanCalProdcts(opportunityObj);
      boolean autoFlag, creditCardFlag, lineOfCreditFlag, unsecureFlag;
      autoFlag = false;
      creditCardFlag = false;
      lineOfCreditFlag = false;
      unsecureFlag = false;
      loanCalculationProductIds = new Map<string, Id>();

      Auto_Request_ADJ_Exception_for_Credit = '';
      Unsecured_Loan_Request_ADJ_Exception_for_Credit = '';
      Credit_Card_Request_ADJ_Exception_for_Credit = '';
      Line_of_Credit_Request_ADJ_Exception_for_Credit = '';

      Auto_Exception_Approved_by = '';
      Unsecured_Loan_Exception_Approved_by = '';
      Credit_Card_Exception_Approved_by = '';
      Line_of_Credit_Exception_Approved_by = '';

      Auto_Date_of_Approval = '';
      Unsecured_Loan_Date_of_Approval = '';
      Credit_Card_Date_of_Approval = '';
      Line_of_Credit_Date_of_Approval = '';
      if (loanCalculationProductList != null) {
        if (loanCalculationProductList.size() > 0) {
          for (
            Loan_Calculation_Product__c loanCalProdctObj : loanCalculationProductList
          ) {
            String recordTypeDevName;
            recordTypeDevName = Schema.getGlobalDescribe()
              .get('Loan_Calculation_Product__c')
              .getDescribe()
              .getRecordTypeInfosById()
              .get(loanCalProdctObj.RecordTypeId)
              .getDeveloperName();
            if (recordTypeDevName == 'Auto' && autoFlag == false) {
              autoFlag = true;
              auto_LoanCalculationProduct = loanCalProdctObj;
              loanCalculationProductIds.Put('Auto', loanCalProdctObj.Id);
              Auto_Request_ADJ_Exception_for_Credit = opportunityObj.Request_ADJ_Exception_for_Credit__c;
              Auto_Exception_Approved_by = opportunityObj.Exception_Approved_by__c;
              Auto_Date_of_Approval = String.valueOf(
                opportunityObj.Date_of_Approval__c
              );
            }
            if (recordTypeDevName == 'Credit_Card' && creditCardFlag == false) {
              creditCardFlag = true;
              CreditCard_LoanCalculationProduct = loanCalProdctObj;
              loanCalculationProductIds.Put('Credit_Card', loanCalProdctObj.Id);
              Credit_Card_Request_ADJ_Exception_for_Credit = opportunityObj.Request_ADJ_Exception_for_Credit__c;
              Credit_Card_Exception_Approved_by = opportunityObj.Exception_Approved_by__c;
              Credit_Card_Date_of_Approval = String.valueOf(
                opportunityObj.Date_of_Approval__c
              );
            }
            if (
              recordTypeDevName == 'Line_of_Credit' &&
              lineOfCreditFlag == false
            ) {
              lineOfCreditFlag = true;
              LineofCredit_LoanCalculationProduct = loanCalProdctObj;
              loanCalculationProductIds.Put(
                'Line_of_Credit',
                loanCalProdctObj.Id
              );
              Line_of_Credit_Request_ADJ_Exception_for_Credit = opportunityObj.Request_ADJ_Exception_for_Credit__c;
              Line_of_Credit_Exception_Approved_by = opportunityObj.Exception_Approved_by__c;
              Line_of_Credit_Date_of_Approval = String.valueOf(
                opportunityObj.Date_of_Approval__c
              );
            }
            if (recordTypeDevName == 'Unsecured' && unsecureFlag == false) {
              unsecureFlag = true;
              Unsecured_LoanCalculationProduct = loanCalProdctObj;
              loanCalculationProductIds.Put('Unsecured', loanCalProdctObj.Id);
              Unsecured_Loan_Request_ADJ_Exception_for_Credit = opportunityObj.Request_ADJ_Exception_for_Credit__c;
              Unsecured_Loan_Exception_Approved_by = opportunityObj.Exception_Approved_by__c;
              Unsecured_Loan_Date_of_Approval = String.valueOf(
                opportunityObj.Date_of_Approval__c
              );
            }
          }
        }
      }
    }
    //Get the list of Loan Calculation Product Fields for calculations
    Map<string, Decimal> loan_CalculationProductsFields = new Map<string, Decimal>();
    loan_CalculationProductsFields = getMapOfLoanCalcProductsFields();

    //Define the list of Account Ids
    list<Id> accountIds = new List<Id>();
    //Define map of Account Id and its related Employment records
    Map<Id, list<FinServ__Employment__c>> emplmntRecordsOfAccount;

    //Populate the list of Account Ids. Using these Account Ids the Employements records would be fetched.
    if (applicanList != null) {
      for (Applicant__c applicantObj : applicanList) {
        accountIds.add(applicantObj.Account__c);
      }
    }

    //Get a map of Account ID and list of its respective employement records
    if (accountIds != null) {
      emplmntRecordsOfAccount = get_MapOfAccountId_And_EmployementRecords(
        accountIds
      );
    }
    //Get a map of Applicant Id and Summation of AssretLiability fields
    map<Id, FinServ__AssetsAndLiabilities__c> mapOfApplIdVsSumOfAssetsLiability = new Map<Id, FinServ__AssetsAndLiabilities__c>();
    mapOfApplIdVsSumOfAssetsLiability = getApplicant_And_AssetsLiabilitySum();

    //Get a map of Applicant Id and Summation of Monthly OutFlow fields
    map<Id, map<string, decimal>> mapOfMontlyOutFlowFields = new Map<Id, map<string, decimal>>();
    mapOfMontlyOutFlowFields = getValuesForMonthlyOutflow();

    //Get a map of Applicant Id and Summation of Monthly Payment After fields
    map<Id, map<string, decimal>> mapOfApplID_MontlyPaymentAfterFields = new Map<Id, map<string, decimal>>();
    mapOfApplID_MontlyPaymentAfterFields = getMonthlyPymntAfter_ValuesForMonthlyOutflowAfterLoan();

    //Get a map of Applicant Id and Summation of Minimum Payment After fields
    map<Id, map<string, decimal>> mapOfApplID_MinimumPaymentAfterFields = new Map<Id, map<string, decimal>>();
    mapOfApplID_MinimumPaymentAfterFields = getMinimumPymntAfter_ValuesForMonthlyOutflowAfterLoan();

    //Get OVERALL RISK SCORE and OVERALL RISK RATING
    loan_Cal_App_Prdct = new Loan_Calculation_Applicant_Product__c();

    if (loanCalculationProductIds != null && applicanList != null) {
      getLoanCalculationApplicationProduct(applIds, loanCalculationProductIds);
    }

    //populate the applicantAndEmplWrapperList
    if (applicanList != null) {
      for (Applicant__c applicantObj : applicanList) {
        //Get a list of Employment Records of the Account
        list<FinServ__Employment__c> employList;
        employList = emplmntRecordsOfAccount.get(applicantObj.Account__c);

        //Convert the list of Employment Records into the list of Employment Wrapper Records
        list<EmploymentWrapper> emploWrapperList = new List<EmploymentWrapper>();

        for (FinServ__Employment__c empObj : employList) {
          EmploymentWrapper EmpWrapper = new EmploymentWrapper(empObj);
          emploWrapperList.add(EmpWrapper);
        }

        Decimal sumTotal_Market_Value = 0;
        Decimal sumAccount_Balance = 0;
        Decimal sumTotal_Contributions_to_Date = 0;
        Decimal sumTotal_AssetCreditBalance = 0;
        Decimal sumCashValue = 0;

        if (
          mapOfApplIdVsSumOfAssetsLiability.containsKey(applicantObj.Id) == true
        ) {
          FinServ__AssetsAndLiabilities__c assetLiabilityObj;
          assetLiabilityObj = mapOfApplIdVsSumOfAssetsLiability.get(
            applicantObj.Id
          );

          sumTotal_Market_Value = assetLiabilityObj.Total_Market_Value__c;
          sumAccount_Balance = assetLiabilityObj.Account_Balance__c;
          sumTotal_Contributions_to_Date = assetLiabilityObj.Total_Contributions_to_Date__c;
          sumTotal_AssetCreditBalance = assetLiabilityObj.Asset_Credit_Balance__c;
          sumCashValue = assetLiabilityObj.Cash_Value__c;
        }

        map<string, decimal> map_Of_Monthly_Out_Flow_Fields = new Map<string, decimal>();
        if (mapOfMontlyOutFlowFields.containsKey(applicantObj.Id) == true) {
          map_Of_Monthly_Out_Flow_Fields = mapOfMontlyOutFlowFields.get(
            applicantObj.Id
          );
        }

        map<string, decimal> map_Of_Monthly_Paymnt_After_Fields = new Map<string, decimal>();
        if (
          mapOfApplID_MontlyPaymentAfterFields.containsKey(applicantObj.Id) ==
          true
        ) {
          map_Of_Monthly_Paymnt_After_Fields = mapOfApplID_MontlyPaymentAfterFields.get(
            applicantObj.Id
          );
        }

        map<string, decimal> map_Of_Minimum_Paymnt_After_Fields = new Map<string, decimal>();
        if (
          mapOfApplID_MinimumPaymentAfterFields.containsKey(applicantObj.Id) ==
          true
        ) {
          map_Of_Minimum_Paymnt_After_Fields = mapOfApplID_MinimumPaymentAfterFields.get(
            applicantObj.Id
          );
        }

        ApplicantAndEmployementWrapper appEmpWrap = new ApplicantAndEmployementWrapper(
          applicantObj,
          emploWrapperList,
          sumTotal_Market_Value,
          sumAccount_Balance,
          sumTotal_Contributions_to_Date,
          sumTotal_AssetCreditBalance,
          sumCashValue,
          map_Of_Monthly_Out_Flow_Fields,
          loan_CalculationProductsFields,
          map_Of_Monthly_Paymnt_After_Fields,
          map_Of_Minimum_Paymnt_After_Fields
        );
        applicantAndEmplWrapperList.add(appEmpWrap);
      }
    }
  }
  /*
   *Name  :  getMapOfLoanCalcProductsFields
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of Loan Calculation Products records.
   */

  private Map<string, Decimal> getMapOfLoanCalcProductsFields() {
    Map<string, Decimal> loanCalculationProductsFields = new Map<string, Decimal>();
    if (loanCalculationProduct != null) {
      if (loanCalculationProduct.Total_Monthly_Loan_Payment_Number__c != null) {
        loanCalculationProductsFields.put(
          Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C,
          loanCalculationProduct.Total_Monthly_Loan_Payment_Number__c
        );
      } else {
        loanCalculationProductsFields.put(
          Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C,
          0
        );
      }
      if (
        loanCalculationProduct.Minimum_Payment_per_Credit_Limit_Number__c !=
        null
      ) {
        loanCalculationProductsFields.put(
          Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C,
          loanCalculationProduct.Minimum_Payment_per_Credit_Limit_Number__c
        );
      } else {
        loanCalculationProductsFields.put(
          Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C,
          0
        );
      }
      if (loanCalculationProduct.Market_Value_of_Vehicle_Number__c != null) {
        loanCalculationProductsFields.put(
          Constants.MARKETVALUEOFVEHICLENUMBER_C,
          loanCalculationProduct.Market_Value_of_Vehicle_Number__c
        );
      } else {
        loanCalculationProductsFields.put(
          Constants.MARKETVALUEOFVEHICLENUMBER_C,
          0
        );
      }
      if (loanCalculationProduct.Starting_Limit_Number__c != null) {
        loanCalculationProductsFields.put(
          Constants.STARTINGLIMITNUMBER_C,
          loanCalculationProduct.Starting_Limit_Number__c
        );
      } else {
        loanCalculationProductsFields.put(Constants.STARTINGLIMITNUMBER_C, 0);
      }
    }
    return loanCalculationProductsFields;
  }
  /*
   *Name  :  getOpportunityObj
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Returns the opportunity Object.
   */

  private Opportunity getOpportunityObj(Id oppId) {
    if (oppId != null) {
      Opportunity oppObj = new Opportunity();
      oppObj = [
        SELECT
          ID,
          Request_ADJ_Exception_for_Credit__c,
          Exception_Approved_by__c,
          Date_of_Approval__c,
          Product_Details__c
        FROM Opportunity
        WHERE Id = :oppId
      ];
      return oppObj;
    }
    return null;
  }
  /*
   *Name  :  getListOfLoanCalProdcts
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get list of Loan Calculation Products of the given Opportunity.
   */

  private list<Loan_Calculation_Product__c> getListOfLoanCalProdcts(
    Opportunity oppId
  ) {
    list<Loan_Calculation_Product__c> loanCalProduct = new List<Loan_Calculation_Product__c>();
    loanCalProduct = [
      SELECT
        Id,
        Loan_Purpose_List__c,
        Years_Number__c,
        Months_Number__c,
        Interest_Rate_Number__c,
        Market_Value_of_Vehicle_Number__c,
        Purchase_Price_of_Vehicle_Number__c,
        Vehicle_Classification_list__c,
        Make_and_Model_of_Motor_Vehicle_text__c,
        Repayment_Method_List__c,
        Applicable_Processing_Fee_Number__c,
        Loan_Amount_Number__c,
        JN_Life_Creditor_Life_Premium_Number__c,
        Processing_Fees_including_GCT_Number__c,
        JNGI_Motor_Premium_1st_Year_during_Numbe__c,
        Total_Loan_Amount_Number__c,
        Monthly_PI_Loan_Amount_Number__c,
        Monthly_P_I_Life_Insurance_Premium__c,
        Monthly_PI_Processing_Fee_Flag__c,
        Monthly_P_I_JNGI_Motor_Premium_Number__c,
        Monthly_JNGI_Motor_Premium_Number__c,
        Total_Monthly_PI_Loan_Payment_Number__c,
        Monthly_Compulsory_Savings_Number__c,
        Total_Monthly_Saving_Loan_Payment_Number__c,
        Total_Compulsory_Savings_Balance_Number__c,
        Total_Interest_Payment_Repayment_Number__c,
        Collateral_Type_List__c,
        Requested_Credit_Limit_Number__c,
        Starting_Limit_Number__c,
        Financial_Institution_List__c,
        Account_Holder_s_text__c,
        Annual_Interest_Rate_Deposit_Acct_Number__c,
        Deposit_Account_Balance_Number__c,
        Existing_Loan_Balance_Number__c,
        Account_Hypothecated_list__c,
        Loan_to_Value_Number__c,
        CurrencyIsoCode,
        Ability_to_Service_Before_Number__c,
        Ability_to_Service_After_Number__c,
        Total_Monthly_Loan_Payment_Number__c,
        Minimum_Payment_per_Credit_Limit_Number__c,
        RecordTypeId
      FROM Loan_Calculation_Product__c
      WHERE Loan_Calculation_Id__c = :oppId.Product_Details__c
    ];

    if (loanCalProduct != null) {
      if (loanCalProduct.size() > 0) {
        loanCalculationProduct = loanCalProduct.get(0);
        return loanCalProduct;
      }
    }
    return null;
  }

  /*
   *Name  :  getLoanCalculationApplicationProduct
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get list of Loan Calculation Application Products of the given Applicant.
   */

  private void getLoanCalculationApplicationProduct(
    list<id> applicant_Ids,
    map<string, id> loanCalcProdctIds
  ) {
    boolean autoFlag, creditCardFlag, lineOfCreditFlag, unsecureFlag;
    id autoId, creditCardId, lineOfCreditId, unsecuredId;
    autoFlag = false;
    creditCardFlag = false;
    lineOfCreditFlag = false;
    unsecureFlag = false;

    if (loanCalcProdctIds.get('Auto') != null) {
      autoId = loanCalcProdctIds.get('Auto');
    }
    if (loanCalcProdctIds.get('Credit_Card') != null) {
      creditCardId = loanCalcProdctIds.get('Credit_Card');
    }
    if (loanCalcProdctIds.get('Line_of_Credit') != null) {
      lineOfCreditId = loanCalcProdctIds.get('Line_of_Credit');
    }
    if (loanCalcProdctIds.get('Unsecured') != null) {
      unsecuredId = loanCalcProdctIds.get('Unsecured');
    }

    List<Loan_Calculation_Applicant_Product__c> loanCalcAppProductList = new List<Loan_Calculation_Applicant_Product__c>();

    loanCalcAppProductList = [
      SELECT
        Id,
        Credit_Score_Number__c,
        Credit_Risk_Rating_Text__c,
        Loan_Calculation_Product_Id__c
      FROM Loan_Calculation_Applicant_Product__c
      WHERE
        Loan_Calculation_Product_Id__c IN :loanCalcProdctIds.values()
        AND Applicant_Id__c IN :applicant_Ids
    ];

    if (loanCalcAppProductList != null) {
      for (
        Loan_Calculation_Applicant_Product__c record : loanCalcAppProductList
      ) {
        if (autoId != null) {
          if (
            record.Loan_Calculation_Product_Id__c == autoId &&
            autoFlag == false
          ) {
            auto_LoanCalculationApplProduct = record;
            autoFlag = true;
          }
        }

        if (creditCardId != null) {
          if (
            record.Loan_Calculation_Product_Id__c == creditCardId &&
            creditCardFlag == false
          ) {
            CreditCard_LoanCalculationApplProduct = record;
            creditCardFlag = true;
          }
        }

        if (lineOfCreditId != null) {
          if (
            record.Loan_Calculation_Product_Id__c == lineOfCreditId &&
            lineOfCreditFlag == false
          ) {
            LineofCredit_LoanCalculationApplProduct = record;
            lineOfCreditFlag = true;
          }
        }

        if (unsecuredId != null) {
          if (
            record.Loan_Calculation_Product_Id__c == unsecuredId &&
            unsecureFlag == false
          ) {
            Unsecured_LoanCalculationApplProduct = record;
            unsecureFlag = true;
          }
        }
      }
    }
  }

  /*
   *Name  :  getListOfApplicants
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get list of Applicants.
   */
  private list<Applicant__c> getListOfApplicants(Id oppId) {
    list<Applicant__c> applicantList = new List<Applicant__c>();
    applicantList = [
      SELECT
        Id,
        Account__c,
        Account__r.Name,
        Account__r.FinServ__Age__pc,
        Account__r.FinServ__Gender__pc,
        Account__r.Marital_Status__c,
        Account__r.Highest_Level_of_Education_attained__pc,
        Account__r.FinServ__NumberOfDependents__pc,
        Account__r.Status_of_Address__pc,
        Account__r.Years_at_Residence__pc,
        Account__r.Political_Exposure__pc,
        Account__r.PersonBirthdate,
        Statutory_Deductions_Numbers__c,
        Rent_Strata_Maintenance__c,
        Personal_Expenses_Monthly_Prior_Loan__c,
        Savings_Pension_Insurance_Number__c,
        Gross_Monthly_Income__c,
        Rent_Board_Monthly_Prior_Loan__c,
        Rent_Board_Monthly_After_Loan__c,
        Strata_Maintenance_Monthly_Prior_Loan__c,
        Strata_Maintenance_Monthly_After_Loan__c,
        Gross_Monthly_IncomeC__c,
        CRIF_Rating__c,
        CreditInfo_Rating__c,
        Overall_Credit_Bureau_Rating__c,
        Credit_History_in_last_24_Months__c,
        Assessment_of_Applicant_Net_Worth__c,
        Is_applicant_KYC_Compliant__c,
        Time_as_Member_Months__c,
        Rim_Number__c,
        Sanction_Screening_has_Negative_Trace__c,
        Affiliation_Type__c,
        JN_Group_Employee__c,
        //-----FINANCIAL & RISK ASSESSMENT------//
        //-----Assets Prior to Proposed Loan-----//
        Real_Estate_Market_Value_Number__c,
        Motor_Vehicle_Market_Value_Number__c,
        Other_Asset_Market_Value_Number__c,
        Life_Insurance_Cash_Value__c,
        Savings_Current_Account_s_Investment_VER__c,
        Savings_Deposit_Investments__c,
        Pension__c,
        Pension_IRS_Total_Contribution__c,
        //-----Market Value of Asset on Proposed Loan-----//
        Market_Value_Number__c,
        //-----Total Liabilities--------//
        Real_Estate_Loan_Balance_Number__c,
        Motor_Vehicle_Loan_Balance_Number__c,
        Other_Asset_Loan_Balance_Number__c,
        Other_Loan_Loan_Balance_Number__c,
        Average_Credit_Card_Balances_Number__c,
        Average_Line_of_Credit_Balance_Number__c,
        //-----Monthly Inflows--------//
        Total_Inflows__c,
        //-----Monthly Outflows--------//
        Total_Outflows__c,
        Property_Tax_Monthly_Prior_Loan__c,
        Property_Insurance_Monthly_Prior_Loan__c,
        Property_Maintenance_Monthly_Prior_loan__c,
        School_Costs_Monthly_Prior_Loan__c,
        Other_Personal_Family_Monthly_Prior_Loan__c,
        Water_Monthly_Prior_Loan__c,
        Internet_Cable_Monthly_Prior_Loan__c,
        House_Keeping_Monthly_Prior_Loan__c,
        Other_Utilities_Monthly_Prior_Loan__c,
        Petrol_Fuel_Monthly_Prior_Loan__c,
        Toll_Fees_Monthly_Prior_Loan__c,
        Motor_V_Insurance_Monthly_Prior_Loan__c,
        Motor_Vehicle_Reg_Monthly_Prior_Loan__c,
        Motor_Vehicle_Fitness_Monthly_Prior_Loan__c,
        Motor_V_Maintenance_Monthly_Before_Loan__c,
        Other_Transport_Costs_Monthly_Prior_Loan__c,
        Real_Estate_Monthly_Payment_Number__c,
        Motor_Vehicle_Monthly_Payment_Number__c,
        Other_Asset_Monthly_Payment_Number__c,
        Other_Loan_Monthly_Payment_Number__c,
        Cell_Phone_Landline_Monthly_After_Loan__c,
        Child_Care_Costs_Monthly_After_Loan__c,
        Cooking_Gas_Monthly_After_Loan__c,
        Electricity_Monthly_After_Loan__c,
        Fares_Monthly_After_Loan__c,
        Food_Costs_Monthly_After_Loan__c,
        Health_Costs_Monthly_After_Loan__c,
        House_Keeping_Costs_Monthly_After_Loan__c,
        Internet_Cable_Monthly_After_Loan__c,
        Motor_V_Insurance_Monthly_After_Loan__c,
        Motor_V_Maintenance_Monthly_After_Loan__c,
        Motor_Vehicle_Fitness_Monthly_After_Loan__c,
        Motor_Vehicle_Monthly_After_Loan__c,
        Motor_Vehicle_Reg_Monthly_After_Loan__c,
        Other_Personal_Family_Costs_Prior_After__c,
        Other_Transport_Monthly_After_Loan__c,
        Other_Utilities_Monthly_After_Loan__c,
        Personal_Expenses_Monthly_After_Loan__c,
        Petrol_Fuel_Monthly_After_Loan__c,
        Property_Insurance_Monthly_After_Loan__c,
        Property_Maintenance_Monthly_After_Loan__c,
        Property_Tax_Monthly_After_Loan__c,
        Rent_Board_Strata_After_TDSR__c,
        School_Costs_Monthly_After_Loan__c,
        Toll_Fees_Monthly_After_Loan__c,
        Water_Monthly_After_Loan__c,
        //-----Existing Monthly Instalment Payments--------//
        Cell_Phone_Landline_Monthly_Prior_Loan__c,
        Child_Care_Costs_Monthly_Prior_Loan__c,
        Cooking_Gas_Monthly_Prior_Loan__c,
        Education_Tax_Monthly_Prior_Loan__c,
        Electricity_Monthly_Prior_Loan__c,
        Fares_Monthly_Prior_Loan__c,
        Food_Cost_Monthly_Prior_Loan__c,
        Health_Costs_Monthly_Prior_Loan__c,
        CurrencyIsoCode,
        Name
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];

    if (applicantList != null) {
      if (applicantList.size() > 0) {
        for (Applicant__c applObj : applicantList) {
          applicantIds.add(applObj.Id);
        }
        return applicantList;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  /*
   *Name  :  get_MapOfAccountId_And_EmployementRecords
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of Account Id and its Employment records.
   */

  private Map<Id, list<FinServ__Employment__c>> get_MapOfAccountId_And_EmployementRecords(
    list<Id> account_Ids
  ) {
    Map<Id, list<FinServ__Employment__c>> employmentRecordsOfAccount = new Map<ID, list<FinServ__Employment__c>>();

    for (Account act : [
      SELECT
        Id,
        (
          SELECT
            Industry__c,
            Professional_Category__c,
            Nature_of_Engagement__c,
            Assessment_of_Business_Working_Capita__c,
            Length_of_Trade__c,
            Assessment_of_Business__c,
            Assessment_of_Statement__c,
            FinServ__EmploymentStatus__c,
            FinServ__LengthOfEmployment__c,
            RecordTypeId
          FROM Employment__r
        )
      FROM Account
      WHERE Id IN :account_Ids
    ]) {
      employmentRecordsOfAccount.put(act.Id, act.Employment__r);
    }
    return employmentRecordsOfAccount;
  }

  /*
   *Name  :  getMonthlyPymntAfter_ValuesForMonthlyOutflowAfterLoan
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of values to calculate Monthly Out flow After Loan
   */
  private map<Id, map<string, decimal>> getMonthlyPymntAfter_ValuesForMonthlyOutflowAfterLoan() {
    list<Application_Asset_Liability__c> applAssetLiabList = new List<Application_Asset_Liability__c>();

    map<Id, map<string, decimal>> map_Of_ApplicantId_and_MonthlyPayAfter = new Map<Id, map<string, decimal>>();

    if (applicantIds == null) {
      return null;
    }
    applAssetLiabList = [
      SELECT Monthly_Payment_After__c, Application__c
      FROM Application_Asset_Liability__c
      WHERE
        Application__c IN :applicantIds
        AND Treatment_of_Credit__c = :Constants.WILL_REMAIN_STRING
    ];

    if (applAssetLiabList != null) {
      if (applAssetLiabList.size() > 0) {
        for (
          Application_Asset_Liability__c appAssetLiab_Record : applAssetLiabList
        ) {
          if (
            map_Of_ApplicantId_and_MonthlyPayAfter.containsKey(
              appAssetLiab_Record.Application__c
            ) == true
          ) {
            decimal MonthlyPaymentAfter = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();
            mapOfFields = map_Of_ApplicantId_and_MonthlyPayAfter.get(
              appAssetLiab_Record.Application__c
            );

            MonthlyPaymentAfter = mapOfFields.get(
              Constants.MONTHLY_PAYMENT_AFTER_C
            );
            if (appAssetLiab_Record.Monthly_Payment_After__c != null) {
              MonthlyPaymentAfter =
                MonthlyPaymentAfter +
                appAssetLiab_Record.Monthly_Payment_After__c;
            }
            mapOfFields.put(
              Constants.MONTHLY_PAYMENT_AFTER_C,
              MonthlyPaymentAfter
            );
            map_Of_ApplicantId_and_MonthlyPayAfter.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          } else {
            decimal MonthlyPaymentAfter = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();
            if (appAssetLiab_Record.Monthly_Payment_After__c != null) {
              MonthlyPaymentAfter =
                MonthlyPaymentAfter +
                appAssetLiab_Record.Monthly_Payment_After__c;
            }
            mapOfFields.put(
              Constants.MONTHLY_PAYMENT_AFTER_C,
              MonthlyPaymentAfter
            );
            map_Of_ApplicantId_and_MonthlyPayAfter.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          }
        }
      }
    }
    return map_Of_ApplicantId_and_MonthlyPayAfter;
  }

  /*
   *Name  :  getMinimumPymntAfter_ValuesForMonthlyOutflowAfterLoan
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of values to calculate Monthly Out flow After Loan
   */

  private map<Id, map<string, decimal>> getMinimumPymntAfter_ValuesForMonthlyOutflowAfterLoan() {
    list<Application_Asset_Liability__c> applAssetLiabList = new List<Application_Asset_Liability__c>();

    list<String> conditionStrings = new List<String>();
    conditionStrings.add(Constants.WILL_REMAIN_STRING);
    conditionStrings.add(Constants.REPAY_FACILITY_STRING);

    map<Id, map<string, decimal>> map_Of_ApplicantId_and_MinPayAfter = new Map<Id, map<string, decimal>>();

    if (applicantIds == null) {
      return null;
    }
    applAssetLiabList = [
      SELECT Minimum_Payment_After__c, Application__c
      FROM Application_Asset_Liability__c
      WHERE
        Application__c IN :applicantIds
        AND Treatment_of_Credit_LOC_list__c IN :conditionStrings
    ];

    if (applAssetLiabList != null) {
      if (applAssetLiabList.size() > 0) {
        for (
          Application_Asset_Liability__c appAssetLiab_Record : applAssetLiabList
        ) {
          if (
            map_Of_ApplicantId_and_MinPayAfter.containsKey(
              appAssetLiab_Record.Application__c
            ) == true
          ) {
            decimal minimumPaymentAfter = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();
            mapOfFields = map_Of_ApplicantId_and_MinPayAfter.get(
              appAssetLiab_Record.Application__c
            );

            minimumPaymentAfter = mapOfFields.get(
              Constants.MINIMUM_PAYMENT_AFTER_C
            );
            if (appAssetLiab_Record.Minimum_Payment_After__c != null) {
              minimumPaymentAfter =
                minimumPaymentAfter +
                appAssetLiab_Record.Minimum_Payment_After__c;
            }
            mapOfFields.put(
              Constants.MINIMUM_PAYMENT_AFTER_C,
              minimumPaymentAfter
            );
            map_Of_ApplicantId_and_MinPayAfter.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          } else {
            decimal minimumPaymentAfter = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();
            if (appAssetLiab_Record.Minimum_Payment_After__c != null) {
              minimumPaymentAfter =
                minimumPaymentAfter +
                appAssetLiab_Record.Minimum_Payment_After__c;
            }
            mapOfFields.put(
              Constants.MINIMUM_PAYMENT_AFTER_C,
              minimumPaymentAfter
            );
            map_Of_ApplicantId_and_MinPayAfter.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          }
        }
      }
    }
    return map_Of_ApplicantId_and_MinPayAfter;
  }

  /*
   *Name  :  getValuesForMonthlyOutflow
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of values to calculate Monthly Out flow
   */

  private map<Id, map<string, decimal>> getValuesForMonthlyOutflow() {
    list<Application_Asset_Liability__c> applAssetLiabList = new List<Application_Asset_Liability__c>();

    map<Id, map<string, decimal>> mapOf_ApplicantId_and_AppAssetsLiabObj = new Map<Id, map<string, decimal>>();

    if (applicantIds == null) {
      return null;
    }
    applAssetLiabList = [
      SELECT
        Overdraft_Limit_Number__c,
        Loan_Balance_Prior__c,
        Monthly_Payment_Prior_Calc_App_Portion__c,
        Minimum_Payment_Calc__c,
        Application__c
      FROM Application_Asset_Liability__c
      WHERE Application__c IN :applicantIds
    ];

    if (applAssetLiabList != null) {
      if (applAssetLiabList.size() > 0) {
        for (
          Application_Asset_Liability__c appAssetLiab_Record : applAssetLiabList
        ) {
          if (
            mapOf_ApplicantId_and_AppAssetsLiabObj.containsKey(
              appAssetLiab_Record.Application__c
            ) == true
          ) {
            decimal overdraft_Limit_Number = 0;
            decimal loan_Balance_Prior = 0;
            decimal monthly_Payment_Prior_Calc_App_Portion = 0;
            decimal minimum_Payment_Calc = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();
            mapOfFields = mapOf_ApplicantId_and_AppAssetsLiabObj.get(
              appAssetLiab_Record.Application__c
            );

            overdraft_Limit_Number = mapOfFields.get(
              Constants.OVERDRAFTLIMITNUMBER_C
            );
            if (appAssetLiab_Record.Overdraft_Limit_Number__c != null) {
              overdraft_Limit_Number =
                overdraft_Limit_Number +
                appAssetLiab_Record.Overdraft_Limit_Number__c;
            }
            mapOfFields.put(
              Constants.OVERDRAFTLIMITNUMBER_C,
              overdraft_Limit_Number
            );

            loan_Balance_Prior = mapOfFields.get(Constants.LOANBALANCEPRIOR_C);
            if (appAssetLiab_Record.Loan_Balance_Prior__c != null) {
              loan_Balance_Prior =
                loan_Balance_Prior + appAssetLiab_Record.Loan_Balance_Prior__c;
            }
            mapOfFields.put(Constants.LOANBALANCEPRIOR_C, loan_Balance_Prior);

            monthly_Payment_Prior_Calc_App_Portion = mapOfFields.get(
              Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C
            );

            if (
              appAssetLiab_Record.Monthly_Payment_Prior_Calc_App_Portion__c !=
              null
            ) {
              monthly_Payment_Prior_Calc_App_Portion =
                monthly_Payment_Prior_Calc_App_Portion +
                appAssetLiab_Record.Monthly_Payment_Prior_Calc_App_Portion__c;
            }
            mapOfFields.put(
              Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C,
              monthly_Payment_Prior_Calc_App_Portion
            );

            minimum_Payment_Calc = mapOfFields.get(
              Constants.MINIMUM_PAYMNT_CALC_C
            );
            if (appAssetLiab_Record.Minimum_Payment_Calc__c != null) {
              minimum_Payment_Calc =
                minimum_Payment_Calc +
                appAssetLiab_Record.Minimum_Payment_Calc__c;
            }
            mapOfFields.put(
              Constants.MINIMUM_PAYMNT_CALC_C,
              minimum_Payment_Calc
            );
            mapOf_ApplicantId_and_AppAssetsLiabObj.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          } else {
            decimal overdraft_Limit_Number = 0;
            decimal loan_Balance_Prior = 0;
            decimal monthly_Payment_Prior_Calc_App_Portion = 0;
            decimal minimum_Payment_Calc = 0;
            map<string, decimal> mapOfFields = new Map<string, decimal>();

            if (appAssetLiab_Record.Overdraft_Limit_Number__c != null) {
              overdraft_Limit_Number =
                overdraft_Limit_Number +
                appAssetLiab_Record.Overdraft_Limit_Number__c;
            }
            mapOfFields.put(
              Constants.OVERDRAFTLIMITNUMBER_C,
              overdraft_Limit_Number
            );

            if (appAssetLiab_Record.Loan_Balance_Prior__c != null) {
              loan_Balance_Prior =
                loan_Balance_Prior + appAssetLiab_Record.Loan_Balance_Prior__c;
            }
            mapOfFields.put(Constants.LOANBALANCEPRIOR_C, loan_Balance_Prior);

            if (
              appAssetLiab_Record.Monthly_Payment_Prior_Calc_App_Portion__c !=
              null
            ) {
              monthly_Payment_Prior_Calc_App_Portion =
                monthly_Payment_Prior_Calc_App_Portion +
                appAssetLiab_Record.Monthly_Payment_Prior_Calc_App_Portion__c;
            }
            mapOfFields.put(
              Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C,
              monthly_Payment_Prior_Calc_App_Portion
            );

            if (appAssetLiab_Record.Minimum_Payment_Calc__c != null) {
              minimum_Payment_Calc =
                minimum_Payment_Calc +
                appAssetLiab_Record.Minimum_Payment_Calc__c;
            }
            mapOfFields.put(
              Constants.MINIMUM_PAYMNT_CALC_C,
              minimum_Payment_Calc
            );
            mapOf_ApplicantId_and_AppAssetsLiabObj.put(
              appAssetLiab_Record.Application__c,
              mapOfFields
            );
          }
        }
      }
    }
    return mapOf_ApplicantId_and_AppAssetsLiabObj;
  }

  /*
   *Name  :  getApplicant_And_AssetsLiabilitySum
   *Author:  Thinqloud Solutions
   *Date  :  Mar 03, 2021
   *Purpose : Get the map of Assets of the applicant
   */
  private map<Id, FinServ__AssetsAndLiabilities__c> getApplicant_And_AssetsLiabilitySum() {
    list<Application_Asset_Liability__c> applAssetLiabList = new List<Application_Asset_Liability__c>();
    map<Id, FinServ__AssetsAndLiabilities__c> mapOf_ApplicantId_and_AssetsLiabObj = new Map<Id, FinServ__AssetsAndLiabilities__c>();
    applAssetLiabList = [
      SELECT
        Id,
        Application__c,
        Assets_and_Liabilities__c,
        Assets_and_Liabilities__r.Total_Market_Value__c,
        Assets_and_Liabilities__r.Total_Contributions_to_Date__c,
        Assets_and_Liabilities__r.Account_Balance__c,
        Assets_and_Liabilities__r.Asset_Credit_Balance__c,
        Assets_and_Liabilities__r.Cash_Value__c
      FROM Application_Asset_Liability__c
      WHERE Application__c IN :applicantIds
    ];

    if (applAssetLiabList != null) {
      if (applAssetLiabList.size() > 0) {
        for (
          Application_Asset_Liability__c appAssetLiab_Record : applAssetLiabList
        ) {
          if (
            mapOf_ApplicantId_and_AssetsLiabObj.containsKey(
              appAssetLiab_Record.Application__c
            ) == true
          ) {
            decimal mrktValue = 0;
            decimal account_Balance = 0;
            decimal total_Contributions_to_Date = 0;
            decimal total_Asset_Credit_Balance = 0;
            decimal cashValue = 0;
            FinServ__AssetsAndLiabilities__c assetLiabilityObj = new FinServ__AssetsAndLiabilities__c();

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Total_Market_Value__c !=
              null
            ) {
              mrktValue =
                mrktValue +
                appAssetLiab_Record.Assets_and_Liabilities__r.Total_Market_Value__c;
            }
            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Account_Balance__c !=
              null
            ) {
              account_Balance =
                account_Balance +
                appAssetLiab_Record.Assets_and_Liabilities__r.Account_Balance__c;
            }
            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c !=
              null
            ) {
              total_Contributions_to_Date =
                total_Contributions_to_Date +
                appAssetLiab_Record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c;
            }
            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Asset_Credit_Balance__c !=
              null
            ) {
              total_Asset_Credit_Balance =
                total_Asset_Credit_Balance +
                appAssetLiab_Record.Assets_and_Liabilities__r.Asset_Credit_Balance__c;
            }
            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Cash_Value__c !=
              null
            ) {
              cashValue =
                cashValue +
                appAssetLiab_Record.Assets_and_Liabilities__r.Cash_Value__c;
            }
            assetLiabilityObj = mapOf_ApplicantId_and_AssetsLiabObj.get(
              appAssetLiab_Record.Application__c
            );
            assetLiabilityObj.Total_Market_Value__c =
              assetLiabilityObj.Total_Market_Value__c + mrktValue;
            assetLiabilityObj.Account_Balance__c =
              assetLiabilityObj.Account_Balance__c + account_Balance;
            assetLiabilityObj.Total_Contributions_to_Date__c =
              assetLiabilityObj.Total_Contributions_to_Date__c +
              total_Contributions_to_Date;
            assetLiabilityObj.Asset_Credit_Balance__c =
              assetLiabilityObj.Asset_Credit_Balance__c +
              total_Asset_Credit_Balance;
            assetLiabilityObj.Cash_Value__c =
              assetLiabilityObj.Cash_Value__c + cashValue;
            mapOf_ApplicantId_and_AssetsLiabObj.put(
              appAssetLiab_Record.Application__c,
              assetLiabilityObj
            );
          } else {
            decimal mrktValue = 0;
            decimal account_Balance = 0;
            decimal total_Contributions_to_Date = 0;
            decimal total_Asset_Credit_Balance = 0;
            decimal cashValue = 0;
            FinServ__AssetsAndLiabilities__c assetLiabilityObj = new FinServ__AssetsAndLiabilities__c();

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Total_Market_Value__c !=
              null
            ) {
              mrktValue =
                mrktValue +
                appAssetLiab_Record.Assets_and_Liabilities__r.Total_Market_Value__c;
            }

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Account_Balance__c !=
              null
            ) {
              account_Balance =
                account_Balance +
                appAssetLiab_Record.Assets_and_Liabilities__r.Account_Balance__c;
            }

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c !=
              null
            ) {
              total_Contributions_to_Date =
                total_Contributions_to_Date +
                appAssetLiab_Record.Assets_and_Liabilities__r.Total_Contributions_to_Date__c;
            }

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Asset_Credit_Balance__c !=
              null
            ) {
              total_Asset_Credit_Balance =
                total_Asset_Credit_Balance +
                appAssetLiab_Record.Assets_and_Liabilities__r.Asset_Credit_Balance__c;
            }

            if (
              appAssetLiab_Record.Assets_and_Liabilities__r.Cash_Value__c !=
              null
            ) {
              cashValue =
                cashValue +
                appAssetLiab_Record.Assets_and_Liabilities__r.Cash_Value__c;
            }

            assetLiabilityObj.Total_Market_Value__c = mrktValue;
            assetLiabilityObj.Account_Balance__c = account_Balance;
            assetLiabilityObj.Total_Contributions_to_Date__c = total_Contributions_to_Date;
            assetLiabilityObj.Asset_Credit_Balance__c = total_Asset_Credit_Balance;
            assetLiabilityObj.Cash_Value__c = cashValue;
            mapOf_ApplicantId_and_AssetsLiabObj.put(
              appAssetLiab_Record.Application__c,
              assetLiabilityObj
            );
          }
        }
      }
    }
    return mapOf_ApplicantId_and_AssetsLiabObj;
  }
}
