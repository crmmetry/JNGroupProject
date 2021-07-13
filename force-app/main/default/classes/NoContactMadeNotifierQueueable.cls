/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 07-13-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-18-2021   Travis Allen   Initial Version
 **/
public with sharing class NoContactMadeNotifierQueueable implements Queueable {
  public Datetime currentTime;

  /**
   * Class constructor
   * @author Travis Allen | 06-23-2021
   * @param currentTime
   **/
  public NoContactMadeNotifierQueueable(Datetime currentTime) {
    this.currentTime = currentTime;
  }
  /**
   * Execute Queueable class
   * @author Travis Allen | 06-22-2021
   * @param context
   **/
  public void execute(QueueableContext context) {
    List<Lead> leads = new List<Lead>(checkLeadsToBeNotified(this.currentTime));
    update leads;
  }

  /**
   *  /**
   * LEAD Assignment SLA Scenarios and conditions
   * 1. Lead reassigned is true and assign to tier1 user, time period for contact is 8hrs - notify user that they have 8hrs to notify.
   * 2. Lead reassigned is false and assign to tier1 user, time perios for contact is 24hrs - notify supervisor.
   * 3. Lead assigned to Tier2 user, time period for contact is 24hrs - notify supervisor.
   * 4. Lead assigned to Tier2 user, time period for contact is 36hrs - notify senior supervisor.
   *
   * @author Travis Allen | 06-22-2021
   **/
  public static Set<Lead> checkLeadsToBeNotified(Datetime currentTime) {
    //Time spent in tier
    Decimal timeSpentInTier = 0;

    //List of Leads to be updated
    Set<Lead> leadsToBeUpdated = new Set<Lead>();

    //Fetch id for Tier one queue
    Id tierOneQueue = Util.getQueueId(Constants.TIER_ONE_QUEUE);

    //Fetch id for Tier two queue
    Id tierTwoQueue = Util.getQueueId(Constants.TIER_TWO_QUEUE);

    //Mapped group members for Tier 1 agents
    Map<Id, GroupMember> tierOneAgentMap = new Map<Id, GroupMember>();

    //Mapped group members for Tier 2 agents
    Map<Id, GroupMember> tierTwoAgentMap = new Map<Id, GroupMember>();

    //Get All mapped Holidays currently in the system
    Map<Date, Holiday> holidays = Util.getHolidays();

    //Populate tier one agent map
    for (GroupMember user : [
      SELECT UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierOneQueue
      WITH SECURITY_ENFORCED
    ]) {
      tierOneAgentMap.put(user.UserOrGroupId, user);
    }

    //Populate tier one agent map
    for (GroupMember user : [
      SELECT UserOrGroupId, GroupId
      FROM GroupMember
      WHERE GroupId = :tierTwoQueue
      WITH SECURITY_ENFORCED
    ]) {
      tierTwoAgentMap.put(user.UserOrGroupId, user);
    }

    //Get a list of all user Ids that are sales user in the system
    List<Id> salesUsers = new List<Id>();
    for (User user : [SELECT Id FROM User WHERE Sales_User__c = TRUE]) {
      salesUsers.add(user.Id);
    }

    //Iterate through all updated leads
    for (Lead leadRecord : [
      SELECT
        Id,
        Assignment_Timestamp__c,
        OwnerId,
        Escalate_to_Tier2__c,
        Lead_Reassigned_flag__c,
        Contact_Made__c,
        Not_Contacted_24_hours_flag__c,
        Not_Contacted_8_hours_flag__c,
        Not_Contacted_24_hours_Tier_2_flag__c,
        Not_Contacted_36_hours_flag__c,
        Last_Contact_Made__c
      FROM Lead
      WHERE
        OwnerId IN :tierOneAgentMap.keySet()
        OR OwnerId IN :tierTwoAgentMap.keySet()
        OR OwnerId IN :salesUsers
      WITH SECURITY_ENFORCED
      FOR UPDATE
    ]) {
      //Check if lead is in tier 1
      //TODO:Optimise requirement to check lead owner is a Sales User
      if (
        !leadRecord.Escalate_to_Tier2__c &&
        ((tierOneAgentMap.keySet().contains(leadRecord.OwnerId) ||
        salesUsers.contains(leadRecord.OwnerId)))
      ) {
        //Check if maximum time has been spent in tier 1 with no contact made for a reassigned lead and no notification have been sent out
        if (
          leadRecord.Contact_Made__c != Constants.CONTACT_MADE &&
          leadRecord.Lead_Reassigned_flag__c &&
          !leadRecord.Not_Contacted_8_hours_flag__c &&
          leadRecord.Not_Contacted_24_hours_flag__c
        ) {
          //Check if expected assignment datetime lines up with what is recorded on lead record
          DateTime expectedAssignedTime = getBackDatedTime(
            Constants.MAX_TIME_SPENT_IN_TIER_ONE_WHEN_REASSIGNED,
            holidays,
            currentTime
          );
          if (expectedAssignedTime >= leadRecord.Assignment_Timestamp__c) {
            //Update Notification flag on lead record
            leadRecord.Not_Contacted_8_hours_flag__c = true;
            leadsToBeUpdated.add(leadRecord);
          }
        }

        //Check if maximum time has been spent in tier 1 with no contact made for a lead and no notification have not been sent
        if (
          leadRecord.Contact_Made__c != Constants.CONTACT_MADE &&
          !leadRecord.Lead_Reassigned_flag__c &&
          !leadRecord.Not_Contacted_24_hours_flag__c
        ) {
          //Check if expected assignment datetime lines up with what is recorded on lead record
          DateTime expectedAssignedTime = getBackDatedTime(
            Constants.MAX_TIME_SPENT_IN_TIER_ONE,
            holidays,
            currentTime
          );
          if (expectedAssignedTime >= leadRecord.Assignment_Timestamp__c) {
            //Update Notification flag on lead record
            leadRecord.Not_Contacted_24_hours_flag__c = true;
            //Reassign lead to tier one queue
            leadRecord.Lead_Reassigned_flag__c = true;
            leadRecord.OwnerId = tierOneQueue;
            //Update lead status to reassigned
            leadRecord.Status = 'Reassigned';
            leadsToBeUpdated.add(leadRecord);
          }
        }
      }

      //Check if lead is in tier 2
      if (
        leadRecord.Escalate_to_Tier2__c &&
        (tierTwoAgentMap.keySet().contains(leadRecord.OwnerId))
      ) {
        //Check if 24h has been spent in tier 2 with no contact made for lead and no notification have been sent out
        if (
          leadRecord.Last_Contact_Made__c <
          leadRecord.Assignment_Timestamp__c &&
          !leadRecord.Not_Contacted_24_hours_Tier_2_flag__c
        ) {
          //Check if expected assignment datetime lines up with what is recorded on lead record
          DateTime expectedAssignedTime = getBackDatedTime(
            Constants.MAX_TIME_SPENT_IN_TIER_TWO_FOR_FIRST_NOTFIFICATION,
            holidays,
            currentTime
          );
          if (expectedAssignedTime >= leadRecord.Assignment_Timestamp__c) {
            //Update Notification flag on lead record
            leadRecord.Not_Contacted_24_hours_Tier_2_flag__c = true;
            leadsToBeUpdated.add(leadRecord);
          }
        } else if (
          leadRecord.Last_Contact_Made__c <
          leadRecord.Assignment_Timestamp__c &&
          leadRecord.Not_Contacted_24_hours_Tier_2_flag__c &&
          !leadRecord.Not_Contacted_36_hours_flag__c
        ) {
          //Check if maximum time has been spent in tier 1 with no contact made for a lead and no notification have not been sent
          //Check if expected assignment datetime lines up with what is recorded on lead record
          DateTime expectedAssignedTime = getBackDatedTime(
            Constants.MAX_TIME_SPENT_IN_TIER_TWO_FOR_SECOND_NOTIFICATION,
            holidays,
            currentTime
          );
          if (expectedAssignedTime >= leadRecord.Assignment_Timestamp__c) {
            //Update Notification flag on lead record
            leadRecord.Not_Contacted_36_hours_flag__c = true;
            leadsToBeUpdated.add(leadRecord);
          }
        }
      }
    }
    return leadsToBeUpdated;
  }

  /**
   *Logic to calculate time when lead is reassigned, hence max allowableTime is 8
   * @author Travis Allen | 06-24-2021
   * @param maxAllowableHours
   * @param assignedTime
   * @return Deciaml
   **/
  public static Datetime getBackDatedTime(
    Integer maxAllowableHours,
    Map<Date, Holiday> mappedHolidays,
    DateTime currentTime
  ) {
    Boolean isHoliday;
    String day;
    DateTime expectedAssignedTime = currentTime;
    //Loop through max allowable hours that alead can be open without contact being made.
    while (maxAllowableHours >= 0) {
      //Check if current date is a holiday
      isHoliday = Util.checkHoliday(
        expectedAssignedTime.date(),
        mappedHolidays
      );
      //Assign the current day with corresponding string literal to identify the day
      day = expectedAssignedTime.format('E');
      //Decrement hour if current day is not holiday or Weekend
      if ((day == 'Sat' || day == 'Sun' || isHoliday) == false) {
        maxAllowableHours -= 1;
      }
      //Decrement expectedAssigneTime until until maxAllowableTime runs out
      if (maxAllowableHours >= 0) {
        expectedAssignedTime = expectedAssignedTime.addHours(-1);
      }
    }
    return expectedAssignedTime;
  }
}
