/**
* @Description        : Handler for trigger
* @Author             : Remario Richards
* @Last Modified By   : Remario Richards
* @Created On		   : 10/7/2019
* @Last Modified On   : 10/7/2019
*/
trigger NewLeadTrigger on Lead (before insert, after insert, before update, after update) {
    LeadTriggerHandler.init(Trigger.new, Trigger.oldMap, Trigger.newMap);
    
    if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            LeadTriggerHandler.crmm_CreateEmploymentOnConversion();
            LeadTriggerHandler.crmm_lead_trigger_conversion();
            LeadTriggerHandler.leadConversionBasic();
            LeadTriggerHandler.convertInfoToEmployment();
        }
        else {
            LeadTriggerHandler.crmm_TimeSpentInStage();
            LeadTriggerHandler.crmm_TierTwoTrigger();
        }
    } else if(Trigger.isInsert){
        if(Trigger.isAfter) {
            LeadTriggerHandler.leadActivityEvent();
        }
        else {
            LeadTriggerHandler.crmm_TierOne();
        }
    } 
}