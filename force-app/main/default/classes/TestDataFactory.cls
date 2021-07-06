/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 07-06-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   06-14-2021   Travis Allen   Initial Version
 **/
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

  public static List<Loan_Calculator__c> CreateLoanCalculation(Integer count) {
    List<Loan_Calculator__c> loanCalculator = new List<Loan_Calculator__c>();
    for (Integer i = 0; i < count; i++) {
      Loan_Calculator__c loanCal = new Loan_Calculator__c();
      loanCal.Product_Type__c = 'Credit Card';
      loanCalculator.add(loanCal);
    }
    return loanCalculator;
  }

  public static List<Loan_Calculation_Product__c> CreateLoanCalculationProduct(
    Integer count
  ) {
    List<Loan_Calculation_Product__c> loanCalculatorPrdct = new List<Loan_Calculation_Product__c>();
    for (Integer i = 0; i < count; i++) {
      Loan_Calculation_Product__c loanCalPrdct = new Loan_Calculation_Product__c();
      loanCalculatorPrdct.add(loanCalPrdct);
    }
    return loanCalculatorPrdct;
  }

  public static List<Loan_Calculation_Applicant_Product__c> CreateLoanCalculationApplicationPrdct(
    Integer count
  ) {
    List<Loan_Calculation_Applicant_Product__c> loanCalculatorApplPrdctlst = new List<Loan_Calculation_Applicant_Product__c>();
    for (Integer i = 0; i < count; i++) {
      Loan_Calculation_Applicant_Product__c loanCalApplPrdct = new Loan_Calculation_Applicant_Product__c();
      loanCalculatorApplPrdctlst.add(loanCalApplPrdct);
    }
    return loanCalculatorApplPrdctlst;
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

  public static Application__c CreateApplication(
    Id accountId,
    Id oppId,
    Id productId
  ) {
    Application__c record = new Application__c();
    record.ApplicantNameID__c = accountId;
    record.Opportunity_ID__c = oppId;
    record.ProductID__c = productId;
    return record;
  }

  public static List<Lead> CreateLeads(Integer count) {
    Map<String, Id> recordTypes = Util.getRecordTypeids('Lead');
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
      c.RecordTypeId = recordTypes.get('Loan');
      //c.Status = 'Qualified';
      //c.LeadSource = 'Credit Card Form';
      records.add(c);
    }
    return records;
  }

  public static ServiceResource CreateServiceResource(Id newUser, String name) {
    ServiceResource serv_res = new ServiceResource();
    serv_res.Name = name;
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

  public static PermissionSetAssignment CreatePermissionSetAssignment(
    Id userId,
    String permissionSetName
  ) {
    PermissionSet ps = [
      SELECT Id
      FROM PermissionSet
      WHERE Name = :permissionSetName
    ];
    return new PermissionSetAssignment(
      AssigneeId = userId,
      PermissionSetId = ps.Id
    );
  }

  public static Product2 CreateProduct(String family, String name) {
    Product2 record = new Product2(Name = name, Family = family);
    return record;
  }

  public static Pricebook2 CreatePriceBook2(String name) {
    Pricebook2 record = new Pricebook2(Name = name);
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

  //JN1-4184
  public static FinServ__AssetsAndLiabilities__c CreateAssetsAndLiabilities(
    Id accountId,
    Id recordTypeId,
    String assetName
  ) {
    FinServ__AssetsAndLiabilities__c record = new FinServ__AssetsAndLiabilities__c();
    record.FinServ__PrimaryOwner__c = accountId;
    record.Name = assetName;
    record.FinServ__Amount__c = 500.00;
    record.RecordTypeId = recordTypeId;
    return record;
  }
  //JN1-4184
  public static Application_Asset_Liability__c CreateApplicantAssetsAndLiabilities(
    Id applicantId,
    Id assetAndLiabilitiesId
  ) {
    Application_Asset_Liability__c record = new Application_Asset_Liability__c();
    record.Application__c = applicantId;
    record.Assets_and_Liabilities__c = assetAndLiabilitiesId;
    return record;
  }
  //JN1-4184
  public static List<Supplementary_Card_Holders__c> CreateSupplementaryCardHolders(
    Integer count,
    Id oppId
  ) {
    List<Supplementary_Card_Holders__c> cardHoldersList = new List<Supplementary_Card_Holders__c>();
    for (Integer i = 0; i < count; i++) {
      Supplementary_Card_Holders__c cardHolder = new Supplementary_Card_Holders__c();
      cardHolder.Opportunity__c = oppId;
      cardHoldersList.add(cardHolder);
    }
    return cardHoldersList;
  }

  public static DocumentChecklistItem CreateDocumentCheckListItem(
    Id parentRecordId,
    Id docTypeId,
    String nameOfRecord,
    String statusOfRecord
  ) {
    DocumentChecklistItem docChkListItem = new DocumentChecklistItem();
    docChkListItem.ParentRecordId = parentRecordId;
    docChkListItem.DocumentTypeId = docTypeId;
    docChkListItem.Name = nameOfRecord;
    docChkListItem.Status = statusOfRecord;

    return docChkListItem;
  }
  public static ContentVersion CreateContentVersionRecord(
    String Title,
    String PathOnClient,
    String blobData,
    boolean IsMajorVersion
  ) {
    ContentVersion contentVersion = new ContentVersion();
    contentVersion.Title = Title;
    contentVersion.PathOnClient = PathOnClient;
    contentVersion.VersionData = Blob.valueOf(blobData);
    contentVersion.IsMajorVersion = IsMajorVersion;
    return contentVersion;
  }
  public static SlaProcess getEntitlementProcessNames(String processName) {
    SlaProcess process = [
      SELECT Id, name
      FROM Slaprocess
      WHERE IsActive = TRUE AND name = :processName AND IsVersionDefault = TRUE
    ];
    return process;
  }

  public static Entitlement createEntitlementRecords(
    String entName,
    String accId,
    Date dt,
    String SlaId
  ) {
    Entitlement entitlement = new Entitlement(
      Name = entName,
      AccountId = accId,
      StartDate = dt,
      SlaProcessId = SlaId
    );
    return entitlement;
  }

  /**
   * @description : create the list of error reporting event logs
   * @author Ishwari Gaikwad(Thinqloud) | 07-06-2021
   * @param recordId
   * @param eventType
   * @param body
   * @param count
   * @return List<OneJN_Event_Log__c>
   **/
  public static List<OneJN_Event_Log__c> createOneJNEventLog(
    String recordId,
    String eventType,
    String body,
    Integer count
  ) {
    List<OneJN_Event_Log__c> eventLogList = new List<OneJN_Event_Log__c>();
    for (Integer i = 0; i < count; i++) {
      OneJN_Event_Log__c eventlog = new OneJN_Event_Log__c();
      eventlog.Salesforce_Record_Id__c = recordId;
      eventlog.Name__c = eventType;
      eventlog.Event_Source__c = Constants.EXTERNAL;
      eventlog.Body__c = body;
      eventLogList.add(eventlog);
    }
    return eventLogList;
  }
}
