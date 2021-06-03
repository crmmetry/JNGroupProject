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
trigger NewOpportunityTrigger on Opportunity(
  before insert,
  after insert,
  after update,
  before update
) {
  if (Util.canTriggerExecute()) {
    OpportunityTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
    Set<id> oppid = new Set<id>();
    if (Trigger.isUpdate) {
      if (Trigger.isBefore) {
        OpportunityTriggerHandler.lockRecordsForEditing();
        OpportunityTriggerHandler.assignOpportunityRecordTypeName();
        //OpportunityTriggerHandler.validateApplicantProfileCompletion();
        OpportunityTriggerHandler.validateCloseBackDate(
          2,
          7,
          Date.today(),
          Constants.DEFAULT_BUSINESS_HOURS_NAME
        );
        OpportunityTriggerHandler.ProductsFamiliyValidation();
      }
    } else if (Trigger.isInsert) {
      if (Trigger.isBefore) {
        OpportunityTriggerHandler.assignOpportunityRecordTypeName();
      }
    }
    OpportunityTriggerHandler.setOpportunityAmountOnLead(
      Trigger.isAfter,
      Trigger.isUpdate,
      Trigger.isInsert
    );
  } // causing last contact made issues
}
