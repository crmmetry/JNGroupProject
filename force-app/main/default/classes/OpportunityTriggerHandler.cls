public class OpportunityTriggerHandler {
    private static String Tag = 'OpportunityTriggerHandler';
    private static List<Opportunity> newRecords;
    private static Map<Id, Opportunity> oldMap;
    
    public static void init(List<Opportunity> newRecords, Map<Id, Opportunity> oldMap){
        OpportunityTriggerHandler.newRecords = newRecords;
        OpportunityTriggerHandler.oldMap = oldMap;
    }
    public static void setOpportunityAmountOnLead(Boolean isAfter, Boolean isUpdate, Boolean isInsert){
        Set<id> oppid = new set<id>();
        Map<id,Double> oppMap = new Map<id,Double>();
        String oppsID;
        Double oppAMT;
        system.debug('Trigger called=====================>');
        if(isAfter){
            if(isInsert){
                for(Opportunity opp : newRecords){
                    if(opp.StageName=='Closed Won' ){
                        oppid.add(opp.ID);
                        oppMap.put(opp.id,opp.Amount);
                        oppsID = opp.ID;
                        oppAMT = opp.Amount;
                    }                            
                }  
            }
            if(isUpdate){
                system.debug('oppid=====================>'+Trigger.new);
                for(Opportunity opp : newRecords){
                    Opportunity oppOld=oldMap.get(opp.id);
                    if((oppOld.StageName != opp.StageName && opp.StageName=='Closed Won' ) ) {
                        oppid.add(opp.ID);
                        oppMap.put(opp.id,opp.Amount);
                        oppsID = opp.ID;
                        oppAMT = opp.Amount;
                    }
                }  
            }
            system.debug('oppid=====>'+oppid);
            /*
if(oppid.size()>0) {
List<Lead> lstlead = [select id,Actual_Amount_From_Opportunity__c,Opportunity__c from lead where Opportunity__c IN:oppid ];
if(lstlead.size()>0){
for(lead l:lstlead){
l.Actual_Amount_From_Opportunity__c = oppMap.get(l.Opportunity__c);
}
update lstlead;
system.debug('lstlead=====>'+lstlead);
}
}
*/
            
            if(oppAMT>0) {
                List<Lead> lstlead = [select id,Actual_Amount_From_Opportunity__c,Opportunity__c , ConvertedAccountId from lead where ConvertedAccountId IN (select accountId from opportunity where Id =:oppsID )];
                if(lstlead.size()>0){
                    for(lead l:lstlead){
                        l.Actual_Amount_From_Opportunity__c = oppAMT;
                    }
                    update lstlead;
                    system.debug('lstlead=====>'+lstlead);
                }
            }
            
            
            
        }
    }
    public static void assignOpportunityRecordTypeName(){
        List<Id> ids = new List<Id>();
        Boolean match = false;
        String recordTypeName = '';
        for(Opportunity opp: newRecords){
            ids.add(opp.AccountId);
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Name FROM Account WHERE Id IN :ids]);
        
        for(Opportunity opp: newRecords){
            recordTypeName = getRecordTypeDeveloperName(getRecordTypeName(opp));
            switch on recordTypeName {
                when 'Credit_Facility' {
                    match = true;
                }
                when 'Mortgage' {
                    match = true;
                }
                when 'Savings_Chequing' {
                    match = true;
                }               
            }
            if(match == true){
                opp.Name = accountMap.get(opp.AccountId).Name + ' - '+ getRecordTypeName(opp);
                match = false;
            }
        }
        
    }
    public static void creditScoreOppHandler() {
        system.debug('Trigger called=====================>');
        CreditScoreHelper cs = new CreditScoreHelper();
        Set<id> oppid = new set<id>();   
        if(Trigger.isAfter){      
            for(Opportunity opp : newRecords){
                oppid.add(opp.ID);
            }        
        }
        if(oppid.size()>0){
            cs.CreditScoreFromOpp(oppid);
        }
    }
    public static void lockRecordsForEditing(){
        String errMsg = 'This record is currently LOCKED due to it being in the stage of "Closed Won" or "Closed Lost". Disable CoreLocker in CustomMetaData to enable record edit.';
        Opportunity_Update_Locker__mdt locker = [SELECT Id, LockEnabled__c, RecordType__c 
                                                 FROM Opportunity_Update_Locker__mdt 
                                                 WHERE Label='CoreLocker' LIMIT 1];
        if(locker != null){            
            if(locker.LockEnabled__c) {
                for(Opportunity opp : newRecords) {
                    if(oldMap.get(opp.Id).StageName == 'Closed Lost' || oldMap.get(opp.Id).StageName == 'Closed Won'){
                        opp.addError(errMsg);
                    }                
                }
            }
        }
    }
    private static String getRecordTypeName(Opportunity opp){
        return Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordTypeId).getname();
    }
    private static String getRecordTypeDeveloperName(String name) {
        return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(name).getDeveloperName();
    }
}