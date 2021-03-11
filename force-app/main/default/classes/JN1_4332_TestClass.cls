@isTest
public class JN1_4332_TestClass {
  //Account
  public static Account testAccountObj;
  public static list<Account> testAccountObjs;

  //Loan Calculator
  public static Loan_Calculator__c testLoanCalculatorObj;
  public static List<Loan_Calculator__c> testLoanCalculatorLst;

  //Opportunity
  public static Opportunity testOpportunityObj;
  public static List<Opportunity> testOpportunityLst;

  //Loan_Calculation_Product__c
  public static Loan_Calculation_Product__c testLoanCalculationProductObj;
  public static List<Loan_Calculation_Product__c> testLoanCalculationProductLst;

  //Loan_Calculation_Applicant_Product__c
  public static Loan_Calculation_Applicant_Product__c testLoanCalculationApplicationProductObj;
  public static List<Loan_Calculation_Applicant_Product__c> testLoanCalculationApplicationProductLst;

  //Employment
  public static FinServ__Employment__c testEmploymentObj;
  public static List<FinServ__Employment__c> testEmploymentLst;

  //Assets
  public static FinServ__AssetsAndLiabilities__c testAssest1;
  public static FinServ__AssetsAndLiabilities__c testAssest2;
  public static Application_Asset_Liability__c testApplAssest1;
  public static Application_Asset_Liability__c testApplAssest2;

  //Applicant
  public static Applicant__c testApplicantObj;

  //Product2
  public static Product2 prodctObj;

  //Price book 2
  public static Pricebook2 priceBook2Obj;

  //Price book Entry
  public static PricebookEntry PricebookEntryObj;

  //Opportunity Line Item
  public static OpportunityLineItem testOpportunityLineItemObj;

  public static Map<String, Id> mapOfRecordTypes;

  public static void CreateData() {
    //------Create Account--------//
    Date dt = Date.newInstance(1995, 11, 13);
    testAccountObjs = TestDataFactory.CreateBasicAccounts(1, 'lastName');
    testAccountObj = testAccountObjs.get(0);
    testAccountObj.Political_Exposure__pc = false;
    testAccountObj.Jamaican_Tax_Registration_Number__pc = '123456789';
    testAccountObj.PersonBirthdate = Date.newInstance(1984, 2, 14);
    testAccountObj.Highest_Level_of_Education_attained__pc = 'High School';
    testAccountObj.Status_of_Address__pc = 'Own (without mortgage)';
    testAccountObj.Years_at_Residence__pc = 4;
    insert testAccountObj;

    //------Create Loan Calculator--------//
    Map<String, Id> recordTypeids = Util.getRecordTypeids('Loan_Calculator__c');
    testLoanCalculatorLst = TestDataFactory.CreateLoanCalculation(1);
    testLoanCalculatorObj = testLoanCalculatorLst.get(0);
    testLoanCalculatorObj.RecordTypeId = recordTypeids.get('Product_Details');
    insert testLoanCalculatorObj;

    //------Create Opportunity--------//
    testOpportunityLst = TestDataFactory.CreateOpportunities(1);
    testOpportunityObj = testOpportunityLst.get(0);
    testOpportunityObj.AccountId = testAccountObj.Id;
    testOpportunityObj.Product_Details__c = testLoanCalculatorObj.Id;
    testOpportunityObj.StageName = 'Submitted and Processing';
    insert testOpportunityObj;
    testLoanCalculatorObj.Opportunity__c = testOpportunityObj.Id;
    update testLoanCalculatorObj;

    //------Create Loan Calculation Product--------//
    testLoanCalculationProductLst = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    testLoanCalculationProductObj = testLoanCalculationProductLst.get(0);
    testLoanCalculationProductObj.Loan_Calculation_Id__c = testLoanCalculatorObj.Id;
    testLoanCalculationProductObj.Requested_Credit_Limit_Number__c = 500;
    testLoanCalculationProductObj.Collateral_Type_List__c = 'Cash/Investments';
    testLoanCalculationProductObj.Loan_to_Value_Number__c = 26;
    testLoanCalculationProductObj.Ability_to_Service_Before_Number__c = 25;
    testLoanCalculationProductObj.Repayment_Method_List__c = 'Salary Deduction';
    testLoanCalculationProductObj.Total_Monthly_Loan_Payment_Number__c = 5220.25;
    testLoanCalculationProductObj.Minimum_Payment_per_Credit_Limit_Number__c = 522;
    testLoanCalculationProductObj.Market_Value_of_Vehicle_Number__c = 522;
    testLoanCalculationProductObj.Starting_Limit_Number__c = 522;

    insert testLoanCalculationProductObj;

    //------Create Employement--------//
    testEmploymentObj = TestDataFactory.CreateEmployment(
      testAccountObj.Id,
      'name'
    );
    testEmploymentObj.FinServ__StartDate__c = Date.newInstance(2010, 11, 13);
    testEmploymentObj.Current_Employment__c = true;
    testEmploymentObj.FinServ__EmploymentStatus__c = 'Permanent';
    testEmploymentObj.Industry__c = 'Financial Services';
    testEmploymentObj.Professional_Category__c = 'Professional';
    testEmploymentObj.Assessment_of_Business_Working_Capita__c = 'Good';
    testEmploymentObj.Nature_of_Engagement__c = 'Professional service provider';
    testEmploymentObj.Assessment_of_Business__c = 'Good growth and or profit trends for 3 - 4 years';
    testEmploymentObj.Assessment_of_Statement__c = 'Strongly Supported';
    testEmploymentObj.Length_of_Trade__c = 'More than 5 years';
    testEmploymentObj.Account__c = testAccountObj.Id;

    insert testEmploymentObj;

    //------Create Application--------//
    testApplicantObj = TestDataFactory.CreateApplicant(
      testAccountObj.Id,
      testOpportunityObj.Id
    );
    testApplicantObj.Sanction_Screening_has_Negative_Trace__c = 'No';
    testApplicantObj.Account__c = testAccountObj.Id;
    testApplicantObj.Opportunity__c = testOpportunityObj.Id;
    testApplicantObj.Credit_History_in_last_24_Months__c = '1 - 10 Days Delinquent';
    testApplicantObj.Assessment_of_Applicant_Net_Worth__c = 'Strong net worth';
    testApplicantObj.Gross_Monthly_Income__c = 5411;
    testApplicantObj.Real_Estate_Market_Value_Number__c = 522;
    testApplicantObj.Motor_Vehicle_Market_Value_Number__c = 522;
    testApplicantObj.Other_Asset_Market_Value_Number__c = 522;
    testApplicantObj.Life_Insurance_Cash_Value__c = 522;
    testApplicantObj.Savings_Deposit_Investments__c = 522;
    testApplicantObj.Pension_IRS_Total_Contribution__c = 522;

    testApplicantObj.Real_Estate_Loan_Balance_Number__c = 522;
    testApplicantObj.Motor_Vehicle_Loan_Balance_Number__c = 522;
    testApplicantObj.Other_Asset_Loan_Balance_Number__c = 522;
    testApplicantObj.Other_Loan_Loan_Balance_Number__c = 522;
    testApplicantObj.Average_Credit_Card_Balances_Number__c = 522;
    testApplicantObj.Average_Line_of_Credit_Balance_Number__c = 522;
    testApplicantObj.Property_Tax_Monthly_Prior_Loan__c = 544;
    testApplicantObj.Property_Insurance_Monthly_Prior_Loan__c = 454;
    testApplicantObj.Property_Maintenance_Monthly_Prior_loan__c = 474;
    testApplicantObj.Personal_Expenses_Monthly_Prior_Loan__c = 445;
    testApplicantObj.Food_Cost_Monthly_Prior_Loan__c = 855;
    testApplicantObj.Child_Care_Costs_Monthly_Prior_Loan__c = 998;
    testApplicantObj.School_Costs_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Health_Costs_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Other_Personal_Family_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Electricity_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Water_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Cell_Phone_Landline_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Internet_Cable_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Cooking_Gas_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.House_Keeping_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Other_Utilities_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Fares_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Petrol_Fuel_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Toll_Fees_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Motor_V_Insurance_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Motor_Vehicle_Reg_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Motor_V_Maintenance_Monthly_Before_Loan__c = 1009;
    testApplicantObj.Other_Transport_Costs_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Savings_Pension_Insurance_Number__c = 1009;
    testApplicantObj.Personal_Expenses_Monthly_Prior_Loan__c = 1009;
    testApplicantObj.Statutory_Deductions_Numbers__c = 1009;
    testApplicantObj.Rent_Strata_Maintenance__c = 1009;
    testApplicantObj.Motor_Vehicle_Monthly_Payment_Number__c = 1009;
    testApplicantObj.Other_Asset_Monthly_Payment_Number__c = 1009;
    testApplicantObj.Other_Loan_Monthly_Payment_Number__c = 1009;
    testApplicantObj.Real_Estate_Monthly_Payment_Number__c = 1009;
    testApplicantObj.Cell_Phone_Landline_Monthly_After_Loan__c = 5442;

    testApplicantObj.Child_Care_Costs_Monthly_After_Loan__c = 5442;
    testApplicantObj.Cooking_Gas_Monthly_After_Loan__c = 5442;
    testApplicantObj.Electricity_Monthly_After_Loan__c = 5442;
    testApplicantObj.Fares_Monthly_After_Loan__c = 5442;
    testApplicantObj.Food_Costs_Monthly_After_Loan__c = 5442;
    testApplicantObj.Health_Costs_Monthly_After_Loan__c = 5442;
    testApplicantObj.House_Keeping_Costs_Monthly_After_Loan__c = 5442;

    testApplicantObj.Internet_Cable_Monthly_After_Loan__c = 5442;
    testApplicantObj.Motor_V_Insurance_Monthly_After_Loan__c = 5442;
    testApplicantObj.Motor_V_Maintenance_Monthly_After_Loan__c = 5442;
    testApplicantObj.Motor_Vehicle_Fitness_Monthly_After_Loan__c = 5442;
    testApplicantObj.Motor_Vehicle_Monthly_After_Loan__c = 5442;
    testApplicantObj.Motor_Vehicle_Reg_Monthly_After_Loan__c = 5442;
    testApplicantObj.Other_Personal_Family_Costs_Prior_After__c = 5442;
    testApplicantObj.Other_Transport_Monthly_After_Loan__c = 5442;
    testApplicantObj.Other_Utilities_Monthly_After_Loan__c = 5442;

    testApplicantObj.Personal_Expenses_Monthly_After_Loan__c = 5442;
    testApplicantObj.Petrol_Fuel_Monthly_After_Loan__c = 5442;
    testApplicantObj.Property_Insurance_Monthly_After_Loan__c = 5442;
    testApplicantObj.Property_Maintenance_Monthly_After_Loan__c = 5442;
    testApplicantObj.Property_Tax_Monthly_After_Loan__c = 5442;
    testApplicantObj.Rent_Board_Monthly_After_Loan__c = 5442;
    testApplicantObj.School_Costs_Monthly_After_Loan__c = 5442;

    testApplicantObj.Strata_Maintenance_Monthly_After_Loan__c = 5442;
    testApplicantObj.Toll_Fees_Monthly_After_Loan__c = 5442;
    testApplicantObj.Water_Monthly_After_Loan__c = 5442;
    testApplicantObj.Savings_Pension_Insurance_Number__c = 5442;
    testApplicantObj.Personal_Expenses_Monthly_After_Loan__c = 5442;
    testApplicantObj.Statutory_Deductions_Numbers__c = 5442;
    testApplicantObj.Rent_Strata_Maintenance__c = 5442;
    testApplicantObj.Motor_Vehicle_Monthly_Payment_Number__c = 5442;
    testApplicantObj.Other_Asset_Monthly_Payment_Number__c = 5455;
    testApplicantObj.Other_Loan_Monthly_Payment_Number__c = 5455;
    testApplicantObj.Real_Estate_Monthly_Payment_Number__c = 5455;

    insert testApplicantObj;

    //------Assets--------//
    mapOfRecordTypes = new Map<String, Id>();
    mapOfRecordTypes = Util.getRecordTypeids(
      'FinServ__AssetsAndLiabilities__c'
    );
    testAssest1 = TestDataFactory.CreateAssetsAndLiabilities(
      testAccountObj.Id,
      mapOfRecordTypes.get('Lines_of_Credit'),
      'TestAsset1'
    );
    testAssest1.Total_Market_Value__c = 522;
    testAssest1.Account_Balance__c = 544;
    testAssest1.Total_Contributions_to_Date__c = 45;
    testAssest1.Asset_Credit_Balance__c = 50;
    testAssest1.Cash_Value__c = 54;

    testAssest2 = TestDataFactory.CreateAssetsAndLiabilities(
      testAccountObj.Id,
      mapOfRecordTypes.get('Lines_of_Credit'),
      'TestAsset2'
    );
    testAssest2.Total_Market_Value__c = 522;
    testAssest2.Account_Balance__c = 544;
    testAssest2.Total_Contributions_to_Date__c = 45;
    testAssest2.Asset_Credit_Balance__c = 50;
    testAssest2.Cash_Value__c = 54;

    insert testAssest1;
    insert testAssest2;

    //------Assets Applicantion--------//
    testApplAssest1 = TestDataFactory.CreateApplicantAssetsAndLiabilities(
      testApplicantObj.Id,
      testAssest1.Id
    );
    testApplAssest1.Treatment_of_Credit__c = Constants.WILL_REMAIN_STRING;
    testApplAssest1.Monthly_Payment_After__c = 522;
    testApplAssest1.Minimum_Payment_After__c = 544;

    testApplAssest2 = TestDataFactory.CreateApplicantAssetsAndLiabilities(
      testApplicantObj.Id,
      testAssest2.Id
    );
    testApplAssest2.Treatment_of_Credit__c = Constants.WILL_REMAIN_STRING;
    testApplAssest2.Monthly_Payment_After__c = 522;
    testApplAssest2.Minimum_Payment_After__c = 544;

    insert testApplAssest1;
    insert testApplAssest2;

    //------Create Loan Calculation Application Product--------//
    testLoanCalculationApplicationProductLst = TestDataFactory.CreateLoanCalculationApplicationPrdct(
      1
    );
    testLoanCalculationApplicationProductObj = testLoanCalculationApplicationProductLst.get(
      0
    );
    testLoanCalculationApplicationProductObj.Loan_Calculation_Product_Id__c = testLoanCalculationProductObj.Id;
    testLoanCalculationApplicationProductObj.Loan_Amount_Number__c = 56;
    testLoanCalculationApplicationProductObj.Applicant_Id__c = testApplicantObj.id;
    insert testLoanCalculationApplicationProductObj;

    //------Create Product--------//
    prodctObj = TestDataFactory.CreateProduct(
      'JN Bank Auto Loan',
      'JN Bank Auto Loan'
    );
    prodctObj.QuantityUnitOfMeasure = 'Each';
    insert prodctObj;

    //------Create Pricebook2--------//
    priceBook2Obj = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );
    //Update priceBook2Obj;

    //------Create PriceBookEntry--------//
    PricebookEntryObj = TestDataFactory.CreatePriceBookEntry(
      priceBook2Obj.Id,
      prodctObj.Id
    );
    insert PricebookEntryObj;

    //------Create Opportunity Line Item--------//
    testOpportunityLineItemObj = TestDataFactory.CreateOpportunityLineItem(
      testOpportunityObj.Id,
      PricebookEntryObj.Id
    );
    insert testOpportunityLineItemObj;
  }

  @isTest
  public static void test1_CreditApplicationSummaryDocumentPage() {
    CreateData();
    Test.StartTest();
    pageReference pager = page.CreditApplicationSummaryDocument;
    pager.getParameters().put('id', String.valueOf(testOpportunityObj.Id));
    Test.setCurrentPage(pager);
    CreditApplicationSummaryDocument testCreditAppSummary = new CreditApplicationSummaryDocument();
    Test.StopTest();
  }
}
