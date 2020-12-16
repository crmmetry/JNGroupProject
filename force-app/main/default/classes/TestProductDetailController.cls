/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4184     16/12/2020      Ishwari G.(thinqloud)  Test Class for ProductDetailController
 **/
@isTest
public with sharing class TestProductDetailController {
  public static List<Opportunity> opList;
  @testSetup
  public static void createData() {
    opList = TestDataFactory.CreateOpportunities(1);
    List<Account> accList = TestDataFactory.CreateBasicAccounts(3, 'Test');
    accList[0].Status_of_Address__pc = 'Own (with mortgage)';
    accList[0].Years_at_Residence__pc = 4;
    accList[0]
      .Highest_Level_of_Education_attained__pc = 'University: Post Graduate';
    accList[0].PersonBirthdate = date.newInstance(
      System.Today().year() - 36,
      2,
      11
    );
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
    List<String> families = new List<String>{
      'JN Bank Auto Loan'
      /*,
      'JN Bank Line Of Credit',
      'JN Bank Term Share Loan',
      'JN Bank Credit Card',
      'JN Bank Deposit Account',
      'JN Bank Mortgage'*/
    };
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

    Map<String, Id> recordTypeMap1 = Util.getRecordTypeids(
      'FinServ__AssetsAndLiabilities__c '
    );
    FinServ__AssetsAndLiabilities__c assetsAndLiabilities = TestDataFactory.CreateAssetsAndLiabilities(
      accList[0].id,
      recordTypeMap1.get('NonfinancialAsset'),
      'Gold'
    );
    insert assetsAndLiabilities;

    Application_Asset_Liability__c applicantAssetsAndLiabilities = TestDataFactory.CreateApplicantAssetsAndLiabilities(
      applicant.Id,
      assetsAndLiabilities.Id
    );
    insert applicantAssetsAndLiabilities;
  }
  @isTest
  public static void testController() {
    createData();
    Test.startTest();
    JNConfiguration jnConfig = ProductDetailController.GetJNConfigs();
    List<SupplementaryCardHolderWrapper> cardHoldersWrapper = ProductDetailController.getSupplementaryCardHolders(
      opList[0].id
    );
    System.assertEquals(2, cardHoldersWrapper.size());
    Object productFamily = ProductDetailController.getSingleProductFamilySelection(
      opList[0].id
    );
    List<ApplicantWrapper> applicantWrapperList = ProductDetailController.getApplicantsRating(
      opList[0].id,
      2.00
    );
    Map<String, Decimal> riskRatingMap = ProductDetailController.getRiskRatingMap();
    List<Object> objList = ProductDetailController.getApplicantsAssetsAndLiabilities(
      opList[0].id
    );
    RiskRatingWrapper wrapper = ProductDetailController.getCreditRiskRating(
      opList[0].id,
      1,
      10,
      'Over The Counter',
      'Cash/Investments'
    );
    System.assertEquals('R1', wrapper.rating);
    Test.stopTest();
  }
}
