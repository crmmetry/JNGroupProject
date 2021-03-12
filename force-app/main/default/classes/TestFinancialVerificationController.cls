/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 03-12-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   03-12-2021   Travis Allen   Initial Version
 **/
@isTest
public with sharing class TestFinancialVerificationController {
  @TestSetup
  static void createData() {
    User testUser = TestDataFactory.CreateUser('testRubiconUser@email.com');
    insert testUser;

    System.runAs(testUser) {
      PermissionSetAssignment psa = TestDataFactory.CreatePermissionSetAssignment(
        testUser.Id,
        'Financial_Verification_Audit'
      );
      insert psa;

      List<Opportunity> testOpps = TestDataFactory.CreateOpportunities(1);
      testOpps[0].StageName = 'Customer Interview';
      testOpps[0].CloseDate = Date.today().addDays(6);

      List<Account> accounts = TestDataFactory.CreateBasicAccounts(1, 'Test');
      insert accounts[0];

      testOpps[0].accountId = accounts[0].Id;
      insert testOpps[0];

      Util.ExecutionCount = 2;

      Map<String, Id> recordTypesMapForApplicants = Util.getRecordTypeids(
        'Applicant__c'
      );
      String IDMRecordTypeId = Util.getMappedRecordTypeId(
        'Instant_Designing_Module_IDM',
        recordTypesMapForApplicants
      );
      Applicant__c applicant = TestDataFactory.CreateApplicant(
        accounts[0].id,
        testOpps[0].id
      );
      applicant.RecordTypeId = IDMRecordTypeId;
      applicant.Real_Estate_Market_Value_Number__c = 1000000;
      applicant.Motor_Vehicle_Market_Value_Number__c = 2000000;
      applicant.Savings_Deposit_Investments__c = 3000000;
      insert applicant;

      Map<String, Id> recordTypesMapForAssetsAndLiabilities = Util.getRecordTypeids(
        'FinServ__AssetsAndLiabilities__c'
      );
      String liabilityRecordType = Util.getMappedRecordTypeId(
        'Liability',
        recordTypesMapForAssetsAndLiabilities
      );
      FinServ__AssetsAndLiabilities__c assetLiability = TestDataFactory.CreateAssetsAndLiabilities(
        accounts[0].Id,
        liabilityRecordType,
        'Test Liability'
      );
      insert assetLiability;

      Map<String, Id> recordTypesMapForApplicantsAssetsAndLiabilities = Util.getRecordTypeids(
        'Application_Asset_Liability__c'
      );
      String debtConsolidationId = Util.getMappedRecordTypeId(
        'Debt_Consolidation',
        recordTypesMapForApplicantsAssetsAndLiabilities
      );
      List<Application_Asset_Liability__c> applicantAssetAndLiabilitiesList = new List<Application_Asset_Liability__c>();

      Application_Asset_Liability__c applicantAssetsAndLiabilities1 = TestDataFactory.CreateApplicantAssetsAndLiabilities(
        applicant.Id,
        assetLiability.Id
      );
      applicantAssetsAndLiabilities1.RecordTypeId = debtConsolidationId;
      applicantAssetsAndLiabilities1.Debt_Type_List__c = 'Unsecured Loan';
      applicantAssetsAndLiabilities1.Debt_Amount_Number__c = 500000;
      applicantAssetsAndLiabilities1.Institution_Debt_List__c = 'Access Financial Limited';
      applicantAssetAndLiabilitiesList.add(applicantAssetsAndLiabilities1);

      Application_Asset_Liability__c applicantAssetsAndLiabilities2 = TestDataFactory.CreateApplicantAssetsAndLiabilities(
        applicant.Id,
        assetLiability.Id
      );
      applicantAssetsAndLiabilities2.RecordTypeId = debtConsolidationId;
      applicantAssetsAndLiabilities2.Debt_Type_List__c = 'Motor Vehicle Loan';
      applicantAssetsAndLiabilities2.Debt_Amount_Number__c = 1000000;
      applicantAssetsAndLiabilities2.Institution_Debt_List__c = 'BPM Financial';
      applicantAssetAndLiabilitiesList.add(applicantAssetsAndLiabilities2);

      Application_Asset_Liability__c applicantAssetsAndLiabilities3 = TestDataFactory.CreateApplicantAssetsAndLiabilities(
        applicant.Id,
        assetLiability.Id
      );
      applicantAssetsAndLiabilities3.RecordTypeId = debtConsolidationId;
      applicantAssetsAndLiabilities3.Debt_Type_List__c = 'Mortgage/ Home Equity Loan';
      applicantAssetsAndLiabilities3.Debt_Amount_Number__c = 20000000;
      applicantAssetsAndLiabilities3.Institution_Debt_List__c = 'CG Co-Operative Credit Union';
      applicantAssetAndLiabilitiesList.add(applicantAssetsAndLiabilities3);

      insert applicantAssetAndLiabilitiesList;
    }
  }

  @isTest
  public static void testGetApplicantFinancialDetailsMethod() {
    Test.startTest();
    List<Opportunity> oppRecords = [SELECT Id FROM Opportunity];
    FinancialDetailsWrapper fianncialWrapper = FinancialDetailsController.getApplicantFinancialDetails(
      oppRecords[0].Id
    );
    System.assert(
      fianncialWrapper != null,
      'Financial details were not retrieved'
    );
    Test.stopTest();
  }

  @isTest
  public static void testGetApplicantConsolidatedDebtsMethod() {
    Test.startTest();
    List<Opportunity> oppRecords = [SELECT Id FROM Opportunity];
    List<DebtsConsolidatedWrapper> debtWrappers = FinancialDetailsController.getApplicantConsolidatedDebts(
      oppRecords[0].Id
    );
    System.assert(debtWrappers.size() == 3, 'Debts were not retrieved');
    Test.stopTest();
  }

  @isTest
  public static void testaveFinancialDetailsAndConsolidatedDebtsMethod() {
    User testUser = [
      SELECT Id
      FROM User
      WHERE Username = 'testRubiconUser@email.com'
    ];
    System.runAs(testUser) {
      Test.startTest();
      List<Opportunity> oppRecords = [SELECT Id FROM Opportunity];
      List<Application_Asset_Liability__c> debts = [
        SELECT Id
        FROM Application_Asset_Liability__c
      ];
      //Debt Consolidation fields
      List<Map<String, Object>> listOfConsolidatedDebts = new List<Map<String, Object>>();
      Map<String, Object> debtConsolidatedFields1 = new Map<String, Object>{
        'Id' => debts[0].Id,
        'debtTypeVerified' => 'Unsecured Loan',
        'debtAmountVerified' => 5435.32,
        'institutionDebtVerified' => 'Access Financial Limited',
        'accountNumber' => 123456789
      };
      Map<String, Object> debtConsolidatedFields2 = new Map<String, Object>{
        'Id' => debts[1].Id,
        'debtTypeVerified' => 'Motor Vehicle Loan',
        'debtAmountVerified' => 5435.32,
        'institutionDebtVerified' => 'BPM Financial',
        'accountNumber' => 123456789
      };
      Map<String, Object> debtConsolidatedFields3 = new Map<String, Object>{
        'Id' => debts[2].Id,
        'debtTypeVerified' => 'Mortgage/ Home Equity Loan',
        'debtAmountVerified' => 5435.33,
        'institutionDebtVerified' => 'CG Co-Operative Credit Union',
        'accountNumber' => 9450.32
      };
      listOfConsolidatedDebts.add(debtConsolidatedFields1);
      listOfConsolidatedDebts.add(debtConsolidatedFields2);
      listOfConsolidatedDebts.add(debtConsolidatedFields3);

      Map<String, Object> financialVerificationFields = new Map<String, Object>{
        'realEstateHoldingsAssetsVerified' => 10000000,
        'mortgageBalanceVerified' => 20000000,
        'personalAndFamilyExpensesVerified' => 2000000000,
        'otherIncomeVerified' => 9450.32,
        'totalLiabilitiesVerified' => 20000000
      };

      Integer status = FinancialDetailsController.saveFinancialDetailsAndConsolidatedDebts(
        financialVerificationFields,
        oppRecords[0].Id,
        listOfConsolidatedDebts
      );
      System.assert(status == Constants.STATUS_SUCCESS_CODE, 'Save Failed');
      Test.stopTest();
    }
  }

  @isTest
  public static void testGetPickListValues() {
    Test.startTest();

    List<String> names = new List<String>();

    names.add('Type');
    names.add('Highest_Level_of_Education_attained__pc');

    Object pickListValues = FinancialDetailsController.getPickListValuesList(
      'Account',
      names
    );
    System.assert(pickListValues != null, 'Picklists fields not being added.');
    Test.stopTest();
  }
}
