/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-13-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-25-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNOutputEventQueueable implements Queueable {
  String eventType;
  String sfRecordId;
  String externalId;
  String body;
  OneJNDeserializer oneJNDeserializer;
  OneJNOnBoardingDeserialiser oneJNOnBoardingDeserializer;
  public OneJNOutputEventQueueable(
    String body,
    String eventType,
    String externalId,
    String sfRecordId
  ) {
    this.eventType = eventType;
    this.externalId = externalId;
    this.sfRecordId = sfRecordId;
    this.body = body;
    try {
      if (
        eventType == Constants.RETURN_LOAN_APPLICATION_ID ||
        eventType == Constants.RETURN_CREDITCARD_PRE_ASSESSMENT ||
        eventType == Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT ||
        eventType == Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE ||
        eventType == Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE ||
        eventType == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
        eventType == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
      ) {
        //deserialize body
        this.oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
          body,
          OneJNDeserializer.class
        );
      } else if (
        eventType == Constants.SUBMIT_PROFILE_EVENT_1 ||
        eventType == Constants.SUBMIT_PROFILE_EVENT_2 ||
        eventType == Constants.SUBMIT_PROFILE_EVENT_3 ||
        eventType == Constants.SUBMIT_PROFILE_EVENT_4 ||
        eventType == Constants.SUBMIT_PROFILE_EVENT_5
      ) {
        //deserialize body
        this.oneJNOnBoardingDeserializer = (OneJNOnBoardingDeserialiser) JSON.deserialize(
          body,
          OneJNOnBoardingDeserialiser.class
        );
      }
    } catch (Exception e) {
      OneJNSerializerDecision.ExceptionWrapper exceptionWrapper = new OneJNSerializerDecision.ExceptionWrapper();
      String json = exceptionWrapper.getExceptionJson(e, eventType);
      One_JN_Output__e requestPlatformEvent = Util.getOutputPlateformEventInstance(
        Constants.GENERIC_ERROR_EVENT,
        '',
        json,
        externalId
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
  /**
   * @description process one JN Output Events
   * @author Trupti Zende (Thinqloud) | 06-21-2021
   * @param context
   **/
  public void execute(QueueableContext context) {
    //process one jn output event types
    if (
      eventType == Constants.RETURN_LOAN_APPLICATION_ID ||
      eventType == Constants.RETURN_CREDITCARD_PRE_ASSESSMENT ||
      eventType == Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT ||
      eventType == Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE ||
      eventType == Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE ||
      eventType == Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT ||
      eventType == Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    ) {
      OneJNEventFactory.ProcessIncomingEvent(
        eventType,
        oneJNDeserializer,
        sfRecordId
      );
    } else if (
      eventType == Constants.SUBMIT_PROFILE_EVENT_1 ||
      eventType == Constants.SUBMIT_PROFILE_EVENT_2 ||
      eventType == Constants.SUBMIT_PROFILE_EVENT_3 ||
      eventType == Constants.SUBMIT_PROFILE_EVENT_4 ||
      eventType == Constants.SUBMIT_PROFILE_EVENT_5
    ) {
      OneJNEventFactory.ProcessIncomingEventOnBoarding(
        eventType,
        oneJNOnBoardingDeserializer
      );
    }
  }
}
