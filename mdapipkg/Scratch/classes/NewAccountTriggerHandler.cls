public class NewAccountTriggerHandler {
    private static final String TAG = 'AccountTriggerHandler';
    private static List<Account> accounts;
    private static List<Account> old;
    private static Map<Id, Account> oldMap;
    private static Map<Id, Account> newMap;
    public static void init(List<Account> accounts, Map<Id, Account> oldMap, Map<Id, Account> newMap, List<Account> old){
        NewAccountTriggerHandler.accounts = accounts;
        NewAccountTriggerHandler.old = old;
        NewAccountTriggerHandler.oldMap = oldMap;
        NewAccountTriggerHandler.newMap = newMap;
    }
    public static void creditscoreonAccount(Boolean isUpdate, Boolean isDelete){
        // can only execute only per execution context
        if(!Util.IsExecuted('creditscoreonAccount')){
        set<Id> oppIdSet= new set<Id>(); 
        if(isDelete){
            // Map<Id,Opportunity> mappedOpportunities = new Map<Id,Opportunity>([select id from Opportunity where AccountId=:old]);
            for(Opportunity opp:[select id from Opportunity where AccountId=:old]){
                oppIdSet.add(opp.Id);
            }
            Map<Id,Applicant__c> mappedApplicants = new Map<Id,Applicant__c>([select id,Opportunity__c from Applicant__c where Account__c=:old]);
            for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:old]){
                oppIdSet.add(app.Opportunity__c);
            }   
        }
        if(isUpdate){
            for(Opportunity opp:[select id from Opportunity where AccountId=:accounts]){
                oppIdSet.add(opp.Id);
            }
            for(Applicant__c app:[select id,Opportunity__c from Applicant__c where Account__c=:accounts]){
                oppIdSet.add(app.Opportunity__c);
            }   
        }
        system.debug('oppIdSet======'+oppIdSet);
        if(oppIdSet.size()>0){
            CreditScoreHelper cs = new CreditScoreHelper();
            cs.CreditScoreFromOpp(oppIdSet);
        }
        }
    }
    public static void assignMobileNumber(){
        for(Account record: accounts){
            record.Mobile_Number__pc = record.PersonMobilePhone;
        }
    }
    
}