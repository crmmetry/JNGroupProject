/**
 * @description       : To Validate that one opportunity have one application
 * @author            : Tushar Chopade(Thinqloud)
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   04-20-2021   Tushar Chopade(Thinqloud)   Initial Version
 **/
public class ApplicationTriggerHandler {
  private static List<Application__c> newRecords;
  private static Map<Id, Application__c> oldMap;
  private static Map<Id, Application__c> newMap;

  public static void init(
    List<Application__c> newRecords,
    Map<Id, Application__c> oldMap,
    Map<Id, Application__c> newMap
  ) {
    ApplicationTriggerHandler.newRecords = newRecords;
    ApplicationTriggerHandler.oldMap = oldMap;
    ApplicationTriggerHandler.newMap = newMap;
  }

  /**
   * @description This method checks validation, whether the Opportunity has one application associated or not otherwise display error message.
   * @author Remario Richards | 04-20-2021
   **/
  public static void checkOpportunityHasOneApplication() {
    Set<Id> oppIdSet = new Set<Id>();
    for (Application__c appRecord : newRecords) {
      oppIdSet.add(appRecord.Opportunity_ID__c);
    }
    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>(
      [
        SELECT id, (SELECT id FROM Applications__r)
        FROM Opportunity
        WHERE Id IN :oppIdSet
        WITH SECURITY_ENFORCED
      ]
    );
    for (Application__c newAppRecord : newRecords) {
      if (opportunityMap.containsKey(newAppRecord.Opportunity_ID__c)) {
        if (
          opportunityMap.get(newAppRecord.Opportunity_ID__c)
            .Applications__r.size() >= 1
        ) {
          newAppRecord.addError(Constants.ONLY_ONE_APPLICATION);
        }
      }
    }
  }

  /**
   * @description : This method is used when the application is accepted from the ADJ
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  public static void changeApplicationStatus() {
    Map<String, List<Id>> groupMemMap = getGroupsMembersMap();
    Id referredQueueId = Util.getQueueId(Constants.REFERRED_QUEUE);
    List<Case> caseList = new List<Case>();
    Set<Id> applicatioIdSet = new Set<Id>();
    for (Application__c newAppRecord : newRecords) {
      applicatioIdSet.add(newAppRecord.Id);
    }

    Map<Id, Application__c> applicationMap = new Map<Id, Application__c>(
      [
        SELECT Id, (SELECT Id, Status FROM Cases__r)
        FROM Application__c
        WHERE Id IN :applicatioIdSet
        WITH SECURITY_ENFORCED
      ]
    );
    for (Application__c newAppRecord : newRecords) {
      if (
        newAppRecord.OwnerId <> oldMap.get(newAppRecord.Id).OwnerId &&
        oldMap.get(newAppRecord.Id).Adjudication_Path_picklist__c ==
        Constants.DEFERRED_STATUS
      ) {
        // when the DM will change the owner of application then application status will be assigned.
        if (
          groupMemMap.get(Constants.REFERRED_QUEUE_NAME)
            .contains(oldMap.get(newAppRecord.Id).OwnerId) &&
          groupMemMap.get(Constants.REFERRED_QUEUE_NAME)
            .contains(newAppRecord.OwnerId)
        ) {
          // check whether exisitng owner was member of referred application queue as well as
          //the new owner is from referred application queue
          newAppRecord.Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
          if (
            applicationMap.get(newAppRecord.Id).cases__r <> null &&
            applicationMap.get(newAppRecord.Id).cases__r.size() > 0
          ) {
            // check whether the application record has case related to it
            for (Case cases : applicationMap.get(newAppRecord.Id).cases__r) {
              cases.Status = Constants.ASSIGNED_STATUS;
              cases.OwnerId = newAppRecord.OwnerId;
              caseList.add(cases);
            }
          }
        }
      }
    }
    if (caseList.size() > 0) {
      update caseList;
    }
  }

  /**
   * @description : This method is used to get map of group members from salesforce
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   * @return Map<String, List<Id>>
   **/
  private static Map<String, List<Id>> getGroupsMembersMap() {
    List<GroupMember> groupList = [
      SELECT UserOrGroupId, Group.DeveloperName
      FROM GroupMember
      WITH SECURITY_ENFORCED
    ];
    Map<String, List<Id>> groupMap = new Map<String, List<Id>>();
    for (GroupMember groups : groupList) {
      if (groupMap.containsKey(groups.Group.DeveloperName)) {
        List<Id> grpMemberList = groupMap.get(groups.Group.DeveloperName);
        grpMemberList.add(groups.UserOrGroupId);
        groupMap.put(groups.Group.DeveloperName, grpMemberList);
      } else {
        groupMap.put(
          groups.Group.DeveloperName,
          new List<Id>{ groups.UserOrGroupId }
        );
      }
    }
    return groupMap;
  }
}
