/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_FinServ_EmploymentTrigger on FinServ__Employment__c(
  before delete,
  before insert,
  before update,
  after delete,
  after insert,
  after undelete,
  after update
) {
  if (Util.canTriggerExecute()) {
    dlrs.RollupService.triggerHandler(FinServ__Employment__c.SObjectType);
  }
}
