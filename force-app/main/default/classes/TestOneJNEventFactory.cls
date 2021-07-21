/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 06-11-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   06-11-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
@isTest
public class TestOneJNEventFactory {
  /**
   * @description to Test process outcoming event for GetApplicationLoanId
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testGetApplicationLoanIdEvent() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount'
    );
    accounts[0].RIM_no__c = '1111';
    insert accounts;

    List<Opportunity> opps = TestDataFactory.CreateOpportunities(1);
    opps[0].RecordTypeId = oppRecordTypeId_cc;
    opps[0].AccountId = accounts[0].Id;
    insert opps;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    appList.add(applicationRecord);
    insert appList;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_LOAN_APPLICATION_ID,
      appList,
      opps
    );
    Test.stopTest();
  }
  /**
   * @description to Test process outcoming event for GetCreditCardPreAssessment
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void tesGetCreditCardPreAssessment() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount2'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    opps2[0].Product_Category__c = 'JN Bank Credit Card';
    opps2[0].CurrencyIsoCode = 'JMD';
    opps2[0].Preferred_Location__c = 'New Kingston';
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList2.add(applicationRecord);
    insert appList2;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Science & Technology';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps2[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;

    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_CREDITCARD_PRE_ASSESSMENT,
      appList2,
      opps2
    );
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_CREDITCARD_PRE_ASSESSMENT,
      appList2,
      opps2
    );
    Test.stopTest();
  }

  /**
   * @description to Test process outcoming event for GetUnsecuredLoanPreAssessment
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testGetUnsecuredLoanPreAssessment() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount2'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    opps2[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps2[0].CurrencyIsoCode = 'JMD';
    opps2[0].Preferred_Location__c = 'New Kingston';
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList2.add(applicationRecord);
    insert appList2;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps2[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;

    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT,
      appList2,
      opps2
    );
    Test.stopTest();
  }
  /**
   * @description  to Test process outcoming event for GetManualDecisionApproved
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testGetManualDecisionApproved() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount2'
    );
    accounts[0].RIM_no__c = '1111';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    opps2[0].Product_Category__c = 'JN Bank Credit Card';
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList2.add(applicationRecord);
    insert appList2;

    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.SUBMIT_CREDIT_CARD_MANUAL_DECISION,
      appList2,
      opps2
    );
    Test.stopTest();
  }
  /**
   * @description to test process incoming event for event type  ReturnApplicationLoanId
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testReturnApplicationLoanIdEvent() {
    OneJNDeserializer oneJNDeserializer;
    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_LOAN_APPLICATION_ID,
      'JN Bank Credit Card'
    );

    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount3'
    );
    accounts[0].RIM_no__c = '1111';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    //appList2.add(applicationRecord);
    insert applicationRecord;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_LOAN_APPLICATION_ID,
      oneJNDeserializer,
      applicationRecord.Id,
      ''
    );
    Test.stopTest();
  }
  /**
   * @description  to test process incoming event for event type  ReturnManualDecisionApproved
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testReturnManualDecisionApproved() {
    OneJNDeserializer oneJNDeserializer;
    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE,
      'JN Bank Credit Card '
    );

    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      2,
      'testAccount3'
    );
    accounts[0].RIM_no__c = '1111';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card ' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opps2[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    insert applicationRecord;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps2[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    Applicant__c applicant1 = TestDataFactory.CreateApplicant(
      accounts[1].id,
      opps2[0].id
    );
    applicant1.Joint_Application_flag__c = 'No';
    applicant1.Primary_Applicant_Flag__c = false;
    applicant1.Number_of_Rejected_Applications_Number__c = 1;
    applicant1.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant1.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant1.Declared_bankrupt_list__c = 'No';
    applicant1.Gross_Monthly_Income__c = 50000;
    applicant1.Other_Income__c = 10000;
    insert applicant1;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE,
      oneJNDeserializer,
      applicationRecord.Id,
      ''
    );
    Test.stopTest();
  }
  /**
   * @description to test process incoming event for event type  ReturnUnsecuredLoanPreAssessment
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testReturnUnsecuredLoanPreAssessment() {
    OneJNDeserializer oneJNDeserializer;
    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_CREDITCARD_PRE_ASSESSMENT,
      'JN Bank Unsecured Loan'
    );

    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      2,
      'testAccount4'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';

    accounts[1].RIM_no__c = '1111';
    accounts[1].Premier_Customer_List__c = 'Yes';
    accounts[1].Politically_Affiliated__c = true;
    accounts[1].MonthsResidence_Number__c = 1;
    accounts[1].FinServ__NumberOfDependents__pc = 2;
    accounts[1].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps3 = TestDataFactory.CreateOpportunities(1);
    opps3[0].RecordTypeId = oppRecordTypeId_cc;
    opps3[0].AccountId = accounts[0].Id;
    opps3[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps3[0].CurrencyIsoCode = 'JMD';
    opps3[0].Preferred_Location__c = 'New Kingston';
    insert opps3;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(TestDataFactory.CreateProduct(family, +family));
    }
    //Insert products with families
    insert products;

    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opps3[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    List<Application__c> appList3 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps3[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList3.add(applicationRecord);
    insert appList3;
    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps3[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    Applicant__c applicant1 = TestDataFactory.CreateApplicant(
      accounts[1].id,
      opps3[0].id
    );
    applicant1.Joint_Application_flag__c = 'No';
    applicant1.Primary_Applicant_Flag__c = false;
    applicant1.Number_of_Rejected_Applications_Number__c = 1;
    applicant1.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant1.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant1.Declared_bankrupt_list__c = 'No';
    applicant1.Gross_Monthly_Income__c = 50000;
    applicant1.Other_Income__c = 10000;
    insert applicant1;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;

    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_CREDITCARD_PRE_ASSESSMENT,
      oneJNDeserializer,
      opps3[0].Id,
      ''
    );
    Test.stopTest();
  }
  /**
   * @description to test process incoming event for event type  ReturnCreditCardFinalAssessment
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testReturnCreditCardFinalAssessment() {
    OneJNDeserializer oneJNDeserializer;

    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT,
      'JN Bank Credit Card'
    );
    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount4'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps3 = TestDataFactory.CreateOpportunities(1);
    opps3[0].RecordTypeId = oppRecordTypeId_cc;
    opps3[0].AccountId = accounts[0].Id;
    opps3[0].Product_Category__c = 'JN Bank Credit Card';
    opps3[0].CurrencyIsoCode = 'JMD';
    opps3[0].Preferred_Location__c = 'New Kingston';
    insert opps3;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opps3[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    List<Application__c> appList3 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps3[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList3.add(applicationRecord);
    insert appList3;
    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps3[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    List<Loan_Calculator__c> loanCalculatorRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalculatorRecord[0].Opportunity__c = opps3[0].Id;
    insert loanCalculatorRecord;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculatorRecord[0].id;
    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT,
      oneJNDeserializer,
      opps3[0].Id,
      ''
    );
    Test.stopTest();
  }

  /**
   * @description to test process incoming event for event type  ReturnCreditCardFinalAssessment
   * @author Trupti Zende (Thinqloud) | 06-11-2021
   **/
  @isTest
  public static void testReturnUnsecuredFinalAssessment() {
    OneJNDeserializer oneJNDeserializer;
    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT,
      'JN Bank Unsecured Loan'
    );
    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      2,
      'testAccount4'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';

    accounts[1].RIM_no__c = '1111';
    accounts[1].Premier_Customer_List__c = 'Yes';
    accounts[1].Politically_Affiliated__c = true;
    accounts[1].MonthsResidence_Number__c = 1;
    accounts[1].FinServ__NumberOfDependents__pc = 2;
    accounts[1].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps3 = TestDataFactory.CreateOpportunities(1);
    opps3[0].RecordTypeId = oppRecordTypeId_cc;
    opps3[0].AccountId = accounts[0].Id;
    opps3[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps3[0].CurrencyIsoCode = 'JMD';
    opps3[0].Preferred_Location__c = 'New Kingston';
    insert opps3;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opps3[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    List<Application__c> appList3 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps3[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList3.add(applicationRecord);
    insert appList3;
    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps3[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    Applicant__c applicant1 = TestDataFactory.CreateApplicant(
      accounts[1].id,
      opps3[0].id
    );
    applicant1.Joint_Application_flag__c = 'No';
    applicant1.Primary_Applicant_Flag__c = false;
    applicant1.Number_of_Rejected_Applications_Number__c = 1;
    applicant1.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant1.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant1.Declared_bankrupt_list__c = 'No';
    applicant1.Gross_Monthly_Income__c = 50000;
    applicant1.Other_Income__c = 10000;
    insert applicant1;

    List<Loan_Calculator__c> loanCalculatorRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalculatorRecord[0].Opportunity__c = opps3[0].Id;
    insert loanCalculatorRecord;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculatorRecord[0].id;
    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT,
      oneJNDeserializer,
      opps3[0].Id,
      ''
    );
    // OneJNEventFactory.ProcessIncomingEvent(Constants.RETURN_LOAN_APPLICATION_ID, oneJNDeserializer, opps3[0].Id,'');
    Test.stopTest();
  }
  @isTest
  public static void testGetUnsecuredLoanFinalAssessment() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount2'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    opps2[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps2[0].CurrencyIsoCode = 'JMD';
    opps2[0].Preferred_Location__c = 'New Kingston';
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList2.add(applicationRecord);
    insert appList2;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps2[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    List<Loan_Calculator__c> loanCalculatorRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalculatorRecord[0].Opportunity__c = opps2[0].Id;
    insert loanCalculatorRecord;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 40000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 2000;
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculatorRecord[0].id;
    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT,
      appList2,
      opps2
    );
    Test.stopTest();
  }
  @isTest
  public static void testGetCreditCardFinalAssessment() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount2'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    opps2[0].Product_Category__c = 'JN Bank Credit Card';
    opps2[0].CurrencyIsoCode = 'JMD';
    opps2[0].Preferred_Location__c = 'New Kingston';
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList2 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps2[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList2.add(applicationRecord);
    insert appList2;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps2[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    applicant.JNRiskGrade__c = 'A';
    applicant.JNRiskScore__c = 'B';
    insert applicant;

    List<Loan_Calculator__c> loanCalculatorRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalculatorRecord[0].Opportunity__c = opps2[0].Id;
    insert loanCalculatorRecord;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 40000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 2000;
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculatorRecord[0].id;
    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_CREDITCARD_FINAL_ASSESSMENT,
      appList2,
      opps2
    );
    Test.stopTest();
  }
}
