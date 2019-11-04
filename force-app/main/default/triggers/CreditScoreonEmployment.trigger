trigger CreditScoreonEmployment on FinServ__Employment__c (after update, before delete) {
    set<Id> oppIdSet= new set<Id>();
    set<Id> accIdSet= new set<Id>();
    if(trigger.isDelete){
        for(FinServ__Employment__c emp:[select id,account__c from FinServ__Employment__c where Id=:Trigger.old]){
            accIdSet.add(emp.account__c);
        }
        for(Opportunity opp:[select id from Opportunity where AccountId=:accIdSet]){
            oppIdSet.add(opp.Id);
        }
        for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:accIdSet]){
            oppIdSet.add(app.Opportunity__c);
        }   
    }
    if(trigger.isUpdate){
        for(FinServ__Employment__c emp:[select id,account__c from FinServ__Employment__c where Id=:Trigger.new]){
            accIdSet.add(emp.account__c);
        }
        for(Opportunity opp:[select id from Opportunity where AccountId=:accIdSet]){
            oppIdSet.add(opp.Id);
        }
        for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:accIdSet]){
            oppIdSet.add(app.Opportunity__c);
        }   
    }
    system.debug('oppIdSet======'+oppIdSet);
    if(oppIdSet.size()>0){
        CreditScoreHelper cs = new CreditScoreHelper();
        cs.CreditScoreFromOpp(oppIdSet);
    }
}