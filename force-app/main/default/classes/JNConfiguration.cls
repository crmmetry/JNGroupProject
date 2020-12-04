/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  Added new fields in the wrapper
 **/
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
  //JN1-3969
  @AuraEnabled
  public Decimal goldCardFee;
  //JN1-3969
  @AuraEnabled
  public Decimal classicCardFee;
  //JN1-3969
  @AuraEnabled
  public Decimal supplementaryCardFee;
  //JN1-3969
  @AuraEnabled
  public Decimal locCreditLimitPercent;
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
    this.goldCardFee = record.Gold_Card_Fee__c; //JN1-3969
    this.classicCardFee = record.Classic_Card_Fee__c; //JN1-3969
    this.supplementaryCardFee = record.Supplementary_Card_Fee__c; //JN1-3969
    this.locCreditLimitPercent = record.LOC_Credit_Limit_Percent__c; //JN1-3969
  }
}
