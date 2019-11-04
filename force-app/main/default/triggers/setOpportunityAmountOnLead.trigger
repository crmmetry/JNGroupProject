trigger setOpportunityAmountOnLead on Opportunity (after insert,after update) {
    Set<id> oppid = new set<id>();
    Map<id,Double> oppMap = new Map<id,Double>();
    String oppsID;
    Double oppAMT;
    system.debug('Trigger called=====================>');
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            for(Opportunity opp : Trigger.new){
                if(opp.StageName=='Closed Won' ){
                    oppid.add(opp.ID);
                    oppMap.put(opp.id,opp.Amount);
                    oppsID = opp.ID;
                    oppAMT = opp.Amount;
                }                            
            }  
        }
        if(Trigger.isUpdate){
            system.debug('oppid=====================>'+Trigger.new);
            for(Opportunity opp : Trigger.new){
                Opportunity oppOld=Trigger.oldMap.get(opp.id);
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