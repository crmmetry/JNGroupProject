/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-24-2021
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
    System.debug('Queueable Class reached');
    List<Lead> leads = checkLeadsToBeNotified(this.currentTime);
    System.debug('Leads to be updated' + leads);
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
  public static List<Lead> checkLeadsToBeNotified(Datetime currentTime) {
    System.debug('Check Leads to be Notified Reached');

    //Time spent in tier
    Decimal timeSpentInTier = 0;

    //List of Leads to be updated
    List<Lead> leadsToBeUpdated = new List<Lead>();

    //Fetch id for Tier one queue
    Id tierOneQueue = Util.getQueueId(Constants.TIER_ONE_QUEUE);

    //Fetch id for Tier two queue
    Id tierTwoQueue = Util.getQueueId(Constants.TIER_TWO_QUEUE);

    //Mapped group members for Tier 1 agents
    Map<Id, GroupMember> tierOneAgentMap = new Map<Id, GroupMember>();

    //Mapped group members for Tier 2 agents
    Map<Id, GroupMember> tierTwoAgentMap = new Map<Id, GroupMember>();

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
    ]) {
      //Calculate time spent in tier
      timeSpentInTier =
        (currentTime.getTime() - leadRecord.Assignment_Timestamp__c.getTime()) /
        (1000.0 *
        60.0 *
        60.0);

      System.debug('Time Spent in Tier: ' + timeSpentInTier);

      System.debug('Is lead Escalated ' + leadRecord.Escalate_to_Tier2__c);

      System.debug('TierOneAgentMap ' + tierOneAgentMap);

      System.debug('Lead Owner ' + leadRecord.OwnerId);

      System.debug(
        'Is lead owned by tier one agent ' +
        tierOneAgentMap.keySet().contains(leadRecord.OwnerId)
      );

      System.debug(
        'Is lead owned by tier two agent ' +
        tierTwoAgentMap.keySet().contains(leadRecord.OwnerId)
      );

      //Check if lead is in tier 1
      //TODO:Optimise requirement to check lead owner is a Sales User
      if (
        !leadRecord.Escalate_to_Tier2__c &&
        (tierOneAgentMap.keySet().contains(leadRecord.OwnerId))
      ) {
        System.debug('Lead In tier one is true');
        //Check if maximum time has been spent in tier 1 with no contact made for a reassigned lead and no notification have been sent out
        if (
          timeSpentInTier >=
          Constants.MAX_TIME_SPENT_IN_TIER_ONE_WHEN_REASSIGNED &&
          leadRecord.Contact_Made__c != Constants.CONTACT_MADE &&
          leadRecord.Lead_Reassigned_flag__c &&
          !leadRecord.Not_Contacted_8_hours_flag__c &&
          leadRecord.Not_Contacted_24_hours_flag__c
        ) {
          //Update Notification flag on lead record
          leadRecord.Not_Contacted_8_hours_flag__c = true;
          leadsToBeUpdated.add(leadRecord);
          System.debug('Lead is reassigned' + leadRecord);
        }

        //Check if maximum time has been spent in tier 1 with no contact made for a lead and no notification have not been sent
        if (
          timeSpentInTier >= Constants.MAX_TIME_SPENT_IN_TIER_ONE &&
          leadRecord.Contact_Made__c != Constants.CONTACT_MADE &&
          !leadRecord.Lead_Reassigned_flag__c &&
          !leadRecord.Not_Contacted_24_hours_flag__c
        ) {
          //Update Notification flag on lead record
          leadRecord.Not_Contacted_24_hours_flag__c = true;

          //Reassign lead to tier one queue
          leadRecord.Lead_Reassigned_flag__c = true;
          leadRecord.OwnerId = tierOneQueue;
          leadsToBeUpdated.add(leadRecord);
        }
      }

      //Check if lead is in tier 2
      if (
        leadRecord.Escalate_to_Tier2__c &&
        (tierTwoAgentMap.keySet().contains(leadRecord.OwnerId))
      ) {
        System.debug('Lead In tier two is true');
        //Check if 24h has been spent in tier 2 with no contact made for lead and no notification have been sent out
        if (
          timeSpentInTier >=
          Constants.MAX_TIME_SPENT_IN_TIER_TWO_FOR_FIRST_NOTFIFICATION &&
          leadRecord.Last_Contact_Made__c <
          leadRecord.Assignment_Timestamp__c &&
          !leadRecord.Not_Contacted_24_hours_Tier_2_flag__c
        ) {
          System.debug('Lead is in tier 2 and have not been assigned.');
          //Update Notification flag on lead record
          leadRecord.Not_Contacted_24_hours_Tier_2_flag__c = true;
          leadsToBeUpdated.add(leadRecord);
        }

        //Check if maximum time has been spent in tier 1 with no contact made for a lead and no notification have not been sent
        if (
          timeSpentInTier >=
          Constants.MAX_TIME_SPENT_IN_TIER_TWO_FOR_SECOND_NOTIFICATION &&
          leadRecord.Last_Contact_Made__c <
          leadRecord.Assignment_Timestamp__c &&
          leadRecord.Not_Contacted_24_hours_Tier_2_flag__c &&
          !leadRecord.Not_Contacted_36_hours_flag__c
        ) {
          //Update Notification flag on lead record
          leadRecord.Not_Contacted_36_hours_flag__c = true;
          leadsToBeUpdated.add(leadRecord);
        }
      }
    }
    return leadsToBeUpdated;
  }
}
