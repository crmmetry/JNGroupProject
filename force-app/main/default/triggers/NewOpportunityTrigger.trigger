trigger NewOpportunityTrigger on Opportunity(
  before insert,
  after insert,
  after update,
  before update
) {
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
  ); // causing last contact made issues
}
