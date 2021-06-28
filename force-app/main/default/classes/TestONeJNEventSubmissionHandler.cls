@isTest
public class TestONeJNEventSubmissionHandler {
  @isTest
  public static void handleCreditCardPreAssessmentEvent() {
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
    opps2[0].Rubicon_Path_list__c = 'Pre-Assessment Submission';
    opps2[0].Product_Category__c = 'JN Bank Credit Card';
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
    appList2.add(applicationRecord);
    insert appList2;

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

    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.RETURN_CREDITCARD_PRE_ASSESSMENT;
    Fli1.externalId = 'abctest';
    Fli1.sfRecordId = opps2[0].Id;
    Fli1.body = jsonData;
    Flilist1.add(Fli1);

    list<ONeJNEventSubmissionHandler.FlowInputs> Flilist = new List<ONeJNEventSubmissionHandler.FlowInputs>();
    ONeJNEventSubmissionHandler.FlowInputs Fli = new ONeJNEventSubmissionHandler.FlowInputs();
    Fli.eventType = Constants.GET_CREDITCARD_PRE_ASSESSMENT;
    Fli.opportunityList = opps2;
    //Fli.applicationList = appList2;
    Flilist.add(Fli);
    Test.startTest();

    ONeJNEventSubmissionHandler.HandleEventSubmission(Flilist);
    OneJNOutputEventHandler.HandleEvent(Flilist1);

    Test.stopTest();
    Opportunity opp = [
      SELECT Id, Pre_Approval_list__c
      FROM Opportunity
      WHERE Id = :opps2.get(0).Id
    ];
    system.assertEquals('Pass', opp.Pre_Approval_list__c);
  }
  @isTest
  public static void handleCreditCardFinalAssessmentEvent() {
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
    opps2[0].Product_Category__c = 'JN Bank Credit Card';
    opps2[0].Rubicon_Path_list__c = 'Final Assessment Submission';
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
    appList2.add(applicationRecord);
    insert appList2;

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

    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT;
    Fli1.externalId = 'abctest';
    Fli1.sfRecordId = opps2[0].Id;
    Fli1.body = jsonData;
    Flilist1.add(Fli1);

    list<ONeJNEventSubmissionHandler.FlowInputs> Flilist = new List<ONeJNEventSubmissionHandler.FlowInputs>();
    ONeJNEventSubmissionHandler.FlowInputs Fli = new ONeJNEventSubmissionHandler.FlowInputs();
    Fli.eventType = Constants.GET_CREDITCARD_FINAL_ASSESSMENT;
    Fli.opportunityList = opps2;
    Fli.applicationList = appList2;
    Flilist.add(Fli);
    Test.startTest();
    ONeJNEventSubmissionHandler.HandleEventSubmission(Flilist);
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    Opportunity opp = [
      SELECT Id, Final_Assessment_Decision_list__c
      FROM Opportunity
      WHERE Id = :opps2.get(0).Id
    ];
    system.assertEquals('Referred', opp.Final_Assessment_Decision_list__c);
  }
  @isTest
  public static void handleUnsecuredLoanPreAssessmentEvent() {
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
    opps2[0].Rubicon_Path_list__c = 'Pre-Assessment Submission';
    opps2[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps2[0].AccountId = accounts[0].Id;
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
    appList2.add(applicationRecord);
    insert appList2;
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

    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT;
    Fli1.externalId = 'abctest';
    Fli1.sfRecordId = opps2[0].Id;
    Fli1.body = jsonData;
    Flilist1.add(Fli1);
    list<ONeJNEventSubmissionHandler.FlowInputs> Flilist = new List<ONeJNEventSubmissionHandler.FlowInputs>();
    ONeJNEventSubmissionHandler.FlowInputs Fli = new ONeJNEventSubmissionHandler.FlowInputs();
    Fli.eventType = Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT;
    Fli.opportunityList = opps2;
    Fli.applicationList = appList2;
    Flilist.add(Fli);
    Test.startTest();
    ONeJNEventSubmissionHandler.HandleEventSubmission(Flilist);
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
  }
  @isTest
  public static void handleUnsecuredLoanFinalAssessmentEvent() {
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
    opps2[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps2[0].Rubicon_Path_list__c = 'Final Assessment Submission';
    opps2[0].AccountId = accounts[0].Id;
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
    appList2.add(applicationRecord);
    insert appList2;

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

    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT;
    Fli1.externalId = 'abctest';
    Fli1.sfRecordId = opps2[0].Id;
    Fli1.body = jsonData;
    Flilist1.add(Fli1);

    list<ONeJNEventSubmissionHandler.FlowInputs> Flilist = new List<ONeJNEventSubmissionHandler.FlowInputs>();
    ONeJNEventSubmissionHandler.FlowInputs Fli = new ONeJNEventSubmissionHandler.FlowInputs();
    Fli.eventType = Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT;
    Fli.opportunityList = opps2;
    Fli.applicationList = appList2;
    Flilist.add(Fli);
    Test.startTest();
    ONeJNEventSubmissionHandler.HandleEventSubmission(Flilist);
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    Opportunity opp = [
      SELECT Id, Final_Assessment_Decision_list__c
      FROM Opportunity
      WHERE Id = :opps2.get(0).Id
    ];
    system.assertEquals('Referred', opp.Final_Assessment_Decision_list__c);
  }
}
