/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 06-11-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   06-11-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
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
    } else if (eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.appData);
      String applicantObj = JSON.serialize(serialiser.applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('feeFinancing');
      appDataJson.remove('loanPurpose');
      appDataJson.remove('isJointApplication');
      appDataJson.remove('isPEP');
      appDataJson.remove('requestedTenure');
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        applicantObj
      );
      applicantJson.remove('monthlyExpensesNonCreditVerified');
      applicantJson.remove('monthlyIncomeVerified');
      applicantJson.remove('otherIncomeVerified');
      applicantJson.remove('totalAssetsVerified');
      applicantJson.remove('totalLiabilitiesConsolidatedVerified');
      applicantJson.remove('totalLiabilitiesVerified');
      applicantJson.remove('totalMonthlyPaymentsVerified');
      applicantJson.remove('totalNetworthVerified');
      applicantJson.remove('totalPaymentsConsolidatedVerified');
      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'appData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
      JSONToSerialize.put(
        'applicant',
        (Object) JSON.deserializeUntyped(applicantObj1)
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.appData);
      String applicantObj = JSON.serialize(serialiser.applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('isPEP');
      appDataJson.remove('minMonthlyRepayment');
      appDataJson.remove('subProductType');

      appDataJson.remove('requestedTenure');
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        applicantObj
      );
      applicantJson.remove('monthlyExpensesNonCreditVerified');
      applicantJson.remove('monthlyIncomeVerified');
      applicantJson.remove('otherIncomeVerified');
      applicantJson.remove('totalAssetsVerified');
      applicantJson.remove('totalLiabilitiesConsolidatedVerified');
      applicantJson.remove('totalLiabilitiesVerified');
      applicantJson.remove('totalMonthlyPaymentsVerified');
      applicantJson.remove('totalNetworthVerified');
      applicantJson.remove('totalPaymentsConsolidatedVerified');

      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'appData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
      JSONToSerialize.put(
        'applicant',
        (Object) JSON.deserializeUntyped(applicantObj1)
      );
    } else if (eventType == Constants.GET_CREDITCARD_FINAL_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.appData);
      String applicantObj = JSON.serialize(serialiser.applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('feeFinancing');
      appDataJson.remove('loanPurpose');
      appDataJson.remove('isJointApplication');
      appDataJson.remove('isPEP');
      appDataJson.remove('requestedTenure');
      String appDataObj1 = JSON.serialize(appDataJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'appData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.appData);
      String applicantObj = JSON.serialize(serialiser.applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('isPEP');
      appDataJson.remove('minMonthlyRepayment');
      appDataJson.remove('subProductType');

      String appDataObj1 = JSON.serialize(appDataJson);
      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'appData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
    }

    return JSONToSerialize;
  }
}
