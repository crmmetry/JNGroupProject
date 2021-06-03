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
trigger NewApplicantTrigger on Applicant__c(
  before insert,
  after insert,
  before update,
  after update,
  before delete
) {
  if (Util.canTriggerExecute()) {
    ApplicantTriggerHandler.init(
      Trigger.new,
      Trigger.oldMap,
      Trigger.newMap,
      Trigger.old
    );
    if (Trigger.isUpdate) {
      if (Trigger.isAfter) {
      } else {
        //ApplicantTriggerHandler.maximumApplicantsOpportunity();
        ApplicantTriggerHandler.setOverallCreditRating();
      }
    } else if (Trigger.isInsert) {
      if (Trigger.isAfter) {
      } else {
        ApplicantTriggerHandler.maximumApplicantsOpportunity();
        ApplicantTriggerHandler.setOverallCreditRating();
      }
    }
  }
}
