/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-11-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-21-2021   Travis Allen   Initial Version
 **/
@isTest
public class TestSkillsBasedRouting {
  @testSetup
  static void setup() {
    //Create a 3 Users
    List<User> newUsers = new List<User>();

    User travis = TestDataFactory.CreateUser('Travis@test.com');
    travis.Sales_User__c = false;
    newUsers.add(travis);

    User remario = TestDataFactory.CreateUser('Remario@test.com');
    remario.Sales_User__c = false;
    newUsers.add(remario);

    User abigail = TestDataFactory.CreateUser('Abigail@test.com');
    abigail.Sales_User__c = false;
    newUsers.add(abigail);

    insert newUsers;

    Skill annottoBaySkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'Annotto Bay'
    ];

    Skill newKingstonSkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'New Kingston'
    ];

    Skill barbicanSkill = [SELECT Id FROM Skill WHERE MasterLabel = 'Barbican'];

    Skill catherineHallSkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'Catherine Hall'
    ];

    Skill autoLoanSkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'JN Bank Auto Loan'
    ];

    Skill creditCardSkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'JN Bank Credit Card'
    ];

    Skill lineOfCreditSkill = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel = 'JN Bank Line Of Credit'
    ];

    //Create service resource for each user
    List<ServiceResource> serviceResources = new List<ServiceResource>();

    ServiceResource travisSR = TestDataFactory.CreateServiceResource(travis.Id);
    serviceResources.add(travisSR);

    ServiceResource remarioSR = TestDataFactory.CreateServiceResource(
      remario.Id
    );
    serviceResources.add(remarioSR);

    ServiceResource abigailSR = TestDataFactory.CreateServiceResource(
      abigail.Id
    );
    serviceResources.add(abigailSR);

    insert serviceResources;

    //List ofer service resource skills
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();

    //Service Resource Skills for Travis [Location(1): Annotto bay, Product(1): JN Bank Auto Loan ]
    ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
      travisSR.Id,
      annottoBaySkill.Id
    );
    travisAnnottoBaySkill.EffectiveStartDate = System.now().addDays(-1);
    travisAnnottoBaySkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(travisAnnottoBaySkill);

    ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
      travisSR.Id,
      autoLoanSkill.Id
    );
    travisAutoLoanSkill.EffectiveStartDate = System.now().addDays(-1);
    travisAutoLoanSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(travisAutoLoanSkill);

    //Skill which effective start date has not come as yet
    ServiceResourceSkill travisCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
      travisSR.Id,
      creditCardSkill.Id
    );
    travisCreditCardSkill.EffectiveStartDate = System.now().addDays(1);
    travisCreditCardSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(travisCreditCardSkill);

    //Skill which effective start date has not come as yet
    ServiceResourceSkill travisNewKingstonSkill = TestDataFactory.CreateServiceResourceSkill(
      travisSR.ID,
      newKingstonSkill.Id
    );
    travisNewKingstonSkill.EffectiveStartDate = System.now().addDays(1);
    travisNewKingstonSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(travisNewKingstonSkill);

    //Service Resource Skills for Remario [Location(2): Barbican, Catherine Hall Product(1): JN Bank Credit Card ]
    ServiceResourceSkill remarioBarbicanSkill = TestDataFactory.CreateServiceResourceSkill(
      remarioSR.Id,
      barbicanSkill.Id
    );
    remarioBarbicanSkill.EffectiveStartDate = System.now().addDays(-1);
    remarioBarbicanSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(remarioBarbicanSkill);

    ServiceResourceSkill remarioCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
      remarioSR.Id,
      creditCardSkill.Id
    );
    remarioCreditCardSkill.EffectiveStartDate = System.now().addDays(-1);
    remarioCreditCardSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(remarioCreditCardSkill);

    ServiceResourceSkill remarioCatherinehallSkill = TestDataFactory.CreateServiceResourceSkill(
      remarioSR.Id,
      catherineHallSkill.Id
    );
    serviceResourceSkills.add(remarioCatherinehallSkill);

    //Service Resource Skills for Abigail [Location(1): AnnottoBay Product(2): JN Bank Credit Card, JN Bank Line Of Credit ]
    ServiceResourceSkill abigailAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      annottoBaySkill.Id
    );
    abigailAnnottoBaySkill.EffectiveStartDate = System.now().addDays(-1);
    abigailAnnottoBaySkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(abigailAnnottoBaySkill);

    ServiceResourceSkill abigailBarbicanSkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      barbicanSkill.Id
    );
    abigailBarbicanSkill.EffectiveStartDate = System.now().addDays(-1);
    abigailBarbicanSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(abigailBarbicanSkill);

    ServiceResourceSkill abigailCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      creditCardSkill.Id
    );
    abigailCreditCardSkill.EffectiveStartDate = System.now().addDays(-1);
    abigailCreditCardSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(abigailCreditCardSkill);

    ServiceResourceSkill abigailLOCSkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      lineOfCreditSkill.Id
    );
    abigailLOCSkill.EffectiveStartDate = System.now().addDays(-1);
    abigailLOCSkill.EffectiveEndDate = System.now().addDays(5);
    serviceResourceSkills.add(abigailLOCSkill);

    insert serviceResourceSkills;

    //Add Users to Sales Team

    System.runAs(travis) {
      //Query Saels team queue
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<GroupMember> salesTeamMembers = new List<GroupMember>();

      //add users to salest team queue
      GroupMember salesTeamTravis = new GroupMember();
      salesTeamTravis.UserOrGroupId = travis.Id;
      salesTeamTravis.GroupId = salesTeam.Id;
      salesTeamMembers.add(salesTeamTravis);

      GroupMember salesTeamRemario = new GroupMember();
      salesTeamRemario.UserOrGroupId = remario.Id;
      salesTeamRemario.GroupId = salesTeam.Id;
      salesTeamMembers.add(salesTeamRemario);

      GroupMember salesTeamAbigail = new GroupMember();
      salesTeamAbigail.UserOrGroupId = abigail.Id;
      salesTeamAbigail.GroupId = salesTeam.Id;
      salesTeamMembers.add(salesTeamAbigail);

      insert salesTeamMembers;
    }

    //Create Leads for each sales team member lead
    List<Lead> leadsToBeInserted = new List<Lead>();

    List<Lead> travisLead = TestDataFactory.CreateLeads(1);
    travisLead[0].Escalate_to_Tier2__c = true;
    travisLead[0].OwnerId = travis.Id;
    travisLead[0].Preferred_Location__c = 'Annotto Bay';
    travisLead[0].Service_of_Interest__c = 'JN Bank Auto Loan';
    travisLead[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(travisLead[0]);

    List<Lead> remarioLead1 = TestDataFactory.CreateLeads(1);
    remarioLead1[0].Escalate_to_Tier2__c = true;
    remarioLead1[0].OwnerId = remario.Id;
    remarioLead1[0].Preferred_Location__c = 'Catherine Hall';
    remarioLead1[0].Service_of_Interest__c = 'JN Bank Credit Card';
    remarioLead1[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(remarioLead1[0]);

    List<Lead> remarioLead2 = TestDataFactory.CreateLeads(1);
    remarioLead2[0].Escalate_to_Tier2__c = true;
    remarioLead2[0].OwnerId = remario.Id;
    remarioLead2[0].Preferred_Location__c = 'Barbican';
    remarioLead2[0].Service_of_Interest__c = 'JN Bank Credit Card';
    remarioLead2[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(remarioLead2[0]);

    List<Lead> abigailLead1 = TestDataFactory.CreateLeads(1);
    abigailLead1[0].Escalate_to_Tier2__c = true;
    abigailLead1[0].OwnerId = abigail.Id;
    abigailLead1[0].Preferred_Location__c = 'Barbican';
    abigailLead1[0].Service_of_Interest__c = 'JN Bank Credit Card';
    abigailLead1[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(abigailLead1[0]);

    List<Lead> abigailLead2 = TestDataFactory.CreateLeads(1);
    abigailLead2[0].Escalate_to_Tier2__c = true;
    abigailLead2[0].OwnerId = abigail.Id;
    abigailLead2[0].Preferred_Location__c = 'Barbican';
    abigailLead2[0].Service_of_Interest__c = 'JN Bank Line Of Credit';
    abigailLead2[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(abigailLead2[0]);

    List<Lead> abigailLead3 = TestDataFactory.CreateLeads(1);
    abigailLead3[0].Escalate_to_Tier2__c = true;
    abigailLead3[0].OwnerId = abigail.Id;
    abigailLead3[0].Preferred_Location__c = 'Annotto Bay';
    abigailLead3[0].Service_of_Interest__c = 'JN Bank Line Of Credit';
    abigailLead3[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(abigailLead3[0]);

    insert leadsToBeInserted;
  }
  //Scenario: Assign lead with Preffered Loaction - Annotto Bay and Product - JN Bank AutoLoan Result: Assigned owner should be Travis
  @isTest
  public static void shouldrouteUsingSkillsTier2Scenario1() {
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Annotto Bay';
      newLead[0].Service_of_Interest__c = 'JN Bank Auto Loan';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead);
      test.stopTest();

      System.assertEquals(
        travis.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId
      );
    }

  }

  //Scenario2: Assign lead with Preffered Loaction - Barbican and Product - JN Bank Credit Card Result: Assigned owner should be Remario
  @isTest
  public static void shouldrouteUsingSkillsTier2Scenario2() {
    User remario = [SELECT Id FROM User WHERE UserName = 'Remario@test.com'];
    System.runAs(remario) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Remario';
      newLead[0].Preferred_Location__c = 'Barbican';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Brbican Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead);
      test.stopTest();

      System.assertEquals(
        remario.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Remario']
        .OwnerId
      );
    }
  }

  //Scenario3: Assign lead with Preffered Loaction - Barbican and Product - JN Bank Line Of Credit Result: Assigned owner should be Remario
  @isTest
  public static void shouldrouteUsingSkillsTier2Scenario3() {
    User abigail = [SELECT Id FROM User WHERE UserName = 'Abigail@test.com'];
    System.runAs(abigail) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Abigail';
      newLead[0].Preferred_Location__c = 'Barbican';
      newLead[0].Service_of_Interest__c = 'JN Bank Line Of Credit';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Barbican Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead);
      test.stopTest();

      System.assertEquals(
        abigail.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Abigail']
        .OwnerId
      );
    }
  }

  //Scenario4: Assign lead with Preffered Loaction - Falmouth and Product - JN Bank Credit Card Result: Assigned owner should be Sales Team (Negative Test Case)
  @isTest
  public static void shouldrouteUsingSkillsTier2Scenario4() {
    User abigail = [SELECT Id FROM User WHERE UserName = 'Abigail@test.com'];
    System.runAs(abigail) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Sales';
      newLead[0].Preferred_Location__c = 'Falmouth';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Barbican Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead);
      test.stopTest();

      System.assertEquals(
        salesTeam.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Sales']
        .OwnerId
      );
    }
  }

  @isTest
  public static void shouldNotRouteSkillWhenSkillHasEnded() {
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'New Kingston';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'New Kingston Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead);
      test.stopTest();

      System.assertEquals(
        salesTeam.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId
      );
    }
  }
}
