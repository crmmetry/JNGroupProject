trigger OneJNOutputEventTrigger on One_JN_Output__e(after insert) {
  for (One_JN_Output__e evt : Trigger.New) {
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('consolidatedReport');

    jsonGen.writeStartObject();
    jsonGen.writeStringField('finalAssessmentReport', 'test');
    jsonGen.writeFieldName('generalInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField(
      'applicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeStringField('preAssessmentDecision', 'Pass');
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
    System.debug('jsonData ===>' + jsonData);
    One_JN_Input__e requestPlatformEvent = new One_JN_Input__e();
    requestPlatformEvent.SfRecordId__c = evt.SfRecordId__c;
    requestPlatformEvent.Body__c = jsonData;
    requestPlatformEvent.ExternalId__c = '';

    if (evt.Name__c == Constants.GET_LOAN_APPLICATION_ID) {
      requestPlatformEvent.Name__c = Constants.RETURN_LOAN_APPLICATION_ID;
    } else if (evt.Name__c == Constants.GET_CREDITCARD_PRE_ASSESSMENT) {
      requestPlatformEvent.Name__c = Constants.RETURN_CREDITCARD_PRE_ASSESSMENT;
    } else if (evt.Name__c == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT) {
      requestPlatformEvent.Name__c = Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT;
    }
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
