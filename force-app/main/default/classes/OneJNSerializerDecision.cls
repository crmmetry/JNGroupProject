/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 06-17-2021
 * @last modified by  : Trupti Zende (Thinqloud)
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
      JSONToSerialize.put('PhoenixId', serialiser.AppData.PhoenixId);
    } else if (
      eventType == Constants.GET_MANUAL_DESICION_APPROVED ||
      eventType == Constants.GET_MANUAL_DESICION_REJECT
    ) {
      JSONToSerialize.put('ApplicationId', serialiser.AppData.ApplicationId);
      JSONToSerialize.put(
        'InterestRate',
        serialiser.AppData.InterestRateForApplication
      );
      JSONToSerialize.put('ApprovedTenure', serialiser.AppData.ApprovedTenure);
      JSONToSerialize.put(
        'ApprovedLoanAmount',
        serialiser.AppData.ApprovedLoanAmount
      );
      JSONToSerialize.put('PhoenixId', serialiser.AppData.PhoenixId);
      JSONToSerialize.put(
        'AdjudicationDecision',
        serialiser.AppData.AdjudicationDecision
      );
    } else if (eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT) {
      String appDataObj = JSON.serialize(serialiser.AppData);
      //String applicantObj = JSON.serialize(serialiser.Applicant);
      String serializerdata = JSON.serialize(serialiser);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);
      List<String> appDataFieldsToRemove = new List<String>{
        'FeeFinancing',
        'LoanPurpose',
        'IsJointApplication',
        'IsPEP',
        'RequestedTenure',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedLoanAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);

      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        serializerdata
      );
      List<Object> applicantData = (List<Object>) applicantJson.get(
        'Applicant'
      );
      List<String> applicantFieldsToRemove = new List<String>{
        'MonthlyExpensesNonCreditVerified',
        'MonthlyIncomeVerified',
        'MtherIncomeVerified',
        'TotalAssetsVerified',
        'TotalLiabilitiesConsolidatedVerified',
        'TotalLiabilitiesVerified',
        'TotalMonthlyPaymentsVerified',
        'TotalNetworthVerified',
        'TotalPaymentsConsolidatedVerified',
        'OtherIncomeVerified'
      };
      for (Object applicant : applicantData) {
        Map<String, Object> applicantMap = (Map<String, Object>) applicant;
        applicantMap = removeFields(applicantMap, applicantFieldsToRemove);
        applicant = (Object) applicantMap;
      }
      //applicantJson = removeFields(applicantJson, applicantFieldsToRemove);

      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantData);

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
      String serializerdata = JSON.serialize(serialiser);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);
      List<String> appDataFieldsToRemove = new List<String>{
        'IsPEP',
        'MinMonthlyRepayment',
        'SubProductType',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedLoanAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        serializerdata
      );
      List<Object> applicantData = (List<Object>) applicantJson.get(
        'Applicant'
      );
      List<String> applicantFieldsToRemove = new List<String>{
        'MonthlyExpensesNonCreditVerified',
        'MonthlyIncomeVerified',
        'OtherIncomeVerified',
        'TotalAssetsVerified',
        'TotalLiabilitiesConsolidatedVerified',
        'TotalLiabilitiesVerified',
        'TotalMonthlyPaymentsVerified',
        'TotalNetworthVerified',
        'TotalPaymentsConsolidatedVerified'
      };
      for (Object applicant : applicantData) {
        Map<String, Object> applicantMap = (Map<String, Object>) applicant;
        applicantMap = removeFields(applicantMap, applicantFieldsToRemove);
        applicant = (Object) applicantMap;
      }
      //applicantJson = removeFields(applicantJson, applicantFieldsToRemove);

      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantObj1 = JSON.serialize(applicantData);

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
      //String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);
      List<String> appDataFieldsToRemove = new List<String>{
        'FeeFinancing',
        'LoanPurpose',
        'IsJointApplication',
        'IsPEP',
        'RequestedTenure',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedLoanAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);

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
      //String applicantObj = JSON.serialize(serialiser.Applicant);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);

      List<String> appDataFieldsToRemove = new List<String>{
        'IsPEP',
        'MinMonthlyRepayment',
        'SubProductType',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedLoanAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);

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
  /**
   * @description to remove the fields from json
   * @author Trupti Zende (Thinqloud) | 06-15-2021
   * @return Map<String, Object>
   **/
  public static Map<String, Object> removeFields(
    Map<String, Object> jsonData,
    List<String> fieldsList
  ) {
    if (fieldsList.size() > 0) {
      for (String field : fieldsList) {
        jsonData.remove(field);
      }
    }
    return jsonData;
  }
}
