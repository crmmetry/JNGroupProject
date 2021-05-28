/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 05-28-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   05-28-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
trigger NewEmploymentTrigger on FinServ__Employment__c(
  before insert,
  before delete,
  after insert,
  before update,
  after update
) {
  if (Util.getContextTriggerSwitches()) {
    EmploymentTriggerHandler.init(
      Trigger.new,
      Trigger.oldMap,
      Trigger.newMap,
      Trigger.old
    );
    // EmploymentTriggerHandler.creditScoreOnEmployment(
    //   Trigger.isDelete,
    //   Trigger.isUpdate
    // );

    if (Trigger.isUpdate) {
      if (Trigger.isAfter) {
      } else {
        EmploymentTriggerHandler.checkCurrentEmployments();
      }
    } else if (Trigger.isInsert) {
      if (Trigger.isAfter) {
      } else {
        EmploymentTriggerHandler.checkCurrentEmployments();
      }
    }
  }
}
