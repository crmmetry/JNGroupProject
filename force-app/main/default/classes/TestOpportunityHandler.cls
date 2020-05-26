@isTest
public class TestOpportunityHandler {
    
    @testSetup static void setup() {
        Integer count = 5;
        // Create common test accounts
        List<Account> testAccts = TestDataFactory.CreateBasicAccounts(count, 'ln');
        insert testAccts;
        List<Opportunity> testOpps = TestDataFactory.CreateOpportunities(count);
        for(Integer i = 0; i<count; i++){
            testOpps.get(i).AccountId = testAccts.get(i).Id;
        }
        insert testOpps;
    }
    
    
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
        record.Product_of_Interest__c = 'JN Bank Credit Card';
        insert record;
        
        Date todayDate = Date.newInstance(2019, 12, 18);
        
    }
    
    @isTest
    public static void shouldsetOpportunityAmountOnLead(){
        //List<Account> accounts = [SELECT Id,PersonContactId FROM Account WHERE LastName LIKE 'ln%']; 
        // List <Opportunity> opps = [SELECT Id FROM Opportunity WHERE Name LIKE '%opp'];
        List<Account> accounts = TestDataFactory.CreateBasicAccounts(1, 'ln');
        //System.assert(opps.size()==5);
        insert accounts;
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = accounts[0].Id;
        insert opp;
        opp.StageName = 'Analysis';
        update opp;
        
        /*Account acc = [SELECT Id FROM Account WHERE FirstName='Test 0' LIKE  LIMIT 1];
Opportunity opp2 = new Opportunity();
opp2.Name = 'Testopp';
opp2.AccountId = acc.Id;
opp2.CloseDate = Date.today();
opp2.StageName = 'Closed Lost';
opp2.Product_of_Interest__c = 'JN Bank Credit Card';        
insert opp2;
opp2.StageName = 'Closed Won';
update opp2;*/
        //Account acc = [SELECT Id FROM Account WHERE FirstName='Test 0' LIMIT 1];
        //System.debug('is acc Empty?'+ acc);
        /*Opportunity testOpp = new Opportunity();
testOpp.Name = 'Testopp';
testOpp.AccountId = acc.Id;
testOpp.CloseDate = Date.today();
testOpp.StageName = 'Closed Won';
testOpp.Product_of_Interest__c = 'JN Bank Credit Card';
insert testOpp;*/
        //System.debug('testOpp: '+[SELECT Id FROM Opportunity WHERE Name='Testopp' LIMIT 1]);
    }
    
    @isTest
    public static void shouldAssignOpportunityRecordTypeName(){
        Test.startTest();
        //List <Opportunity> opps = [SELECT Id FROM Opportunity WHERE Name LIKE '%opp'];
        //Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        List<Account> accounts = TestDataFactory.CreateBasicAccounts(3, 'ln');
        insert accounts;
        List <Opportunity> opps = TestDataFactory.CreateOpportunities(3);
        Map <String, Id> mappedOppRecTypes = Util.GetRecordTypeIds('Opportunity');
        Id recordTypeId_cc = mappedOppRecTypes.get('Credit_Facility');
        Id recordTypeId_m = mappedOppRecTypes.get('Mortgage');
        Id recordTypeId_sc = mappedOppRecTypes.get('Savings_Chequing');
        opps[0].RecordTypeId = recordTypeId_cc;
        opps[0].AccountId = accounts[0].Id;
        //opps[0].Product_of_Interest__c = 'JN Bank Deposit Account';
        opps[1].RecordTypeId = recordTypeId_m;
        opps[1].AccountId = accounts[1].Id;
        opps[1].Product_of_Interest__c = 'JN Bank Mortgage Loan';
        opps[2].RecordTypeId = recordTypeId_sc;
        opps[2].AccountId = accounts[2].Id;
        opps[2].Product_of_Interest__c = 'JN Bank Deposit Account';
        insert opps;
        System.debug('opps:'+opps);
        Test.stopTest();
    }
    
    @isTest
    public static void shouldValidateProductsFamily(){
        Test.startTest();
        List<Product2> products = new List<Product2>();
        List<String> families = new List<String>{
            'JN Bank Auto Loan','JN Bank Line Of Credit',
                'JN Bank Term Share Loan','JN Bank Credit Card',
                'JN Bank Deposit Account','JN Bank Mortgage'};
                    for(String family: families){
                        //add each product to be created
                        products.add(TestDataFactory.CreateProduct(family, 'iPhone X - ' + family));
                    }
        //Insert products with families
        insert products;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
        for(Product2 record: products){
            priceBookEntries.add(TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id));
        }
        //Insert Price Book Entries
        insert priceBookEntries;
        
        //Create Account record
        Account acc = TestDataFactory.CreateBasicAccounts(1,'ln')[0];
        insert acc;
        
        //Create Opportunity record
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
        for(PricebookEntry record: priceBookEntries){
            lineItems.add(TestDataFactory.CreateOpportunityLineItem(opp.Id, record.Id));            
        }
        // Insert Opportunity Line Items
        insert lineItems;
        
        Test.stopTest();
    }
    @isTest
    public static void shouldValidateApplicantProfileCompletion(){
        
        Test.startTest();      
        Map <String, Id> mappedOppRecTypes = Util.GetRecordTypeIds('Opportunity');
        
        //Create new Account record
        Account acc = TestDataFactory.CreateBasicAccounts(1,'ln')[0];
        insert acc;
        
        //Create new opportunity record
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        opp.Name = 'Quick Test';
        opp.RecordTypeId =  mappedOppRecTypes.get('Credit_Facility');
        
        boolean a = false;
        
        try{
            insert opp;
            
            opp.Loan_Path__c = 'Complete Applicant Profile(s)';
            opp.Personal_Details_Complete_PK__c = 'Yes';
            opp.Financial_Information_Complete_PK__c = 'Yes';
            update opp;}catch(System.DmlException e){
                if(e.getMessage()!= null){
                    a = true;
                }
            }
        
        Test.stopTest();
        system.assert(a, 'Error was thrown and handled!');
        
    }
    
    @isTest
    public static void shouldValidateBackDate(){
        Map<Id,Opportunity> m = new Map<Id,Opportunity>();
        List<Account> accounts = [SELECT Name, Id FROM Account];
        System.assert(accounts.size() > 0 , 'Accounts list empty');
        List<Opportunity> opps = [SELECT Name, Id , AccountId, StageName,CloseDate,CreatedDate FROM Opportunity];
        System.assert(opps.size() > 0 , 'Opportunities list empty');
        // init records
        OpportunityTriggerHandler.init(opps, m, m);
        Test.startTest();
        String err1 = 'The Closed Date cannot be this far back in the past. Please contact Sales Support.';
        String err2 = 'The Closed Date cannot be less than the last 2 days within this month. Please contact Sales Support.';
        String err3 = 'The Closed Date cannot be greater than today. Please contact Sales Support.';
        // scenario 1
        // 	a) update a opportunity with a close date greater than today date
        Opportunity opp1 = opps[0];
        opp1.CloseDate = Date.newInstance(2020, 04, 23);
         OpportunityTriggerHandler.validateCloseBackDate(0, 0, Date.newInstance(2020, 04, 23));
        try {
            // b) update a opportunity with a close date equal to today date
            OpportunityTriggerHandler.validateCloseBackDate(0, 0, Date.newInstance(2020, 04, 25));
        } catch(Exception e){
            System.assert(e.getMessage().length() > 0);
            System.assertEquals(err3, e.getMessage(), e.getMessage());
        }
        
        //scenario 2 
         // a) the closedate is less than today, so the closedate cant be greater than maxPrevDays, default = 2
         Integer maxPrevDays = 2;
         Date d0 = Date.newInstance(2020, 04, 23);
         Date d1 = Util.GetBackDatedDate(d0, maxPrevDays);
         System.assertEquals(d1, Date.newInstance(2020, 04, 22),d1 + ' wrong backdate with ' + maxPrevDays);
         
        Test.stopTest();
        
    }
    
    @isTest
    public static void shouldLockRecordsForEditing(){
        Test.startTest();
        //Create new Account record
        Account acc = TestDataFactory.CreateBasicAccounts(1,'ln')[0];
        insert acc;
        
        //Create new opportunity record
        Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
        opp.AccountId = acc.Id;
        insert opp;
        
        try{
            opp.Record_Lock__c = False;
            update opp;
        }catch(System.Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('This record is currently LOCKED due to it being in the stage of "Closed Won" or "Closed Lost". Click Reactivate button to enable record edit.') ? true : false;       
            System.AssertEquals(expectedExceptionThrown, true, 'Error message was thrown!');    
        }
        Test.stopTest();
    }
    
}