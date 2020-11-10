public with sharing class JNConfigurations {
  /**
   * gets the default jn configurations
   * @return {JNConfiguration}
   */
  @AuraEnabled
  public static JNConfiguration GetDefaultConfiguration() {
    try {
      List<JN_Defaults__mdt> records = [
        SELECT Id, GCT__c
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
}
