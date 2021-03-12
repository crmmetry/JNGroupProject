@isTest
public class testClass_RUB191_5 {
  //Account
  public static Account testAccountObj;
  public static list<Account> testAccountObjs;

  //Opportunity
  public static Opportunity testOpportunityObj = new Opportunity();
  public static List<Opportunity> testOpportunityLst;

  //Document Types
  public static map<String, id> mapOfDocTypes;
  public static list<DocumentType> listOfDocTypes;

  public static list<DocumentChecklistItem> docChkListItemList;
  public static DocumentChecklistItem testDocChkListItem1;
  public static DocumentChecklistItem testDocChkListItem2;
  public static DocumentChecklistItem testDocChkListItem3;
  public static DocumentChecklistItem testDocChkListItem4;
  public static DocumentChecklistItem testDocChkListItem5;
  public static DocumentChecklistItem testDocChkListItem6;
  public static DocumentChecklistItem testDocChkListItem7;
  public static DocumentChecklistItem testDocChkListItem8;

  @testSetup
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

    //------Create Opportunity--------//
    testOpportunityLst = TestDataFactory.CreateOpportunities(1);
    testOpportunityObj = testOpportunityLst.get(0);
    testOpportunityObj.AccountId = testAccountObj.Id;
    testOpportunityObj.StageName = 'Submitted and Processing';
    testOpportunityObj.Signing_Legal_Documents_Promissory_flag__c = false;
    testOpportunityObj.Documents_Complete_flag__c = false;
    testOpportunityObj.Submission_Of_Signed_Deduction_of_Salary__c = '';
    insert testOpportunityObj;

    //------Get Document Type--------//
    mapOfDocTypes = new Map<String, Id>();
    listOfDocTypes = new List<DocumentType>();

    listOfDocTypes = [SELECT Id, DeveloperName FROM DocumentType];
    if (listOfDocTypes != null) {
      if (listOfDocTypes.size() > 0) {
        for (DocumentType record : listOfDocTypes) {
          mapOfDocTypes.put(record.DeveloperName, record.Id);
        }
      }
    }

    docChkListItemList = new List<DocumentChecklistItem>();
    testDocChkListItem1 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Promissory_Note'),
      'Attach Promissory Doc',
      'New'
    );
    docChkListItemList.add(testDocChkListItem1);
    testDocChkListItem2 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Signed_Salary_Deduction'),
      'Attach Signed Salary Deduction',
      'New'
    );
    docChkListItemList.add(testDocChkListItem2);
    testDocChkListItem3 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Proof_of_income_Audited_Financial_Statements'),
      'Attach Proof of income Audited FinancialStatements',
      'New'
    );
    docChkListItemList.add(testDocChkListItem3);
    testDocChkListItem4 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Proof_of_income_Bank_Statements'),
      'Attach Proof of income Bank Statements',
      'New'
    );
    docChkListItemList.add(testDocChkListItem4);
    testDocChkListItem5 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Proof_of_income_Other'),
      'Attach Proof of income Other',
      'New'
    );
    docChkListItemList.add(testDocChkListItem5);
    testDocChkListItem6 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Proof_of_income_Payslips'),
      'Attach Proof of income Payslips',
      'New'
    );
    docChkListItemList.add(testDocChkListItem6);
    testDocChkListItem7 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Proof_of_income_Unaudited_Financial_Statements'),
      'Attach Proof of income Unaudited Financial Statements',
      'New'
    );
    docChkListItemList.add(testDocChkListItem7);
    testDocChkListItem8 = TestDataFactory.CreateDocumentCheckListItem(
      testOpportunityObj.Id,
      mapOfDocTypes.get('Signed_Standing_Order'),
      'Attach Signed Standing Order',
      'New'
    );
    docChkListItemList.add(testDocChkListItem8);
    insert docChkListItemList;
  }

  @isTest
  public static void test1_Rub191_PromissoryFlagTest() {
    Test.StartTest();
    CreateData();

    ContentVersion cntVersionPromissory = TestDataFactory.CreateContentVersionRecord(
      'Test1',
      'test.jpg',
      'Sample test data',
      true
    );
    upsert cntVersionPromissory;

    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = documents[0].Id;
    cdl.LinkedEntityId = testDocChkListItem1.Id;
    upsert cdl;

    Opportunity updateOpp = new Opportunity();
    updateOpp = [
      SELECT
        Signing_Legal_Documents_Promissory_flag__c,
        Submission_Of_Signed_Deduction_of_Salary__c,
        Documents_Complete_flag__c
      FROM Opportunity
      WHERE Id = :testOpportunityObj.Id
    ];
    system.assertEquals(
      true,
      updateOpp.Signing_Legal_Documents_Promissory_flag__c,
      'Error - Promissory Note flag'
    );
    system.assertNotEquals(
      'Yes',
      updateOpp.Submission_Of_Signed_Deduction_of_Salary__c,
      'Error - Signed Salary Ded flag'
    );
    system.assertNotEquals(
      true,
      updateOpp.Documents_Complete_flag__c,
      'Error - Complete Doc flag'
    );

    Test.StopTest();
  }

  @isTest
  public static void test1_Rub191_SignedSalaFlagTest() {
    Test.StartTest();
    CreateData();
    ContentVersion cntVersionSigned = TestDataFactory.CreateContentVersionRecord(
      'Test2',
      'test.jpg',
      'Sample test data',
      true
    );
    upsert cntVersionSigned;

    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];
    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = documents[0].Id;
    cdl.LinkedEntityId = testDocChkListItem2.Id;
    upsert cdl;

    Opportunity updateOpp = new Opportunity();
    updateOpp = [
      SELECT
        Signing_Legal_Documents_Promissory_flag__c,
        Submission_Of_Signed_Deduction_of_Salary__c,
        Documents_Complete_flag__c
      FROM Opportunity
      WHERE Id = :testOpportunityObj.Id
    ];

    system.assertEquals(
      false,
      updateOpp.Signing_Legal_Documents_Promissory_flag__c,
      'Error - Promissory Note flag'
    );
    system.assertEquals(
      'Yes',
      updateOpp.Submission_Of_Signed_Deduction_of_Salary__c,
      'Error - Signed Salary Ded flag'
    );
    system.assertNotEquals(
      true,
      updateOpp.Documents_Complete_flag__c,
      'Error - Complete Doc flag'
    );

    Test.StopTest();
  }

  @isTest
  public static void test1_Rub229_PreAssessmentFlag() {
    Test.StartTest();
    CreateData();
    testOpportunityObj.StageName = Constants.OPPORTUNITY_PRE_ASSESSMENT_STAGE;
    update testOpportunityObj;

    //---Create a content version document---//
    ContentVersion cntVersionSigned = TestDataFactory.CreateContentVersionRecord(
      'Test2',
      'test.jpg',
      'Sample test data',
      true
    );
    upsert cntVersionSigned;
    //---As soon as content version document is inserted in Salesforce, its respective ---//
    //---ContentDocument is prepared and we can fetch it by Select SOQL as below ---//
    List<ContentDocument> documents = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];

    ContentDocumentLink cdl = new ContentDocumentLink();
    cdl.ContentDocumentId = documents[0].Id;
    cdl.LinkedEntityId = testDocChkListItem3.Id;
    upsert cdl;

    Opportunity updatedOpp = new Opportunity();
    updatedOpp = [
      SELECT
        Signing_Legal_Documents_Promissory_flag__c,
        Submission_Of_Signed_Deduction_of_Salary__c,
        Documents_Complete_flag__c,
        Pre_Assessment_Submitted_flag__c
      FROM Opportunity
      WHERE Id = :testOpportunityObj.Id
    ];

    system.assertEquals(
      true,
      updatedOpp.Pre_Assessment_Submitted_flag__c,
      'Error - Pre_Assessment_Submitted_flag__c flag'
    );
    system.assertEquals(
      false,
      updatedOpp.Signing_Legal_Documents_Promissory_flag__c,
      'Error - Promissory Note flag'
    );
    system.assertNotEquals(
      'Yes',
      updatedOpp.Submission_Of_Signed_Deduction_of_Salary__c,
      'Error - Signed Salary Ded flag'
    );
    system.assertNotEquals(
      true,
      updatedOpp.Documents_Complete_flag__c,
      'Error - Complete Doc flag'
    );

    Test.StopTest();
  }

  @isTest
  public static void test1_Rub191_BothFlagTest() {
    Test.StartTest();
    CreateData();
    //------------1------------------//
    ContentVersion cntVersionPromissory = TestDataFactory.CreateContentVersionRecord(
      'Test1',
      'test1.jpg',
      'Sample test data 1',
      true
    );
    upsert cntVersionPromissory;

    List<ContentDocument> documents1 = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];
    ContentDocumentLink cdl1 = new ContentDocumentLink();
    cdl1.ContentDocumentId = documents1[0].Id;
    cdl1.LinkedEntityId = testDocChkListItem1.Id;

    //------------2------------------//
    ContentVersion cntVersionSigned = TestDataFactory.CreateContentVersionRecord(
      'Test2',
      'test2.jpg',
      'Sample test data 2',
      true
    );
    upsert cntVersionSigned;

    List<ContentDocument> documents2 = [
      SELECT Id, Title, LatestPublishedVersionId
      FROM ContentDocument
    ];
    ContentDocumentLink cdl2 = new ContentDocumentLink();
    cdl2.ContentDocumentId = documents2[1].Id;
    cdl2.LinkedEntityId = testDocChkListItem2.Id;

    upsert cdl1;
    upsert cdl2;

    Opportunity updateOpp = new Opportunity();
    updateOpp = [
      SELECT
        Signing_Legal_Documents_Promissory_flag__c,
        Submission_Of_Signed_Deduction_of_Salary__c,
        Documents_Complete_flag__c
      FROM Opportunity
      WHERE Id = :testOpportunityObj.Id
    ];

    system.assertEquals(
      true,
      updateOpp.Signing_Legal_Documents_Promissory_flag__c,
      'Error - Promissory Note flag'
    );
    system.assertEquals(
      'Yes',
      updateOpp.Submission_Of_Signed_Deduction_of_Salary__c,
      'Error - Signed Salary Ded flag'
    );
    system.assertNotEquals(
      true,
      updateOpp.Documents_Complete_flag__c,
      'Error - Complete Doc flag'
    );

    Test.StopTest();
  }
}
