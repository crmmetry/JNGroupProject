/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-15-2021
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
  String replayId;
  public OneJNOutputEventQueueable(
    String body,
    String eventType,
    String externalId,
    String sfRecordId,
    String replayId
  ) {
    this.eventType = eventType;
    this.externalId = externalId;
    this.sfRecordId = sfRecordId;
    this.body = body;
    this.replayId = replayId;
  }
  /**
   * @description process one JN Output Events
   * @author Trupti Zende (Thinqloud) | 06-21-2021
   * @param context
   **/
  public void execute(QueueableContext context) {
    //process one jn output event types
    Map<String, Boolean> classNameMap = OneJNBaseDeSerializer.identifyInstance(
      eventType
    );
    try {
      if (classNameMap.get(Constants.LOANQUOTE_CLASSNAME)) {
        OneJNDeserializer oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
          body,
          OneJNDeserializer.class
        );
        OneJNEventFactory.ProcessIncomingEvent(
          eventType,
          oneJNDeserializer,
          sfRecordId,
          replayId
        );
      } else if (classNameMap.get(Constants.ONBOARDING_CLASSNAME)) {
        OneJNOnBoardingDeserialiser oneJNOnBoardingDeserializer = (OneJNOnBoardingDeserialiser) JSON.deserialize(
          body,
          OneJNOnBoardingDeserialiser.class
        );
        OneJNEventFactory.ProcessIncomingEventOnBoarding(
          eventType,
          oneJNOnBoardingDeserializer,
          replayId
        );
      }
    } catch (Exception e) {
      Util.handleOneJNExeption(e, eventType, externalId, sfRecordId, replayId);
    }
  }
}
