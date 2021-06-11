/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-26-2021
 * @last modified by  : Remario Richards
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
    //deserialize body
    this.oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      body,
      OneJNDeserializer.class
    );
  }
  public void execute(QueueableContext context) {
    //process one jn output event types
    OneJNEventFactory.ProcessIncomingEvent(
      eventType,
      oneJNDeserializer,
      sfRecordId
    );
  }
}
