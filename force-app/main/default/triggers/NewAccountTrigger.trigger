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
trigger NewAccountTrigger on Account(
  after update,
  before delete,
  before update,
  after insert,
  before insert
) {
  if (Util.canTriggerExecute()) {
    NewAccountTriggerHandler.init(
      Trigger.new,
      Trigger.oldMap,
      Trigger.newMap,
      Trigger.old
    );
    // NewAccountTriggerHandler.creditscoreonAccount(
    //   Trigger.isUpdate,
    //   Trigger.isDelete
    // );
    if (Trigger.isUpdate) {
      if (Trigger.isAfter) {
      } else {
        NewAccountTriggerHandler.assignMobileNumber();
        NewAccountTriggerHandler.SetAccountAffiliations();
      }
    } else if (Trigger.isInsert) {
      if (Trigger.isAfter) {
      } else {
        NewAccountTriggerHandler.assignMobileNumber();
      }
    }
  }
}
