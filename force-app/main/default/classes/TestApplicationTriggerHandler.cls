/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-17-2021
 * @last modified by  : Remario Richards
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
          .contains(Constants.ONLY_ONE_APPLICATION)
        ? true
        : false;
      System.assertEquals(expectedExceptionThrown, true);
    }
    ApplicationTriggerHandler.checkOpportunityHasOneApplication();
    Test.stopTest();
  }
}
