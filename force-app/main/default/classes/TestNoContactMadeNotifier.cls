/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-24-2021
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
  public static Id tierOneQueueId = Util.getQueueId(Constants.TIER_ONE_QUEUE);
  public static Id tierTwoQueueId = Util.getQueueId(Constants.TIER_TWO_QUEUE);

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

    System.runAs(travisTierOne) {
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
  }

  //Scenario 1: Lead has been reassigned to tier 1 for 8hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario1() {
    //Get user from Tier 1 queue
    User tierOneAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest@email.com'
      LIMIT 1
    ];

    System.debug('tier one agent: ' + tierOneAgent);
    System.debug(
      'tier one queue users ' +
      [
        SELECT Id, UserOrGroupId
        FROM GroupMember
        WHERE Group.Name = 'Sales Development Team'
      ]
    );

    //Create reassigned lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime.addHours(-8);
    leads[0].Not_Contacted_8_hours_flag__c = false;
    leads[0].Not_Contacted_24_hours_flag__c = true;
    leads[0].Lead_Reassigned_flag__c = true;
    insert leads;

    leads[0].OwnerId = tierOneAgent.Id;
    update leads;

    Test.startTest();
    //Set time for which the schedule job should run
    String CRON_EXP = '0 0 * * * ?';

    //Enqueue Job with the above CRON expression
    // String jobId = System.schedule(
    //   'TestScheduledApex',
    //   CRON_EXP,
    //   new NoContactMadeNotifierSchedulable(currentDateTime)
    // );
    System.enqueueJob(new NoContactMadeNotifierQueueable(currentDateTime));

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
    User tierOneAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest@email.com'
      LIMIT 1
    ];

    //Create TIER ONE lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime.addHours(-24);
    leads[0].Not_Contacted_24_hours_flag__c = false;
    leads[0].Lead_Reassigned_flag__c = false;
    insert leads;

    leads[0].OwnerId = tierOneAgent.Id;
    update leads;

    Test.startTest();
    //Set time for which the schedule job should run

    //Enqueue Job
    System.enqueueJob(new NoContactMadeNotifierQueueable(currentDateTime));
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
    User tierTwoAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest2@email.com'
      LIMIT 1
    ];

    System.debug('tier two agent: ' + tierTwoAgent);
    System.debug('tier two queue Id ' + tierTwoQueueId);
    System.debug(
      'tier two queue users ' +
      [
        SELECT Id, UserOrGroupId
        FROM GroupMember
        WHERE Group.Name = 'Sales Team'
      ]
    );

    //Create TIER TWO lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime.addHours(-24);
    leads[0].Not_Contacted_24_hours_Tier_2_flag__c = false;
    leads[0].Last_Contact_Made__c = currentDateTime.addHours(-36);
    insert leads;

    leads[0].Escalate_to_Tier2__c = true;
    update leads;

    leads[0].OwnerId = tierTwoAgent.Id;
    update leads;

    Test.startTest();
    //Enqueue Job
    System.enqueueJob(new NoContactMadeNotifierQueueable(currentDateTime));
    Test.stopTest();

    //System Asserts to check if leads were updated correctly
    System.assertEquals(
      true,
      [SELECT Id, Not_Contacted_24_hours_Tier_2_flag__c FROM Lead]
      .Not_Contacted_24_hours_Tier_2_flag__c,
      'Notfication was not sent out.'
    );
  }
  //Scenario 4: Lead has been assigned to tier 2 for 36hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario4() {
    //Get Group Member from Tier 2 queue
    User tierTwoAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest2@email.com'
      LIMIT 1
    ];

    //Create TIER TWO lead where contact has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentDateTime.addHours(-36);
    leads[0].Last_Contact_Made__c = currentDateTime.addHours(-40);
    leads[0].Not_Contacted_36_hours_flag__c = false;
    leads[0].Not_Contacted_24_hours_Tier_2_flag__c = true;
    insert leads;

    leads[0].Escalate_to_Tier2__c = true;
    update leads;

    leads[0].OwnerId = tierTwoAgent.Id;
    update leads;

    Test.startTest();
    //Enqueue Job
    System.enqueueJob(new NoContactMadeNotifierQueueable(currentDateTime));
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
