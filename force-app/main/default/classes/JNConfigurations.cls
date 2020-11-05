public with sharing class JNConfigurations {
    /**
     * gets the default jn configurations
     * @return {JNConfiguration}
     */
    @AuraEnabled
    public static JNConfiguration GetDefaultConfiguration(){
        try {
            List<JN_Defaults__mdt> records = [SELECT Id,GCT__c FROM JN_Defaults__mdt WHERE Label = :Constants.DEFAULT_METADATA_LABEL];
            System.assert(records.size() == 1, 'default custom meta type size ');
            JN_Defaults__mdt record = records[0];
            return new JNConfiguration(record);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }
}
