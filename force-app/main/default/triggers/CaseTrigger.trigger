/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 06-09-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   05-28-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
trigger CaseTrigger on Case(before insert, after update) {
  if (Util.canTriggerExecute()) {
    CaseTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
    if (Trigger.isInsert) {
      if (Trigger.isBefore) {
        CaseTriggerHandler.addEntitlementToCase();
      }
    }
    if (Trigger.isUpdate) {
      if (Trigger.isAfter) {
        CaseTriggerHandler.restartMilestone();
      }
    }
  }
}
