@isTest
public class TestLeadTriggerHandler {
  @testSetup
  static void setup() {
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
  }

  @isTest
  public static void shouldcrmm_TierTwoTrigger() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create an Account
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'Stone')[0];
      insert acc;

      //Create an opportunity to merge with converted lead
      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');
      Test.startTest();
      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());

      leadRecord.Escalate_to_Tier2__c = true;
      update leadRecord;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCheckIfNewConversion() {
    Map<String, Id> recordTypes_lead = Util.getRecordTypeids('Lead');

    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Industry = 'ICT';
      leadRecord.Primary_Employment_Type__c = 'Employed';
      leadRecord.RecordTypeId = recordTypes_lead.get('Loan');
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      //lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);
      Test.startTest();
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());

      Test.stopTest();
    }
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenOpen() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Open';
      leadRecords[0].Time_in_Open__c = 500000;
      leadRecords[1].Status = 'Open';

      update leadRecords;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenWorking() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Working';
      leadRecords[0].Time_in_Working__c = 500000;
      leadRecords[1].Status = 'Working';

      update leadRecords;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenContactMade() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Contact Made';
      leadRecords[0].Time_in_Contact_Made__c = 500000;
      leadRecords[1].Status = 'Contact Made';

      update leadRecords;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenDetermineCustomersNeedsGoals() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Determine Customers needs goals';
      leadRecords[0].Time_in_Determine_Customer_Need_Goals__c = 500000;
      leadRecords[1].Status = 'Determine Customers needs goals';

      update leadRecords;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenCollectCustomersInformation() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Collect Customers Information';
      leadRecords[0].Time_in_Collect_Customers_Information__c = 500000;
      leadRecords[1].Status = 'Collect Customers Information';

      update leadRecords;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenRunLoanScenarios() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Run Loan Scenarios';
      leadRecords[0].Time_in_Run_Loan_Scenario__c = 500000;
      leadRecords[1].Status = 'Run Loan Scenarios';

      update leadRecords;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenDisqualified() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Disqualified';
      leadRecords[0].Time_in_Disqualified__c = 500000;
      leadRecords[1].Status = 'Disqualified';

      update leadRecords;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenQualified() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Time_in_Qualified__c = 500000;
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Test.startTest();
      Database.LeadConvertResult lcr = Database.convertLead(lc);
      leadRecord.Status = 'Qualified';
      update leadRecord;

      Test.stopTest();
    }
  }

  @isTest
  public static void shouldcrmm_lead_trigger_conversion() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create an Account
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'Stone')[0];
      insert acc;

      //Create an opportunity to merge with converted lead
      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');
      Test.startTest();
      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageZeroWhenQualified() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Test.startTest();
      Database.LeadConvertResult lcr = Database.convertLead(lc);

      leadRecord.Status = 'Qualified';
      update leadRecord;

      Test.stopTest();
    }
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenUnqualified() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Unqualified';
      leadRecords[0].Time_in_Qualified__c = 500000;
      leadRecords[1].Status = 'Unqualified';

      update leadRecords;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldCrmm_TimeSpentInStageWhenNurturing() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      List<Lead> leadRecords = TestDataFactory.CreateLeads(2);
      insert leadRecords;

      leadRecords[0].Status = 'Nurturing';
      leadRecords[0].Time_in_Nurturing__c = 500000;
      leadRecords[1].Status = 'Nurturing';

      update leadRecords;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldEnforceLeadOpportunityRecordType() {
    Map<String, Id> recordTypes_opp = Util.getRecordTypeids('Opportunity');
    Map<String, Id> recordTypes_acc = Util.getRecordTypeids('Account');
    Map<String, Id> recordTypes_lead = Util.getRecordTypeids('Lead');

    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');

    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Service_of_Interest__c = 'JN Bank Auto Loan';
      leadRecord.RecordTypeId = recordTypes_lead.get('Loan');
      leadRecord.Salutation = 'Mr';
      //leadRecord.Last_Contact_Made__c = System.now();
      insert leadRecord;

      Account acc = TestDataFactory.CreateBasicAccounts(1, 'ln')[0];
      acc.FirstName = 'ABC';
      acc.LastName = 'Company';
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.StageName = 'Prospecting';
      //opp.RecordTypeId = recordTypes_opp.get('Mortgage');
      insert opp;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');

      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      System.debug('convertStatus ' + convertStatus.MasterLabel);
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());
      update leadRecord;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldleadConversionBasic() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create an Account
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'Stone')[0];
      insert acc;

      //Create an opportunity to merge with converted lead
      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');
      Test.startTest();
      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());

      leadRecord.Status = 'Qualified';
      update leadRecord;

      System.assertEquals(
        'Qualified',
        leadRecord.Status,
        'Lead status do not match'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldValidateIndustryTypeWhenEmployed() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      //Update Primary Employment Field and Industry
      leadRecord.Primary_Employment_Type__c = 'Employed';
      leadRecord.Industry = 'Agriculture';

      try {
        update leadRecord;
      } catch (System.DmlException e) {
        Boolean expectedExceptionThrown = e.getMessage()
            .contains(
              'The selected Industry value does not match the Primary Employment Type (Employed) selected'
            )
          ? true
          : false;
        System.AssertEquals(
          expectedExceptionThrown,
          true,
          'Error message was thrown!'
        );
      }
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldValidateIndustryTypeWhenUnemployed() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      //Update Primary Employment Field and Industry
      leadRecord.Primary_Employment_Type__c = 'Unemployed';
      leadRecord.Industry = 'Agriculture';

      try {
        update leadRecord;
      } catch (System.DmlException e) {
        Boolean expectedExceptionThrown = e.getMessage()
            .contains(
              'The selected Industry value does not match the Primary Employment Type (Unemployed) selected'
            )
          ? true
          : false;
        System.AssertEquals(
          expectedExceptionThrown,
          true,
          'Error message was thrown!'
        );
      }
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldValidateIndustryTypeWhenSelfemployed() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      //Update Primary Employment Field and Industry
      leadRecord.Primary_Employment_Type__c = 'Self-Employed';
      leadRecord.Industry = 'Technology';

      try {
        update leadRecord;
      } catch (System.DmlException e) {
        Boolean expectedExceptionThrown = e.getMessage()
            .contains(
              'The selected Industry value does not match the Primary Employment Type (Self-Employed) selected'
            )
          ? true
          : false;
        System.AssertEquals(
          expectedExceptionThrown,
          true,
          'Error message was thrown!'
        );
      }

      Test.stopTest();
    }
  }

  @isTest
  public static void shouldCreateEmploymentOnConversion() {
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
    insert acc;
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      insert leadRecord;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);

      leadRecord.Employer_Address_Street_1__c = 'Harbour Street';
      leadRecord.Employer_Address_Street_2__c = 'Crescent Street';
      leadRecord.Employer_Address_Street_3__c = 'Moon Street';
      leadRecord.Employer_Area_District__c = 'Sun District';
      leadRecord.Employer_City_Town__c = 'Small Town';
      leadRecord.Employer_City__c = 'Spanish City';
      leadRecord.Employer_City__c = 'Spanish City';
      leadRecord.Employer_Country__c = 'Jamaica';
      leadRecord.Previous_Employer_Street_2__c = 'Circular Street';
      leadRecord.Previous_Employer_Street_3__c = 'Sun Street';
      leadRecord.Previous_Employment_Area_District__c = 'Moon District';
      leadRecord.Previous_Employer_City_Town__c = 'Half-Way Tree';
      leadRecord.Previous_Employer_City__c = 'St Andrew';
      leadRecord.Name_of_Current_Employer__c = 'Remario Richards';
      leadRecord.Name_of_Previous_Employer__c = 'John Smalls';
      update leadRecord;

      test.stopTest();
    }
  }

  @isTest
  public static void shouldleadActivityEvent() {
    Test.startTest();
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Preferred_Time_of_Contact__c = Time.newInstance(0, 1, 3, 0);
      leadRecord.Preferred_Date_of_Contact__c = Date.newInstance(2020, 5, 16);
      leadRecord.Preferred_Contact_Method__c = 'Email';
      insert leadRecord;
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldcreateDateTime() {
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Preferred_Time_of_Contact__c = Time.newInstance(0, 1, 3, 0);
      leadRecord.Preferred_Date_of_Contact__c = Date.newInstance(2020, 5, 16);
      insert leadRecord;
    }
  }

  @isTest
  public static void shouldContactRelatedPersonsWhenAffiliateIsJNBank() {
    Map<String, Id> recordTypeids = Util.getRecordTypeids('Account');
    Id personAccountId = recordTypeids.get('PersonAccount');

    Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
    insert acc;
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Account e_acc = new Account();
      e_acc.FirstName = 'Travis';
      e_acc.LastName = 'Allen';
      e_acc.Mobile_Number__pc = TestDataFactory.PHONE;
      e_acc.RecordTypeId = personAccountId;
      insert e_acc;

      //System.assert(e_acc.PersonContactId != null, 'Ooops! this account is not a person');

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];

      leadRecord.Emergency_Contact_First_Name__c = 'Travis';
      leadRecord.Emergency_Contact_Last_Name__c = 'Allen';
      leadRecord.Emergency_Contact_Personal_Email__c = 'leadtester@test.com';
      leadRecord.Emergency_Contact_Mobile__c = TestDataFactory.PHONE;
      insert leadRecord;

      Lead_Related_Person__c relatedLead = new Lead_Related_Person__c();
      relatedLead.TRN__c = '123456789111';
      relatedLead.TItle__c = 'Mr.';
      relatedLead.Role__c = 'ContactRole';
      relatedLead.Relationship__c = 'Father';
      relatedLead.Mobile_Number__c = TestDataFactory.Phone;
      relatedLead.Middle_Name__c = 'JR';
      relatedLead.Lead_and_Referral__c = leadRecord.Id;
      relatedLead.Last_Name__c = 'Jones';
      relatedLead.JN_Location__c = 'Barbican';
      relatedLead.Home_Phone_Number__c = TestDataFactory.PHONE;
      relatedLead.First_Name__c = 'Tevar';
      relatedLead.Email__c = 'tevar@test.com';
      relatedLead.Business_Number__c = TestDataFactory.PHONE;
      relatedLead.Afilliate_Type__c = 'JN Bank';
      insert relatedLead;

      System.assert(relatedLead != null, 'Ooops the related lead is empty');

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);

      test.stopTest();
    }
  }

  @isTest
  public static void shouldContactRelatedPersonsWhenAffiliateIsPolitical() {
    Map<String, Id> recordTypeids = Util.getRecordTypeids('Account');
    Id personAccountId = recordTypeids.get('PersonAccount');
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');
    System.runAs(newUser) {
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
      insert acc;

      Account e_acc = new Account();
      e_acc.FirstName = 'Travis';
      e_acc.LastName = 'Allen';
      e_acc.Mobile_Number__pc = TestDataFactory.PHONE;
      e_acc.RecordTypeId = personAccountId;
      insert e_acc;

      //System.assert(e_acc.PersonContactId != null, 'Ooops! this account is not a person');

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];

      leadRecord.Emergency_Contact_First_Name__c = 'Travis';
      leadRecord.Emergency_Contact_Last_Name__c = 'Allen';
      leadRecord.Emergency_Contact_Personal_Email__c = 'leadtester@test.com';
      leadRecord.Emergency_Contact_Mobile__c = TestDataFactory.PHONE;
      insert leadRecord;

      Lead_Related_Person__c relatedLead = new Lead_Related_Person__c();
      relatedLead.TRN__c = '123456789111';
      relatedLead.TItle__c = 'Mr.';
      relatedLead.Role__c = 'ContactRole';
      relatedLead.Relationship__c = 'Father';
      relatedLead.Mobile_Number__c = TestDataFactory.Phone;
      relatedLead.Middle_Name__c = 'JR';
      relatedLead.Lead_and_Referral__c = leadRecord.Id;
      relatedLead.Last_Name__c = 'Jones';
      relatedLead.JN_Location__c = 'Barbican';
      relatedLead.Home_Phone_Number__c = TestDataFactory.PHONE;
      relatedLead.First_Name__c = 'Tevar';
      relatedLead.Email__c = 'tevar@test.com';
      relatedLead.Business_Number__c = TestDataFactory.PHONE;
      relatedLead.Afilliate_Type__c = 'Political';
      insert relatedLead;

      System.assert(relatedLead != null, 'Ooops the related lead is empty');

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);

      test.stopTest();
    }
  }

  @isTest
  public static void shouldContactRelatedPersonsWhenAffiliateIsCreditCardExtension() {
    Map<String, Id> recordTypeids = Util.getRecordTypeids('Account');
    Id personAccountId = recordTypeids.get('PersonAccount');
    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');

    System.runAs(newUser) {
      Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
      insert acc;

      Account e_acc = new Account();
      e_acc.FirstName = 'Travis';
      e_acc.LastName = 'Allen';
      e_acc.Mobile_Number__pc = TestDataFactory.PHONE;
      e_acc.RecordTypeId = personAccountId;
      insert e_acc;

      //System.assert(e_acc.PersonContactId != null, 'Ooops! this account is not a person');

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.Last_Contact_Made__c = System.now();
      opp.StageName = 'Prospecting';
      insert opp;

      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];

      leadRecord.Emergency_Contact_First_Name__c = 'Travis';
      leadRecord.Emergency_Contact_Last_Name__c = 'Allen';
      leadRecord.Emergency_Contact_Personal_Email__c = 'leadtester@test.com';
      leadRecord.Emergency_Contact_Mobile__c = TestDataFactory.PHONE;
      insert leadRecord;

      Lead_Related_Person__c relatedLead = new Lead_Related_Person__c();
      relatedLead.TRN__c = '123456789111';
      relatedLead.TItle__c = 'Mr.';
      relatedLead.Role__c = 'ContactRole';
      relatedLead.Relationship__c = 'Father';
      relatedLead.Mobile_Number__c = TestDataFactory.Phone;
      relatedLead.Middle_Name__c = 'JR';
      relatedLead.Lead_and_Referral__c = leadRecord.Id;
      relatedLead.Last_Name__c = 'Jones';
      relatedLead.JN_Location__c = 'Barbican';
      relatedLead.Home_Phone_Number__c = TestDataFactory.PHONE;
      relatedLead.First_Name__c = 'Tevar';
      relatedLead.Email__c = 'tevar@test.com';
      relatedLead.Business_Number__c = TestDataFactory.PHONE;
      relatedLead.Afilliate_Type__c = 'Credit Card Extension';
      insert relatedLead;

      System.assert(relatedLead != null, 'Ooops the related lead is empty');

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;

      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      lc.setConvertedStatus(convertStatus.MasterLabel);

      test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);

      test.stopTest();
    }
  }

  @isTest
  public static void shouldAssignStageUponConversionWhenMortgage() {
    Map<String, Id> recordTypes_opp = Util.getRecordTypeids('Opportunity');
    Map<String, Id> recordTypes_acc = Util.getRecordTypeids('Account');
    Map<String, Id> recordTypes_lead = Util.getRecordTypeids('Lead');

    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');

    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Service_of_Interest__c = 'JN Bank Mortgage Loan';
      leadRecord.RecordTypeId = recordTypes_lead.get('Mortgage');
      leadRecord.Salutation = 'Mr';
      //leadRecord.Last_Contact_Made__c = System.now();
      insert leadRecord;

      Account acc = TestDataFactory.CreateBasicAccounts(1, 'ln')[0];
      acc.FirstName = 'ABC';
      acc.LastName = 'Company';
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.StageName = 'Prospecting';
      opp.RecordTypeId = recordTypes_opp.get('Mortgage');
      opp.Product_Purchased__c = 'Product Purchase Place Holder';
      opp.Product_of_Interest__c = 'JN Bank Mortgage Loan';
      insert opp;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');

      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      System.debug('convertStatus ' + convertStatus.MasterLabel);
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());
      update leadRecord;
    }

    Test.stopTest();
  }

  @isTest
  public static void shouldAssignStageUponConversionWhenSavingsChequing() {
    Map<String, Id> recordTypes_opp = Util.getRecordTypeids('Opportunity');
    Map<String, Id> recordTypes_acc = Util.getRecordTypeids('Account');
    Map<String, Id> recordTypes_lead = Util.getRecordTypeids('Lead');

    User newUser = [SELECT Id FROM User WHERE UserName = 'leadtester@test.com'];
    System.assert(newUser != null, 'User is empty');

    System.runAs(newUser) {
      //Create new lead record
      Lead leadRecord = TestDataFactory.CreateLeads(1)[0];
      leadRecord.Service_of_Interest__c = 'JN Bank Deposit Account';
      leadRecord.RecordTypeId = recordTypes_lead.get('Savings_Chequing');
      leadRecord.Salutation = 'Mr';
      //leadRecord.Last_Contact_Made__c = System.now();
      insert leadRecord;

      Account acc = TestDataFactory.CreateBasicAccounts(1, 'ln')[0];
      acc.FirstName = 'ABC';
      acc.LastName = 'Company';
      insert acc;

      Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
      opp.AccountId = acc.Id;
      opp.StageName = 'Prospecting';
      opp.RecordTypeId = recordTypes_opp.get('Savings_Chequing');
      opp.Product_of_Interest__c = 'JN Bank Deposit Account';
      opp.Product_Purchased__c = 'JN Way Deposit Account';
      insert opp;

      Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecord.Id);
      tsk.Result__c = 'Contact Made';
      insert tsk;
      System.assert(tsk != null, 'Task is empty');

      //Create a convert lead
      Database.LeadConvert lc = new Database.LeadConvert();
      lc.setLeadId(leadRecord.id);
      lc.setOwnerId(newUser.Id);
      lc.setAccountId(acc.Id);
      lc.setOpportunityId(opp.Id);

      LeadStatus convertStatus = [
        SELECT Id, MasterLabel
        FROM LeadStatus
        WHERE IsConverted = TRUE
        LIMIT 1
      ];
      System.debug('convertStatus ' + convertStatus.MasterLabel);
      lc.setConvertedStatus(convertStatus.MasterLabel);

      Test.startTest();

      Database.LeadConvertResult lcr = Database.convertLead(lc);
      System.assert(lcr.isSuccess());
      update leadRecord;
    }
    Test.stopTest();
  }
}
