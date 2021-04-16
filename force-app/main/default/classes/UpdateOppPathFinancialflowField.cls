public class UpdateOppPathFinancialflowField {
  public class FlowInputParameters {
    @InvocableVariable(label='Main OpportunityId' required=true)
    public String opportunityId;
  }

  @InvocableMethod(label='Update Opportunity Financial Flow')
  public static void updateOpportunityFinancialFlow(
    FlowInputParameters[] inputs
  ) {
    FlowInputParameters instance = inputs.get(0);
    if (instance != null) {
      String oppId = instance.opportunityId;
      if (String.isNotBlank(oppId)) {
        Opportunity updateOpportunity = new Opportunity(
          Id = oppId,
          Financial_Flow_flag__c = true
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
