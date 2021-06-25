/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-25-2021
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
    18,
    12,
    0,
    0
  );

  //Get Sales Team and SalesDeveloperTeam Queue Ids
  public static Id tierOneQueueId = Util.getQueueId(Constants.TIER_ONE_QUEUE);
  public static Id tierTwoQueueId = Util.getQueueId(Constants.TIER_TWO_QUEUE);

  /**
   * Data setup for testing
   * @author Travis Allen | 06-25-2021
   **/
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

  /**
   * Scenario 1: Lead has been reassigned to tier 1 for 8hrs without contact being made
   * @author Travis Allen | 06-25-2021
   **/
  @isTest
  public static void shouldNotifyNoContactMadeScenario1() {
    //Get user from Tier 1 queue
    User tierOneAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest@email.com'
      LIMIT 1
    ];

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
    //Enqueue job
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

  /**
   * Scenario 2: Lead has been assigned to tier 1 for 24hrs without contact being made
   * @author Travis Allen | 06-25-2021
   **/
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

  /**
   * Scenario 3: Lead has been assigned to tier 2 for 24hrs without contact being made
   * @author Travis Allen | 06-25-2021
   **/
  @isTest
  public static void shouldNotifyNoContactMadeScenario3() {
    //Get Group Member from Tier 2 queue
    User tierTwoAgent = [
      SELECT Id
      FROM User
      WHERE UserName = 'travistest2@email.com'
      LIMIT 1
    ];

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

  /**
   * Scenario 4: Lead has been assigned to tier 2 for 36hrs without contact being made
   * @author Travis Allen | 06-25-2021
   **/
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

  /**
   * Scenario 1 getBackDatedTime: Get back dated time of a reassigned lead without holidays or weekends falling in between.
   * @author Travis Allen | 06-24-2021
   **/
  @isTest
  public static void shouldGetExpectedAssignmentDateTimeScenario1() {
    //Set specific datetime for scenario
    Datetime now = Datetime.newInstance(2021, 6, 18, 12, 0, 0);
    //Get Holidays in system currently
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    //Call getBackDatedMethod from NoContactMadeNotifierQueueable
    Datetime expectedTime = NoContactMadeNotifierQueueable.getBackDatedTime(
      8,
      mappedHolidays,
      now
    );
    //Assert that the expected time is equal to the assigned time
    System.assertEquals(
      now.addHours(-8),
      expectedTime,
      'Back Dated time is inaccurate.'
    );
  }

  /**
   * Scenario 2 getBackDatedTime: Get back dated date of tier 1 / firststage tier 2 lead.
   * @author Travis Allen | 06-24-2021
   **/
  @isTest
  public static void shouldGetExpectedAssignmentDateTimeScenario2() {
    //Set specific datetime for scenario
    Datetime now = Datetime.newInstance(2021, 6, 18, 12, 0, 0);
    //Get Holidays in system currently
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    //Call getBackDatedMethod from NoContactMadeNotifierQueueable
    Datetime expectedTime = NoContactMadeNotifierQueueable.getBackDatedTime(
      24,
      mappedHolidays,
      now
    );
    //Assert that the expected time is equal to the assigned time
    System.assertEquals(
      now.addDays(-1),
      expectedTime,
      'Back Dated time is inaccurate.'
    );
  }

  /**
   * Scenario 3 getBackDatedTime: Get back dated time of tier 2 second stage lead.
   * @author Travis Allen | 06-24-2021
   **/
  @isTest
  public static void shouldGetExpectedAssignmentDateTimeScenario3() {
    //Set specific datetime for scenario
    Datetime now = Datetime.newInstance(2021, 6, 18, 12, 0, 0);
    //Get Holidays in system currently
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    //Call getBackDatedMethod from NoContactMadeNotifierQueueable
    Datetime expectedTime = NoContactMadeNotifierQueueable.getBackDatedTime(
      36,
      mappedHolidays,
      now
    );
    //Assert that the expected time is equal to the assigned time
    System.assertEquals(
      now.addDays(-1).addHours(-12),
      expectedTime,
      'Back Dated time is inaccurate.'
    );
  }

  /**
   * Scenario 4 getBackDatedTime: Get back dated time of tier 1 reassigned lead during weekend.
   * @author Travis Allen | 06-24-2021
   **/
  @isTest
  public static void shouldGetExpectedAssignmentDateTimeScenario4() {
    //Set specific datetime for scenario
    Datetime now = Datetime.newInstance(2021, 6, 21, 0, 0, 0);
    //Get Holidays in system currently
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    //Call getBackDatedMethod from NoContactMadeNotifierQueueable
    Datetime expectedTime = NoContactMadeNotifierQueueable.getBackDatedTime(
      8,
      mappedHolidays,
      now
    );
    //Assert that the expected time is equal to the assigned time
    System.assertEquals(
      Datetime.newInstanceGMT(2021, 6, 18, 21, 0, 0),
      expectedTime,
      'Back Dated time is inaccurate.'
    );
  }

  /**
   * Scenario 5 getBackDatedTime: Get back dated time of tier 2 first stage lead during holiday.
   * @author Travis Allen | 06-24-2021
   **/
  @isTest
  public static void shouldGetExpectedAssignmentDateTimeScenario5() {
    //Set specific datetime for scenario (Day After Ash Wednesday)
    Datetime now = Datetime.newInstanceGMT(2021, 2, 18, 5, 0, 0);
    //Get Holidays in system currently
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    //Call getBackDatedMethod from NoContactMadeNotifierQueueable
    Datetime expectedTime = NoContactMadeNotifierQueueable.getBackDatedTime(
      24,
      mappedHolidays,
      now
    );
    //Assert that the expected time is equal to the assigned time
    //5 hours was added to ensure that the Time Zone was equivalent to that of the system for testing accuracy.
    System.assertEquals(
      Datetime.newInstanceGMT(2021, 2, 16, 5, 0, 0),
      expectedTime,
      'Back Dated time is inaccurate.'
    );
  }
}
