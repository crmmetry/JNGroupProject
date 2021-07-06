/**
 * @description       : Controller for the OneJNErrorReporting lightning component
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-06-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-06-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public class OneJNErrorReportingController {
  /**
   * @description : get the map of error logs for the opportunity and application object
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   * @param recordId
   * @return Map<Id, Map<String, String>>
   **/
  @AuraEnabled
  public static Map<Id, Map<String, String>> getErrorLogs(Id recordId) {
    Schema.SObjectType objectName = recordId.getSobjectType();

    sObject sobjectRecord = getsObjectRecord(recordId, objectName);
    User userDetails = getUserDetails(
      String.valueOf(sobjectRecord.get('LastModifiedById'))
    );
    Map<Id, Map<String, String>> eventLogMap = new Map<Id, Map<String, String>>();

    List<OneJN_Event_Log__c> eventLogList = getErrorEventLogs(recordId);

    if (!eventLogList.isEmpty() && eventLogList.size() > 0) {
      for (OneJN_Event_Log__c eventLog : eventLogList) {
        String body = eventLog.Body__c;
        Map<String, Object> JSONData = (Map<String, Object>) JSON.deserializeUntyped(
          body
        );
        Map<String, String> valuesMap = new Map<String, String>();
        for (String jsonKey : JSONData.KeySet()) {
          if (JSONData.get(jsonKey) != null || JSONData.get(jsonKey) != '') {
            if (jsonKey == 'SourceEvent') {
              valuesMap.put(
                jsonKey,
                String.valueOf(JSONData.get(jsonKey)).substringAfterLast('.')
              );
            } else {
              valuesMap.put(jsonKey, String.valueOf(JSONData.get(jsonKey)));
            }
          }
        }
        valuesMap.put('Time', eventLog.CreatedDate.format('h:mm a'));
        valuesMap.put('Date', eventLog.CreatedDate.format('MM/dd/yyyy'));
        valuesMap.put('LastModifiedBy', userDetails.Name);
        eventLogMap.put(eventLog.Id, valuesMap);
      }
    }
    return eventLogMap;
  }

  /**
   * @description : get the user details by passing the Id
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   * @param userId
   * @return User
   **/
  public static User getUserDetails(Id userId) {
    User userDetails = [SELECT ID, Name FROM User WHERE Id = :userId];
    return userDetails;
  }

  /**
   * @description : get the list of error reporting event
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   * @param recordId
   * @return List<OneJN_Event_Log__c>
   **/
  public static List<OneJN_Event_Log__c> getErrorEventLogs(Id recordId) {
    List<OneJN_Event_Log__c> eventLogList = [
      SELECT Body__c, Id, CreatedDate
      FROM OneJN_Event_Log__c
      WHERE
        Event_Source__c = :Constants.EXTERNAL
        AND Name__c = :Constants.GENERIC_ERROR_EVENT
        AND Salesforce_Record_Id__c = :recordId
      ORDER BY CreatedDate DESC
      LIMIT 5
    ];
    return eventLogList;
  }

  /**
   * @description : get the sobject ( opportunity or Application) record by passing id
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   * @param recordId
   * @param objectName
   * @return sObject
   **/
  public static sObject getsObjectRecord(
    String recordId,
    Schema.SObjectType objectName
  ) {
    String query =
      'SELECT Id, Name,' +
      ' LastModifiedBy.Name' +
      ' FROM ' +
      objectName +
      ' WHERE Id = \'' +
      recordId +
      '\'';
    sObject sobjectRecord = Database.query(query);
    return sobjectRecord;
  }
}
