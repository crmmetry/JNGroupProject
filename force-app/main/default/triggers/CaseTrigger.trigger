/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   05-28-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
trigger CaseTrigger on Case(before insert, before update) {
  if (Util.canTriggerExecute()) {
    CaseTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
    if (Trigger.isInsert) {
      if (Trigger.isBefore) {
        CaseTriggerHandler.addEntitlementToCase();
      }
    }
    if (Trigger.isUpdate) {
      if (Trigger.isBefore) {
        CaseTriggerHandler.restartMilestone();
      }
    }
  }
}
