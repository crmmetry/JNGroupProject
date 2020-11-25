@isTest
public class TestDataFactory {
  // test variables
  public static final String PHONE = '8767578495';
  public static final String COMPANY = 'ABC Company';
  public static List<Contact> CreateBasicContacts(
    Integer count,
    String lastName
  ) {
    List<Contact> contacts = new List<Contact>();
    for (Integer i = 0; i < count; i++) {
      Contact c = new Contact(FirstName = 'Test ' + i + 1, LastName = lastName);
      contacts.add(c);
    }
    return contacts;
  }

  public static Holiday CreateHoliday(Datetime holidate, String holidayName) {
    Holiday hol = new Holiday();
    hol.Name = holidayName;
    hol.ActivityDate = holidate.date();
    return hol;
  }

  public static Sobject CreateMappedRecord(
    Map<String, Object> info,
    String typeOfObject
  ) {
    Sobject c = getNewSobject(typeOfObject);
    for (String key : info.keySet()) {
      c.put(key, info.get(key));
    }
    return c;
  }
  public static List<Account> CreateBasicAccounts(
    Integer count,
    String lastName
  ) {
    Map<String, Id> recordTypeids = Util.getRecordTypeids('Account');
    Id personAccountId = recordTypeids.get('PersonAccount');
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < count; i++) {
      Account c = new Account(
        FirstName = 'Test ' + i,
        LastName = lastName + 'i'
      );
      c.RecordTypeId = personAccountId;
      accounts.add(c);
    }
    return accounts;
  }

  public static List<Loan_Calculator__c> CreateLoanCalculation(Integer count) {
    List<Loan_Calculator__c> loanCalculator = new List<Loan_Calculator__c>();
    for (Integer i = 0; i < count; i++) {
      Loan_Calculator__c loanCal = new Loan_Calculator__c();
      loanCal.Product_Type__c = 'Credit Card';
      loanCalculator.add(loanCal);
    }
    return loanCalculator;
  }

  public static List<Opportunity> CreateOpportunities(Integer count) {
    List<Opportunity> records = new List<Opportunity>();
    for (Integer i = 0; i < count; i++) {
      Opportunity c = new Opportunity();
      c.Name = i + ' opp';
      c.CloseDate = Date.today();
      c.StageName = 'Closed Won';
      c.Product_of_Interest__c = 'JN Bank Credit Card';
      records.add(c);
    }
    return records;
  }

  public static Applicant__c CreateApplicant(Id accountId, Id oppId) {
    Applicant__c record = new Applicant__c();
    record.Account__c = accountId;
    record.Opportunity__c = oppId;
    return record;
  }

  public static List<Lead> CreateLeads(Integer count) {
    List<Lead> records = new List<Lead>();
    for (Integer i = 0; i < count; i++) {
      Lead c = new Lead();
      c.FirstName = i + ' testL';
      c.LastName = i + ' lead';
      c.Email = 'test@gmail.com';
      c.MobilePhone = Phone;
      c.Estimated_Amount__c = 50000.00;
      c.Service_of_Interest__c = 'JN Bank Credit Card';
      c.Company = COMPANY;
      //c.Status = 'Qualified';
      //c.LeadSource = 'Credit Card Form';
      records.add(c);
    }
    return records;
  }

  public static ServiceResource CreateServiceResource(Id newUser) {
    ServiceResource serv_res = new ServiceResource();
    serv_res.Name = 'Travis';
    serv_res.ResourceType = 'T';
    serv_res.IsActive = true;
    serv_res.RelatedRecordId = newUser;
    return serv_res;
  }

  public static ServiceResourceSkill CreateServiceResourceSkill(
    Id serv_res_id,
    Id test_skill_id
  ) {
    ServiceResourceSkill serv_res_skill = new ServiceResourceSkill();
    serv_res_skill.ServiceResourceId = serv_res_id;
    serv_res_skill.EffectiveStartDate = Date.today();
    serv_res_skill.EffectiveEndDate = Date.today().addDays(5);
    serv_res_skill.SkillId = test_skill_id;
    return serv_res_skill;
  }

  /*public static PriorityQueue CreatePriorityQueue(){
        Comparator comp;
        Type t;
        Integer i = 5;
        PriorityQueue prio_queue = new PriorityQueue(comp, t, i);
        return prio_queue;
    }*/

  public static void CreateApplicants() {
  }
  public static FinServ__Employment__c CreateEmployment(
    Id accountId,
    String name
  ) {
    FinServ__Employment__c record = new FinServ__Employment__c(
      Account__c = accountId,
      Current_Employment__c = false,
      Description__c = 'random ',
      Name = name
    );
    return record;
  }
  public static void CreateSupplementaryCardHolders() {
  }

  public static Task CreateTask(Id ownerId, Id whoId) {
    Task tsk = new Task();
    tsk.Subject = 'Follow up with Lead';
    tsk.WhoId = whoId;
    tsk.OwnerId = ownerId;
    tsk.Status = 'New';
    tsk.Type = 'Call';
    return tsk;
  }
  public static GroupMember CreateGroupMember(Id userId, Id groupId) {
    GroupMember record = new GroupMember();
    record.UserOrGroupId = userId;
    record.GroupId = groupId;
    return record;
  }
  public static User CreateUser(String uniqueUserName) {
    Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    User record = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = uniqueUserName
    );
    return record;
  }

  public static Product2 CreateProduct(String family, String name) {
    Product2 record = new Product2(Name = name, Family = family);
    return record;
  }
  public static OpportunityLineItem CreateOpportunityLineItem(
    Id OpportunityId,
    Id PricebookEntryId
  ) {
    OpportunityLineItem record = new OpportunityLineItem();
    record.OpportunityId = OpportunityId;
    record.Quantity = 1;
    record.TotalPrice = 500.00;
    record.PricebookEntryId = PricebookEntryId;
    return record;
  }
  public static PricebookEntry CreatePriceBookEntry(
    Id pricebookId,
    Id productId
  ) {
    PricebookEntry record = new PricebookEntry(
      Pricebook2Id = pricebookId,
      Product2Id = productId,
      UnitPrice = 1020,
      IsActive = true
    );
    return record;
  }
  public static SObject getNewSobject(String typeOfObject) {
    /* Call global describe to get the map of string to token. */
    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

    /* Get the token for the sobject based on the type. */
    Schema.SObjectType st = gd.get(typeOfObject);
    System.assert(
      st != null,
      'Type provided: "' +
      typeOfObject +
      '" doesnt map to an sobject token in this org.'
    );

    /* Instantiate the sobject from the token. */
    return st.newSobject();
  }

  public static FinServ__ReciprocalRole__c CreateRole(String name) {
    FinServ__ReciprocalRole__c role = new FinServ__ReciprocalRole__c();
    Map<String, Id> recordTypesMap = Util.GetRecordTypeIds(
      'FinServ__ReciprocalRole__c'
    );
    role.FinServ__CreateInverseRole__c = true;
    role.Name = name;
    role.FinServ__RelationshipType__c = 'Contact Contact Relation';
    role.RecordTypeId = recordTypesMap.get('ContactRole');
    role.FinServ__InverseRole__c = name + ' Dependent';
    return role;
  }
}