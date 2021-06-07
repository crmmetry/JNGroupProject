/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 05-28-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   05-18-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
@isTest
public class CaseTriggerHandler_Test {
  @testSetup
  public static void createData() {
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
    applicationRecord.Adjudication_Path_picklist__c = Constants.OPEN_STATUS;
    insert applicationRecord;

    SlaProcess process = TestDataFactory.getEntitlementProcessNames(
      Constants.ENTITLEMENT_RECORD_NAME
    );
    Entitlement entitlement = TestDataFactory.createEntitlementRecords(
      Constants.ENTITLEMENT_RECORD_NAME,
      accList[0].Id,
      System.today(),
      process.Id
    );
    insert entitlement;
  }

  /**
   * @description : this method tests scenario when application is newly created the entitlementId should gets assigned to it.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  @isTest
  public static void checkAddEntitlementMethod() {
    Test.startTest();
    List<Application__c> applicationList = [
      SELECT Id, Adjudication_Path_picklist__c
      FROM Application__c
    ];
    if (applicationList.size() > 0) {
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;
    }

    List<Case> caseList = [SELECT Id, Status, EntitlementId FROM Case];
    System.assertEquals(1, caseList.size());
    System.assert(caseList[0].EntitlementId <> null);
    Test.stopTest();
  }
  /**
   * @description : this method tests scenario when application is reassigned then the SLA should be reset for the new owner.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  @isTest
  public static void checkReassignmentForMilestones() {
    List<Application__c> applicationList = [
      SELECT Id, Adjudication_Path_picklist__c
      FROM Application__c
    ];
    if (applicationList.size() > 0) {
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.IN_PROGRESS_STATUS;
      update applicationList;
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;
    }
  }

  /**
   * @description :this method tests scenario when application is in In Progress status
   * and manual decision is made as "Defer" then existing case milestone should be closed and New should be start.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  @isTest
  public static void checkDeferalManagerMileston() {
    List<Application__c> applicationList = [
      SELECT Id, Adjudication_Path_picklist__c
      FROM Application__c
    ];
    if (applicationList.size() > 0) {
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;

      applicationList[0].IDM_Loan_Amount_Number__c = 1000.00;
      applicationList[0].IDM_Tenure_Date__c = 10.00;
      applicationList[0].IDM_Interest_Rate_Number__c = 12.00;
      update applicationList;
      applicationList[0]
        .Adjudication_Decision_picklist__c = Constants.MANUAL_DEFER;
      update applicationList;
    }
  }

  /**
   * @description this method tests scenario when application is in "Deferred" status
   * and manual decision is made then case milestone should be closed.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  @isTest
  public static void checkClosedCaseMilestone() {
    List<Application__c> applicationList = [
      SELECT Id, Adjudication_Path_picklist__c
      FROM Application__c
    ];
    if (applicationList.size() > 0) {
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;
      applicationList[0].IDM_Loan_Amount_Number__c = 1000.00;
      applicationList[0].IDM_Tenure_Date__c = 10.00;
      applicationList[0].IDM_Interest_Rate_Number__c = 12.00;
      update applicationList;
      applicationList[0]
        .Adjudication_Decision_picklist__c = Constants.MANUAL_DEFER;
      update applicationList;
      applicationList[0]
        .Adjudication_Decision_picklist__c = Constants.MANUAL_APPROVE;
      update applicationList;
    }
  }

  /**
   * @description : this method tests scenario when application is in "ADJ In Progress" status
   * and manual decision is made then case milestone should be closed.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  @isTest
  public static void checkClosedCaseMilestone1() {
    List<Application__c> applicationList = [
      SELECT Id, Adjudication_Path_picklist__c
      FROM Application__c
    ];
    if (applicationList.size() > 0) {
      applicationList[0]
        .Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
      update applicationList;
      applicationList[0].IDM_Loan_Amount_Number__c = 1000.00;
      applicationList[0].IDM_Tenure_Date__c = 10.00;
      applicationList[0].IDM_Interest_Rate_Number__c = 12.00;
      update applicationList;
      applicationList[0]
        .Adjudication_Decision_picklist__c = Constants.MANUAL_APPROVE;
      //applicationList[0].Adjudication_Path_picklist__c = 'Closed';

      update applicationList;
    }
  }
}
