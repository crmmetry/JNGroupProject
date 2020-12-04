public with sharing class JNConfigurations {
  /**
   * gets the default jn configurations
   * @return {JNConfiguration}
   */
  @AuraEnabled
  public static JNConfiguration GetDefaultConfiguration() {
    try {
      List<JN_Defaults__mdt> records = [
        SELECT
          Id,
          GCT__c,
          Assignment_Fee__c,
          Estimated_Stamp_Duty_Admin_Fee__c,
          Legal_Fee__c,
          Stamp_Duty_Uns__c,
          Stamp_Duty_Auto__c,
          NSIPP_Registration_Fee__c,
          Policy_Limit__c,
          Credit_Limit_Allowable_Max_Number__c,
          Credit_Limit_Allowable_Min_Number__c,
          Discount_Factor_Number__c,
          Credit_Card_Principal_Payment_Number__c,
          Line_Of_Credit_Principal_Payment_Number__c,
          Credit_Limit_Value__c //JN-4049 :: Added a field to track max limit of credit limit
        FROM JN_Defaults__mdt
        WHERE Label = :Constants.DEFAULT_METADATA_LABEL
      ];
      System.assert(records.size() == 1, 'default custom meta type size ');
      JN_Defaults__mdt record = records[0];
      return new JNConfiguration(record);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  /**
   * retrieves creditor life rating for a list of applicants
   * @return {List<CreditorLifeMatrixWrapper> }
   */

  @AuraEnabled
  public static List<CreditorLifeMatrixWrapper> getCreditorLifeMatrix() {
    List<CreditorLifeMatrixWrapper> wrappers = new List<CreditorLifeMatrixWrapper>();
    List<Creditor_Life_Matrix__mdt> creditorLifeMatrices = [
      SELECT
        Label,
        X0_5__c,
        X1__c,
        X1_5__c,
        X2__c,
        X2_5__c,
        X3__c,
        X3_5__c,
        X4__c,
        X4_5__c,
        X5__c,
        X5_5__c,
        X6__c,
        X6_5__c,
        X7__c,
        X7_5__c,
        X8__c,
        X8_5__c,
        X9__c,
        X9_5__c,
        X10__c
      FROM Creditor_Life_Matrix__mdt
    ];
    for (Creditor_Life_Matrix__mdt record : creditorLifeMatrices) {
      CreditorLifeMatrixWrapper wrapper = new CreditorLifeMatrixWrapper(record);
      wrappers.add(wrapper);
    }
    return wrappers;
  }

  /**
   * retrieves Credit Rating for a list of applicants
   * @return {List<Credit_Rating__mdt> }
   */
  @AuraEnabled
  public static List<CreditRatingWrapper> getCreditRatings() {
    List<CreditRatingWrapper> creditRatingWrapperList = new List<CreditRatingWrapper>();
    List<Credit_Rating__mdt> creditRating = [
      SELECT
        Label,
        Classification__c,
        Credit_Score_Max__c,
        Credit_Score_Min__c,
        Rating__c
      FROM Credit_Rating__mdt
    ];
    for (Credit_Rating__mdt creditRatingObj : creditRating) {
      creditRatingWrapperList.add(new CreditRatingWrapper(creditRatingObj));
    }
    return creditRatingWrapperList;
  }

  /*
   * Retrieves Personal Credit Score Model related data
   * @return {List<Personal_Credit_Score_Model__mdt> }
   */
  @AuraEnabled
  public static List<PersonalCreditScoreModelWrapper> getPersonalCreditScore() {
    List<PersonalCreditScoreModelWrapper> personalCreditScoreModel = new List<PersonalCreditScoreModelWrapper>();
    List<Personal_Credit_Score_Model__mdt> creditScoreModel = [
      SELECT
        Label,
        Salaried_Score_Number__c,
        Self_Employed_Score_Number__c,
        Sub_Criteria_Option__c,
        Sub_Criteria_Options__c,
        Sub_Criteria_Weight_Numbr__c,
        Type__c
      FROM Personal_Credit_Score_Model__mdt
    ];
    for (Personal_Credit_Score_Model__mdt personalCredit : creditScoreModel) {
      PersonalCreditScoreModelWrapper personalCreditScore = new PersonalCreditScoreModelWrapper(
        personalCredit
      );
      personalCreditScoreModel.add(personalCreditScore);
    }
    return personalCreditScoreModel;
  }
}
