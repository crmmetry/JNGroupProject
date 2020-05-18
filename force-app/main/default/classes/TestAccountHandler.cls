@isTest
public class TestAccountHandler {
    @testSetup
    public static void setup(){
        List<FinServ__ReciprocalRole__c> roles = new  List<FinServ__ReciprocalRole__c>();
        List<String> roleNames = new String[]{'Emergency Contact','Political Affiliation','JN Affiliation'};
            for(String roleName: roleNames){
                roles.add(TestDataFactory.CreateRole(roleName));
            }
        insert roles;
        insert TestDataFactory.CreateBasicAccounts(2, 'ln');
        
    }
    @isTest
    static void shouldTestOldAccounts (){
        List<Account> accounts = [SELECT Id,PersonContactId FROM Account WHERE LastName LIKE 'ln%'];
        System.assert(accounts[0] != null);
        Opportunity opp  = TestDataFactory.CreateOpportunities(1)[0];
        opp.StageName = 'Prospecting';
        opp.AccountId = accounts[0].Id;
        insert opp;
        delete accounts;
    }
    @isTest
    public static void shouldAssignMobileNumber(){
        List<Account> accounts  = TestDataFactory.CreateBasicAccounts(1, 'testlastname');
        Map<String, Id> recordTypesMap = Util.getRecordTypeids('Account');
        accounts.get(0).PersonMobilePhone = TestDataFactory.PHONE;
        accounts.get(0).RecordTypeId = recordTypesMap.get('PersonAccount');
        System.debug(accounts);        
        insert accounts;
        System.assert(accounts.get(0).Id != null);
        System.assertEquals(TestDataFactory.PHONE, accounts.get(0).PersonMobilePhone, 'PersonMobilePhone incorrect');
        Account queriedAccount = [SELECT id,Mobile_Number__pc FROM Account where Id = :accounts.get(0).Id];
        System.assert(queriedAccount!=null, 'queriedAccount is null');
        System.assertEquals(queriedAccount.Mobile_Number__pc, accounts.get(0).PersonMobilePhone, 'Mobile_Number__pc was not assigned.');
    }
    
    @isTest
    public static void shouldCreditScoreonAccount(){
        Test.startTest();
        List<Account> accounts = [SELECT Id,PersonContactId FROM Account WHERE LastName LIKE 'ln%'];       
        List<Opportunity> opportunities  = TestDataFactory.CreateOpportunities(1);
        opportunities.get(0).AccountId = accounts[0].Id;
        opportunities.get(0).StageName = 'Prospecting';
        insert opportunities;
        Applicant__c app = new Applicant__c(Account__c = accounts[0].Id, Opportunity__c = opportunities[0].Id);
        
        insert app;
        accounts[0].FinServ__AnnualIncome__pc  = 48943.43;
        delete accounts[0];
        Test.stopTest();
    }
    
    @isTest
    public static void shouldSetAccountAffiliations(){
        List<FinServ__ContactContactRelation__c> conToCons = new List<FinServ__ContactContactRelation__c>();
        Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships('ContactRole'); //get contact roles
        Id roleId = mappedRoles.get('Emergency Contact').Id;
        Id roleId2 = mappedRoles.get('Political Affiliation').Id;
        Id roleId3 = mappedRoles.get('JN Affiliation').Id;
        
        Test.startTest();
        Contact con = TestDataFactory.CreateBasicContacts(1, 'testlastname')[0];
        insert con;
        List<Account> accounts = [SELECT Id,PersonContactId FROM Account WHERE LastName LIKE 'ln%'];
        System.assert(accounts.size() == 2);
        conToCons.add(Util.createContactToContactRelationship(accounts[0].PersonContactId, con.Id, roleId2));
        conToCons.add(Util.createContactToContactRelationship(accounts[1].PersonContactId, con.Id, roleId));
        conToCons.add(Util.createContactToContactRelationship(accounts[0].PersonContactId, con.Id, roleId3));
        insert conToCons;
        accounts[0].FinServ__AnnualIncome__pc  = 48943.43;
        update accounts;
        
        Test.stopTest();
        
    }
    
  
    
}