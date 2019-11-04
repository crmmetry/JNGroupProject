trigger CreditscoreonAccount on Account (after update, before delete) {
    if(CreditScoreHelper.FirstRunAcc)
        return;
    set<Id> oppIdSet= new set<Id>(); 
    if(trigger.isDelete){
        for(Opportunity opp:[select id from Opportunity where AccountId=:Trigger.old]){
            oppIdSet.add(opp.Id);
        }
        for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:Trigger.old]){
            oppIdSet.add(app.Opportunity__c);
        }   
    }
    if(trigger.isUpdate){
        for(Opportunity opp:[select id from Opportunity where AccountId=:Trigger.new]){
            oppIdSet.add(opp.Id);
        }
        for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:Trigger.new]){
            oppIdSet.add(app.Opportunity__c);
        }   
    }
    system.debug('oppIdSet======'+oppIdSet);
    if(oppIdSet.size()>0){
        CreditScoreHelper cs = new CreditScoreHelper();
        cs.CreditScoreFromOpp(oppIdSet);
    }
}