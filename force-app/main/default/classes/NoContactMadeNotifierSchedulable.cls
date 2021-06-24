/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-24-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-22-2021   Travis Allen   Initial Version
 **/
public with sharing class NoContactMadeNotifierSchedulable implements Schedulable {
  public Datetime currentTime;

  /**
   * Class constructor
   * @author Travis Allen | 06-23-2021
   * @param currentTime
   **/
  public NoContactMadeNotifierSchedulable(Datetime currentTime) {
    this.currentTime = currentTime;
  }
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
