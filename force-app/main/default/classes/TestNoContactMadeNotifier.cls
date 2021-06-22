/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-22-2021
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
    //Set time for which the schedule job should run
    String CRON_EXP = currentTime.addHours(8);

    //TODO:Get Group Member from Tier 1 queue
    GroupMember tierOneAgent = [
      SELECT Id, UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierOneQueueId
      LIMIT 1
    ];

    //Create reassigned lead where contacts has not been made
    List<Lead> leads = TestDataFactory.CreateLeads(1);
    leads[0].Assignment_Timestamp__c = currentTime;
    leads[0].Not_Contacted_8_hours_flag__c = false;
    leads[0].Lead_Reassigned_flag__c = true;
    leads[0].Contact_Made__c = false;
    //TODO:assign owner to tier one agents
    leads[0].OwnerId = tierOneQueueId;
    insert leads[0];

    Test.startTest();
    String jobId = System.schedule(
      'TestScheduledApex',
      CRON_EXP,
      new SchedulableNoContactMadeNotifier()
    );
    Test.stopTest();
  }

  //Scenario 2: Lead has been assigned to tier 1 for 24hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario2() {
  }
  //Scenario 3: Lead has been assigned to tier 2 for 24hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario3() {
  }
  //Scenario 4: Lead has been assigned to tier 2 for 36hrs without contact being made
  @isTest
  public static void shouldNotifyNoContactMadeScenario4() {
  }
}
