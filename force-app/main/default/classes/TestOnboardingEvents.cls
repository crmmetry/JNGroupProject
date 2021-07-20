/**
 * @description       : For testing onboarding event
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-20-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-15-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
@isTest
public class TestOnboardingEvents {
  /**
   * @description : testing onboarding event 5
   * @author Ishwari Gaikwad(Thinqloud) | 07-15-2021
   **/
  @isTest
  public static void testOnBoardingEvent5() {
    String jsonData = TestDataFactory.getOnBoardingJson();
    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.SUBMIT_PROFILE_EVENT_5;
    Fli1.externalId = '24-test23-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    List<Account> accRecordList = [
      SELECT Id
      FROM Account
      WHERE GUID_Text__c = '24-test23-3323'
    ];
    System.assertEquals(1, accRecordList.size());
  }

  /**
   * @description : testing onboarding event 4
   * @author Ishwari Gaikwad(Thinqloud) | 07-15-2021
   **/
  @isTest
  public static void testOnBoardingEvent4() {
    String jsonData = TestDataFactory.getOnBoardingJson();
    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.SUBMIT_PROFILE_EVENT_4;
    Fli1.externalId = '24-test23-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    List<Account> accRecordList = [
      SELECT Id
      FROM Account
      WHERE GUID_Text__c = '24-test23-3323'
    ];
    System.assertEquals(1, accRecordList.size());
  }

  /**
   * @description : testing onboarding event 3
   * @author Ishwari Gaikwad(Thinqloud) | 07-15-2021
   **/
  @isTest
  public static void testOnBoardingEvent3() {
    String jsonData = TestDataFactory.getOnBoardingJson();
    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.SUBMIT_PROFILE_EVENT_3;
    Fli1.externalId = '24-test23-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    List<Account> accRecordList = [
      SELECT Id
      FROM Account
      WHERE GUID_Text__c = '24-test23-3323'
    ];
    System.assertEquals(1, accRecordList.size());
  }

  /**
   * @description : testing onboarding event 2
   * @author Ishwari Gaikwad(Thinqloud) | 07-15-2021
   **/
  @isTest
  public static void testOnBoardingEvent2() {
    String jsonData = TestDataFactory.getOnBoardingJson();
    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.SUBMIT_PROFILE_EVENT_2;
    Fli1.externalId = '24-test23-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    List<Account> accRecordList = [
      SELECT Id
      FROM Account
      WHERE GUID_Text__c = '24-test23-3323'
    ];
    System.assertEquals(1, accRecordList.size());
  }

  /**
   * @description : testing onboarding event 1
   * @author Ishwari Gaikwad(Thinqloud) | 07-15-2021
   **/
  @isTest
  public static void testOnBoardingEvent1() {
    String jsonData = TestDataFactory.getOnBoardingJson();
    list<OneJNOutputEventHandler.FlowInputs> Flilist1 = new List<OneJNOutputEventHandler.FlowInputs>();
    OneJNOutputEventHandler.FlowInputs Fli1 = new OneJNOutputEventHandler.FlowInputs();
    Fli1.eventType = Constants.SUBMIT_PROFILE_EVENT_1;
    Fli1.externalId = '24-test23-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
    List<Account> accRecordList = [
      SELECT Id
      FROM Account
      WHERE GUID_Text__c = '24-test23-3323'
    ];
    System.assertEquals(1, accRecordList.size());
  }
}
