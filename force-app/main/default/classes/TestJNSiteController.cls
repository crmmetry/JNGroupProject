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
    
    @isTest
    public static void shouldGetPickListValues(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Boswell')[0];
        acc.Type = 'Analyst';
        insert acc;
        
        JNSiteController.getPickListValues('Account', 'Type');
        
        Test.stopTest();
    }

    @isTest
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

    /*public static void shouldUpdateApplicantTextInfo(){
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

    }*/

    @isTest
    public static void shouldCreateLeadReferral(){
        Map<String,String> applicantDetails = new Map<String,String>('FirstName'=>'Travis',
                                                                    'MiddleName'=>'Junior',
                                                                    'Lastname'=>'Allen',
                                                                    'Estimated_Amount__c'=> 5000.00,
                                                                    'Service_of_Interest__c'=>'JN Bank Credit Card',
                                                                    'Lead_Title__c'=>'Mr.',
                                                                    'Suffix__c'=>'Jnr',
                                                                    'Gender__c'=>'Male',
                                                                    'Marital_Status__c'=>'Married',
                                                                    'Date_of_Birth__c'=>Date.Today(),
                                                                    'Place_of_Birth__c'=>'Kingston',
                                                                    'Mother_s_Maiden_Name__c'=>'Johnson',
                                                                    'Number_of_Dependent_Adults__c'=>5,
                                                                    'Number_of_Dependent_Children__c'=>2,
                                                                    'Country_of_Citizenship__c'=>'Jamaica',
                                                                    'Country_of_Residence__c'=>'Jamaica',
                                                                    'Highest_Level_of_Education_Attained__c'=>'University: Post Graduate',
                                                                    'Jamaican_Tax_Registration_Number__c'=>'123456789');
            Lead leadRecord = new Lead();
            leadRecord = JNSiteController.creaLeadReferral(applicantDetails);
                                                                    
    }
}