public with sharing class JNDefaultsHelper {
    /**
     * gets the default jn configurations
     */
    @AuraEnabled
    public static JNDefault GetDefaultsConfiguration(){
        try {
            List<JN_Defaults__mdt> records = [SELECT Id,GCT__c FROM JN_Defaults__mdt WHERE Label = :Constants.DEFAULT_METADATA_LABEL];
            System.assert(records.size() == 1, 'default custom meta type size ');
            JN_Defaults__mdt record = records[0];
            return new JNDefault(record);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    class JNDefault {
        @AuraEnabled
        public Decimal gct;
        public JNDefault(JN_Defaults__mdt record){
            this.gct = record.GCT__c;
        }
    }
}