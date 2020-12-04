public class JNConfiguration {
  @AuraEnabled
  public Decimal gct;
  @AuraEnabled
  public Decimal assignmentFee;
  @AuraEnabled
  public Decimal estimatedStampDutyAndAdminFee;
  @AuraEnabled
  public Decimal legalFee;
  @AuraEnabled
  public Decimal stampDutyUns;
  @AuraEnabled
  public Decimal stampDutyAuto;
  @AuraEnabled
  public Decimal nsipp;
  @AuraEnabled
  public Decimal policyLimit;
  @AuraEnabled
  public Decimal creditLimitMin;
  @AuraEnabled
  public Decimal creditLimitMax;
  @AuraEnabled
  public Decimal creditCardPrincipalPayment;
  @AuraEnabled
  public Decimal lineOfCreditPrincipalPayment;
  @AuraEnabled
  public Decimal discountFactor;
  @AuraEnabled
  public decimal creditLimitValue;
  public JNConfiguration(JN_Defaults__mdt record) {
    this.gct = record.GCT__c;
    this.assignmentFee =
      record.Assignment_Fee__c + (record.Assignment_Fee__c * record.GCT__c);
    this.estimatedStampDutyAndAdminFee = record.Estimated_Stamp_Duty_Admin_Fee__c;
    this.legalFee = record.Legal_Fee__c + (record.Legal_Fee__c * record.GCT__c);
    this.stampDutyUns = record.Stamp_Duty_Uns__c;
    this.stampDutyAuto = record.Stamp_Duty_Auto__c;
    this.nsipp = record.NSIPP_Registration_Fee__c;
    this.policyLimit = record.Policy_Limit__c;
    this.creditLimitMin = record.Credit_Limit_Allowable_Min_Number__c;
    this.creditLimitMax = record.Credit_Limit_Allowable_Max_Number__c;
    this.creditCardPrincipalPayment = record.Credit_Card_Principal_Payment_Number__c;
    this.lineOfCreditPrincipalPayment = record.Line_Of_Credit_Principal_Payment_Number__c;
    this.discountFactor = record.Discount_Factor_Number__c;
    this.creditLimitValue = record.Credit_Limit_Value__c;//JN1-4049 :: Kirti R. :: shows the credit limit
  }
}
