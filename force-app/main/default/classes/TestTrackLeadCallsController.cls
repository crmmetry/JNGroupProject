@isTest
public with sharing class TestTrackLeadCallsController {
  @TestSetup
  static void makeData() {
    Id profileId = [SELECT Id FROM Profile WHERE Name = 'Call Centre - Sales']
    .Id;
    User user = TestDataFactory.CreateUser('userTest123@email.com');
    user.ProfileId = profileId;
    insert user;
    List<Lead> leadRecords = TestDataFactory.CreateLeads(3);
    System.runAs(user) {
      leadRecords[0].Assignment_Timestamp__c = Datetime.newInstance(
        2020,
        9,
        15,
        8,
        2,
        3
      );
      leadRecords[1].Assignment_Timestamp__c = Datetime.newInstance(
        2020,
        9,
        15,
        8,
        0,
        0
      );
      leadRecords[2].Assignment_Timestamp__c = Datetime.newInstance(
        2020,
        9,
        15,
        14,
        2,
        0
      );
      insert leadRecords;
    }
  }
  // @IsTest
  // static void shouldUpdateDisqualifiedLeads(){

  //     List<Task> tasks = new List<Task>();

  //     List<User> users = [SELECT Id FROM User];
  //     User user = users[0];

  //     List<Lead> leads = [SELECT Id, Assignment_Timestamp__c FROM Lead];

  //     //scenario 1: Lead has 3 calls with no cantact being made
  //     Lead lead1 = leads[0];
  //     Task lead1task1 = TestDataFactory.CreateTask(user.Id, lead1.Id);
  //     lead1task1.Result__c = 'No Contact';
  //     tasks.add(lead1task1);
  //     //insert lead1task1;

  //     Task lead1task2 = TestDataFactory.CreateTask(user.Id, lead1.Id);
  //     lead1task2.Result__c = 'No Contact';
  //     tasks.add(lead1task2);
  //     //insert lead1task2;

  //     Task lead1task3 = TestDataFactory.CreateTask(user.Id, lead1.Id);
  //     lead1task3.Result__c = 'No Contact';
  //     tasks.add(lead1task3);
  //     //insert lead1task3;

  //     //scenario 2: No contact was made to lead and the 8hr window is up.
  //     Lead lead2 = leads[1];

  //     //scenario 3: current hours less than 8 and contact was made
  //     Lead lead3 = leads[2];
  //     Task lead3task1 = TestDataFactory.CreateTask(user.Id, lead3.Id);
  //     lead3task1.Result__c = 'Contact Made';
  //     tasks.add(lead3task1);
  //     //insert lead3task1;

  //     insert tasks;

  //     Test.startTest();
  //     System.enqueueJob(new TrackLeadCallsController());
  //     Test.stopTest();

  //     System.assert(lead1.Disqualified_Flag__c == true, 'Lead should be disqualified');
  //     System.assert(lead1.Disqualified_Timestamp__c != null, 'Lead should be disqualified');

  //     System.assert(lead2.Disqualified_Flag__c == true, 'Lead should be disqualified');
  //     System.assert(lead2.Disqualified_Timestamp__c != null, 'Lead should be disqualified');

  //     System.assert(lead3.Disqualified_Flag__c == false, 'Lead should not be disqualified');
  //     System.assert(lead3.Disqualified_Timestamp__c == null, 'Lead should not be disqualified');

  // }
}
