/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 03-08-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   03-08-2021   Travis Allen   Initial Version
 **/
@isTest
public inherited sharing class TestRubiconProductDetailsController {
  @testSetup
  public static void createData() {
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
    List<Account> accList = TestDataFactory.CreateBasicAccounts(3, 'Test');
    accList[0].Status_of_Address__pc = Constants.OWN;
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
    Util.ExecutionCount = 2;

    opList[0].accountId = accList[0].id;
    opList[0].Collateral_CC__c = 'Cash';
    opList[0].Collateral_LOC__c = 'Cash';
    opList[0].Loan_to_ValueCC__c = 1;
    opList[0].StageName = 'Customer Interview';
    opList[0].CloseDate = Date.today().addDays(6);
    insert opList[0];

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Auto Loan' };
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
  }

  @isTest
  public static void testSupplementaryCardHoldersMethod() {
    List<Opportunity> opList = [SELECT Id FROM Opportunity];
    Test.startTest();
    List<SupplementaryCardHolderWrapper> cardHoldersWrapper = RubiconProductDetailsController.getSupplementaryCardHolders(
      opList[0].id
    );
    System.assertEquals(2, cardHoldersWrapper.size());
    Test.stopTest();
  }

  @isTest
  public static void testProductFamilySelection() {
    List<Opportunity> opList = [SELECT Id FROM Opportunity];
    Test.startTest();
    Object productFamily = RubiconProductDetailsController.getSingleProductFamilySelection(
      opList[0].id
    );
    Test.stopTest();
  }

  @isTest
  public static void testGetIDMDataMap() {
    List<Opportunity> opList = [SELECT Id FROM Opportunity];
    Test.startTest();
    Object loanCalcRecord = RubiconProductDetailsController.getIDMProductDetails(
      opList[0].Id
    );
    System.assert(
      loanCalcRecord != null,
      'Loan Calculation Record Was not retrieved'
    );
    Test.stopTest();
  }

  @isTest
  public static void testGetApplicantDetails() {
    List<Opportunity> opList = [SELECT Id FROM Opportunity];
    Test.startTest();
    Object applicantRecord = RubiconProductDetailsController.getApplicantsDetails(
      opList[0].Id
    );
    System.assert(
      applicantRecord != null,
      'Applicant Record Was not retrieved'
    );
    Test.stopTest();
  }

  @isTest
  public static void testGetOpportunityDetails() {
    List<Opportunity> opList = [SELECT Id FROM Opportunity];
    Test.startTest();
    Object oppRecord = RubiconProductDetailsController.getOpportunityDetails(
      opList[0].Id
    );
    System.assert(oppRecord != null, 'Opportunity Record Was not retrieved');
    Test.stopTest();
  }

  @isTest
  public static void testGetPickListValues() {
    Test.startTest();

    List<String> names = new List<String>();

    names.add('Type');
    names.add('Highest_Level_of_Education_attained__pc');

    Object pickListValues = RubiconProductDetailsController.getPickListValuesList(
      'Account',
      names
    );
    System.assert(pickListValues != null, 'Picklists fields not being added.');
    Test.stopTest();
  }

  @isTest
  public static void testUpdateFieldsOnOpportunity() {
    List<Opportunity> opList = [SELECT Id, Amount FROM Opportunity];
    Map<String, Object> mapFields = new Map<String, Object>();
    mapFields.put('Amount', 10000);
    Test.startTest();
    Object result = RubiconProductDetailsController.updateFieldsOnOpportunity(
      opList[0].Id,
      mapFields
    );
    System.assert(
      result === Constants.SUCCESS,
      'Opportunity Record Was not updated'
    );
    Test.stopTest();
  }
}
