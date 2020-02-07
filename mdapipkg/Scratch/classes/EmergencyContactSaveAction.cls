public class EmergencyContactSaveAction {
    private static final String TAG = 'EmergencyContactSaveAction';
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        
        @InvocableVariable(label='Accounts to create' required = false)
        public Account[] accountsToSave;
        
        @InvocableVariable(label='Account ids already saved' required = false)
        public String[] accountIds;
        
        @InvocableVariable(label='Main AccountId' required = true)
        public String accountId;
        
    }

    @InvocableMethod(label='Save Emergency Contacts')
    public static void SaveContacts(FlowInputParameters[] inputs){
        FlowInputParameters instance = inputs.get(0);
        if(instance != null){
            List<FinServ__ContactContactRelation__c> contacts = new List<FinServ__ContactContactRelation__c>();
            Id role = Util.getRoleRelationships('ContactRole').get('Emergency Contact').Id;
            List<Id> idsToSearch = new List<String>();
            String accountId = instance.accountId;
            List<String> accountIds = instance.accountIds;
            Account[] accountsToSave = instance.accountsToSave;
            System.debug('accountsToSave: ' + accountsToSave);
            try{
                
                Account mainAccount = [SELECT Id, PersonContactId FROM Account WHERE Id = :accountId];
                if(accountsToSave != null){
                    //upsert accountsToSave;
                    for(Account record: accountsToSave){
                        idsToSearch.add(record.Id);
                    }
                }
                if(idsToSearch != null){
                    if(accountIds!=null) {
                       idsToSearch.addAll(accountIds); 
                    }
                   
                    System.debug('idsToSearch ' +  idsToSearch);
                }
                if(!idsToSearch.isEmpty()){
                    for(Account record: [SELECT Id, PersonContactId FROM Account WHERE Id in :idsToSearch]){
                        contacts.add(Util.createContactToContactRelationship(mainAccount.PersonContactId, record.PersonContactId, role));
                        System.debug('record: ' + record.PersonContactId);
                    }
                }
                if(!contacts.isEmpty()){
                    insert contacts;
                }

            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
}