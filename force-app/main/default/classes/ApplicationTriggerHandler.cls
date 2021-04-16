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

  public static void checkOpportunityHasOneAppliaction() {
    String errMsg = 'You cant add more than one application for this opportunity';
    Set<Id> oppIdSet = new Set<Id>();
    for (Application__c appRecord : newRecords) {
      oppIdSet.add(appRecord.Opportunity_ID__c);
    }
    Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>(
      [
        SELECT id, (SELECT id FROM Applications__r)
        FROM Opportunity
        WHERE Id IN :oppIdSet AND RecordType.developerName = 'Rubicon'
      ]
    );
    for (Application__c newAppRecord : newRecords) {
      if (opportunityMap.containsKey(newAppRecord.Opportunity_ID__c)) {
        if (
          opportunityMap.get(newAppRecord.Opportunity_ID__c)
            .Applications__r.size() > 1
        ) {
          newAppRecord.addError(errMsg);
        }
      }
    }
  }
}
