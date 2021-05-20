trigger CaseTrigger on Case(before insert, before update) {
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
