/**
 * @File Name          : crmm_simpleloancalc.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 8/22/2019, 1:09:59 AM
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/21/2019, 10:31:29 PM   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
 **/
public with sharing class crmm_simpleloancalc {
  @AuraEnabled
  public static Loan_Calculator__c save(Loan_Calculator__c con) {
    insert con;
    return con;
  }
}
