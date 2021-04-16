trigger ApplicationTrigger on Application__c(
  before insert,
  after insert,
  after update,
  before update
) {
  ApplicationTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
  if (Trigger.isInsert) {
    if (Trigger.isAfter) {
      ApplicationTriggerHandler.checkOpportunityHasOneAppliaction();
    }
  }
}
