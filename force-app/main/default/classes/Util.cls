public with sharing class Util {
    public static final String AccountRole = 'AccountRole';
    public static final String ContactRole = 'ContactRole';
    public static Integer ExecutionCount = 0;
    public static Map<String,Boolean> affiliations = new Map<String,Boolean>();
    public static Map<String,Boolean> Memory = new Map<String,Boolean>();// ensures methods are executed only once
    public static Map<String, Id> getRecordTypeids(String sobjectType){
        Map<String, Id> recordTypesMap = new Map<String, Id>();
        List<RecordType> recordTypes = [SELECT Id,DeveloperName FROM RecordType WHERE SobjectType = :sobjectType];
        for(RecordType record: recordTypes){
            recordTypesMap.put(record.DeveloperName, record.Id);
        }
        return recordTypesMap;
    }
    
    public static String getRecordTypeDevName(Id recordTypeId,  Map<String, Id> recordTypes){
        for(String key: recordTypes.keySet()){
            if(recordTypeId == recordTypes.get(key)){
                return key;
            }
        }
        return null;
    }
    public static String getMappedRecordTypeId(String devName,  Map<String, Id> recordTypes){
        for(String value: recordTypes.keySet()){
            if(value == devName){
                return recordTypes.get(value);
            }
        }
        return null;
    }
    
    public static Map<String, FinServ__ReciprocalRole__c> getRoleRelationships(String roleRecordType){
        Map<String, FinServ__ReciprocalRole__c> roleMap = new Map<String, FinServ__ReciprocalRole__c>();
        List<FinServ__ReciprocalRole__c> roles = [SELECT id,Name, FinServ__InverseRole__c, FinServ__RelationshipType__c 
                                                  FROM FinServ__ReciprocalRole__c WHERE Name in ('Emergency Contact','Political Affiliation','JN Affiliation') 
                                                  AND FinServ__InverseRole__c IN ('Emergency Contact Dependent','Political Affiliation Dependent',
                                                                                  'JN Affiliation Dependent')
                                                  AND RecordType.DeveloperName = :roleRecordType];
        for(FinServ__ReciprocalRole__c record: roles){
            roleMap.put(record.Name, record);
        }
        return roleMap;
    }
    public static FinServ__AccountAccountRelation__c createAcountToAccountRelationship(Id mainAccount, Id relatedAccount, Id role){
        FinServ__AccountAccountRelation__c  accountRecord = new FinServ__AccountAccountRelation__c();
        //accountRecord.FinServ__Role__c = role;
        accountRecord.FinServ__Account__c = mainAccount;
        accountRecord.FinServ__RelatedAccount__c = relatedAccount;
        return accountRecord;
    }
    
    public static List<AggregateResult> QueryContactToContactRelationship(List<Id> roleIds, List<Id> contactIds){
        return [SELECT Id,FinServ__Contact__c,FinServ__Role__r.Name FROM FinServ__ContactContactRelation__c 
                WHERE FinServ__Contact__c IN :contactIds AND FinServ__Role__c IN :roleIds 
                AND FinServ__RelatedContact__c != NULL
                GROUP BY FinServ__Contact__c,Id,FinServ__Role__r.Name ];
    }
    public static FinServ__ContactContactRelation__c createContactToContactRelationship(Id mainContact, Id relatedContact, Id role){
        FinServ__ContactContactRelation__c   record = new FinServ__ContactContactRelation__c ();
        record.FinServ__Role__c = role;
        record.FinServ__Contact__c = mainContact;
        record.FinServ__RelatedContact__c = relatedContact;
        return record;
    }
    public static Account createAccount(Map<String, String> fields, Sobject record, String recordTypeId){
        Account newAccount = new Account();
        newAccount.RecordTypeId = recordTypeId;
        //key is from account, value is to record
        for(String key: fields.keySet()){
            newAccount.put(key, record.get(fields.get(key)));
        }
        //insert newAccount;
        return newAccount;
    }
    public static Supplementary_Card_Holders__c createSupplementaryCardHolder(Id opportunityId, Id accountId){
        Supplementary_Card_Holders__c newRecord = new Supplementary_Card_Holders__c();
        newRecord.Opportunity__c = opportunityId;
        newRecord.Account__c = accountId;
        return newRecord;
    }
    public static Boolean areFieldsEmpty(List<String> fields, Sobject record){
        for(String field: fields){
            if(record.get(field) == null || record.get(field) == ''){
                return true;
            }
        }
        return false;
    }
    public static Long getNameHash(List<String> values){     
        return String.join(Values, ':').hashCode();
    }
    public static Date GetBackDatedDate(Date currentDate, Integer days){
        while(days > 0){
            DateTime dt = DateTime.newInstance(currentDate.year(),currentDate.month(),currentDate.day());
            String day = dt.format('E');
            if(day != 'Sat' && day != 'Sun'){              
                days-=1;
            }
            if (days > 0) {
                currentDate = currentDate.addDays(-1);
            }          
        }
        return currentDate;
    }
        
    public static Boolean DidFieldChange(Object v1, Object v2) {
        if (v1 == null && v2 == null) {
            return false;
        }
        if (v1 != v2) {
            return true;
        }
        return false;
    }
    public static Map<String, Integer> GetYearValues(Date startDate, Date currentDate){
        Map<String, Integer> values = new Map<String, Integer>();
        Integer days = 0;
        Integer months = 0;
        Integer years = 0;
        while(startDate < currentDate){
             days += 1;
             startDate = startDate.addDays(1);
        }

        Integer calendarYears = Integer.valueOf(days / 365);
		Integer calendarMonths = Integer.valueOf(days / 30.417);
        values.put('days', days);
        values.put('years', calendarMonths >= 12 ? calendarYears: 0);
        values.put('months', calendarMonths);
        return values;
    }
    public static String GenerateHash(List<String> values){
        Blob targetBlob = Blob.valueOf(String.join(values, '-'));
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        return EncodingUtil.base64Encode(hash);
    }
    public static Boolean IsExecuted(String method){
		String hash = GenerateHash(new List<String>{ method });        
        if(Memory.containsKey(hash)){
            return true;
        }
        Memory.put(hash, true);
        return false;
    }
    public static Boolean Some(List<String> records, String match){
        for(String record: records){
            if(record == match)
                return true;
        }
        return false;
    }
    /**
     * returns the previous month last day
     * @param {Date} current - current date
     */
    public static Date GetPrevMonthLastDay(Date current){
        return Date.newInstance(current.year(), current.month(), Date.daysInMonth(current.year(), current.month()));
    }
}