/**
 * @description       : Test class
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-06-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-06-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
@isTest
public with sharing class TestOneJNErrorReportingController {
  /**
   * @description : get the error logs related to the opportunity object
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   **/
  @IsTest
  static void testOpportunityErrorLogs() {
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
    accounts[0].RIM_no__c = '1111';
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

    List<Application__c> appList = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    appList.add(applicationRecord);
    insert appList;

    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeStringField('SFRecordId', opps[0].Id);
    jsonGen.writeStringField('ErrorMessage', 'Application id was not found.');
    jsonGen.writeStringField('ErrorCode', '16003');
    jsonGen.writeStringField(
      'SourceEvent',
      'JNGroup.OneJN.CreditInfo.Domain.Events.GetApplicationIdEvent'
    );
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();

    List<OneJN_Event_Log__c> eventLogList = TestDataFactory.createOneJNEventLog(
      appList[0].Id,
      Constants.GENERIC_ERROR_EVENT,
      jsonData,
      1
    );
    insert eventLogList;

    Test.startTest();
    Map<Id, Map<String, String>> errorLogMap = OneJNErrorReportingController.getErrorLogs(
      opps[0].Id
    );
    Test.stopTest();
  }

  /**
   * @description : get the error logs related to the Application object
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   **/
  @isTest
  static void testApplicationErrorLogs() {
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
    accounts[0].RIM_no__c = '1111';
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

    List<Application__c> appList = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    appList.add(applicationRecord);
    insert appList;

    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeStringField('SFRecordId', opps[0].Id);
    jsonGen.writeStringField('ErrorMessage', 'Application id was not found.');
    jsonGen.writeStringField('ErrorCode', '16003');
    jsonGen.writeStringField(
      'SourceEvent',
      'JNGroup.OneJN.CreditInfo.Domain.Events.GetApplicationIdEvent'
    );
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();

    List<OneJN_Event_Log__c> eventLogList = TestDataFactory.createOneJNEventLog(
      appList[0].Id,
      Constants.GENERIC_ERROR_EVENT,
      jsonData,
      1
    );
    insert eventLogList;

    Test.startTest();
    Map<Id, Map<String, String>> errorLogMap = OneJNErrorReportingController.getErrorLogs(
      appList[0].Id
    );
    Test.stopTest();
  }
}
