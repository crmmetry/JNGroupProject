/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 06-11-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   06-11-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
@isTest
public class TestOneJNOutputEventHandler {
  @isTest
  public static void handleGetApplicationIdEvent() {
    OneJNDeserializer oneJNDeserializer;
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    list<OneJNOutputEventHandler.FlowInputs> Flilist = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli = new OneJNOutputEventHandler.FlowInputs();
    Fli.eventType = Constants.RETURN_LOAN_APPLICATION_ID;
    Fli.externalId = 'abctest';
    Fli.sfRecordId = applicationRecord.Id;
    Fli.body = jsonData;
    Flilist.add(Fli);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist);
    Test.stopTest();
  }

  @isTest
  public static void handleCreditCardPreAssessmentEvent() {
    OneJNDeserializer oneJNDeserializer;
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');

    jsonGen.writeStartObject();
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeStringField('preAssessmentDecision', 'Pass');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{
      Constants.CREDITCARD_PRODUCT_FAMILY
    };
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
    list<OneJNOutputEventHandler.FlowInputs> Flilist = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli = new OneJNOutputEventHandler.FlowInputs();
    Fli.eventType = Constants.RETURN_CREDITCARD_PRE_ASSESSMENT;
    Fli.externalId = 'abctest';
    Fli.sfRecordId = opps2[0].Id;
    Fli.body = jsonData;
    Flilist.add(Fli);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist);
    Test.stopTest();
  }
  @isTest
  public static void handleUnsecuredPreAssessmentEvent() {
    OneJNDeserializer oneJNDeserializer;
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');
    jsonGen.writeStartObject();
    jsonGen.writeStringField('finalAssessmentReport', 'test');
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeStringField('preAssessmentDecision', 'Pass');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{
      Constants.UNSECURED_PRODUCT_FAMILY
    };
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
    list<OneJNOutputEventHandler.FlowInputs> Flilist = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli = new OneJNOutputEventHandler.FlowInputs();
    Fli.eventType = Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT;
    Fli.externalId = 'abctest';
    Fli.sfRecordId = opps2[0].Id;

    Fli.body = jsonData;

    Flilist.add(Fli);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist);
    Test.stopTest();
  }
  @isTest
  public static void handleUnsecuredfinalEvent() {
    OneJNDeserializer oneJNDeserializer;
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');

    jsonGen.writeStartObject();
    jsonGen.writeStringField('finalAssessmentReport', 'test');
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeStringField('finalAssessmentDecision', 'Referred');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    insert accounts;

    List<Opportunity> opps2 = TestDataFactory.CreateOpportunities(1);
    opps2[0].RecordTypeId = oppRecordTypeId_cc;
    opps2[0].AccountId = accounts[0].Id;
    insert opps2;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{
      Constants.UNSECURED_PRODUCT_FAMILY
    };
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
    list<OneJNOutputEventHandler.FlowInputs> Flilist = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli = new OneJNOutputEventHandler.FlowInputs();
    Fli.eventType = Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT;
    Fli.externalId = 'abctest';
    Fli.sfRecordId = opps2[0].Id;

    Fli.body = jsonData;

    Flilist.add(Fli);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist);
    Test.stopTest();
  }
  @isTest
  public static void handleCreditCardfinalEvent() {
    OneJNDeserializer oneJNDeserializer;
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');

    jsonGen.writeStartObject();
    jsonGen.writeStringField('finalAssessmentReport', 'test');
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeStringField('finalAssessmentDecision', 'Referred');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    list<OneJNOutputEventHandler.FlowInputs> Flilist = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli = new OneJNOutputEventHandler.FlowInputs();
    Fli.eventType = Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT;
    Fli.externalId = 'abctest';
    Fli.sfRecordId = opps2[0].Id;
    Fli.body = jsonData;
    Flilist.add(Fli);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist);
    Test.stopTest();
  }
}
