public class JNConfiguration {
  @AuraEnabled
  public Decimal gct;
  @AuraEnabled
  public Decimal assignmentFee;
  @AuraEnabled
  public Decimal estimatedStampDutyAndAdminFee;
  public JNConfiguration(JN_Defaults__mdt record) {
    this.gct = record.GCT__c;
    this.assignmentFee = record.Assignment_Fee__c;
    this.estimatedStampDutyAndAdminFee = record.Estimated_Stamp_Duty_Admin_Fee__c;
  }
}
