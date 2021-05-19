trigger CaseTrigger on Case(before insert, after update) {
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
