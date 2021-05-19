/**
 * @description       : To Validate that one opportunity have one application
 * @author            : Tushar Chopade(Thinqloud)
 * @group             :
 * @last modified on  : 05-19-2021
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
    for (Application__c newAppRecord : newRecords) {
      if (
        newAppRecord.OwnerId <> oldMap.get(newAppRecord.Id).OwnerId &&
        newAppRecord.Adjudication_Path_picklist__c == Constants.OPEN_STATUS
      ) {
        if (
          oldMap.get(newAppRecord.Id).OwnerId == referredQueueId &&
          groupMemMap.get(Constants.REFERRED_QUEUE_NAME)
            .contains(newAppRecord.OwnerId)
        ) {
          newAppRecord.Adjudication_Path_picklist__c = Constants.ASSIGNED_STATUS;
        }
      }
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
