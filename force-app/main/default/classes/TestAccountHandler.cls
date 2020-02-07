@isTest
public class TestAccountHandler {
    
    @isTest
    public static void shouldAssignMobileNumber(){
        List<Account> accounts  = TestDataFactory.CreateBasicAccounts(1, 'testlastname');
        Map<String, Id> recordTypesMap = Util.getRecordTypeids('Account');
        accounts.get(0).PersonMobilePhone = TestDataFactory.PHONE;
        accounts.get(0).RecordTypeId = recordTypesMap.get('PersonAccount');
        System.debug(accounts);        
        insert accounts;
        System.assert(accounts.get(0).Id != null);
        System.assertEquals(TestDataFactory.PHONE, accounts.get(0).PersonMobilePhone, 'PersonMobilePhone incorrect');
        Account queriedAccount = [SELECT id,Mobile_Number__pc FROM Account where Id = :accounts.get(0).Id];
        System.assert(queriedAccount!=null, 'queriedAccount is null');
        System.assertEquals(queriedAccount.Mobile_Number__pc, accounts.get(0).PersonMobilePhone, 'Mobile_Number__pc was not assigned.');
    }
    
}