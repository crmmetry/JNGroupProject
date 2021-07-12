/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-12-2021
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
      eventType == Constants.SUBMIT_PROFILE_CREATION_EVENT ||
      eventType == Constants.SUMBIT_PROFILE_UPDATE_EVENT
    ) {
      //deserialize body
      this.oneJNOnBoardingDeserializer = (OneJNOnBoardingDeserialiser) JSON.deserialize(
        body,
        OneJNOnBoardingDeserialiser.class
      );
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
      eventType == Constants.SUBMIT_PROFILE_CREATION_EVENT ||
      eventType == Constants.SUMBIT_PROFILE_UPDATE_EVENT
    ) {
      OneJNEventFactory.ProcessIncomingEventOnBoarding(
        eventType,
        oneJNOnBoardingDeserializer
      );
    }
  }
}
