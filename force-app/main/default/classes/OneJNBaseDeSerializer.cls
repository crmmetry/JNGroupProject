/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-14-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   07-14-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public with sharing class OneJNBaseDeSerializer {
  /**
   * @description : to identify the type of event whethere it is Loan Quote event or On Boarding event
   * @author Ishwari Gaikwad(Thinqloud) | 07-14-2021
   * @param eventType
   * @return String
   **/
  public static String identifyInstance(String eventType) {
    String className;
    List<String> loanQuoateEventList = new List<String>{
      Constants.RETURN_LOAN_APPLICATION_ID,
      Constants.RETURN_CREDITCARD_PRE_ASSESSMENT,
      Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT,
      Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE,
      Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE,
      Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT,
      Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT
    };
    List<String> onBoardingEventList = new List<String>{
      Constants.SUBMIT_PROFILE_EVENT_1,
      Constants.SUBMIT_PROFILE_EVENT_2,
      Constants.SUBMIT_PROFILE_EVENT_3,
      Constants.SUBMIT_PROFILE_EVENT_4,
      Constants.SUBMIT_PROFILE_EVENT_5
    };

    if (Util.Some(loanQuoateEventList, eventType)) {
      className = 'OneJNDeserializer';
    } else if (Util.Some(onBoardingEventList, eventType)) {
      className = 'OneJNOnBoardingDeserialiser';
    }
    return className;
  }
}
