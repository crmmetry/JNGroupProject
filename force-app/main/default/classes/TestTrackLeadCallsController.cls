@isTest
public with sharing class TestTrackLeadCallsController {
    @TestSetup
    static void makeData(){
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Lead' AND Name = 'Business Referral'];

        User user = TestDataFactory.CreateUser('userTest123@email.com');
        insert user;

        List<Lead> leadRecords = TestDataFactory.CreateLeads(3);
        leadRecords[0].RecordType = rt;
        leadRecords[1].RecordType = rt;
        leadRecords[2].RecordType = rt;
        insert leadRecords;   
    }
    @IsTest
    static void shouldUpdateDisqualifiedLeads(){

        List<User> users = [SELECT Id FROM User];
        User user = users[0];

        List<Lead> leads = [SELECT Id, Assignment_Timestamp__c FROM Lead];
        
        Lead lead1 = leads[0];
        lead1.Assignment_Timestamp__c = Datetime.newInstance(2020, 9, 15, 8, 2, 3);
        update lead1;

        Lead lead2 = leads[1];
        lead2.Assignment_Timestamp__c = Datetime.newInstance(2020, 9, 15, 8, 0, 0);
        update lead2;

        Lead lead3 = leads[2];
        lead2.Assignment_Timestamp__c = Datetime.newInstance(2020, 9, 15, 14, 2, 3);
        update lead3;

        //scenario 1: Lead has 3 calls with no cantact being made
        Task lead1task1 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task1.Result__c = 'No Contact Made';
        insert lead1task1;

        Task lead1task2 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task2.Result__c = 'No Contact Made';
        insert lead1task2;

        Task lead1task3 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task3.Result__c = 'No Contact Made';
        insert lead1task3;

        //scenario 2: No contact was made to lead and the 8hr window is up.
        

        //scenario 3: current hours less than 8 and contact was made
        Task lead3task1 = TestDataFactory.CreateTask(user.Id, lead3.Id);
        lead3task1.Result__c = 'Contact Made';
        insert lead3task1;

        Test.startTest();
        System.enqueueJob(new TrackLeadCallsController());
        Test.stopTest();
        
        System.assert(lead1.Disqualified_Flag__c == true, 'Lead should be disqualified');
        System.assert(lead1.Disqualified_Timestamp__c != null, 'Lead should be disqualified');

        System.assert(lead2.Disqualified_Flag__c == true, 'Lead should be disqualified');
        System.assert(lead2.Disqualified_Timestamp__c != null, 'Lead should be disqualified');

        System.assert(lead3.Disqualified_Flag__c == false, 'Lead should not be disqualified');
        System.assert(lead3.Disqualified_Timestamp__c == null, 'Lead should not be disqualified');

    }
}
