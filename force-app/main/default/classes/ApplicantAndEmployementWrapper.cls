/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-19-2021   Remario Richards   Initial Version
 **/
public with sharing class ApplicantAndEmployementWrapper {
  public String type_of_Industry { get; set; }
  public String professional_Category { get; set; }
  public String nature_of_Engagement { get; set; }
  public String assment_of_Business_Working_Capital { get; set; }
  public String length_of_Trade { get; set; }
  public String assment_of_Business_Financial_Performance { get; set; }
  public String assment_of_Business_Financial_Statement_Support { get; set; }

  public String applicantName { get; set; }
  public Integer ageOfApplicant { get; set; }
  public String genderOfApplicant { get; set; }
  public String maritalStatusOfApplicant { get; set; }
  public String highestEducationOfApplicant { get; set; }
  public Double numberOfDependent { get; set; }
  public String statusOfAddress { get; set; }
  public Double timeLivingAtAddress { get; set; }

  public String crif_Rating { get; set; }
  public String creditInfo_Rating { get; set; }
  public String overAllCreditBureau { get; set; }

  public String creditHistoryin24mnths { get; set; }
  public String assessmentofApplicantNetWorth { get; set; }

  public String is_KYC { get; set; }
  public Decimal timeAsMember { get; set; }
  public String RIM_Number { get; set; }
  public String hasNegativeScreening { get; set; }
  public String affiliationType { get; set; }
  public Boolean pep { get; set; }
  public String pepString { get; set; }
  public String jnGroup { get; set; }

  public ApplicantWrapper appWrp;

  public Decimal totalAssetsPriorLoan { get; set; }
  public Decimal totalAssetsAfterLoan { get; set; }
  public Decimal totalLiabilitiesPriorLoan { get; set; }
  public Decimal totalLiabilitiesAfterLoan { get; set; }
  public Decimal netWorthPriorLoan { get; set; }
  public Decimal netWorthAfterLoan { get; set; }

  public Decimal monthlyInflowsPriorLoan { get; set; }
  public Decimal monthlyInflowsAfterLoan { get; set; }
  public Decimal monthlyOutflowsPriorLoan { get; set; }
  public Decimal monthlyOutflowsAfterLoan { get; set; }
  public Decimal residualIncomePriorLoan { get; set; }
  public Decimal residualIncomeAfterLoan { get; set; }

  public Decimal realEstateMktValue { get; set; }
  public string currencyCode { get; set; }

  public Decimal grossMonthlyIncomePriorLoan { get; set; }
  public Decimal grossMonthlyIncomeAfterLoan { get; set; }

  public Decimal existingMonthlyPaymntsPriorLoan { get; set; }
  public Decimal existingMonthlyPaymntsAfterLoan { get; set; }

  public Decimal sum_Total_Market_Value { get; set; }
  public Decimal sum_Account_Balance { get; set; }
  public Decimal sum_Total_Contributions_to_Date { get; set; }
  public Decimal sum_Asset_Credit_Balance { get; set; }
  public Decimal sum_Cash_Value_Asset { get; set; }

  public ApplicantAndEmployementWrapper(
    Applicant__c record,
    list<EmploymentWrapper> emploWrapperList,
    Decimal sumTotalMarketValue,
    Decimal sumAccountBalance,
    Decimal sumTotalContributionstoDate,
    Decimal sumTotalAssetCreditBalance,
    Decimal sum_Cash_Value,
    map<string, decimal> mapOfMonthlyOutFlow_Fields,
    Map<string, Decimal> loan_Calcul_Products_Fields,
    map<string, decimal> mapOfMonthlyPaymntAfterFields,
    map<string, decimal> mapOfMinimumPaymntAfterFields
  ) {
    sum_Total_Market_Value = sumTotalMarketValue;
    sum_Account_Balance = sumAccountBalance;
    sum_Total_Contributions_to_Date = sumTotalContributionstoDate;
    sum_Asset_Credit_Balance = sumTotalAssetCreditBalance;
    sum_Cash_Value_Asset = sum_Cash_Value;

    appWrp = new ApplicantWrapper(record);
    applicantName = record.Account__r.Name;
    currencyCode = record.CurrencyIsoCode;
    genderOfApplicant = record.Account__r.FinServ__Gender__pc;
    ageOfApplicant = appWrp.age;
    maritalStatusOfApplicant = record.Account__r.Marital_Status__c;
    highestEducationOfApplicant = record.Account__r.Highest_Level_of_Education_attained__pc;
    numberOfDependent = record.Account__r.FinServ__NumberOfDependents__pc;
    statusOfAddress = record.Account__r.Status_of_Address__pc;
    timeLivingAtAddress = record.Account__r.Years_at_Residence__pc;
    crif_Rating = record.CRIF_Rating__c;
    creditInfo_Rating = record.CreditInfo_Rating__c;
    overAllCreditBureau = record.Overall_Credit_Bureau_Rating__c;

    creditHistoryin24mnths = record.Credit_History_in_last_24_Months__c;
    assessmentofApplicantNetWorth = record.Assessment_of_Applicant_Net_Worth__c;

    is_KYC = record.Is_applicant_KYC_Compliant__c;
    timeAsMember = record.Time_as_Member_Months__c;
    RIM_Number = record.Rim_Number__c;
    hasNegativeScreening = record.Sanction_Screening_has_Negative_Trace__c;
    affiliationType = record.Affiliation_Type__c;

    pep = record.Account__r.Political_Exposure__pc;
    if (pep) {
      pepString = Constants.YESSTRING;
    } else {
      pepString = Constants.NOSTRING;
    }

    grossMonthlyIncomePriorLoan = 0;
    
    if (record.Gross_Monthly_IncomeC__c != null) {
      grossMonthlyIncomePriorLoan = record.Gross_Monthly_IncomeC__c;
    }

    grossMonthlyIncomeAfterLoan = 0;
    if (record.Gross_Monthly_IncomeC__c != null) {
      grossMonthlyIncomeAfterLoan = record.Gross_Monthly_IncomeC__c;

    }

    monthlyInflowsPriorLoan = 0;
    if (record.Total_Inflows__c != null) {
      monthlyInflowsPriorLoan = record.Total_Inflows__c;
    }
    monthlyInflowsAfterLoan = 0;
    if (record.Total_Inflows__c != null) {
      monthlyInflowsAfterLoan = record.Total_Inflows__c;
    }
    getMonthlyOutFlowsPriorLoan(record, mapOfMonthlyOutFlow_Fields);
    getMonthlyOutFlowsAfterLoan(
      record,
      loan_Calcul_Products_Fields,
      mapOfMonthlyPaymntAfterFields,
      mapOfMinimumPaymntAfterFields
    );

    residualIncomePriorLoan =
      monthlyInflowsPriorLoan - monthlyOutflowsPriorLoan;
    residualIncomeAfterLoan =
      monthlyInflowsAfterLoan - monthlyOutflowsAfterLoan;

    getTotalAssetsPriorToLoan(record);
    getTotalAssetsAfterLoan(record, loan_Calcul_Products_Fields);

    getTotalLiabilitiesPriorToLoan(record, mapOfMonthlyOutFlow_Fields);
    getTotalLiabilitiesAfterLoan(record, loan_Calcul_Products_Fields);

    getExistingMonthlyInstallmentPriorLoan(record, mapOfMonthlyOutFlow_Fields);
    getExistingMonthlyInstallmentAfterLoan(
      record,
      mapOfMonthlyOutFlow_Fields,
      loan_Calcul_Products_Fields,
      mapOfMonthlyPaymntAfterFields,
      mapOfMinimumPaymntAfterFields
    );

    netWorthPriorLoan = totalAssetsPriorLoan - totalLiabilitiesPriorLoan;
    netWorthAfterLoan = totalAssetsAfterLoan - totalLiabilitiesAfterLoan;
    jnGroup = record.JN_Group_Employee__c;
    Assign_Value_To_Employement_Fields(emploWrapperList);
  }

  public void Assign_Value_To_Employement_Fields(
    list<EmploymentWrapper> empWrpList
  ) {
    type_of_Industry = '';
    professional_Category = '';
    nature_of_Engagement = '';
    assment_of_Business_Working_Capital = '';
    length_of_Trade = '';
    assment_of_Business_Financial_Performance = '';
    assment_of_Business_Financial_Statement_Support = '';

    if (empWrpList != null) {
      if (empWrpList.size() > 0) {
        type_of_Industry = empWrpList.get(0).industry;
        professional_Category = empWrpList.get(0).professionalCategory;
        nature_of_Engagement = empWrpList.get(0).natureOfEngagement;
        assment_of_Business_Working_Capital = empWrpList.get(0)
          .assessmentOfBusinessWorkingCapita;
        length_of_Trade = empWrpList.get(0).lengthOfTrade;
        assment_of_Business_Financial_Performance = empWrpList.get(0)
          .assessmentOfBusiness;
        assment_of_Business_Financial_Statement_Support = empWrpList.get(0)
          .assessmentOfStatement;
      }
    }
  }

  public void getTotalAssetsPriorToLoan(Applicant__c record) {
    Decimal real_Estate_MktValue;
    Decimal motor_Vehicle_MktValue;
    Decimal other_Asset_MktValue;
    Decimal life_Insurance_Cash_Value;
    Decimal savings_Deposit_Investments;
    Decimal pension;
    totalAssetsPriorLoan = 0.0;

    if (record.Real_Estate_Market_Value_Number__c != null) {
      real_Estate_MktValue = record.Real_Estate_Market_Value_Number__c;
    } else {
      real_Estate_MktValue = 0;
    }
    if (record.Motor_Vehicle_Market_Value_Number__c != null) {
      motor_Vehicle_MktValue = record.Motor_Vehicle_Market_Value_Number__c;
    } else {
      motor_Vehicle_MktValue = 0;
    }
    if (record.Other_Asset_Market_Value_Number__c != null) {
      other_Asset_MktValue = record.Other_Asset_Market_Value_Number__c;
    } else {
      other_Asset_MktValue = 0;
    }
    if (record.Life_Insurance_Cash_Value__c != null) {
      life_Insurance_Cash_Value = record.Life_Insurance_Cash_Value__c;
    } else {
      life_Insurance_Cash_Value = 0;
    }
    if (record.Savings_Deposit_Investments__c != null) {
      savings_Deposit_Investments = record.Savings_Deposit_Investments__c;
    } else {
      savings_Deposit_Investments = 0;
    }
    if (record.Pension_IRS_Total_Contribution__c != null) {
      pension = record.Pension_IRS_Total_Contribution__c;
    } else {
      pension = 0;
    }
    totalAssetsPriorLoan =
      sum_Total_Market_Value +
      sum_Account_Balance +
      sum_Total_Contributions_to_Date +
      motor_Vehicle_MktValue +
      other_Asset_MktValue +
      real_Estate_MktValue +
      life_Insurance_Cash_Value +
      savings_Deposit_Investments +
      pension;
  }

  public void getTotalAssetsAfterLoan(
    Applicant__c record,
    Map<string, Decimal> loan_Calc_Prdcts_Fields
  ) {
    totalAssetsAfterLoan = totalAssetsPriorLoan + sum_Cash_Value_Asset;

    if (loan_Calc_Prdcts_Fields != null) {
      if (
        loan_Calc_Prdcts_Fields.get(Constants.MARKETVALUEOFVEHICLENUMBER_C) !=
        null
      ) {
        totalAssetsAfterLoan =
          totalAssetsAfterLoan +
          loan_Calc_Prdcts_Fields.get(Constants.MARKETVALUEOFVEHICLENUMBER_C);
      }
    }
  }

  public void getTotalLiabilitiesPriorToLoan(
    Applicant__c record,
    map<string, decimal> mapOf_MonthlyOutFlow_Fields
  ) {
    Decimal real_Estate_loan;
    Decimal motor_Vehicle_loan;
    Decimal other_Asset_loan;
    Decimal other_loan;
    Decimal credit_Card_loan;
    Decimal lineofCredit_loan;
    Decimal loan_Balance_Prior = 0;
    Decimal overdraft_LimitNumber = 0;

    totalLiabilitiesPriorLoan = 0.0;

    if (mapOf_MonthlyOutFlow_Fields.get(Constants.LOANBALANCEPRIOR_C) != null) {
      loan_Balance_Prior =
        0 + mapOf_MonthlyOutFlow_Fields.get(Constants.LOANBALANCEPRIOR_C);
    }

    if (
      mapOf_MonthlyOutFlow_Fields.get(Constants.OVERDRAFTLIMITNUMBER_C) != null
    ) {
      overdraft_LimitNumber =
        0 + mapOf_MonthlyOutFlow_Fields.get(Constants.OVERDRAFTLIMITNUMBER_C);
    }

    if (record.Real_Estate_Loan_Balance_Number__c != null) {
      real_Estate_loan = record.Real_Estate_Loan_Balance_Number__c;
    } else {
      real_Estate_loan = 0;
    }

    if (record.Motor_Vehicle_Loan_Balance_Number__c != null) {
      motor_Vehicle_loan = record.Motor_Vehicle_Loan_Balance_Number__c;
    } else {
      motor_Vehicle_loan = 0;
    }

    if (record.Other_Asset_Loan_Balance_Number__c != null) {
      other_Asset_loan = record.Other_Asset_Loan_Balance_Number__c;
    } else {
      other_Asset_loan = 0;
    }

    if (record.Other_Loan_Loan_Balance_Number__c != null) {
      other_loan = record.Other_Loan_Loan_Balance_Number__c;
    } else {
      other_loan = 0;
    }

    if (record.Average_Credit_Card_Balances_Number__c != null) {
      credit_Card_loan = record.Average_Credit_Card_Balances_Number__c;
    } else {
      credit_Card_loan = 0;
    }

    if (record.Average_Line_of_Credit_Balance_Number__c != null) {
      lineofCredit_loan = record.Average_Line_of_Credit_Balance_Number__c;
    } else {
      lineofCredit_loan = 0;
    }

    totalLiabilitiesPriorLoan =
      sum_Asset_Credit_Balance +
      real_Estate_loan +
      motor_Vehicle_loan +
      other_Asset_loan +
      other_loan +
      credit_Card_loan +
      lineofCredit_loan +
      loan_Balance_Prior +
      overdraft_LimitNumber;
  }

  public void getTotalLiabilitiesAfterLoan(
    Applicant__c record,
    Map<string, Decimal> loan_Calc_Prdcts_Fields
  ) {
    totalLiabilitiesAfterLoan = 0.0;
    totalLiabilitiesAfterLoan = totalLiabilitiesPriorLoan;

    if (loan_Calc_Prdcts_Fields != null) {
      if (
        loan_Calc_Prdcts_Fields.get(Constants.STARTINGLIMITNUMBER_c) != null
      ) {
        totalLiabilitiesAfterLoan =
          totalLiabilitiesAfterLoan +
          loan_Calc_Prdcts_Fields.get(Constants.STARTINGLIMITNUMBER_c);
      }
    }
  }

  public void getExistingMonthlyInstallmentPriorLoan(
    Applicant__c record,
    map<string, decimal> mapOf_MonthlyOutFlow_Fields
  ) {
    decimal mnlyPymntPriorCalcApp = 0;
    decimal minimumPymntCalc = 0;
    existingMonthlyPaymntsPriorLoan = 0;

    if (
      mapOf_MonthlyOutFlow_Fields.get(
        Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C
      ) != null
    ) {
      mnlyPymntPriorCalcApp = mapOf_MonthlyOutFlow_Fields.get(
        Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C
      );
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan + mnlyPymntPriorCalcApp;
    }

    if (
      mapOf_MonthlyOutFlow_Fields.get(Constants.MINIMUM_PAYMNT_CALC_C) != null
    ) {
      minimumPymntCalc = mapOf_MonthlyOutFlow_Fields.get(
        Constants.MINIMUM_PAYMNT_CALC_C
      );
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan + minimumPymntCalc;
    }
  }

  public void getExistingMonthlyInstallmentAfterLoan(
    Applicant__c record,
    map<string, decimal> mapOf_MonthlyOutFlow_Fields,
    Map<string, Decimal> loan_Calc_Prdcts_Fields,
    map<string, decimal> mapOfMnlyPayAfter,
    map<string, decimal> mapOfMinPayAfter
  ) {
    existingMonthlyPaymntsAfterLoan = 0;

    if (mapOfMnlyPayAfter != null) {
      if (mapOfMnlyPayAfter.get(Constants.MONTHLY_PAYMENT_AFTER_C) != null) {
        existingMonthlyPaymntsAfterLoan =
          existingMonthlyPaymntsAfterLoan +
          mapOfMnlyPayAfter.get(Constants.MONTHLY_PAYMENT_AFTER_C);
      }
    }

    if (mapOfMinPayAfter != null) {
      if (mapOfMinPayAfter.get(Constants.MINIMUM_PAYMENT_AFTER_C) != null) {
        existingMonthlyPaymntsAfterLoan =
          existingMonthlyPaymntsAfterLoan +
          mapOfMinPayAfter.get(Constants.MINIMUM_PAYMENT_AFTER_C);
      }
    }

    if (loan_Calc_Prdcts_Fields != null) {
      if (
        loan_Calc_Prdcts_Fields.get(
          Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C
        ) != null
      ) {
        existingMonthlyPaymntsAfterLoan =
          existingMonthlyPaymntsAfterLoan +
          loan_Calc_Prdcts_Fields.get(
            Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C
          );
      }
      if (
        loan_Calc_Prdcts_Fields.get(
          Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C
        ) != null
      ) {
        existingMonthlyPaymntsAfterLoan =
          existingMonthlyPaymntsAfterLoan +
          loan_Calc_Prdcts_Fields.get(
            Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C
          );
      }
    }
  }

  public void getMonthlyOutFlowsPriorLoan(
    Applicant__c record,
    map<string, decimal> mapOf_MonthlyOutFlow_Fields
  ) {
    monthlyOutflowsPriorLoan = 0;
    decimal mnlyPymntPriorCalcApp = 0;
    decimal minimumPymntCalc = 0;

    if (
      mapOf_MonthlyOutFlow_Fields.get(
        Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C
      ) != null
    ) {
      mnlyPymntPriorCalcApp = mapOf_MonthlyOutFlow_Fields.get(
        Constants.MONTHLY_PAYMNT_PRIOR_CALC_APP_PORTION_C
      );
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + mnlyPymntPriorCalcApp;
    }

    if (
      mapOf_MonthlyOutFlow_Fields.get(Constants.MINIMUM_PAYMNT_CALC_C) != null
    ) {
      minimumPymntCalc = mapOf_MonthlyOutFlow_Fields.get(
        Constants.MINIMUM_PAYMNT_CALC_C
      );
      monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + minimumPymntCalc;
    }

    if (record.Property_Tax_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Property_Tax_Monthly_Prior_Loan__c;
    }
    if (record.Property_Insurance_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Property_Insurance_Monthly_Prior_Loan__c;
    }
    if (record.Property_Maintenance_Monthly_Prior_loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Property_Maintenance_Monthly_Prior_loan__c;
    }
    if (record.Personal_Expenses_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Personal_Expenses_Monthly_Prior_Loan__c;
    }
    if (record.Food_Cost_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Food_Cost_Monthly_Prior_Loan__c;
    }
    if (record.Child_Care_Costs_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Child_Care_Costs_Monthly_Prior_Loan__c;
    }
    if (record.School_Costs_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.School_Costs_Monthly_Prior_Loan__c;
    }
    if (record.Health_Costs_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Health_Costs_Monthly_Prior_Loan__c;
    }
    if (record.Other_Personal_Family_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Other_Personal_Family_Monthly_Prior_Loan__c;
    }
    if (record.Electricity_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Electricity_Monthly_Prior_Loan__c;
    }
    if (record.Water_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Water_Monthly_Prior_Loan__c;
    }
    if (record.Cell_Phone_Landline_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Cell_Phone_Landline_Monthly_Prior_Loan__c;
    }
    if (record.Internet_Cable_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Internet_Cable_Monthly_Prior_Loan__c;
    }
    if (record.Cooking_Gas_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Cooking_Gas_Monthly_Prior_Loan__c;
    }
    if (record.House_Keeping_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.House_Keeping_Monthly_Prior_Loan__c;
    }
    if (record.Other_Utilities_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Other_Utilities_Monthly_Prior_Loan__c;
    }

    if (record.Fares_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Fares_Monthly_Prior_Loan__c;
    }
    if (record.Petrol_Fuel_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Petrol_Fuel_Monthly_Prior_Loan__c;
    }
    if (record.Toll_Fees_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Toll_Fees_Monthly_Prior_Loan__c;
    }
    if (record.Motor_V_Insurance_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_V_Insurance_Monthly_Prior_Loan__c;
    }
    if (record.Motor_Vehicle_Reg_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_Vehicle_Reg_Monthly_Prior_Loan__c;
    }
    if (record.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c;
    }
    if (record.Motor_V_Maintenance_Monthly_Before_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_V_Maintenance_Monthly_Before_Loan__c;
    }
    if (record.Other_Transport_Costs_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Other_Transport_Costs_Monthly_Prior_Loan__c;
    }
    if (record.Savings_Pension_Insurance_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Savings_Pension_Insurance_Number__c;
    }
    if (record.Personal_Expenses_Monthly_Prior_Loan__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Personal_Expenses_Monthly_Prior_Loan__c;
    }
    if (record.Statutory_Deductions_Numbers__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Statutory_Deductions_Numbers__c;
    }
    if (record.Rent_Strata_Maintenance__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Rent_Strata_Maintenance__c;
    }
    if (record.Motor_Vehicle_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_Vehicle_Monthly_Payment_Number__c;
    }
    if (record.Other_Asset_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Other_Asset_Monthly_Payment_Number__c;
    }
    if (record.Other_Loan_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Other_Loan_Monthly_Payment_Number__c;
    }
    if (record.Real_Estate_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Real_Estate_Monthly_Payment_Number__c;
    }
  }

  public void getMonthlyOutFlowsAfterLoan(
    Applicant__c record,
    Map<string, Decimal> loan_Calc_Prdcts_Fields,
    map<string, decimal> mapOfMnlyPayAfter,
    map<string, decimal> mapOfMinPayAfter
  ) {
    monthlyOutflowsAfterLoan = 0;
    if (mapOfMnlyPayAfter != null) {
      if (mapOfMnlyPayAfter.get(Constants.MONTHLY_PAYMENT_AFTER_C) != null) {
        monthlyOutflowsAfterLoan =
          monthlyOutflowsAfterLoan +
          mapOfMnlyPayAfter.get(Constants.MONTHLY_PAYMENT_AFTER_C);
      }
    }

    if (mapOfMinPayAfter != null) {
      if (mapOfMinPayAfter.get(Constants.MINIMUM_PAYMENT_AFTER_C) != null) {
        monthlyOutflowsAfterLoan =
          monthlyOutflowsAfterLoan +
          mapOfMinPayAfter.get(Constants.MINIMUM_PAYMENT_AFTER_C);
      }
    }

    if (loan_Calc_Prdcts_Fields != null) {
      if (
        loan_Calc_Prdcts_Fields.get(
          Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C
        ) != null
      ) {
        monthlyOutflowsAfterLoan =
          monthlyOutflowsAfterLoan +
          loan_Calc_Prdcts_Fields.get(
            Constants.TOTAL_MONTHLY_LOAN_PAYMENT_NUMBER_C
          );
      }
      if (
        loan_Calc_Prdcts_Fields.get(
          Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C
        ) != null
      ) {
        monthlyOutflowsAfterLoan =
          monthlyOutflowsAfterLoan +
          loan_Calc_Prdcts_Fields.get(
            Constants.MINIMUM_PAYMENT_PER_CREDIT_LIMIT_NUMBER_C
          );
      }
    }

    if (record.Cell_Phone_Landline_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Cell_Phone_Landline_Monthly_After_Loan__c;
    }
    if (record.Child_Care_Costs_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Child_Care_Costs_Monthly_After_Loan__c;
    }
    if (record.Cooking_Gas_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Cooking_Gas_Monthly_After_Loan__c;
    }
    if (record.Electricity_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Electricity_Monthly_After_Loan__c;
    }
    if (record.Fares_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Fares_Monthly_After_Loan__c;
    }
    if (record.Food_Costs_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Food_Costs_Monthly_After_Loan__c;
    }
    if (record.Health_Costs_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Health_Costs_Monthly_After_Loan__c;
    }
    if (record.House_Keeping_Costs_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.House_Keeping_Costs_Monthly_After_Loan__c;
    }
    if (record.Internet_Cable_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Internet_Cable_Monthly_After_Loan__c;
    }
    if (record.Motor_V_Insurance_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Motor_V_Insurance_Monthly_After_Loan__c;
    }
    if (record.Motor_V_Maintenance_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Motor_V_Maintenance_Monthly_After_Loan__c;
    }
    if (record.Motor_Vehicle_Fitness_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Motor_Vehicle_Fitness_Monthly_After_Loan__c;
    }
    if (record.Motor_Vehicle_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Motor_Vehicle_Monthly_After_Loan__c;
    }
    if (record.Motor_Vehicle_Reg_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Motor_Vehicle_Reg_Monthly_After_Loan__c;
    }
    if (record.Other_Personal_Family_Costs_Prior_After__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Other_Personal_Family_Costs_Prior_After__c;
    }
    if (record.Other_Transport_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Other_Transport_Monthly_After_Loan__c;
    }
    if (record.Other_Utilities_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Other_Utilities_Monthly_After_Loan__c;
    }
    if (record.Personal_Expenses_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Personal_Expenses_Monthly_After_Loan__c;
    }
    if (record.Petrol_Fuel_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Petrol_Fuel_Monthly_After_Loan__c;
    }
    if (record.Property_Insurance_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Property_Insurance_Monthly_After_Loan__c;
    }
    if (record.Property_Maintenance_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Property_Maintenance_Monthly_After_Loan__c;
    }
    if (record.Property_Tax_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Property_Tax_Monthly_After_Loan__c;
    }
    if (record.Rent_Board_Strata_After_TDSR__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Rent_Board_Strata_After_TDSR__c;
    }
    if (record.Rent_Board_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Rent_Board_Monthly_After_Loan__c;
    }
    if (record.School_Costs_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.School_Costs_Monthly_After_Loan__c;
    }
    if (record.Strata_Maintenance_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Strata_Maintenance_Monthly_After_Loan__c;
    }
    if (record.Toll_Fees_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Toll_Fees_Monthly_After_Loan__c;
    }
    if (record.Water_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Water_Monthly_After_Loan__c;
    }
    if (record.Savings_Pension_Insurance_Number__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Savings_Pension_Insurance_Number__c;
    }
    if (record.Personal_Expenses_Monthly_After_Loan__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan +
        record.Personal_Expenses_Monthly_After_Loan__c;
    }
    if (record.Statutory_Deductions_Numbers__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Statutory_Deductions_Numbers__c;
    }
    if (record.Rent_Strata_Maintenance__c != null) {
      monthlyOutflowsAfterLoan =
        monthlyOutflowsAfterLoan + record.Rent_Strata_Maintenance__c;
    }
    if (record.Motor_Vehicle_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan +
        record.Motor_Vehicle_Monthly_Payment_Number__c;
    }
    if (record.Other_Asset_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Other_Asset_Monthly_Payment_Number__c;
    }
    if (record.Other_Loan_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Other_Loan_Monthly_Payment_Number__c;
    }
    if (record.Real_Estate_Monthly_Payment_Number__c != null) {
      monthlyOutflowsPriorLoan =
        monthlyOutflowsPriorLoan + record.Real_Estate_Monthly_Payment_Number__c;
    }
  }

  public void getExistingmnthlyPaymnt(Applicant__c record) {
    existingMonthlyPaymntsPriorLoan = 0;
    existingMonthlyPaymntsAfterLoan = 0;

    if (record.Cell_Phone_Landline_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Cell_Phone_Landline_Monthly_Prior_Loan__c;
    }

    if (record.Child_Care_Costs_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Child_Care_Costs_Monthly_Prior_Loan__c;
    }

    if (record.Cooking_Gas_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Cooking_Gas_Monthly_Prior_Loan__c;
    }

    if (record.Education_Tax_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Education_Tax_Monthly_Prior_Loan__c;
    }

    if (record.Electricity_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Electricity_Monthly_Prior_Loan__c;
    }

    if (record.Fares_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan + record.Fares_Monthly_Prior_Loan__c;
    }

    if (record.Food_Cost_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Food_Cost_Monthly_Prior_Loan__c;
    }

    if (record.Health_Costs_Monthly_Prior_Loan__c != null) {
      existingMonthlyPaymntsPriorLoan =
        existingMonthlyPaymntsPriorLoan +
        record.Health_Costs_Monthly_Prior_Loan__c;
    }
    existingMonthlyPaymntsAfterLoan = existingMonthlyPaymntsPriorLoan;
  }
}
