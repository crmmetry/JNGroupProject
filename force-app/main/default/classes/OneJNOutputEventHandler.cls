/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-25-2021
 * @last modified by  : Remario Richards
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
    FlowInputs record = request[0];
    System.enqueueJob(new OneJNOutputEventQueueable(record.body));
  }

  public class FlowInputs {
    @InvocableVariable
    public String sender;

    @InvocableVariable
    public String body;
  }
}
