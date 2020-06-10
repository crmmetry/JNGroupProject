@isTest
public class TestJNSiteController {

    @testSetup static void setup(){
        User newUser = TestDataFactory.CreateUser('leadtester@test.com');
        insert newUser;
        List<FinServ__ReciprocalRole__c> roles = new  List<FinServ__ReciprocalRole__c>();
        List<String> roleNames = new String[]{'Emergency Contact','Political Affiliation','JN Affiliation'};
            for(String roleName: roleNames){
                roles.add(TestDataFactory.CreateRole(roleName));
            }
        insert roles;
    }
    
    public static void shouldGetPickListValues(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Boswell')[0];
        acc.Type = 'Analyst';
        insert acc;
        
        JNSiteController.getPickListValues('Account', 'Type');
        
        Test.stopTest();
    }

    public static void shouldGetPickListValuesList(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Holloway')[0];
        acc.Type = 'Analyst';
        acc.Rating = 'Warm';
        insert acc;
        
        List<String> names = new List<String>();
        
        names.add('Type');
        names.add('Rating');
        
        System.assert(names!=null, 'Picklists fields not being added.');
        JNSiteController.getPickListValuesList('Account', names);
        
        Test.stopTest();
    }

    public static void shouldUpdateApplicantTextInfo(){
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Rivka')[0];
        insert acc;
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        Applicant__c newApplicant = TestDataFactory.CreateApplicant(acc.Id, opp.Id);
        insert newApplicant;

        List<Lead> leads = new List<Lead>();
        leads.add(TestDataFactory.CreateLeads(1));
        insert leads;

        JNSiteController.updateApplicantTextInfo(newApplicant, leads[0].Id);

    }
}
