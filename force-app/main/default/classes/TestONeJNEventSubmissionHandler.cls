/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 07-01-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   06-29-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
@isTest
public class TestONeJNEventSubmissionHandler {
  /**
   * @description test method for credit card pre-assessment submission
   * @author Trupti Zende (Thinqloud) | 06-29-2021
   **/
  @isTest
  public static void handleCreditCardPreAssessmentEvent() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids(
      Constants.OPPORTUNITYSTRING
    );
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
    opps2[0].Rubicon_Path_list__c = Constants.PRE_ASSESSMENT_SUBMISSION;
    opps2[0].Product_Category__c = Constants.CREDITCARD_PRODUCT_FAMILY;
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
    jsonGen.writeStringField(
      'preAssessmentDecision',
      Constants.PASS_PRE_APPROVAL
    );
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
    system.assertEquals(Constants.PASS_PRE_APPROVAL, opp.Pre_Approval_list__c);
  }
  /**
   * @description test method for Credit Card final assessment submission
   * @author Trupti Zende (Thinqloud) | 06-29-2021
   **/
  @isTest
  public static void handleCreditCardFinalAssessmentEvent() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids(
      Constants.OPPORTUNITYSTRING
    );
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
    opps2[0].Product_Category__c = Constants.CREDITCARD_PRODUCT_FAMILY;
    opps2[0].Rubicon_Path_list__c = Constants.FINAL_ASSESMENT_SUBMISSION;
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
    appList2.add(applicationRecord);
    insert appList2;
    String jsonData = TestDataFactory.getJsonString(
      Constants.GET_CREDITCARD_FINAL_ASSESSMENT,
      'JN Bank Credit Card'
    );
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
    system.assertEquals(
      Constants.REFERRED_DECISION,
      opp.Final_Assessment_Decision_list__c
    );
  }
  /**
   * @description test method for Unsecured Loan  pre-assessment submission
   * @author Trupti Zende (Thinqloud) | 06-29-2021
   **/
  @isTest
  public static void handleUnsecuredLoanPreAssessmentEvent() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids(
      Constants.OPPORTUNITYSTRING
    );
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
    opps2[0].Rubicon_Path_list__c = Constants.PRE_ASSESSMENT_SUBMISSION;
    opps2[0].Product_Category__c = Constants.UNSECURED_PRODUCT_FAMILY;
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
    appList2.add(applicationRecord);
    insert appList2;

    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT,
      'JN Bank Unsecured Loan'
    );

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
    Opportunity opp = [
      SELECT Id, Pre_Approval_list__c
      FROM Opportunity
      WHERE Id = :opps2.get(0).Id
    ];
    system.assertEquals(Constants.PASS_PRE_APPROVAL, opp.Pre_Approval_list__c);
  }
  /**
   * @description test method for Unsecured Loan final assessment submission
   * @author Trupti Zende (Thinqloud) | 06-29-2021
   **/
  @isTest
  public static void handleUnsecuredLoanFinalAssessmentEvent() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids(
      Constants.OPPORTUNITYSTRING
    );
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
    opps2[0].Product_Category__c = Constants.UNSECURED_PRODUCT_FAMILY;
    opps2[0].Rubicon_Path_list__c = Constants.FINAL_ASSESMENT_SUBMISSION;
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
    appList2.add(applicationRecord);
    insert appList2;

    String jsonData = TestDataFactory.getJsonString(
      Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT,
      'JN Bank Unsecured Loan'
    );
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
    system.assertEquals(
      Constants.REFERRED_DECISION,
      opp.Final_Assessment_Decision_list__c
    );
  }
}
