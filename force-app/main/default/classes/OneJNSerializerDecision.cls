/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 06-14-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   06-14-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public class OneJNSerializerDecision {
  /**
   * @description : preparing the serialiser as per the event type
   * @author Ishwari Gaikwad(Thinqloud) | 06-14-2021
   * @param serialiser
   * @param eventType
   * @return Map<String, Object>
   **/
  public static Map<String, Object> setSerializer(
    OneJNSerializer serialiser,
    String eventType
  ) {
    Map<String, Object> JSONToSerialize = new Map<String, Object>();

    if (eventType == Constants.GET_LOAN_APPLICATION_ID) {
      JSONToSerialize.put('ProductType', serialiser.AppData.ProductType);
      JSONToSerialize.put('Rim', serialiser.Applicant.Rim);
    } else if (
      eventType == Constants.GET_MANUAL_DESICION_APPROVED ||
      eventType == Constants.GET_MANUAL_DESICION_REJECT
    ) {
      JSONToSerialize.put('ApplicationId', serialiser.AppData.ApplicationId);
      JSONToSerialize.put('InterestRate', serialiser.AppData.InterestRate);
      JSONToSerialize.put('Tenure', serialiser.AppData.Tenure);
      JSONToSerialize.put('LoanAmount', serialiser.AppData.LoanAmount);
      JSONToSerialize.put('Rim', serialiser.Applicant.Rim);
      JSONToSerialize.put(
        'AdjudicationDecision',
        serialiser.AppData.AdjudicationDecision
      );
    } else if (eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.AppData);
      String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('FeeFinancing');
      appDataJson.remove('LoanPurpose');
      appDataJson.remove('IsJointApplication');
      appDataJson.remove('IsPEP');
      appDataJson.remove('RequestedTenure');
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        applicantObj
      );
      applicantJson.remove('MonthlyExpensesNonCreditVerified');
      applicantJson.remove('MonthlyIncomeVerified');
      applicantJson.remove('MtherIncomeVerified');
      applicantJson.remove('TotalAssetsVerified');
      applicantJson.remove('TotalLiabilitiesConsolidatedVerified');
      applicantJson.remove('TotalLiabilitiesVerified');
      applicantJson.remove('TotalMonthlyPaymentsVerified');
      applicantJson.remove('TotalNetworthVerified');
      applicantJson.remove('TotalPaymentsConsolidatedVerified');
      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'AppData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
      JSONToSerialize.put(
        'Applicant',
        (Object) JSON.deserializeUntyped(applicantObj1)
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.AppData);
      String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('IsPEP');
      appDataJson.remove('MinMonthlyRepayment');
      appDataJson.remove('SubProductType');

      appDataJson.remove('RequestedTenure');
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        applicantObj
      );
      applicantJson.remove('MonthlyExpensesNonCreditVerified');
      applicantJson.remove('MonthlyIncomeVerified');
      applicantJson.remove('OtherIncomeVerified');
      applicantJson.remove('TotalAssetsVerified');
      applicantJson.remove('TotalLiabilitiesConsolidatedVerified');
      applicantJson.remove('TotalLiabilitiesVerified');
      applicantJson.remove('TotalMonthlyPaymentsVerified');
      applicantJson.remove('TotalNetworthVerified');
      applicantJson.remove('TotalPaymentsConsolidatedVerified');

      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'AppData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
      JSONToSerialize.put(
        'Applicant',
        (Object) JSON.deserializeUntyped(applicantObj1)
      );
    } else if (eventType == Constants.GET_CREDITCARD_FINAL_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.AppData);
      String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        AppDataObj
      );
      appDataJson.remove('FeeFinancing');
      appDataJson.remove('LoanPurpose');
      appDataJson.remove('IsJointApplication');
      appDataJson.remove('IsPEP');
      appDataJson.remove('RequestedTenure');
      String appDataObj1 = JSON.serialize(appDataJson);

      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'AppData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.AppData);
      String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      appDataJson.remove('IsPEP');
      appDataJson.remove('MinMonthlyRepayment');
      appDataJson.remove('SubProductType');

      String appDataObj1 = JSON.serialize(appDataJson);
      String SerializeObj = JSON.serialize(serialiser);
      JSONToSerialize = (Map<String, Object>) JSON.deserializeUntyped(
        SerializeObj
      );

      JSONToSerialize.put(
        'AppData',
        (Object) JSON.deserializeUntyped(appDataObj1)
      );
    }

    return JSONToSerialize;
  }
}
