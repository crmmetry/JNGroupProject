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
trigger DocumentCheckList on DocumentChecklistItem(
  before insert,
  after insert,
  before update,
  after update
) {
  if (Util.canTriggerExecute()) {
    if (Trigger.isInsert) {
      if (Trigger.isAfter) {
        DocumentChecklistItemTriggerHandler.CheckDocumentType(Trigger.New);
      } else if (Trigger.isBefore) {
      }
    } else if (Trigger.isUpdate) {
      if (Trigger.isAfter) {
      } else if (Trigger.isBefore) {
      }
    }
  }
}
