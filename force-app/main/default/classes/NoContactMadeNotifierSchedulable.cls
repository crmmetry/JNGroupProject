/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 07-09-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-22-2021   Travis Allen   Initial Version
 **/
public with sharing class NoContactMadeNotifierSchedulable implements Schedulable {
  public Datetime currentTime = System.now();
  /**
   * Enqueue queueable class.
   * @author Travis Allen | 06-22-2021
   * @param ctx
   **/
  public void execute(SchedulableContext ctx) {
    System.debug('Schedulable Class reached');
    System.enqueueJob(new NoContactMadeNotifierQueueable(currentTime));
  }
}
