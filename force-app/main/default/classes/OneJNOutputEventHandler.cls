/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-21-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-25-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNOutputEventHandler {
  private static final String TAG = 'OneJNOutputEventHandler';
  @InvocableMethod(
    label='Handle One JN Output Event'
    description='Handle One JN Output Event'
  )
  /**
   * @description handle event payload
   * @author Remario Richards | 05-25-2021
   * @param request
   **/
  public static void HandleEvent(List<FlowInputs> request) {
    System.debug('request body   : ' + request[0].body);
    FlowInputs record = request[0];
    System.enqueueJob(
      new OneJNOutputEventQueueable(
        record.body,
        record.eventType,
        record.externalId,
        record.sfRecordId,
        record.replayId
      )
    );
  }

  public class FlowInputs {
    @InvocableVariable
    public String eventType;
    @InvocableVariable
    public String externalId;
    @InvocableVariable
    public String sfRecordId;
    @InvocableVariable
    public String body;
    @InvocableVariable
    public String replayId;
  }
}
