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

        System.assert(acc.Type!=null, 'Account Type field is empty.');
        
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

    @isTest
    public static void shouldUpdateApplicantTextInfo(){

        Map<String, String> applicantDetails = new Map<String, String>{
            'Different_Mailing_Address__c' => 'No',
            'JN_Site_Form_Completed_Flag__c' =>'Yes',
            'Mailing_Years_at_Residence__c' => '4',
            'Years_at_Residence__c' => '5',
            'Time_with_Current_Employer__c' => '3',
            'Time_in_Industry__c' => '6',
            'Preferred_Date_of_Contact__c' => '08/07/2020',
            'Date_of_Birth__c' => '04/12/1992',
            'Identification_Type_Expiration__c' => '15/03/2024',
            'Date_of_Incorporation__c' => '30/01/2020'
        };               

        List<Lead> leads = TestDataFactory.CreateLeads(2);
        insert leads;

        System.assert(leads!=null, 'Lead was not added.');
        JNSiteController.updateApplicantTextInfo(applicantDetails, leads[0].Id);

    }

    @isTest
    public static void shouldGetRecordTypeId(){
        Test.startTest();
        
        Account acc = TestDataFactory.CreateBasicAccounts(1, 'Walters')[0];
        insert acc;
        
        String devName;
        Map<String, Id> recordTypeId = Util.getRecordTypeids('Account');
        
        for(String key: recordTypeId.keySet()){
            if(acc.RecordTypeId == recordTypeId.get(key)){
                devName = key;
            }
        }
                
        System.assert(devName!=null, 'Developer Name is null.');

        JNSiteController.getRecordTypeId(devName);
        
        
        Test.stopTest();
    }
}
