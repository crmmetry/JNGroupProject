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
    String JSONString = OneJNEventService.build(
      applicationList,
      new List<Opportunity>{}
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
}
