/**
 * @description       : 
 * @author            : Trupti Zende (Thinqloud)
 * @group             : 
 * @last modified on  : 06-21-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log 
 * Ver   Date         Author                     Modification
 * 1.0   06-16-2021   Trupti Zende (Thinqloud)   Initial Version
**/
public with sharing class ONeJNEventSubmissionHandler {
	@InvocableMethod(
    label='Handle One JN Event Submission'
    description='Handle One JN Event Submission'
  )
    /**
    * @description To process the OneJN Outcoming Events
    * @author Trupti Zende (Thinqloud) | 06-16-2021 
    * @param inputs 
    **/
    public static void HandleEventSubmission(List<FlowInputs> inputs) {
        FlowInputs input = inputs[0];
        OneJNEventFactory.ProcessOutgoingEvent(input.eventType,input.applicationList , input.opportunityList);
    }
    public class FlowInputs {
    @InvocableVariable
    public String eventType;
    @InvocableVariable
    public List<Opportunity> opportunityList;
    @InvocableVariable
    public List<Application__c> applicationList;
  }
}