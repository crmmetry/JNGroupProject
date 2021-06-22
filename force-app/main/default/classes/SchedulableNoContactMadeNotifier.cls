/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-22-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-22-2021   Travis Allen   Initial Version
 **/
global with sharing class SchedulableNoContactMadeNotifier implements Schedulable {
  global void execute(SchedulableContext ctx) {
    System.enqueueJob(new NoContactMadeNotifierOnLeads());
  }
}
