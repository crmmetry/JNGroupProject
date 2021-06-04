trigger OneJNOutputEventTrigger on One_JN_Output__e(after insert) {
  for (One_JN_Output__e evt : Trigger.New) {
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField('applicationID', 'TEST5236');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
    System.debug('jsonData ===>' + jsonData);
    One_JN_Input__e requestPlatformEvent = new One_JN_Input__e();
    requestPlatformEvent.SfRecordId__c = evt.SfRecordId__c;
    requestPlatformEvent.Body__c = jsonData;
    requestPlatformEvent.ExternalId__c = '';

    Database.SaveResult result = EventBus.publish(requestPlatformEvent);
    if (result.isSuccess()) {
      System.debug('Input Platform event published successfully.');
    } else {
      for (Database.Error err : result.getErrors()) {
        System.debug('Input Error returned: ' + err.getStatusCode());
      }
    }
  }
}
