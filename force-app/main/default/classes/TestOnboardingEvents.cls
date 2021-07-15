/**
 * @description       : For testing onboarding event
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-15-2021
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
    Fli1.externalId = '24-test-3323';
    Fli1.sfRecordId = '';
    Fli1.body = jsonData;
    Fli1.replayId = '';
    Flilist1.add(Fli1);
    Test.startTest();
    OneJNOutputEventHandler.HandleEvent(Flilist1);
    Test.stopTest();
  }
}
