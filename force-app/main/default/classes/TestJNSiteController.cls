@isTest
public class TestJNSiteController {
  @testSetup
  static void setup() {
    Test.startTest();
    User newUser = TestDataFactory.CreateUser('leadtester@test.com');
    insert newUser;
    List<FinServ__ReciprocalRole__c> roles = new List<FinServ__ReciprocalRole__c>();
    List<String> roleNames = new List<String>{
      'Emergency Contact',
      'Political Affiliation',
      'JN Affiliation'
    };
    for (String roleName : roleNames) {
      roles.add(TestDataFactory.CreateRole(roleName));
    }
    insert roles;
    insert TestDataFactory.CreateBasicAccounts(1, 'ln');
    Test.stopTest();
  }

  @isTest
  public static void shouldGetPickListValues() {
    Test.startTest();

    Account acc = TestDataFactory.CreateBasicAccounts(1, 'Boswell')[0];
    acc.Type = 'Analyst';
    insert acc;

    System.assert(acc.Type != null, 'Account Type field is empty.');

    JNSiteController.getPickListValues('Account', 'Type');

    Test.stopTest();
  }

  @isTest
  public static void shouldGetPickListValuesList() {
    Test.startTest();

    Account acc = TestDataFactory.CreateBasicAccounts(1, 'Holloway')[0];
    acc.Type = 'Analyst';
    acc.Rating = 'Warm';
    insert acc;

    List<String> names = new List<String>();

    names.add('Type');
    names.add('Rating');

    System.assert(names != null, 'Picklists fields not being added.');
    JNSiteController.getPickListValuesList('Account', names);

    Test.stopTest();
  }

  @isTest
  public static void shouldUpdateApplicantTextInfo() {
    Map<String, String> applicantDetails = new Map<String, String>{
      'Different_Mailing_Address__c' => 'No',
      'JN_Site_Form_Completed_Flag__c' => 'Yes',
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

    System.assert(leads != null, 'Lead was not added.');
    JNSiteController.updateApplicantTextInfo(applicantDetails, leads[0].Id);
  }

  @isTest
  public static void shouldGetRecordTypeId() {
    Test.startTest();

    Account acc = TestDataFactory.CreateBasicAccounts(1, 'Walters')[0];
    insert acc;

    String devName;
    Map<String, Id> recordTypeId = Util.getRecordTypeids('Account');

    for (String key : recordTypeId.keySet()) {
      if (acc.RecordTypeId == recordTypeId.get(key)) {
        devName = key;
      }
    }

    System.assert(devName != null, 'Developer Name is null.');
    JNSiteController.getRecordTypeId(devName);
    Test.stopTest();
  }
  @isTest
  public static void shouldSaveFile() {
    String base64 = 'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';
    Account newAcc = [
      SELECT Id, Name
      FROM Account
      WHERE LastName LIKE '%ln%'
      LIMIT 1
    ];
    System.debug('Account:' + newAcc);
    Object result = JNSiteController.saveFile(
      newAcc.Id,
      'TestFile.png',
      base64,
      'png',
      'Birth Certificate'
    );
    System.assert(result != null, 'save file result is null');
  }
  @isTest
  public static void shouldNotSaveFile() {
    String base64 = 'data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==';
    Account newAcc = [
      SELECT Id, Name
      FROM Account
      WHERE LastName LIKE '%ln%'
      LIMIT 1
    ];
    System.debug('Account:' + newAcc);
    try {
      Object result = JNSiteController.saveFile(
        newAcc.Id,
        'TestFile.png',
        base64,
        'png',
        'Birth Certificate'
      );
      System.assert(result != null, 'save file result is null');
    } catch (Exception e) {
      System.assert(e.getMessage().length() > 0, 'no error');
    }
  }

  @isTest
  public static void shouldCreateLeadReferral() {
    Map<String, Object> applicantDetails = new Map<String, Object>{
      'FirstName' => 'Travis',
      'MiddleName' => 'Junior',
      'LastName' => 'Allen',
      'Estimated_Amount__c' => '5000.00',
      'Service_of_Interest__c' => 'JN Bank Credit Card',
      'Lead_Title__c' => 'Mr.',
      'Suffix__c' => 'Jnr',
      'Gender__c' => 'Male',
      'Marital_Status__c' => 'Married',
      'Date_of_Birth__c' => ('1997-05-05'),
      'Preferred_Date_of_Contact__c' => ('1997-05-05'),
      'Preferred_Time_of_Contact__c' => '13:13:13',
      'Loan_Purpose_UL__c' => 'Other',
      'Gross_Monthly_Income__c' => '34344',
      'Gross_Monthly_Expenses__c' => '43423',
      'Place_of_Birth__c' => 'Kingston',
      'Mother_s_Maiden_Name__c' => 'Johnson',
      'Number_of_Dependent_Adults__c' => '5',
      'Number_of_Dependent_Children__c' => '2',
      'Country_of_Citizenship__c' => 'Jamaica',
      'Country_of_Residence__c' => 'Jamaica',
      'Highest_Level_of_Education_Attained__c' => 'University: Post Graduate',
      'Jamaican_Tax_Registration_Number__c' => '123456789'
    };
    System.assert(applicantDetails != null);
    JNSiteController.createLeadReferral(
      (Lead) JSON.deserialize(JSON.serialize(applicantDetails), Lead.class)
    );
  }

  @isTest
  public static void shouldCreatePersonExtensions() {
    Map<String, Object> data = new Map<String, Object>();
    Map<String, Object> values = new Map<String, Object>{
      'First_Name__c' => 'John',
      'Last_Name__c' => 'Constantine',
      'Middle_Name__c' => 'Fury',
      'Title__c' => 'Mr',
      'TRN__c' => '333000111',
      'Relationship__c' => 'Brother',
      'Afilliate_Type__c' => 'JN Bank'
    };

    List<Lead> leadRecords = TestDataFactory.CreateLeads(1);
    insert leadRecords;
    Lead leadRecord = leadRecords[0];
    System.assert(leadRecord != null, 'leadRecord is null');
    data.put('1', values);
    Object result = JNSiteController.createPersonExtensions(
      data,
      leadRecord.Id
    );
    System.assert(result != null, 'result is null');
  }
  @isTest
  public static void shouldCreatePersonAffiliates() {
    List<Lead> leadRecords = TestDataFactory.CreateLeads(1);
    insert leadRecords;
    Lead leadRecord = leadRecords[0];
    Map<String, Object> data = new Map<String, Object>();
    Map<String, String> values = new Map<String, String>{
      'First_Name__c' => 'Johny',
      'Last_Name__c' => 'Constantin',
      'Middle_Name__c' => 'Dakeo',
      'Title__c' => 'Mr',
      'TRN__c' => '333000111',
      'Relationship__c' => 'Brother',
      'Afilliate_Type__c' => 'JN Bank',
      'JN_Location__c' => 'Kingston',
      'Lead_and_Referral__c' => leadRecord.Id,
      'Mobile_Number__c' => '87656789098'
    };
    data.put('1', values);
    JNSiteController.createPersonAffiliates(data, leadRecord.Id);
  }
}
