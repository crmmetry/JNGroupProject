/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4185     16/12/2020      Ishwari G.(thinqloud)  Test Class for JNApplicantFlowController
 **/
@isTest
public with sharing class TestJNApplicantFlowController {
  public static Applicant__c applicant;

  private class RestCallOutMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
      List<String> valueList = new List<String>{
        'Unconnected',
        'JN Bank Employee',
        'Other JN Group Employee',
        'JN Bank Director',
        'Other JN Group Director'
      };
      String fullJson = JSON.serialize(valueList);
      String json = '{"values" : [ {"attributes" : null,"label" : "Advertisement","validFor" : [ ], "value" : "Unconnected"}]}';
      HTTPResponse res = new HTTPResponse();
      res.setHeader('Content-Type', 'text/json');
      res.setBody(json);
      res.setStatusCode(200);
      return res;
    }
  }
  @isTest
  public static void testController1() {
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
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

    applicant = TestDataFactory.CreateApplicant(accList[0].id, opList[0].id);
    applicant.Credit_History_in_last_24_Months__c = 'No Delinquency';
    applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
    insert applicant;

    Test.setMock(HttpCalloutMock.class, new RestCallOutMock());
    Test.startTest();
    List<Account> accounts = [SELECT Id FROM Account];
    List<String> IDs = new List<String>();
    for (Account acc : accounts) {
      IDs.add(acc.Id);
    }
    List<Account> accountList = JNApplicantFlowController.getContactsAccount(
      IDs
    );
    List<Account> accountList1 = JNApplicantFlowController.getAccounts(IDs);
    Object obj = JNApplicantFlowController.getApplicantDetails(applicant.Id);
    Object obj1 = JNApplicantFlowController.getFullApplicantDetails(
      applicant.Id
    );

    Map<String, Id> recordTypeMap = Util.getRecordTypeids('Applicant__c');
    List<String> picklistValues = JNApplicantFlowController.getPickListValues(
      'Applicant__c',
      'Affiliation_Type__c',
      null,
      null
    );
    List<String> picklistValues1 = JNApplicantFlowController.getPickListValues(
      'Applicant__c',
      'Affiliation_Type__c',
      'Short_Summary_of_Income',
      null
    );
    Map<String, List<String>> fieldsWithValues = JNApplicantFlowController.getPickListValuesList(
      'Applicant__c',
      new List<String>{ 'CreditInfo_Rating__c', 'JN_Group_Employee__c' }
    );
    Map<String, List<String>> fieldsWithValues1 = JNApplicantFlowController.getMultiPickListValuesList(
      new List<String>{ 'Applicant__c' },
      new List<String>{ 'CreditInfo_Rating__c', 'JN_Group_Employee__c' }
    );
    String rtName = JNApplicantFlowController.getRecordTypeId(
      'Empty_Application'
    );
    Object obj2 = JNApplicantFlowController.updateApplicantDetailsBasic(
      applicant
    );
    Object obj3 = JNApplicantFlowController.updateApplicantDetails(applicant);
    Test.stopTest();
  }

  @isTest
  public static void testController() {
    List<Opportunity> opList = TestDataFactory.CreateOpportunities(1);
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

    applicant = TestDataFactory.CreateApplicant(accList[0].id, opList[0].id);
    applicant.Credit_History_in_last_24_Months__c = 'No Delinquency';
    applicant.Assessment_of_Applicant_Net_Worth__c = 'Reasonable net worth';
    insert applicant;

    Test.setMock(HttpCalloutMock.class, new RestCallOutMock());
    Test.startTest();
    List<Account> accounts = [SELECT Id FROM Account];
    List<String> IDs = new List<String>();
    for (Account acc : accounts) {
      IDs.add(acc.Id);
    }

    Object obj = JNApplicantFlowController.getApplicantDetails(null);
    Object obj1 = JNApplicantFlowController.getFullApplicantDetails(null);

    Map<String, Id> recordTypeMap = Util.getRecordTypeids('Applicant__c');
    List<String> picklistValues = JNApplicantFlowController.getPickListValues(
      'Applicant__c',
      'Affiliation_Type__c',
      null,
      recordTypeMap.get('Empty_Application')
    );
    Test.stopTest();
  }
}
