/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNEventFactory {
  /**
   * @description process inbound events
   * @author Remario Richards | 05-26-2021
   * @param eventType
   * @param oneJNDeserializer
   **/
  public static void ProcessIncomingEvent(
    String eventType,
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId
  ) {
    if (eventType == Constants.RETURN_LOAN_APPLICATION_ID) {
      processGetApplicationEvent(oneJNDeserializer, sfRecordId, eventType);
    }
    if (
      eventType == Constants.RETURN_CREDITCARD_PRE_ASSESSMENT ||
      eventType == Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT
    ) {
      processGetPreAssessmentEventResponse(
        oneJNDeserializer,
        sfRecordId,
        eventType
      );
    }
    /*    if(eventType == Constants.RETURN_MANUAL_DESICION ){
      processGetManualIdEvent(oneJNDeserializer,sfRecordId, eventType);
    }*/
    if (
      eventType == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      eventType == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      processGetPreAssessmentEventResponse(
        oneJNDeserializer,
        sfRecordId,
        eventType
      );
    }
  }
  /**
   * @description process outbound events
   * @author Remario Richards | 05-26-2021
   **/
  public static void ProcessOutgoingEvent(
    String eventType,
    List<Application__c> applicationList,
    List<Opportunity> opportunityList
  ) {
    if (eventType == Constants.GET_LOAN_APPLICATION_ID) {
      processGetApplicationIdEvent(applicationList);
    }
    if (
      eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT ||
      eventType == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT
    ) {
      processGetPreAssessmentEvent(eventType, opportunityList);
    }
    if (
      eventType == Constants.GET_CREDITCARD_FINAL_ASSESSMENT ||
      eventType == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      processGetPreAssessmentEvent(eventType, opportunityList);
    }
    if (eventType == Constants.GET_MANUAL_DESICION) {
      processGetManualEvent(applicationList);
    }
  }

  /**
   * @description
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param application
   **/
  private static void processGetApplicationIdEvent(
    List<Application__c> applicationList
  ) {
    // to get the request JSON
    system.debug('processGetApplicationIdEvent');
    String JSONString = OneJNEventService.build(
      applicationList,
      new List<Opportunity>{}
    );
    system.debug('JSONString :: ' + JSONString);
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      Constants.GET_LOAN_APPLICATION_ID,
      applicationList[0].Id,
      JSONString
    );
    // publish the event
    Database.SaveResult result = EventBus.publish(requestPlatformEvent);
    if (result.isSuccess()) {
      System.debug('Platform event published successfully.');
    } else {
      for (Database.Error err : result.getErrors()) {
        System.debug('Error returned: ' + err.getStatusCode());
      }
    }
  }
  /**
   * @description
   * @author Rahul Rahangdale (Thinqloud) | 06-07-2021
   * @param application
   **/
  private static void processGetManualEvent(
    List<Application__c> applicationList
  ) {
    // to get the request JSON
    system.debug('processGetManualEvent');
    String JSONString = OneJNEventService.build(
      applicationList,
      new List<Opportunity>{}
    );
    system.debug('JSONString :: ' + JSONString);
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      Constants.GET_MANUAL_DESICION,
      applicationList[0].Id,
      JSONString
    );
    // publish the event
    Database.SaveResult result = EventBus.publish(requestPlatformEvent);
    if (result.isSuccess()) {
      System.debug('Platform event published successfully.');
    } else {
      for (Database.Error err : result.getErrors()) {
        System.debug('Error returned: ' + err.getStatusCode());
      }
    }
  }

  /**
   * @description process application events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processGetApplicationEvent(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String EventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      EventType,
      sfRecordId
    );
    if (deserialiser.applicationRecord <> null) {
      update deserialiser.applicationRecord;
    }
  }
  /**
   * @description process pre assessment events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processPreassessmentEvent(
    OneJNDeserializer oneJNDeserializer
  ) {
  }
  /**
   * @description process final assessment events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processFinalAssessmentEvent(
    OneJNDeserializer oneJNDeserializer
  ) {
  }

  /**
   * @description
   * @author Trupti Zende (Thinqloud) | 06-04-2021
   * @param applicationList
   **/
  private static void processGetPreAssessmentEvent(
    String eventType,
    List<Opportunity> opportunityList
  ) {
    // to get the request JSON
    String JSONString = OneJNEventService.build(
      new List<Application__c>{},
      opportunityList
    );
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      eventType,
      opportunityList[0].id,
      JSONString
    );
    // publish the event
    Database.SaveResult result = EventBus.publish(requestPlatformEvent);
    if (result.isSuccess()) {
      System.debug('Platform event published successfully.');
    } else {
      for (Database.Error err : result.getErrors()) {
        System.debug('Error returned: ' + err.getStatusCode());
      }
    }
  }

  private static void processGetPreAssessmentEventResponse(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String EventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      EventType,
      sfRecordId
    );
    if (deserialiser.primaryApplicantRecord <> null) {
      update deserialiser.primaryApplicantRecord;
    }
    if (deserialiser.coApplicantRecord <> null) {
      update deserialiser.coApplicantRecord;
    }
    if (deserialiser.opportunityRecord <> null) {
      update deserialiser.opportunityRecord;
    }
    if (deserialiser.applicationRecord <> null) {
      update deserialiser.applicationRecord;
    }
    if (
      EventType == RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      EventType == RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      if (deserialiser.loanCalculationProductRecord <> null) {
        update deserialiser.loanCalculationProductRecord;
      }
    }
  }
  private static void processGetManualIdEvent(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String EventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      EventType,
      sfRecordId
    );
    if (deserialiser.primaryApplicantRecord <> null) {
      // update deserialiser.primaryApplicantRecord;
    }
    if (deserialiser.coApplicantRecord <> null) {
      //   update deserialiser.coApplicantRecord;
    }
    if (deserialiser.opportunityRecord <> null) {
      update deserialiser.opportunityRecord;
    }
    if (deserialiser.applicationRecord <> null) {
      update deserialiser.applicationRecord;
    }
    if (deserialiser.loanCalculationProductRecord <> null) {
      update deserialiser.loanCalculationProductRecord;
    }
  }
}
