public class JNConfiguration {
    @AuraEnabled
    public Decimal gct;
    public JNConfiguration(JN_Defaults__mdt record){
        this.gct = record.GCT__c;
    }
}