public class OneJNErrorReportingController {
  @AuraEnabled
  public static Map<Id, Map<String, String>> getErrorLogs(Id recordId) {
    system.debug('recordId :: ' + recordId);
    Map<Id, Map<String, String>> eventLogMap = new Map<Id, Map<String, String>>();
    List<OneJN_Event_Log__c> eventLogList = [
      SELECT Body__c, Id
      FROM OneJN_Event_Log__c
      WHERE
        Event_Source__c = 'External'
        AND Name__c = 'JNGroup.OneJN.CreditInfo.Domain.Events.GenericErrorEvent'
        AND Salesforce_Record_Id__c = :recordId
      ORDER BY CreatedDate DESC
      LIMIT 5
    ];
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
        eventLogMap.put(eventLog.Id, valuesMap);
      }
    }
    system.debug('eventLogMap ::' + eventLogMap);
    return eventLogMap;
  }
}
