/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 07-21-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-18-2021   Remario Richards   Initial Version
 **/
@isTest
public class TestUtil {
  @testSetup
  static void setup() {
    List<Account> accounts = TestDataFactory.CreateBasicAccounts(5, 'ln');
    insert accounts;
  }

  @isTest
  public static void shouldGetRecordTypeIds() {
    Test.startTest();
    List<Account> accs = [SELECT Id, Name FROM Account];
    Map<String, Id> mappedRecords = Util.GetRecordTypeIds('Account');
    String[] devNames = new List<String>{
      'PersonAccount',
      'IndustriesBusiness',
      'IndustriesHousehold',
      'IndustriesInstitution',
      'IndustriesIndividual'
    };
    for (String name : devNames) {
      System.assert(
        mappedRecords.containsKey(name),
        'Map does not contain devname'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldGetRecordTypeDevName() {
    Test.startTest();
    List<Account> accs = [SELECT Id, Name, RecordTypeId FROM Account];
    Map<String, Id> mappedRecords_acc = Util.GetRecordTypeIds('Account');
    Map<String, Id> mappedRecords_opp = Util.GetRecordTypeIds('Opportunity');
    Integer i;
    String key = Util.getRecordTypeDevName(
      accs[0].RecordTypeId,
      mappedRecords_opp
    );
    key = Util.getRecordTypeDevName(accs[0].RecordTypeId, mappedRecords_acc);
    String[] devNames = new List<String>{
      'PersonAccount',
      'IndustriesBusiness',
      'IndustriesHousehold',
      'IndustriesInstitution',
      'IndustriesIndividual'
    };
    for (String name : devNames) {
      System.assert(
        mappedRecords_acc.containsKey(name),
        'Map does not contain devname'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void shouldGetMappedRecordTypeIds() {
    Test.startTest();
    Map<String, Id> mappedRecords = Util.GetRecordTypeIds('Account');
    String[] devNames = new List<String>{
      'PersonAccount',
      'IndustriesBusiness',
      'IndustriesHousehold',
      'IndustriesInstitution',
      'IndustriesIndividual'
    };
    String mapId = Util.getMappedRecordTypeId('PersonAccount', mappedRecords);
    String mapId2 = Util.getMappedRecordTypeId(
      'Credit_Facility',
      mappedRecords
    );
    boolean flag = false;
    for (String name : devNames) {
      if (mapId == name) {
        flag = true;
      }
    }
    //System.assert(flag==true,'Mapped RecordIds are invalid');
    Test.stopTest();
  }

  @isTest
  public static void shouldGetRoleRelationships() {
    Test.startTest();

    Map<String, Id> mappedRecords = Util.GetRecordTypeIds(
      'FinServ__ReciprocalRole__c'
    );

    FinServ__ReciprocalRole__c r_role = new FinServ__ReciprocalRole__c();
    r_role.Name = 'Emergency Contact';
    r_role.FinServ__InverseRole__c = 'Emergency Contact Dependent';
    r_role.RecordTypeId = mappedRecords.get('ContactRole');
    insert r_role;

    Map<String, FinServ__ReciprocalRole__c> roleRelationship = Util.getRoleRelationships(
      'ContactRole'
    );

    Test.stopTest();
  }

  @isTest
  public static void shouldCreateAcountToAccountRelationship() {
    Test.startTest();

    //Create Account
    List<Account> accs = TestDataFactory.CreateBasicAccounts(2, 'lastName');
    insert accs;

    Map<String, Id> mappedRecords = Util.GetRecordTypeIds(
      'FinServ__ReciprocalRole__c'
    );

    FinServ__ReciprocalRole__c r_role = new FinServ__ReciprocalRole__c();
    r_role.Name = 'Emergency Contact';
    r_role.FinServ__InverseRole__c = 'Emergency Contact Dependent';
    r_role.RecordTypeId = mappedRecords.get('AccountRole');
    insert r_role;

    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'AccountRole'
    );
    FinServ__ReciprocalRole__c role = mappedRoles.get('Emergency Contact');
    //System.debug('Id Null?'+accs[0].Id+''+accs[1].Id+''+role.Id);
    FinServ__AccountAccountRelation__c accToAcc = Util.createAcountToAccountRelationship(
      accs[0].Id,
      accs[1].Id,
      role.Id
    );

    Test.stopTest();
  }

  @isTest
  public static void shouldCreateContactToContactRelationship() {
    Test.startTest();

    //Create Account
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
    insert acc;

    //Create Contact
    Contact con = TestDataFactory.CreateBasicContacts(1, 'lastName')[0];
    insert con;

    Map<String, Id> mappedRecords = Util.GetRecordTypeIds(
      'FinServ__ReciprocalRole__c'
    );

    FinServ__ReciprocalRole__c r_role = new FinServ__ReciprocalRole__c();
    r_role.Name = 'Emergency Contact';
    r_role.FinServ__InverseRole__c = 'Emergency Contact Dependent';
    r_role.RecordTypeId = mappedRecords.get('ContactRole');
    insert r_role;

    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'ContactRole'
    );
    FinServ__ReciprocalRole__c role = mappedRoles.get('Emergency Contact');
    //System.debug('Id Null?'+accs[0].Id+''+accs[1].Id+''+role.Id);
    FinServ__ContactContactRelation__c conToCon = Util.createContactToContactRelationship(
      acc.PersonContactId,
      con.Id,
      role.Id
    );

    Test.stopTest();
  }

  @isTest
  public static void shouldQueryContactToContactRelationship() {
    Test.startTest();

    //Create Account
    List<Account> accs = TestDataFactory.CreateBasicAccounts(2, 'lastName');
    insert accs;

    //Create Contact
    List<Contact> cons = TestDataFactory.CreateBasicContacts(2, 'lastName');
    insert cons;

    List<Id> conIds = new List<Id>();
    conIds.add(cons[0].id);
    conIds.add(cons[1].id);

    Map<String, Id> mappedRecords = Util.GetRecordTypeIds(
      'FinServ__ReciprocalRole__c'
    );

    FinServ__ReciprocalRole__c r_role = new FinServ__ReciprocalRole__c();
    r_role.Name = 'Emergency Contact';
    r_role.FinServ__InverseRole__c = 'Emergency Contact Dependent';
    r_role.RecordTypeId = mappedRecords.get('ContactRole');
    insert r_role;

    FinServ__ReciprocalRole__c r_role2 = new FinServ__ReciprocalRole__c();
    r_role2.Name = ('Political Affiliation');
    r_role2.FinServ__InverseRole__c = 'Political Affiliation Dependent';
    r_role2.RecordTypeId = mappedRecords.get('ContactRole');
    insert r_role2;

    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'ContactRole'
    );

    List<Id> roleIds = new List<Id>();
    roleIds.add(mappedRoles.get('Emergency Contact').Id);
    roleIds.add(mappedRoles.get('Political Affiliation').Id);

    FinServ__ContactContactRelation__c conToCon = Util.createContactToContactRelationship(
      accs[0].PersonContactId,
      cons[0].Id,
      roleIds[0]
    );
    insert conToCon;

    List<AggregateResult> result = Util.QueryContactToContactRelationship(
      roleIds,
      conIds
    );
    Test.stopTest();
  }

  @isTest
  public static void shouldCreateSupplementaryCardHolder() {
    Test.startTest();
    Account acc = TestDataFactory.CreateBasicAccounts(1, 'lastName')[0];
    insert acc;

    Opportunity opp = TestDataFactory.CreateOpportunities(1)[0];
    opp.AccountId = acc.Id;
    insert opp;

    Supplementary_Card_Holders__c new_Supp_Card = Util.createSupplementaryCardHolder(
      acc.Id,
      opp.Id
    );

    Test.stopTest();
  }

  @isTest
  public static void shouldCheckIfFieldsAreEmpty() {
    Test.startTest();

    List<String> fields = new List<String>();
    fields.add('FirstName');
    fields.add('LastName');

    Account acc = new Account();

    Boolean empty = Util.areFieldsEmpty(fields, acc);
    Test.stopTest();
  }

  @isTest
  public static void shouldGetBackedDate() {
    //TODO:Date backedDate = Util.GetBackDatedDate(Date.today(), 5);
  }

  @isTest
  public static void shouldGetYearValues() {
    Map<String, Integer> dateValues = Util.GetYearValues(
      Date.today(),
      Date.today().addMonths(-5)
    );
    Map<String, Integer> dateValues2 = Util.GetYearValues(
      Date.today().addMonths(-5),
      Date.today()
    );
  }

  @isTest
  public static void shouldSome() {
    List<String> records = new List<String>();
    records.add('Account');
    records.add('Opportunity');
    Boolean is_match = Util.Some(records, 'Account');
    is_match = Util.Some(records, 'User');
  }

  @isTest
  public static void shouldCheckForFieldChange() {
    String field1 = 'Travis';
    String field2 = 'Allen';
    Boolean fieldChange = Util.DidFieldChange(field1, field2);
    field1 = 'Allen';
    fieldChange = Util.DidFieldChange(field1, field2);
    field1 = null;
    field2 = null;
    fieldChange = Util.DidFieldChange(field1, field2);
  }

  @isTest
  public static void shouldGetHashName() {
    List<String> records = new List<String>();
    records.add('Account');
    records.add('Opportunity');
    Long hashName = Util.getNameHash(records);
  }
  //TODO: FIX ALL ASSERTS

  /*@isTest
  public static void shouldIsWithinBusinessHours() {
    
    Datetime holiday = Datetime.newInstance(2020, 8, 6);
    Holiday hol = TestDataFactory.CreateHoliday(holiday, 'Test Holiday');
    insert hol;
    Datetime currentDateTime = Datetime.now();
    Datetime weekend = Datetime.newInstance(2020, 9, 19);

    //scenario: 1 date passed in is a holiday
    Boolean isBusinessHours1 = Util.isWithinBusinessHours(holiday);
    System.assert(
      isBusinessHours1 == false,
      'Should not be business hour due to holiday!'
    );

    //scenario: 2 date passed in is a business hour
    Boolean isBusinessHours2 = Util.isWithinBusinessHours(currentDateTime);
    System.assert(isBusinessHours2 == true, 'Should be business holiday');

    //scenario: 3 date passed in is a weekend day
    Boolean isBusinessHours3 = Util.isWithinBusinessHours(weekend);
    System.assert(
      isBusinessHours3 == false,
      'Should not be business hour due to weekend!'
    );
  }*/

  @isTest
  public static void shouldLeadWithinTimeLimit() {
    Integer hours = 8;
    Datetime assignmentTime = DateTime.newInstance(2020, 9, 14, 13, 15, 0);
    String businessHoursName = Constants.DEFAULT_BUSINESS_HOURS_NAME;
    Datetime currentTime;
    Boolean within;
    BusinessHours businessHours = Util.GetActiveBusinessHours(
      businessHoursName
    );
    //scenario 1: currentTime is on same day before end time
    /**
     *  assigned sep 14 2020 at 1:15PM
     *  current  sep 14 2020 at 4:15PM
     *  max time sep 15 2020 at 1PM (because 5 hours remained)
     * if (business day + diff hours > that day end time)
     *  its fine
     * if(business day + diff hours < end time)
     * if current > business day + diff hours
     *  then over limit
     *  else
     * within limit
     */
    currentTime = DateTime.newInstance(2020, 9, 14, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 2: currentTime is on different day limit not exceeded
    currentTime = DateTime.newInstance(2020, 9, 15, 11, 0, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 3: currentTime is on different day on the exact limit
    currentTime = DateTime.newInstance(2020, 9, 15, 13, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 4: currentTime is on different day one minute over limit
    currentTime = DateTime.newInstance(2020, 9, 15, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 5: currentTime is on different day + 1,
    currentTime = DateTime.newInstance(2020, 9, 15, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    currentTime = DateTime.newInstance(2020, 9, 16, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    currentTime = DateTime.newInstance(2020, 9, 17, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    currentTime = DateTime.newInstance(2020, 9, 18, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
  }
  /**
   * @description : test method to cover the savePdf functionality
   * @author Ishwari Gaikwad(Thinqloud) | 04-20-2021
   **/
  @isTest
  public static void shouldSavePdf() {
    List<Account> accList = TestDataFactory.CreateBasicAccounts(1, 'Test');
    accList[0].Years_at_Residence__pc = 4;
    accList[0]
      .Highest_Level_of_Education_attained__pc = 'University: Post Graduate';
    accList[0].PersonBirthdate = date.newInstance(
      System.Today().year() - 36,
      2,
      11
    );
    insert accList;

    Util.savePdf(
      accList[0].Id,
      new PageReference('http://www.salesforce.com'),
      'SampleFile'
    );
  }

  /**
   * @description : Test method to cover the context trigger switch
   * @author Ishwari Gaikwad(Thinqloud) | 06-02-2021
   **/
  @isTest
  public static void testcanTriggerExecute() {
    Boolean isActive = Util.canTriggerExecute();
    Context_Trigger_Switch__mdt triggerSwitchMetadata = Util.getContextTriggerMetadata();
    system.assertEquals(!triggerSwitchMetadata.Disable_Trigger__c, isActive);
  }

  /**
   * @description : to test the method that creates the platform event
   * @author Ishwari Gaikwad(Thinqloud) | 07-20-2021
   **/
  @isTest
  public static void testGetPlatformEventInstance() {
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      1,
      'testAccount'
    );
    accounts[0].RIM_no__c = '1111';
    insert accounts;

    List<Opportunity> opps = TestDataFactory.CreateOpportunities(1);
    opps[0].RecordTypeId = oppRecordTypeId_cc;
    opps[0].AccountId = accounts[0].Id;
    insert opps;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Credit Card' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    List<Application__c> appList = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    appList.add(applicationRecord);
    insert appList;
    Test.startTest();
    OneJNEventFactory.ProcessOutgoingEvent(
      Constants.GET_LOAN_APPLICATION_ID,
      appList,
      opps
    );
    Test.stopTest();
  }

  /**
   * @description : To test the method that generates the exception event log
   * @author Ishwari Gaikwad(Thinqloud) | 07-20-2021
   **/
  @isTest
  public static void testExceptionEventCreation() {
    JSONGenerator jsonGen = JSON.createGenerator(true);
    jsonGen.writeStartObject();
    jsonGen.writeFieldName('ConsolidatedReport');

    jsonGen.writeStartObject();
    jsonGen.writeStringField('FinalAssessmentReport', 'test');
    jsonGen.writeFieldName('GeneralInformation');
    jsonGen.writeStartObject();
    jsonGen.writeStringField('ProductType', 'JN Bank Unsecured Loan');
    jsonGen.writeStringField(
      'ApplicationID',
      'TEST ' + Integer.valueof((Math.random() * 1000))
    );
    jsonGen.writeEndObject();
    jsonGen.writeFieldName('ApplicantDetailsPrimary');
    jsonGen.writeStartObject();
    jsonGen.writeEndObject();
    jsonGen.writeFieldName('ApplicantDetailsCoApplicants');
    jsonGen.writeStartArray();
    jsonGen.writeStartObject();
    jsonGen.writeEndObject();
    jsonGen.writeEndArray();
    jsonGen.writeEndObject();
    jsonGen.writeEndObject();
    String jsonData = jsonGen.getAsString();
    OneJNDeserializer oneJNDeserializer;
    oneJNDeserializer = (OneJNDeserializer) JSON.deserialize(
      jsonData,
      OneJNDeserializer.class
    );
    Map<String, Id> mappedOppRecTypes = Util.getRecordTypeids('Opportunity');
    Id oppRecordTypeId_cc = mappedOppRecTypes.get('Rubicon');

    //Get Application Record Type
    Map<String, Id> mappedApplicationRecTypes = Util.getRecordTypeids(
      'Application__c'
    );
    Id applRecordTypeId_cc = mappedApplicationRecTypes.get('Application');

    List<Account> accounts = TestDataFactory.CreateBasicAccounts(
      2,
      'testAccount4'
    );
    accounts[0].RIM_no__c = '1111';
    accounts[0].Premier_Customer_List__c = 'Yes';
    accounts[0].Politically_Affiliated__c = true;
    accounts[0].MonthsResidence_Number__c = 1;
    accounts[0].FinServ__NumberOfDependents__pc = 2;
    accounts[0].Highest_Level_of_Education_attained__pc = 'Community Colleges';

    accounts[1].RIM_no__c = '1111';
    accounts[1].Premier_Customer_List__c = 'Yes';
    accounts[1].Politically_Affiliated__c = true;
    accounts[1].MonthsResidence_Number__c = 1;
    accounts[1].FinServ__NumberOfDependents__pc = 2;
    accounts[1].Highest_Level_of_Education_attained__pc = 'Community Colleges';
    insert accounts;

    List<Opportunity> opps3 = TestDataFactory.CreateOpportunities(1);
    opps3[0].RecordTypeId = oppRecordTypeId_cc;
    opps3[0].AccountId = accounts[0].Id;
    opps3[0].Product_Category__c = 'JN Bank Unsecured Loan';
    opps3[0].CurrencyIsoCode = 'JMD';
    opps3[0].Preferred_Location__c = 'New Kingston';
    insert opps3;

    List<Product2> products = new List<Product2>();
    List<String> families = new List<String>{ 'JN Bank Unsecured Loan' };
    for (String family : families) {
      //add each product to be created
      products.add(
        TestDataFactory.CreateProduct(family, 'test Product - ' + family)
      );
    }
    //Insert products with families
    insert products;

    Pricebook2 standardPricebook = new Pricebook2(
      Id = Test.getStandardPricebookId(),
      IsActive = true
    );

    List<PricebookEntry> priceBookEntries = new List<PricebookEntry>();
    for (Product2 record : products) {
      priceBookEntries.add(
        TestDataFactory.CreatePriceBookEntry(standardPricebook.Id, record.Id)
      );
    }
    //Insert Price Book Entries
    insert priceBookEntries;

    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>();
    for (PricebookEntry record : priceBookEntries) {
      lineItems.add(
        TestDataFactory.CreateOpportunityLineItem(opps3[0].id, record.Id)
      );
    }
    // Insert Opportunity Line Items
    insert lineItems;

    List<OpportunityLineItem> lineItems2 = Util.getOpportunityProducts(
      opps3[0].id
    );

    List<Application__c> appList3 = new List<Application__c>();
    Application__c applicationRecord = TestDataFactory.CreateApplication(
      accounts[0].Id,
      opps3[0].Id,
      products[0].Id
    );
    applicationRecord.RecordTypeId = applRecordTypeId_cc;
    applicationRecord.IDM_Tenure_Date__c = 2;
    applicationRecord.IDM_Loan_Amount_Number__c = 222;
    applicationRecord.IDM_Interest_Rate_Number__c = 6;
    applicationRecord.Adjudication_Decision_picklist__c = 'Manual Approve';
    appList3.add(applicationRecord);
    insert appList3;
    FinServ__Employment__c employee = TestDataFactory.CreateEmployment(
      accounts[0].id,
      'Employeement Test'
    );
    employee.Professional_Category__c = 'Professional';
    //employee.Industry__c = 'Construction';
    employee.Position_List__c = 'Analyst';
    employee.FinServ__EmploymentStatus__c = 'Permanent';
    employee.Time_Employed_in_Present_Employer_M__c = 10;
    employee.Time_Employed_with_Previous_Employer_M__c = 20;
    insert employee;

    Applicant__c applicant = TestDataFactory.CreateApplicant(
      accounts[0].id,
      opps3[0].id
    );
    applicant.Joint_Application_flag__c = 'No';
    applicant.Primary_Applicant_Flag__c = true;
    applicant.Number_of_Rejected_Applications_Number__c = 1;
    applicant.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant.Declared_bankrupt_list__c = 'No';
    applicant.Gross_Monthly_Income__c = 50000;
    applicant.Other_Income__c = 10000;

    applicant.Life_Insurance_Cash_Value__c = 1000;
    applicant.Pension_IRS_Total_Contribution__c = 5000;
    applicant.Other_Asset_Market_Value_Number__c = 2000;
    applicant.Savings_Deposit_Investments__c = 2000;
    applicant.Motor_Vehicle_Market_Value_Number__c = 2000;
    applicant.Real_Estate_Market_Value_Number__c = 2000;

    applicant.Mortgage_Balance_Number__c = 2000;
    applicant.Other_Loan_Loan_Balance_Number__c = 2000;
    applicant.Other_Debt_Number__c = 2000;
    applicant.Average_Credit_Card_Balances_Number__c = 2000;
    applicant.Average_Line_of_Credit_Balance_Number__c = 2000;

    applicant.Personal_and_Family_Expenses_Number__c = 2000;
    applicant.Mortgage_Rent_Number__c = 2000;
    applicant.Other_Expenses_Number__c = 2000;
    applicant.Utilties_and_Household_Expenses_Number__c = 2000;
    applicant.Statutory_Deductions_Numbers__c = 2000;
    applicant.Transportation_Number__c = 2000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 2000;

    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Monthly_Payment__c = 1000;
    applicant.Total_Amount_Consolidated__c = 5000;
    applicant.Total_Monthly_Loan_Payments_Number__c = 500;
    applicant.Other_Income_VERIFIED_Number__c = 9999;
    insert applicant;

    Applicant__c applicant1 = TestDataFactory.CreateApplicant(
      accounts[1].id,
      opps3[0].id
    );
    applicant1.Joint_Application_flag__c = 'No';
    applicant1.Primary_Applicant_Flag__c = false;
    applicant1.Number_of_Rejected_Applications_Number__c = 1;
    applicant1.Public_Sector_or_Civil_Servant_List__c = 'Yes';
    applicant1.Are_you_currently_in_bankruptcy_list__c = 'No';
    applicant1.Declared_bankrupt_list__c = 'No';
    applicant1.Gross_Monthly_Income__c = 50000;
    applicant1.Other_Income__c = 10000;
    insert applicant1;

    List<Loan_Calculator__c> loanCalculatorRecord = TestDataFactory.CreateLoanCalculation(
      1
    );
    loanCalculatorRecord[0].Opportunity__c = opps3[0].Id;
    insert loanCalculatorRecord;
    List<Loan_Calculation_Product__c> loanCalculationProductRecord = TestDataFactory.CreateLoanCalculationProduct(
      1
    );
    loanCalculationProductRecord[0].Loan_Amount_Number__c = 50000;
    loanCalculationProductRecord[0].Interest_Rate_Number__c = 7;
    loanCalculationProductRecord[0]
      .Method_of_Fee_Payment_List__c = 'Added to Loan';
    //loanCalculationProductRecord[0].Loan_Purpose_List__c='Medical Expenses';
    loanCalculationProductRecord[0].Months_Number__c = 9;
    loanCalculationProductRecord[0]
      .Minimum_Payment_per_Credit_Limit_Number__c = 1000;
    loanCalculationProductRecord[0]
      .Loan_Calculation_Id__c = loanCalculatorRecord[0].id;
    insert loanCalculationProductRecord;
    Test.startTest();
    OneJNEventFactory.ProcessIncomingEvent(
      Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT,
      oneJNDeserializer,
      opps3[0].Id,
      ''
    );

    OneJN_Event_Log__c exceptionLog = [
      SELECT id, name, name__c, Body__c, Salesforce_Record_Id__c
      FROM OneJN_Event_Log__c
      WHERE
        createddate = today
        AND name__c = 'JNGroup.OneJN.CreditInfo.Domain.Events.GenericErrorEvent'
        AND Salesforce_Record_Id__c = :opps3[0].Id
    ];
    system.assert(
      exceptionLog.Body__c.contains('Attempt to de-reference a null object')
    );
    Test.stopTest();
  }

  /**
   * @description : To test method when date is on Tuesday
   * @author Ishwari Gaikwad(Thinqloud) | 07-21-2021
   **/
  @isTest
  public static void shouldLeadWithinTimeLimit_Tue() {
    Integer hours = 8;
    Datetime assignmentTime = DateTime.newInstance(2020, 9, 15, 13, 15, 0);
    String businessHoursName = Constants.DEFAULT_BUSINESS_HOURS_NAME;
    Datetime currentTime;
    Boolean within;
    BusinessHours businessHours = Util.GetActiveBusinessHours(
      businessHoursName
    );
    //scenario 1: currentTime is on same day before end time
    /**
     *  assigned sep 14 2020 at 1:15PM
     *  current  sep 14 2020 at 4:15PM
     *  max time sep 15 2020 at 1PM (because 5 hours remained)
     * if (business day + diff hours > that day end time)
     *  its fine
     * if(business day + diff hours < end time)
     * if current > business day + diff hours
     *  then over limit
     *  else
     * within limit
     */
    currentTime = DateTime.newInstance(2020, 9, 15, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 2: currentTime is on different day limit not exceeded
    currentTime = DateTime.newInstance(2020, 9, 16, 11, 0, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 3: currentTime is on different day on the exact limit
    currentTime = DateTime.newInstance(2020, 9, 16, 13, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 4: currentTime is on different day one minute over limit
    currentTime = DateTime.newInstance(2020, 9, 16, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 5: currentTime is on different day + 1,
    currentTime = DateTime.newInstance(2020, 9, 16, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );
  }

  /**
   * @description : To test the method when date is on Wednesday
   * @author Ishwari Gaikwad(Thinqloud) | 07-21-2021
   **/
  @isTest
  public static void shouldLeadWithinTimeLimit_Wed() {
    Integer hours = 8;
    Datetime assignmentTime = DateTime.newInstance(2020, 9, 16, 13, 15, 0);
    String businessHoursName = Constants.DEFAULT_BUSINESS_HOURS_NAME;
    Datetime currentTime;
    Boolean within;
    BusinessHours businessHours = Util.GetActiveBusinessHours(
      businessHoursName
    );
    //scenario 1: currentTime is on same day before end time
    /**
     *  assigned sep 14 2020 at 1:15PM
     *  current  sep 14 2020 at 4:15PM
     *  max time sep 15 2020 at 1PM (because 5 hours remained)
     * if (business day + diff hours > that day end time)
     *  its fine
     * if(business day + diff hours < end time)
     * if current > business day + diff hours
     *  then over limit
     *  else
     * within limit
     */
    currentTime = DateTime.newInstance(2020, 9, 16, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 2: currentTime is on different day limit not exceeded
    currentTime = DateTime.newInstance(2020, 9, 17, 11, 0, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 3: currentTime is on different day on the exact limit
    currentTime = DateTime.newInstance(2020, 9, 17, 13, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 4: currentTime is on different day one minute over limit
    currentTime = DateTime.newInstance(2020, 9, 17, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 5: currentTime is on different day + 1,
    currentTime = DateTime.newInstance(2020, 9, 17, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );
  }

  /**
   * @description : To test the the method when date is on Thursday
   * @author Ishwari Gaikwad(Thinqloud) | 07-21-2021
   **/
  @isTest
  public static void shouldLeadWithinTimeLimit_Thu() {
    Integer hours = 8;
    Datetime assignmentTime = DateTime.newInstance(2020, 9, 17, 13, 15, 0);
    String businessHoursName = Constants.DEFAULT_BUSINESS_HOURS_NAME;
    Datetime currentTime;
    Boolean within;
    BusinessHours businessHours = Util.GetActiveBusinessHours(
      businessHoursName
    );
    //scenario 1: currentTime is on same day before end time
    /**
     *  assigned sep 14 2020 at 1:15PM
     *  current  sep 14 2020 at 4:15PM
     *  max time sep 15 2020 at 1PM (because 5 hours remained)
     * if (business day + diff hours > that day end time)
     *  its fine
     * if(business day + diff hours < end time)
     * if current > business day + diff hours
     *  then over limit
     *  else
     * within limit
     */
    currentTime = DateTime.newInstance(2020, 9, 17, 16, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 2: currentTime is on different day limit not exceeded
    currentTime = DateTime.newInstance(2020, 9, 18, 11, 0, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 3: currentTime is on different day on the exact limit
    currentTime = DateTime.newInstance(2020, 9, 18, 13, 15, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      false,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 4: currentTime is on different day one minute over limit
    currentTime = DateTime.newInstance(2020, 9, 18, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );

    //scenario 5: currentTime is on different day + 1,
    currentTime = DateTime.newInstance(2020, 9, 18, 13, 16, 0);
    within = Util.LeadWithinTimeLimit(
      hours,
      assignmentTime,
      currentTime,
      businessHours
    );
    System.assertEquals(
      true,
      within,
      'Current time ' +
      currentTime +
      ' not withing '
    );
  }
}
