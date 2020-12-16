/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4187     16/12/2020      Ishwari G.(thinqloud)  Test Class for TrackLeadCallsController
 **/
@isTest
public with sharing class TestTrackLeadCallsController {
  @testSetup
  public static void createData() {
    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now())
      .replace(' ', '')
      .replace(':', '')
      .replace('-', '');
    Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
    String uniqueName = orgId + dateString + randomInt;
    User newUser = TestDataFactory.CreateUser(uniqueName + '@test.com');
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Call Centre - Sales'];
    newUser.ProfileId = p.Id;
    newUser.Sales_User__c = true;
    insert newUser;
    system.debug('newUser id ' + newUser);
    List<Lead> leadRecords = TestDataFactory.CreateLeads(3);
    System.runAs(newUser) {
      //Create new lead record
      leadRecords[0].Assignment_Timestamp__c = Datetime.newInstance(
        2020,
        9,
        15,
        8,
        2,
        3
      );
      leadRecords[0].Disqualified_Flag__c = false;
      leadRecords[0].OwnerId = newUser.Id;
      leadRecords[1].Assignment_Timestamp__c = Datetime.now().addDays(-2);
      leadRecords[1].Disqualified_Flag__c = false;
      leadRecords[1].Disqualified_Timestamp__c = null;
      leadRecords[1].OwnerId = newUser.Id;
      leadRecords[2].Assignment_Timestamp__c = Datetime.newInstance(
        2020,
        9,
        15,
        14,
        2,
        0
      );
      leadRecords[2].Disqualified_Flag__c = false;
      leadRecords[2].Disqualified_Timestamp__c = null;
      leadRecords[2].OwnerId = newUser.Id;
      Database.DMLOptions insertDML = new Database.DMLOptions();
      insertDML.DuplicateRuleHeader.AllowSave = true;
      List<Database.SaveResult> srList = Database.insert(
        leadRecords,
        insertDML
      );
    }

    Task tsk = TestDataFactory.CreateTask(newUser.Id, leadRecords[0].Id);
    tsk.Result__c = 'No Contact';
    insert tsk;
    Task tsk1 = TestDataFactory.CreateTask(newUser.Id, leadRecords[1].Id);
    tsk1.Result__c = 'No Contact - Left Voicemail';
    insert tsk1;
  }

  @isTest
  public static void runBatchClass() {
    createData();
    List<BusinessHours> businessHours = [
      SELECT
        Id,
        name,
        FridayStartTime,
        FridayEndTime,
        ThursdayStartTime,
        ThursdayEndTime,
        WednesdayStartTime,
        WednesdayEndTime,
        TuesdayStartTime,
        TuesdayEndTime,
        MondayStartTime,
        MondayEndTime
      FROM BusinessHours
    ];
    List<Lead> leads = [
      SELECT
        Id,
        Owner.Profile.Name,
        Assignment_Timestamp__c,
        Disqualified_Flag__c,
        Disqualified_Timestamp__c,
        createdbyid
      FROM Lead
    ];
    for (Lead leadObj : leads) {
      leadObj.Assignment_Timestamp__c = Datetime.now().addDays(-10);
    }
    Test.startTest();
    update leads;
    TrackLeadCallsController obj = new TrackLeadCallsController(
      businessHours[0]
    );
    ID jobID = System.enqueueJob(obj);
    Test.stopTest();
  }
}
