/**
 * @description       : To update Opportunity path field 'Financial Flow'
 * @author            : Tushar Chopade(Thinqloud)
 * @group             :
 * @last modified on  : 04-20-2021
 * @last modified by  : Tushar Chopade(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                      Modification
 * 1.0   04-20-2021   Tushar Chopade(Thinqloud)   Initial Version
 **/
public class UpdateOppPathFinancialflowField {
  public class FlowInputParameters {
    @InvocableVariable(label='Main OpportunityId' required=true)
    public String opportunityId;
  }

  /**
   * @description : This method aceepts parameter from flow and update field ,based on Opportunity Id
   * @author Tushar Chopade(Thinqloud) | 04-20-2021
   * @param inputs
   **/
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
