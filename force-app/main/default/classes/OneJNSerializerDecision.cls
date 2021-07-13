/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 07-13-2021
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
  public class Application {
    /**
     * @description : serialize get application event
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<String, Object>
     **/
    public Map<String, Object> serialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();
      JSONToSerialize.put('ProductType', serialiser.AppData.ProductType);
      JSONToSerialize.put('PhoenixId', serialiser.AppData.PhoenixId);

      JSONToSerialize = removeNullData(JSONToSerialize);
      return JSONToSerialize;
    }
  }
  public class ManualDecision {
    /**
     * @description serialize manual decision events
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<String, Object>
     **/
    public Map<String, Object> serialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();
      JSONToSerialize.put('ApplicationId', serialiser.AppData.ApplicationId);
      JSONToSerialize.put(
        'ApprovedInterestRate',
        serialiser.AppData.InterestRateForApplication
      );
      JSONToSerialize.put('ApprovedTenure', serialiser.AppData.ApprovedTenure);
      JSONToSerialize.put(
        'ApprovedCreditAmount',
        serialiser.AppData.ApprovedCreditAmount
      );
      JSONToSerialize.put('PhoenixId', serialiser.AppData.PhoenixId);
      JSONToSerialize.put(
        'AdjudicationDecision',
        serialiser.AppData.AdjudicationDecision
      );
      JSONToSerialize = removeNullData(JSONToSerialize);
      return JSONToSerialize;
    }
  }

  public class PreAssesssment {
    /**
     * @description serialize credit card pre- assessment evnets
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<String, Object>
     **/
    public Map<String, Object> creditCardSerialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();

      String appDataObj = JSON.serialize(serialiser.AppData);
      String serializerdata = JSON.serialize(serialiser);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);
      //appDataJson.put('InterestRate', serialiser.AppData.ApprovedInterestRate);
      List<String> appDataFieldsToRemove = new List<String>{
        'FeeFinancing',
        'LoanPurpose',
        'IsJointApplication',
        'IsPEP',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedCreditAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);

      //to remove fields with null values
      appDataJson = removeNullData(appDataJson);

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
        //to remove fields with null values
        applicantMap = removeNullData(applicantMap);
        applicant = (Object) applicantMap;
      }
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
      return JSONToSerialize;
    }
    /**
     * @description serialize unsecured loan pre-assessment event
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<STring, Object>
     **/
    public Map<STring, Object> unsecuredLoanSerialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();
      String appDataObj = JSON.serialize(serialiser.AppData);
      String serializerdata = JSON.serialize(serialiser);
      Map<String, Object> appDataJson = (Map<String, Object>) JSON.deserializeUntyped(
        appDataObj
      );
      Object currencyType = appDataJson.get('CurrencyType');
      appDataJson.put('Currency', currencyType);
      //appDataJson.put('InterestRate', serialiser.AppData.ApprovedInterestRate);
      List<String> appDataFieldsToRemove = new List<String>{
        'IsPEP',
        'SubProductType',
        'ApprovedTenure',
        'AdjudicationDecision',
        'CurrencyType',
        'PhoenixId',
        'ApprovedCreditAmount',
        'InterestRateForApplication'
      };
      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);
      //to remove fields with null values
      appDataJson = removeNullData(appDataJson);
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
        //to remove fields with null values
        applicantMap = removeNullData(applicantMap);
        applicant = (Object) applicantMap;
      }
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
      return JSONToSerialize;
    }
  }
  public class FinalAssessment {
    /**
     * @description serialize credit card final assessment events
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<String, Object>
     **/
    public Map<String, Object> creditCardserialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();
      String appDataObj = JSON.serialize(serialiser.AppData);
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
        'ApprovedCreditAmount',
        'InterestRateForApplication'
      };

      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);
      //to remove fields with null values
      appDataJson = removeNullData(appDataJson);

      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        serializerdata
      );
      List<Object> applicantData = (List<Object>) applicantJson.get(
        'Applicant'
      );
      for (Object applicant : applicantData) {
        Map<String, Object> applicantMap = (Map<String, Object>) applicant;
        //to remove fields with null values
        applicantMap = removeNullData(applicantMap);
        applicant = (Object) applicantMap;
      }

      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantDataObj1 = JSON.serialize(applicantData);
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
        (Object) JSON.deserializeUntyped(applicantDataObj1)
      );
      return JSONToSerialize;
    }
    /**
     * @description serialize unsecured loan final assessment event
     * @author Trupti Zende (Thinqloud) | 06-21-2021
     * @param serialiser
     * @param eventType
     * @return Map<String, Object>
     **/
    public Map<String, Object> unsecuredLoanserialize(
      OneJNSerializer serialiser,
      String eventType
    ) {
      Map<String, Object> JSONToSerialize = new Map<String, Object>();

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
        'ApprovedCreditAmount',
        'InterestRateForApplication'
      };
      appDataJson = removeFields(appDataJson, appDataFieldsToRemove);
      //to remove fields with null values
      appDataJson = removeNullData(appDataJson);
      Map<String, Object> applicantJson = (Map<String, Object>) JSON.deserializeUntyped(
        serializerdata
      );
      List<Object> applicantData = (List<Object>) applicantJson.get(
        'Applicant'
      );
      for (Object applicant : applicantData) {
        Map<String, Object> applicantMap = (Map<String, Object>) applicant;
        //to remove fields with null values
        applicantMap = removeNullData(applicantMap);
        applicant = (Object) applicantMap;
      }
      String appDataObj1 = JSON.serialize(appDataJson);
      String applicantDataObj1 = JSON.serialize(applicantData);
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
        (Object) JSON.deserializeUntyped(applicantDataObj1)
      );
      return JSONToSerialize;
    }
  }
  /**
   * @description to set the request body for one JN events
   * @author Trupti Zende (Thinqloud) | 06-21-2021
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
      Application application = new Application();
      JSONToSerialize = application.serialize(serialiser, eventType);
    } else if (
      eventType == Constants.SUBMIT_CREDIT_CARD_MANUAL_DECISION ||
      eventType == Constants.SUBMIT_UNSECURED_LOAN_MANUAL_DECISION
    ) {
      ManualDecision manualDecision = new ManualDecision();
      JSONToSerialize = manualDecision.serialize(serialiser, eventType);
    } else if (eventType == Constants.GET_CREDITCARD_PRE_ASSESSMENT) {
      PreAssesssment preAssessment = new PreAssesssment();
      JSONToSerialize = preAssessment.creditCardSerialize(
        serialiser,
        eventType
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT) {
      PreAssesssment preAssessment = new PreAssesssment();
      JSONToSerialize = preAssessment.unsecuredLoanSerialize(
        serialiser,
        eventType
      );
    } else if (eventType == Constants.GET_CREDITCARD_FINAL_ASSESSMENT) {
      FinalAssessment finalAssessment = new FinalAssessment();
      JSONToSerialize = finalAssessment.creditCardserialize(
        serialiser,
        eventType
      );
    } else if (eventType == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT) {
      FinalAssessment finalAssessment = new FinalAssessment();
      JSONToSerialize = finalAssessment.unsecuredLoanserialize(
        serialiser,
        eventType
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
  /**
   * @description : To remove fields with null values from JSON request body
   * @author Trupti Zende (Thinqloud) | 06-29-2021
   * @param JSONData
   * @return Map<String, Object>
   **/
  public static Map<String, Object> removeNullData(
    Map<String, Object> JSONData
  ) {
    List<String> fieldsToRemove = new List<String>();
    for (String jsonKey : JSONData.KeySet()) {
      //if(String.isBlank(JSON.serialize(JSONData.get(jsonKey)))){
      if (JSONData.get(jsonKey) == null || JSONData.get(jsonKey) == '') {
        fieldsToRemove.add(jsonKey);
      }
    }
    JSONData = removeFields(JSONData, fieldsToRemove);
    return JSONData;
  }

  public class ExceptionWrapper {
    public String getExceptionJson(Exception e, String eventName) {
      String stackTrace = e.getStackTraceString().substringBefore('\n');
      String className = stackTrace.substringAfter('.').substringBefore('.');
      String methodName = stackTrace.substringBefore(':')
        .substringAfter(className)
        .substringAfter('.');
      Map<String, String> jsonData = new Map<String, String>();
      jsonData.put('ProcessName', className);
      jsonData.put('MethodName', methodName);
      jsonData.put('ErrorMessage', e.getMessage());
      jsonData.put('StackTrace', e.getStackTraceString());
      jsonData.put('EventType', eventName);

      String json = JSON.serialize(jsonData);
      return json;
    }
  }
}
