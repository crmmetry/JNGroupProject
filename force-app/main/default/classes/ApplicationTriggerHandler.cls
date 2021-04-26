/**
 * @description       : To Validate that one opportunity have one application
 * @author            : Tushar Chopade(Thinqloud)
 * @group             :
 * @last modified on  : 04-21-2021
 * @last modified by  : Remario Richards
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
            .Applications__r.size() > 1
        ) {
          newAppRecord.addError(Constants.ONLY_ONE_APPLICATION);
        }
      }
    }
  }
}