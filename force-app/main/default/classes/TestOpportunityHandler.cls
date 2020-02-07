@isTest
public class TestOpportunityHandler {

    @isTest
    public static void shouldCalcValidBackDate(){
        DateTime now =System.now();
      Map<String,Id> recordTypes =  Util.getRecordTypeids('Opportunity');
        Map<String,Object> info = new Map<String,Object>();
        info.put('RecordTypeId', recordTypes.get('Credit_Facility'));
        List<Account> accounts  = TestDataFactory.CreateBasicAccounts(1, 'testlastname');
        Map<String, Id> recordTypesMap = Util.getRecordTypeids('Account');
        accounts.get(0).RecordTypeId = recordTypesMap.get('PersonAccount');
        insert accounts;
        Opportunity record = (Opportunity)TestDataFactory.CreateMappedRecord(info, 'Opportunity');
        record.AccountId = accounts.get(0).Id;
        record.StageName = 'Qualification';
        record.CloseDate = Date.newInstance(now.year(), now.month(), now.day());
        insert record;
        
        Date todayDate = Date.newInstance(2019, 12, 18);
        
    }
}