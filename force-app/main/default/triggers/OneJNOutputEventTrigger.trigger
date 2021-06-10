/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 06-07-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   06-07-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
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
    if (evt.Name__c == Constants.GET_MANUAL_DESICION_APPROVED) {
      jsonGen.writeStringField('finalAssessmentDecision', 'Approved');
    } else if (evt.Name__c == Constants.GET_MANUAL_DESICION_REJECT) {
      jsonGen.writeStringField('finalAssessmentDecision', 'Denied');
    } else if (
      evt.Name__c == Constants.GET_CREDITCARD_FINAL_ASSESSMENT ||
      evt.Name__c == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      jsonGen.writeStringField('finalAssessmentDecision', 'Referred');
    }
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
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
    } else if (evt.Name__c == Constants.GET_MANUAL_DESICION_APPROVED) {
      requestPlatformEvent.Name__c = Constants.RETURN_MANUAL_DESICION_APPROVED;
    } else if (evt.Name__c == Constants.GET_MANUAL_DESICION_REJECT) {
      requestPlatformEvent.Name__c = Constants.RETURN_MANUAL_DESICION_REJECT;
    } else if (evt.Name__c == Constants.GET_CREDITCARD_FINAL_ASSESSMENT) {
      requestPlatformEvent.Name__c = Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT;
    } else if (evt.Name__c == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT) {
      requestPlatformEvent.Name__c = Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT;
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
