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
public with sharing class OneJNOutputEventQueueable implements Queueable {
  String body;
  public OneJNOutputEventQueueable(String body) {
    this.body = body;
  }
  public void execute(QueueableContext context) {
    //process one jn output event types
  }
}
