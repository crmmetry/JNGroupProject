/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-23-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-22-2021   Travis Allen   Initial Version
 **/
@isTest
public with sharing class TestNoContactMadeNotifier {
  //Set Current Static time for Test Scenarios to take place
  public static DateTime currentDateTime = DateTime.newInstance(
    2021,
    6,
    21,
    12,
    0,
    0
  );
  //Get Sales Team and SalesDeveloperTeam Queue Ids
  public static Id tierOneQueueId = Util.getQueueId('Sales Development Team');
  public static Id tierTwoQueueId = Util.getQueueId('Sales Team');
  @TestSetup
  static void makeData() {
    //Create Users

    List<User> usersToInsert = new List<User>();
    //User to be added to Tier One queue
    User travisTierOne = TestDataFactory.CreateUser('travistest@email.com');
    usersToInsert.add(travisTierOne);
    //User to be added to Tier Two Queue
    User travisTierTwo = TestDataFactory.CreateUser('travistest2@email.com');
    usersToInsert.add(travisTierTwo);
    //Stand alone sales user (tier One)
    User salesUser = TestDataFactory.CreateUser('salesUsertest@email.com');
    salesUser.Sales_User__c = true;
    usersToInsert.add(salesUser);

    insert usersToInsert;

    //Add users to Queue as GroupMembers
    List<GroupMember> groupMembers = new List<GroupMember>();
    GroupMember tierOneAgent = TestDataFactory.CreateGroupMember(
      travisTierOne.Id,
      tierOneQueueId
    );
    GroupMember tierTwoAgent = TestDataFactory.CreateGroupMember(
      travisTierTwo.Id,
      tierTwoQueueId
    );
    groupMembers.add(tierOneAgent);
    groupMembers.add(tierTwoAgent);
    insert groupMembers;
  }

  //Scenario 1: Lead has been reassigned to tier 1 for 8hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario1() {
    //Get Group Member from Tier 1 queue
    GroupMember tierOneAgent = [
      SELECT Id, UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierOneQueueId
      LIMIT 1
    ];

    //Create reassigned lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime;
    leads[0].Not_Contacted_8_hours_flag__c = false;
    leads[0].Lead_Reassigned_flag__c = true;
    leads[0].OwnerId = tierOneAgent.UserOrGroupId;
    insert leads;

    Test.startTest();
    //Set time for which the schedule job should run
    DateTime scheduledTime = currentDateTime.addHours(8);
    String CRON_EXP =
      '0 ' +
      scheduledTime.minute() +
      ' * ' +
      scheduledTime.day() +
      ' ' +
      scheduledTime.month() +
      ' ? ' +
      scheduledTime.year();

    //Enqueue Job with the above CRON expression
    String jobId = System.schedule(
      'TestScheduledApex',
      CRON_EXP,
      new NoContactMadeNotifierSchedulable()
    );
    Test.stopTest();

    //System Asserts to check if leads were updated correctly
    System.assertEquals(
      true,
      [SELECT Id, Not_Contacted_8_hours_flag__c FROM Lead]
      .Not_Contacted_8_hours_flag__c,
      'Notfication was not sent out.'
    );
  }

  //Scenario 2: Lead has been assigned to tier 1 for 24hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario2() {
    //Get Group Member from Tier 1 queue
    GroupMember tierOneAgent = [
      SELECT Id, UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierOneQueueId
      LIMIT 1
    ];

    //Create TIER ONE lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime;
    leads[0].Not_Contacted_24_hours_flag__c = false;
    leads[0].Lead_Reassigned_flag__c = false;
    leads[0].OwnerId = tierOneAgent.UserOrGroupId;
    insert leads;

    Test.startTest();
    //Set time for which the schedule job should run
    DateTime scheduledTime = currentDateTime.addHours(24);
    String CRON_EXP =
      '0 ' +
      scheduledTime.minute() +
      ' * ' +
      scheduledTime.day() +
      ' ' +
      scheduledTime.month() +
      ' ? ' +
      scheduledTime.year();

    //Enqueue Job with the above CRON expression
    String jobId = System.schedule(
      'TestScheduledApex',
      CRON_EXP,
      new NoContactMadeNotifierSchedulable()
    );
    Test.stopTest();

    //System Asserts to check if leads were updated correctly
    System.assertEquals(
      true,
      [SELECT Id, Not_Contacted_24_hours_flag__c FROM Lead]
      .Not_Contacted_24_hours_flag__c,
      'Notfication was not sent out.'
    );
    System.assertEquals(
      tierOneQueueId,
      [SELECT Id, OwnerId FROM Lead]
      .OwnerId,
      'Lead was not reassigned to tier one queue'
    );
  }

  //Scenario 3: Lead has been assigned to tier 2 for 24hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario3() {
    //Get Group Member from Tier 2 queue
    GroupMember tierTwoAgent = [
      SELECT Id, UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierTwoQueueId
      LIMIT 1
    ];

    //Create TIER TWO lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime;
    leads[0].Not_Contacted_24_hours_flag__c = false;
    leads[0].OwnerId = tierTwoAgent.UserOrGroupId;
    insert leads;

    Test.startTest();
    //Set time for which the schedule job should run
    DateTime scheduledTime = currentDateTime.addHours(24);
    String CRON_EXP =
      '0 ' +
      scheduledTime.minute() +
      ' * ' +
      scheduledTime.day() +
      ' ' +
      scheduledTime.month() +
      ' ? ' +
      scheduledTime.year();

    //Enqueue Job with the above CRON expression
    String jobId = System.schedule(
      'TestScheduledApex',
      CRON_EXP,
      new NoContactMadeNotifierSchedulable()
    );
    Test.stopTest();

    //System Asserts to check if leads were updated correctly
    System.assertEquals(
      true,
      [SELECT Id, Not_Contacted_24_hours_flag__c FROM Lead]
      .Not_Contacted_24_hours_flag__c,
      'Notfication was not sent out.'
    );
  }
  //Scenario 4: Lead has been assigned to tier 2 for 36hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario4() {
    //Get Group Member from Tier 2 queue
    GroupMember tierTwoAgent = [
      SELECT Id, UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierTwoQueueId
      LIMIT 1
    ];

    //Create TIER TWO lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime;
    leads[0].Not_Contacted_36_hours_flag__c = false;
    leads[0].Not_Contacted_24_hours_flag__c = true;
    leads[0].OwnerId = tierTwoAgent.UserOrGroupId;
    insert leads;

    Test.startTest();
    //Set time for which the schedule job should run
    DateTime scheduledTime = currentDateTime.addHours(36);
    String CRON_EXP =
      '0 ' +
      scheduledTime.minute() +
      ' * ' +
      scheduledTime.day() +
      ' ' +
      scheduledTime.month() +
      ' ? ' +
      scheduledTime.year();

    //Enqueue Job with the above CRON expression
    String jobId = System.schedule(
      'TestScheduledApex',
      CRON_EXP,
      new NoContactMadeNotifierSchedulable()
    );
    Test.stopTest();

    //System Asserts to check if leads were updated correctly
    System.assertEquals(
      true,
      [SELECT Id, Not_Contacted_36_hours_flag__c FROM Lead]
      .Not_Contacted_36_hours_flag__c,
      'Notfication was not sent out.'
    );
  }
}
