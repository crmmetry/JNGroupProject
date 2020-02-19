trigger ContactContactTrigger on FinServ__ContactContactRelation__c (after insert, before delete) {
    Set<Id> ids = new Set<Id>();
    List<FinServ__ContactContactRelation__c> records;
    if(Trigger.isDelete){
        records = [SELECT Id,FinServ__Role__r.Name,FinServ__Contact__c 
                   FROM FinServ__ContactContactRelation__c WHERE Id IN:Trigger.Old];
        for(FinServ__ContactContactRelation__c record:records){
            if(!record.FinServ__Role__r.Name.contains('Dependent')){
                ids.add(record.FinServ__Contact__c);
                Util.affiliations.put(record.Id, true);
            }
        }
    }  else {
        records = [SELECT Id,FinServ__Role__r.Name,FinServ__Contact__c 
                   FROM FinServ__ContactContactRelation__c WHERE Id IN:Trigger.New];   
        for(FinServ__ContactContactRelation__c record:records){
            if(!record.FinServ__Role__r.Name.contains('Dependent')){
                ids.add(record.FinServ__Contact__c);
            }
        }
    }
    
    List<Account> accounts = [SELECT Id,PersonContactId FROM Account WHERE PersonContactId IN :ids];
    update accounts;
}