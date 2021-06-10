public class SerializerDecision {
  public static Map<String, Object> setSerializer(
    OneJNSerializer serialiser,
    String eventType
  ) {
    Map<String, Object> JSONToSerialize = new Map<String, Object>();

    if (eventType == Constants.GET_LOAN_APPLICATION_ID) {
      JSONToSerialize.put('productType', serialiser.appData.productType);
      JSONToSerialize.put('rim', serialiser.applicant.rim);
    } else if (
      eventType == Constants.GET_MANUAL_DESICION_APPROVED ||
      eventType == Constants.GET_MANUAL_DESICION_REJECT
    ) {
      JSONToSerialize.put('applicationId', serialiser.appData.applicationId);
      JSONToSerialize.put('interestRate', serialiser.appData.interestRate);
      JSONToSerialize.put('tenure', serialiser.appData.tenure);
      JSONToSerialize.put('loanAmount', serialiser.appData.loanAmount);
      JSONToSerialize.put('rim', serialiser.applicant.rim);
      JSONToSerialize.put(
        'adjudicationDecision',
        serialiser.appData.adjudicationDecision
      );
    } else {
      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );
    }

    return JSONToSerialize;
  }
}
