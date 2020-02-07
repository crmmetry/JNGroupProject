/**
 * @File Name          : crmm_TierOne.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/3/2019, 7:40:18 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/3/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_TierOne on Lead (before insert) {
    for(Lead leadObj :Trigger.new){
QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name ='Sales Development Team' Limit 1];
     User usrID = [Select Id,Sales_User__c from User where Id=:leadObj.OwnerId];
        if( usrID.Sales_User__c==False){
            leadObj.OwnerId= QueueID.Queue.Id; 
        }
    }

}