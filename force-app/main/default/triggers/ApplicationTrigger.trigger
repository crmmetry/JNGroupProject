/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-09-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-20-2021   Remario Richards   Initial Version
 **/
trigger ApplicationTrigger on Application__c(before insert, before update) {
  if (Util.canTriggerExecute()) {
    ApplicationTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
    if (Trigger.isInsert) {
      if (Trigger.isBefore) {
        ApplicationTriggerHandler.checkOpportunityHasOneApplication();
      }
    }

    if (Trigger.isUpdate) {
      if (Trigger.isBefore) {
        ApplicationTriggerHandler.changeApplicationStatus();
      }
    }
  }
}
