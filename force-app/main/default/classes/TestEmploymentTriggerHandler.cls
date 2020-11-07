@isTest
public class TestEmploymentTriggerHandler {
  @testSetup
  public static void setup() {
    Integer count = 5;
    List<Account> accs = TestDataFactory.CreateBasicAccounts(count, 'Dynamics');
    // Insert Accounts
    insert accs;

    List<Opportunity> opps = TestDataFactory.CreateOpportunities(count);
    for (Integer i = count - 1; i >= 0; i--) {
      opps[i].AccountId = accs[i].Id;
    }
    // Insert opportunities
    insert opps;

    List<FinServ__Employment__c> emps = new List<FinServ__Employment__c>();
    // Create employee with accounts
    for (Integer i = 0; i < count; i++) {
      emps.add(TestDataFactory.CreateEmployment(accs[0].Id, 'Employment ' + i));
    }
    FinServ__Employment__c emp = emps[0];
    emp.Current_Employment__c = true;
    insert emps;
  }

  @isTest
  public static void shouldCheckCurrentEmployments_Update() {
    Test.startTest();
    List<FinServ__Employment__c> employments = [
      SELECT Account__c, Id, Name
      FROM FinServ__Employment__c
    ];
    System.assert(!employments.isEmpty(), 'employments is empty');
    for (FinServ__Employment__c record : employments) {
      System.assert(
        record.Account__c != null,
        'Employment Account' +
        record.Name +
        ' is null'
      );
    }
    FinServ__Employment__c emp = employments[1];
    emp.Current_Employment__c = true;
    try {
      update employments;
    } catch (DMLException e) {
      Boolean include = e.getMessage()
        .contains('You can only have One Employment record marked as');
      System.assertEquals(true, include, e.getMessage());
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldCheckCurrentEmployments_Delete() {
    Test.startTest();
    List<FinServ__Employment__c> employments = [
      SELECT Account__c, Id, Name
      FROM FinServ__Employment__c
    ];
    System.assert(!employments.isEmpty(), 'employments is empty');
    for (FinServ__Employment__c record : employments) {
      System.assert(
        record.Account__c != null,
        'Employment Account' +
        record.Name +
        ' is null'
      );
    }
    delete employments;
    Test.stopTest();
  }
}
