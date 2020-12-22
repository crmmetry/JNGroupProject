/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4188     16/12/2020      Ishwari G.(thinqloud)  Test Class for LeadassignmentSchedulable
 **/
@isTest
public with sharing class TestLeadAssignmentSchedulable {
  @testSetup
  public static void createData() {
    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now())
      .replace(' ', '')
      .replace(':', '')
      .replace('-', '');
    Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
    String uniqueName = orgId + dateString + randomInt;
    User newUser = TestDataFactory.CreateUser(uniqueName + '@test.com');
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Call Centre - Sales'];
    newUser.ProfileId = p.Id;
    insert newUser;

    Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
    System.runAs(newUser) {
      //Create new lead record
      leadRecord.Email = 'lead' + uniqueName + '@test.com';
      leadRecord.Disqualified_Flag__c = false;
      Database.DMLOptions insertDML = new Database.DMLOptions();
      insertDML.DuplicateRuleHeader.AllowSave = true;
      Database.SaveResult sr = Database.insert(leadRecord, insertDML);
    }
    Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
    tsk.Result__c = 'No Contact';
    insert tsk;
    Task tsk1 = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
    tsk1.Result__c = 'No Contact - Left Voicemail';
    insert tsk1;
  }

  @isTest
  public static void testConstructorWithParameters() {
    String CRON_EXP;
    Test.startTest();
    Datetime dt = Datetime.now().addMinutes(1);
    CRON_EXP =
      '0 ' +
      dt.minute() +
      ' * ' +
      dt.day() +
      ' ' +
      dt.month() +
      ' ? ' +
      dt.year();
    String jobId = System.schedule(
      'ScheduledApexTest1',
      CRON_EXP,
      new LeadAssignmentSchedulable()
    );
    Test.stopTest();
  }

  @isTest
  public static void testConstructorWithoutParameters() {
    String CRON_EXP;
    Test.startTest();
    Datetime dt = Datetime.now().addMinutes(1);
    CRON_EXP =
      '0 ' +
      dt.minute() +
      ' * ' +
      dt.day() +
      ' ' +
      dt.month() +
      ' ? ' +
      dt.year();
    String jobId = System.schedule(
      'ScheduledApexTest1',
      CRON_EXP,
      new LeadAssignmentSchedulable('Default', dt)
    );
    Test.stopTest();
  }
}
