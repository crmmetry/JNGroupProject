@isTest
public with sharing class TestTrackLeadCallsController {
    @TestSetup
    static void makeData(){
        User user = TestDataFactory.CreateUser('userTest123');
        insert user;

        List<Lead> leads = TestDataFactory.CreateLeads(3);
        insert leads;   
    }
    @IsTest
    static void shouldUpdateDisqualifiedLeads(){
        List<Lead> leads = [SELECT Id, Assignment_Timestamp__c FROM Lead];
        
        Lead lead1 = leads[0];
        lead1.Assignment_Timestamp__c = Datetime.newInstance();
        update lead1;

        Lead lead2 = leads[1];
        lead2.Assignment_Timestamp__c = Datetime.newInstance();
        update lead2;

        Lead lead3 = leads[2];
        lead2.Assignment_Timestamp__c = Datetime.newInstance();
        update lead1;

        //scenario 1: Lead has 3 calls with no cantact being made
        Task lead1task1 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task1.Result__c = 'No Contact Made';
        insert lead1task1;

        Task lead1task2 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task2.Result__c = 'No Contact Made';
        insert lead1task2;

        Task lead1task1 = TestDataFactory.CreateTask(user.Id, lead1.Id);
        lead1task3.Result__c = 'No Contact Made';
        insert lead1task3;

        // //scenario 2:
        // Task task2 = TestDataFactory.CreateTask(user.Id, lead2.Id);
        // insert task2;

        // //scenario 3:
        // Task task3 = TestDataFactory.CreateTask(user.Id, lead3.Id);
        //insert task3;
        Test.startTest();
        System.enqueueJob(new TrackLeadCallsController());
        Test.stopTest();
        
    }
}
