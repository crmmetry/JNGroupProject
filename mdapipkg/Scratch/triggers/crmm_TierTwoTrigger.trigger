/**
 * @File Name          : crmm_TierTwoTrigger.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/4/2019, 7:02:32 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/4/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_TierTwoTrigger on Lead (before update) {
   for(Lead leadObj :Trigger.new){
   Lead leadObjOld = Trigger.oldMap.get(leadObj.Id);
QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name ='Sales Team' Limit 1];

        if( leadObj.Escalate_to_Tier2__c==true && leadObjOld.Escalate_to_Tier2__c==false ){
            leadObj.Escalated_By__c = UserInfo.getUserId();
            leadObj.OwnerId= QueueID.Queue.Id; 
        } 
    } 

}