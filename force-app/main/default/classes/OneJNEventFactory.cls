/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 05-26-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public with sharing class OneJNEventFactory {
  public static void Process(
    String eventType,
    OneJNDeserializer oneJNDeserializer
  ) {
    if (eventType == Constants.GET_LOAN_APPLICATION_ID) {
      processGetApplicationEvent();
    }
  }

  /**
   * @description process application events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processGetApplicationEvent() {
  }
  /**
   * @description process pre assessment events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processPreassessmentEvent() {
  }
  /**
   * @description process final assessment events
   * @author Remario Richards | 05-26-2021
   **/
  private static void processFinalAssessmentEvent() {
  }
}
