/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-22-2021
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
    serviceResourceSkills.add(travisAnnottoBaySkill);

    ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
      travisSR.Id,
      autoLoanSkill.Id
    );
    serviceResourceSkills.add(travisAutoLoanSkill);

    //Service Resource Skills for Remario [Location(2): Barbican, Catherine Hall Product(1): JN Bank Credit Card ]
    ServiceResourceSkill remarioBarbicanSkill = TestDataFactory.CreateServiceResourceSkill(
      remarioSR.Id,
      barbicanSkill.Id
    );
    serviceResourceSkills.add(remarioBarbicanSkill);

    ServiceResourceSkill remarioCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
      remarioSR.Id,
      creditCardSkill.Id
    );
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
    serviceResourceSkills.add(abigailAnnottoBaySkill);

    ServiceResourceSkill abigailCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      creditCardSkill.Id
    );
    serviceResourceSkills.add(abigailCreditCardSkill);

    ServiceResourceSkill abigailLOCSkill = TestDataFactory.CreateServiceResourceSkill(
      abigailSR.Id,
      lineOfCreditSkill.Id
    );
    serviceResourceSkills.add(abigailLOCSkill);

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
    abigailLead1[0].OwnerId = remario.Id;
    abigailLead1[0].Preferred_Location__c = 'Annotto Bay';
    abigailLead1[0].Service_of_Interest__c = 'JN Bank Credit Card';
    abigailLead1[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(abigailLead1[0]);

    List<Lead> abigailLead2 = TestDataFactory.CreateLeads(1);
    abigailLead1[0].Escalate_to_Tier2__c = true;
    abigailLead1[0].OwnerId = remario.Id;
    abigailLead1[0].Preferred_Location__c = 'Annotto Bay';
    abigailLead1[0].Service_of_Interest__c = 'JN Bank Line Of Credit';
    abigailLead1[0].Last_Contact_Made__c = System.now();
    leadsToBeInserted.add(abigailLead1[0]);

    insert leadsToBeInserted;
  }
  //Scenario: Assign lead with Preffered Loaction - Annotto Bay and Product - JN Bank AutoLoan Result: Assigned owner should be Travis
  @isTest
  public static void shouldrouteUsingSkillsTier2Scenario1() {
    test.startTest();
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newLead[0].Preferred_Location__c = 'Anotto Bay';
      newLead[0].Service_of_Interest__c = 'JN Bank AutoLoan';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = System.now();
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead[0];

      newLead[0].Escalate_to_Tier2__c = true;
      update newLead;

      System.assertEquals(
        travis.Id,
        [
          SELECT Id, OwnerId, Company
          FROM Lead
          WHERE Company = :newLead[0].Company
        ]
        .OwnerId
      );
    }
    test.stopTest();
  }
}
