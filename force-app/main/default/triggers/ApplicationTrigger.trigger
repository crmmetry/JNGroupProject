/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-18-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-20-2021   Remario Richards   Initial Version
 **/
trigger ApplicationTrigger on Application__c(before insert, before update) {
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
