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
    public static void shouldValidateBackDate(){
        Test.startTest();
        DateTime now =System.now();
        // current date
        Date currentDate = Date.newInstance(2020, 10, 2);
        // valid backdated date
        Date validBackDate = Date.newInstance(2020, 8, 6);
        // valid previous month backdated date
        Date validPrevBackDate = Date.newInstance(2020, 7, 30);

        Holiday hol = TestDataFactory.CreateHoliday(Date.newInstance(2020, 10, 4),'Test Holiday');
        insert hol;
        
        // populate values
        List<Opportunity> opps = new  List<Opportunity>();
        for(Opportunity record: TestDataFactory.CreateOpportunities(5)){
            record.CloseDate = Date.newInstance(2020, 8, 4);
            record.StageName = 'Closed Lost';
            opps.add(record);
        }
        //insert opps;
        Map<Id,Opportunity> mappedOpps = new Map<Id,Opportunity>();
        
        //scenario one: close date greater than current date
        opps[2].CloseDate = Date.newInstance(2020,10,4);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[2]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate, 'JN Default Business Hours'); 
        
        // scenario two: close date less than current date and greater than back max prev days
        opps[1].CloseDate = Date.newInstance(2020,10, 5);
        // acceptable date: (2020,8, 3)
        Date d1 = Date.newInstance(2020, 10, 15);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[1]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, d1, 'JN Default Business Hours');
        
        // scenario three: close date less than current date and falls in previous month and greater than max backdated days
        opps[2].CloseDate = Date.newInstance(2020,9, 28);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[2]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate, 'JN Default Business Hours'); 

        // **scenario three: close date less than current date and falls in previous month and less than max backdated days
        opps[2].CloseDate = Date.newInstance(2020,9, 29);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[2]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate, 'JN Default Business Hours'); 
        
        //scenario 4: years are different
        opps[3].CloseDate = Date.newInstance(2019,8, 8);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[3]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate, 'JN Default Business Hours'); 
        
        //**scenario 5: a public holiday falls between current date and prospective backedDate and less than max prev days
        opps[4].CloseDate = Date.newInstance(2020,9, 29);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[4]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate.addDays(5), 'JN Default Business Hours');

        //**scenario 6: close date falls on a public hoiliday
        opps[4].CloseDate = Date.newInstance(2020,10, 3);
        OpportunityTriggerHandler.init(new List<Opportunity>{opps[4]}, mappedOpps, mappedOpps);
        OpportunityTriggerHandler.validateCloseBackDate(2, 7, currentDate.addDays(5), 'JN Default Business Hours');
        Test.stopTest(); 
        
        
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