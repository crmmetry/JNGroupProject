/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 04-20-2021
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
}
