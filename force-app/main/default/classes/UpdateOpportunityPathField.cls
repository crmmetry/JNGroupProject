public class UpdateOpportunityPathField {
  public class FlowInputParameters {
    @InvocableVariable(label='Main OpportunityId' required=true)
    public String opportunityId;
  }

  @InvocableMethod(label='Update Opportunity Application Flow')
  public static void updateOpportunityApplicationFlow(
    FlowInputParameters[] inputs
  ) {
    FlowInputParameters instance = inputs.get(0);
    if (instance != null) {
      String oppId = instance.opportunityId;
      if (String.isNotBlank(oppId)) {
        Opportunity updateOpportunity = new Opportunity(
          Id = oppId,
          Application_Flow_flag__c = true
        );
        try {
          update updateOpportunity;
        } catch (Exception e) {
          System.debug(e.getMessage());
        }
      }
    }
  }
}
