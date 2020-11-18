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
  public JNConfiguration(JN_Defaults__mdt record) {
    this.gct = record.GCT__c;
    this.assignmentFee =
      record.Assignment_Fee__c + (record.Assignment_Fee__c * record.GCT__c);
    this.estimatedStampDutyAndAdminFee = record.Estimated_Stamp_Duty_Admin_Fee__c;
    this.legalFee = record.Legal_Fee__c + (record.Legal_Fee__c * record.GCT__c);
    this.stampDutyUns = record.Stamp_Duty_Uns__c;
    this.stampDutyAuto = record.Stamp_Duty_Auto__c;
    this.nsipp = record.NSIPP_Registration_Fee__c;
  }
}
