/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-21-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-18-2021   Travis Allen   Initial Version
 **/
global with sharing class NoContactMadeNotifierOnLeads implements Schedulable {
  global NoContactMadeNotifierOnLeads(
    List<Lead> leads,
    Map<Id, Lead> newLeadMap,
    Map<Id, Lead> oldLeadMap
  ) {
    this.leads = leads;
    this.newLeadMap = newLeadMap;
    this.oldLeadMap = oldLeadMap;
  }

  global void execute(SchedulableContext ctx) {
    /**
     * LEAD Assignment SLA Scenarios and conditions
     * 1. Lead reassigned is true and assign to tier1 user, time period for contact is 8hrs - notify user that they have 8hrs to notify.
     * 2. Lead reassigned is false and assign to tier1 user, time perios for contact is 24hrs - notify supervisor.
     * 3. Lead assigned to Tier2 user, time period for contact is 24hrs - notify supervisor.
     * 4. Lead assigned to Tier2 user, time period for contact is 36hrs - notify senior supervisor.
     */
    //Fetch id for Tier one queue
    Id tierOneQueue = Util.getQueueId(Constants.TIER_ONE_QUEUE);

    //Fetch id for Tier two queue
    Id tierTwoQueue = Util.getQueueId(Constants.TIER_TWO_QUEUE);

    //Fetch tier2 Agents
    //List<User> tierOneAgents = [SELECT UserOrGroupId, GroupId FROM GroupMember WHERE GroupId = :tierOneQueue];

    //Fetch tier2 Agents
    //List<User> tierTwoAgents = [SELECT UserOrGroupId, GroupId FROM GroupMember WHERE GroupId = :tierTwoQueue];

    //Iterate through all updated leads
    for (Lead leadRecord : [
      SELECT Id, Assignment_Timestamp__c, OwnerId, Escalate_to_Tier2__c
      FROM Lead
    ]) {
      //Current time at which the job is is Running
      Datetime currentTime = System.now();

      //Check if lead is tier1 or Tier2 and assigned to an Agent
      if (!leadRecord.Escalate_to_Tier2__c) {
        //Lead is currently in tier 1 and assigned to an Agent
      }

      //Check if leas si tier1 and reassigned to a tier one agents
      // if(!leadRecord.Escalate_to_Tier2__c && tierOneAgents.contains(leadReacord.OwnerId)&& leadRecord.Reass){
      //   //Lead is currently reassigned to tier1 agents

      // }

      //Check if lead is tier1 or Tier2 and assigned to an Agent
      if (leadRecord.Escalate_to_Tier2__c) {
        //Lead is currently assigned to tier2 agent
        //Enqueue Schedulable class to check if contact has been made after 24 hours

        //Enqueue Schedulable class to check if contact has been made after 36 hours
      }
    }
  }
}
