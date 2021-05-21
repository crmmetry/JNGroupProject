/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-21-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-20-2021   Remario Richards   Initial Version
 **/
@isTest
public class TestApplicationTriggerHandler {
  @isTest
  public static void testOpportunityHasApplication() {
    Test.startTest();
    //Get Opportunity Record Type
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

    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    insert applicationRecord;

    Application__c applicationRecord1 = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;

    try {
      insert applicationRecord1;
    } catch (Exception e) {
      Boolean expectedExceptionThrown = e.getMessage()
          .contains(
            'you cannot add any more than one application for this opportunity'
          )
        ? true
        : false;
      System.assertEquals(expectedExceptionThrown, true);
    }
    ApplicationTriggerHandler.checkOpportunityHasOneApplication();
    Test.stopTest();
  }

  /**
   * @description : This test method is used to test the functionality of application when it is assign from queue to user in ADJ open status.
   * @author Ishwari Gaikwad(Thinqloud) | 05-21-2021
   **/
  @isTest
  public static void testApplicationStatusChangeMethod() {
    //Get Opportunity Record Type
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
    List<Account> accList = TestDataFactory.CreateBasicAccounts(3, 'Test');
    accList[0].Years_at_Residence__pc = 4;
    accList[0]
      .Highest_Level_of_Education_attained__pc = 'University: Post Graduate';
    accList[0].PersonBirthdate = date.newInstance(
      System.Today().year() - 36,
      2,
      11
    );
    accList[0].Type = 'Analyst';
    insert accList;

    opList[0].RecordTypeId = oppRecordTypeId_cc;
    opList[0].accountId = accList[0].id;
    opList[0].Collateral_CC__c = 'Cash';
    opList[0].Collateral_LOC__c = 'Cash';
    opList[0].Loan_to_ValueCC__c = 1;
    opList[0].StageName = 'Customer Interview';
    opList[0].CloseDate = Date.today().addDays(6);
    insert opList[0];

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'iPhone X - ' + family)
      );
    }
    //Insert products with families
    insert products;

    //Instantiate the Pricebook2 record with StandardPricebookId
    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    //Execute an update DML on the Pricebook2 record, to make IsStandard to true
    update standardPricebook;

    //Query for the Pricebook2 record, to check IsStandard field
    standardPricebook = [
      SELECT Id, IsStandard
      FROM Pricebook2
      WHERE Id = :standardPricebook.Id
    ];
    //It should return true
    System.assertEquals(true, standardPricebook.IsStandard);

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
        TestDataFactory.CreateOpportunityLineItem(opList[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accList[0].id,
      'Employeement Test'
    );
    employee.Current_Employment__c = true;
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Employment_Status__c = 'Contractual';
    employee.Industry__c = 'Financial Services';
    employee.Professional_Category__c = 'Professional';
    employee.Assessment_of_Business_Working_Capita__c = 'Good';
    employee.Nature_of_Engagement__c = 'Professional service provider';
    employee.Assessment_of_Business__c = Constants.THREE_TO_FOUR_YEARS_AND_OR;
    employee.Assessment_of_Statement__c = '	Strongly Supported';
    employee.Length_of_Trade__c = 'More than 5 years';
    Map<String, Id> recordTypeMap = Util.getRecordTypeids(
      'FinServ__Employment__c'
    );
    employee.RecordTypeId = recordTypeMap.get('Employed');
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accList[0].id,
      opList[0].id
    );
    applicant.Credit_History_in_last_24_Months__c = 'No Delinquency';
    applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
    insert applicant;

    List<Supplementary_Card_Holders__c> cardHolderList = TestDataFactory.CreateSupplementaryCardHolders(
      2,
      opList[0].id
    );
    cardHolderList[0].Account__c = accList[1].id;
    cardHolderList[1].Account__c = accList[2].id;
    insert cardHolderList;

    List<Loan_Calculator__c> loanCalculationRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    insert loanCalculationRecord;

    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculationRecord[0].Id;
    loanCalculationProductRecord[0]
      .Approved_Starting_Limit_Number__c = 10000000;
    loanCalculationProductRecord[0].Legal_Fees_including_GCT_Number__c = 1000;
    loanCalculationProductRecord[0].Stamp_Duty_Number__c = 500;
    insert loanCalculationProductRecord;
    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id refeRecordTypeId_cc = mappedApplicationRecTypes.get(
      'Referred_Application'
    );

    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accList[0].id,
      opList[0].id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = refeRecordTypeId_cc;
    applicationRecord.Adjudication_Path_picklist__c = 'ADJ_Open';
    applicationRecord.OwnerId = Util.getQueueId(Constants.REFERRED_QUEUE);
    insert applicationRecord;

    Test.startTest();
    applicationRecord.OwnerId = UserInfo.getUserId();
    update applicationRecord;
    Test.stopTest();
  }

  /**
   * @description : This test method is used to test the functionality of application when it is assign from queue to user in Deferred status.
   * @author Ishwari Gaikwad(Thinqloud) | 05-21-2021
   **/
  @isTest
  public static void testApplicationStatusChangeDeferMethod() {
    //Get Opportunity Record Type
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
    List<Account> accList = TestDataFactory.CreateBasicAccounts(3, 'Test');
    accList[0].Years_at_Residence__pc = 4;
    accList[0]
      .Highest_Level_of_Education_attained__pc = 'University: Post Graduate';
    accList[0].PersonBirthdate = date.newInstance(
      System.Today().year() - 36,
      2,
      11
    );
    accList[0].Type = 'Analyst';
    insert accList;

    opList[0].RecordTypeId = oppRecordTypeId_cc;
    opList[0].accountId = accList[0].id;
    opList[0].Collateral_CC__c = 'Cash';
    opList[0].Collateral_LOC__c = 'Cash';
    opList[0].Loan_to_ValueCC__c = 1;
    opList[0].StageName = 'Customer Interview';
    opList[0].CloseDate = Date.today().addDays(6);
    insert opList[0];

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'iPhone X - ' + family)
      );
    }
    //Insert products with families
    insert products;

    //Instantiate the Pricebook2 record with StandardPricebookId
    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    //Execute an update DML on the Pricebook2 record, to make IsStandard to true
    update standardPricebook;

    //Query for the Pricebook2 record, to check IsStandard field
    standardPricebook = [
      SELECT Id, IsStandard
      FROM Pricebook2
      WHERE Id = :standardPricebook.Id
    ];
    //It should return true
    System.assertEquals(true, standardPricebook.IsStandard);

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
        TestDataFactory.CreateOpportunityLineItem(opList[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accList[0].id,
      'Employeement Test'
    );
    employee.Current_Employment__c = true;
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Employment_Status__c = 'Contractual';
    employee.Industry__c = 'Financial Services';
    employee.Professional_Category__c = 'Professional';
    employee.Assessment_of_Business_Working_Capita__c = 'Good';
    employee.Nature_of_Engagement__c = 'Professional service provider';
    employee.Assessment_of_Business__c = Constants.THREE_TO_FOUR_YEARS_AND_OR;
    employee.Assessment_of_Statement__c = '	Strongly Supported';
    employee.Length_of_Trade__c = 'More than 5 years';
    Map<String, Id> recordTypeMap = Util.getRecordTypeids(
      'FinServ__Employment__c'
    );
    employee.RecordTypeId = recordTypeMap.get('Employed');
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accList[0].id,
      opList[0].id
    );
    applicant.Credit_History_in_last_24_Months__c = 'No Delinquency';
    applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
    insert applicant;

    List<Supplementary_Card_Holders__c> cardHolderList = TestDataFactory.CreateSupplementaryCardHolders(
      2,
      opList[0].id
    );
    cardHolderList[0].Account__c = accList[1].id;
    cardHolderList[1].Account__c = accList[2].id;
    insert cardHolderList;

    List<Loan_Calculator__c> loanCalculationRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    insert loanCalculationRecord;

    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculationRecord[0].Id;
    loanCalculationProductRecord[0]
      .Approved_Starting_Limit_Number__c = 10000000;
    loanCalculationProductRecord[0].Legal_Fees_including_GCT_Number__c = 1000;
    loanCalculationProductRecord[0].Stamp_Duty_Number__c = 500;
    insert loanCalculationProductRecord;
    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id refeRecordTypeId_cc = mappedApplicationRecTypes.get(
      'Referred_Application'
    );

    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accList[0].id,
      opList[0].id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = refeRecordTypeId_cc;
    applicationRecord.Adjudication_Path_picklist__c = 'ADJ_Open';
    applicationRecord.OwnerId = Util.getQueueId(Constants.REFERRED_QUEUE);
    insert applicationRecord;

    Test.startTest();
    applicationRecord.OwnerId = UserInfo.getUserId();
    update applicationRecord;
    applicationRecord.IDM_Loan_Amount_Number__c = 1000.00;
    applicationRecord.IDM_Tenure_Date__c = 10.00;
    applicationRecord.IDM_Interest_Rate_Number__c = 12.00;
    update applicationRecord;
    applicationRecord.Adjudication_Decision_picklist__c = Constants.MANUAL_DEFER;
    update applicationRecord;
    applicationRecord.OwnerId = UserInfo.getUserId();
    update applicationRecord;
    Test.stopTest();
  }
}
