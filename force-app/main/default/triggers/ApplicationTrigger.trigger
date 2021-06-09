/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-20-2021   Remario Richards   Initial Version
 **/
trigger ApplicationTrigger on Application__c(after insert, before insert) {
  ApplicationTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
  if (Trigger.isInsert) {
    if (Trigger.isBefore) {
      ApplicationTriggerHandler.checkOpportunityHasOneApplication();
    }
  }
}
