/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-13-2021
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
      processGetApplicationEventResponse(
        oneJNDeserializer,
        sfRecordId,
        eventType
      );
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
    if (
      eventType == Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE ||
      eventType == Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE
    ) {
      processGetManualIdEventResponse(oneJNDeserializer, sfRecordId, eventType);
    }
    if (
      eventType == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      eventType == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      processFinalAssessmentEventResponse(
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
      processGetApplicationIdEventRequest(applicationList, eventType);
    }
    if (
      eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT ||
      eventType == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT
    ) {
      processGetPreAssessmentEventRequest(eventType, opportunityList);
    }
    if (
      eventType == Constants.SUBMIT_CREDIT_CARD_MANUAL_DECISION ||
      eventType == Constants.SUBMIT_UNSECURED_LOAN_MANUAL_DECISION
    ) {
      processGetManualEventRequest(eventType, applicationList);
    }
    if (
      eventType == Constants.GET_CREDITCARD_FINAL_ASSESSMENT ||
      eventType == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      processGetPreAssessmentEventRequest(eventType, opportunityList);
    }
  }

  /**
   * @description process application event request
   * @author Ishwari Gaikwad(Thinqloud) | 06-03-2021
   * @param application
   **/
  private static void processGetApplicationIdEventRequest(
    List<Application__c> applicationList,
    String eventType
  ) {
    // to get the request JSON
    String JSONString = OneJNEventService.build(
      applicationList,
      new List<Opportunity>{},
      eventType
    );
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      Constants.GET_LOAN_APPLICATION_ID,
      applicationList[0].Id,
      JSONString,
      ''
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
  private static void processGetManualEventRequest(
    string eventType,
    List<Application__c> applicationList
  ) {
    // to get the request JSON
    String JSONString = OneJNEventService.build(
      applicationList,
      new List<Opportunity>{},
      eventType
    );
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      eventType,
      applicationList[0].Id,
      JSONString,
      ''
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
  private static void processGetApplicationEventResponse(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String eventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      eventType,
      sfRecordId
    );
    if (deserialiser.applicationRecord <> null) {
      SObjectAccessDecision decision = Security.stripInaccessible(
        AccessType.UPDATABLE,
        new List<Application__c>{ deserialiser.applicationRecord }
      );
      update decision.getRecords();
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
  private static void processFinalAssessmentEventResponse(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String eventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      eventType,
      sfRecordId
    );
    List<sObject> sObjectsToUpdate = new List<sObject>();
    if (deserialiser.primaryApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.primaryApplicantRecord);
    }
    if (deserialiser.coApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.coApplicantRecord);
    }
    if (deserialiser.opportunityRecord <> null) {
      sObjectsToUpdate.add(deserialiser.opportunityRecord);
    }
    if (deserialiser.applicationRecord <> null) {
      sObjectsToUpdate.add(deserialiser.applicationRecord);
    }
    if (deserialiser.loanCalculationProductRecord <> null) {
      sObjectsToUpdate.add(deserialiser.loanCalculationProductRecord);
    }
    if (sObjectsToUpdate.size() > 0) {
      SObjectAccessDecision decision = Security.stripInaccessible(
        AccessType.UPDATABLE,
        sObjectsToUpdate
      );
      update decision.getRecords();
    }
  }

  /**
   * @description to process request for pre-assessment event
   * @author Trupti Zende (Thinqloud) | 06-04-2021
   * @param applicationList
   **/
  private static void processGetPreAssessmentEventRequest(
    String eventType,
    List<Opportunity> opportunityList
  ) {
    // to get the request JSON
    String JSONString = OneJNEventService.build(
      new List<Application__c>{},
      opportunityList,
      eventType
    );
    // to get the initialised platform event record
    One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
      eventType,
      opportunityList[0].id,
      JSONString,
      ''
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
   * @description process pre-assessment events
   * @author Trupti Zende (Thinqloud) | 06-21-2021
   * @param oneJNDeserializer
   * @param sfRecordId
   * @param eventType
   **/
  private static void processGetPreAssessmentEventResponse(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String eventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      eventType,
      sfRecordId
    );
    List<sObject> sObjectsToUpdate = new List<sObject>();
    if (deserialiser.primaryApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.primaryApplicantRecord);
    }
    if (deserialiser.coApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.coApplicantRecord);
    }
    if (deserialiser.opportunityRecord <> null) {
      sObjectsToUpdate.add(deserialiser.opportunityRecord);
    }
    if (deserialiser.applicationRecord <> null) {
      sObjectsToUpdate.add(deserialiser.applicationRecord);
    }
    if (deserialiser.documentInstructions <> null) {
      sObjectsToUpdate.addAll(deserialiser.documentInstructions);
    }
    if (sObjectsToUpdate.size() > 0) {
      SObjectAccessDecision decision = Security.stripInaccessible(
        AccessType.UPSERTABLE,
        sObjectsToUpdate
      );
      upsert decision.getRecords();
    }
  }
  /**
   * @description process manual decision events
   * @author Rahul Rahangdale (Thinqloud) | 06-09-2021
   * @param application
   **/

  private static void processGetManualIdEventResponse(
    OneJNDeserializer oneJNDeserializer,
    String sfRecordId,
    String eventType
  ) {
    oneJNDeserializer deserialiser = OneJNDeserializer.parse(
      oneJNDeserializer,
      eventType,
      sfRecordId
    );
    List<sObject> sObjectsToUpdate = new List<sObject>();
    if (deserialiser.primaryApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.primaryApplicantRecord);
    }
    if (deserialiser.coApplicantRecord <> null) {
      sObjectsToUpdate.add(deserialiser.coApplicantRecord);
    }
    if (deserialiser.opportunityRecord <> null) {
      sObjectsToUpdate.add(deserialiser.opportunityRecord);
    }
    if (deserialiser.applicationRecord <> null) {
      sObjectsToUpdate.add(deserialiser.applicationRecord);
    }
    if (deserialiser.loanCalculationProductRecord <> null) {
      sObjectsToUpdate.add(deserialiser.loanCalculationProductRecord);
    }
    if (sObjectsToUpdate.size() > 0) {
      SObjectAccessDecision decision = Security.stripInaccessible(
        AccessType.UPDATABLE,
        sObjectsToUpdate
      );
      update decision.getRecords();
    }
  }

  /**
   * @description
   * @author Ishwari Gaikwad(Thinqloud) | 07-12-2021
   * @param eventType
   * @param oneJNOnBoardingDeserializer
   **/
  public static void ProcessIncomingEventOnBoarding(
    String eventType,
    OneJNOnBoardingDeserialiser oneJNOnBoardingDeserializer
  ) {
    OneJNOnBoardingDeserialiser deserialiser = OneJNOnBoardingDeserialiser.parse(
      oneJNOnBoardingDeserializer,
      eventType
    );
    try {
      if (deserialiser.accountRecord <> null) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(
          AccessType.UPSERTABLE,
          new List<sObject>{ deserialiser.accountRecord }
        );
        upsert (List<Account>) securityDecision.getRecords() GUID_Text__c;
      }
    } catch (Exception e) {
      OneJNSerializerDecision.ExceptionWrapper exceptionWrapper = new OneJNSerializerDecision.ExceptionWrapper();
      String json = exceptionWrapper.getExceptionJson(e, eventType);
      One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
        Constants.GENERIC_ERROR_EVENT,
        '',
        json,
        deserialiser.Id
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
  }
}
