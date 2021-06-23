/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-21-2021
 * @last modified by  : Trupti Zende (Thinqloud)
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
  /**
  * @description process one JN Output Events
  * @author Trupti Zende (Thinqloud) | 06-21-2021 
  * @param context 
  **/
  public void execute(QueueableContext context) {
    //process one jn output event types
    OneJNEventFactory.ProcessIncomingEvent(
      eventType,
      oneJNDeserializer,
      sfRecordId
    );
  }
}
