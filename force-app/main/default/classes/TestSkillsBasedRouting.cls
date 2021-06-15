/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 06-15-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-21-2021   Travis Allen   Initial Version
 **/
@isTest
public class TestSkillsBasedRouting {
  public static DateTime todaysDate = DateTime.newInstance(
    2021,
    6,
    1,
    12,
    0,
    0
  );
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

    //Create service resource for each user
    List<ServiceResource> serviceResources = new List<ServiceResource>();

    ServiceResource travisSR = TestDataFactory.CreateServiceResource(
      travis.Id,
      'Travis'
    );
    serviceResources.add(travisSR);

    ServiceResource remarioSR = TestDataFactory.CreateServiceResource(
      remario.Id,
      'Remario'
    );
    serviceResources.add(remarioSR);

    ServiceResource abigailSR = TestDataFactory.CreateServiceResource(
      abigail.Id,
      'Abigail'
    );
    serviceResources.add(abigailSR);

    insert serviceResources;

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
  }

  //Scenario 1: Assign lead when only one service resource exists with appropriate active skills and a workload of 0 leads.
  @isTest
  public static void shouldRouteLeadScenario1() {
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();
    //User to run system
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      //Query Service Resource to be tested
      ServiceResource travisSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Travis'
        LIMIT 1
      ];

      //Skills to be added to each service resources
      Skill annottoBaySkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Annotto Bay'
      ];
      Skill autoLoanSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Auto Loan'
      ];

      //Service Resource Skills for each service resource
      ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        annottoBaySkill.Id
      );
      travisAnnottoBaySkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAnnottoBaySkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAnnottoBaySkill);

      ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        autoLoanSkill.Id
      );
      travisAutoLoanSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAutoLoanSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAutoLoanSkill);

      insert serviceResourceSkills;

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Annotto Bay';
      newLead[0].Service_of_Interest__c = 'JN Bank Auto Loan';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = todaysDate;
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead, todaysDate);
      test.stopTest();

      System.assertEquals(
        travisSR.RelatedRecordId,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId,
        'New lead should be assigned to Travis'
      );
    }

  }

  //Scenario 2: Assign lead when a service resource has the qulified skills but not effective.
  @isTest
  public static void shouldRouteLeadScenario2() {
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();
    //User to run system
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      //Query Service Resource to be tested
      ServiceResource travisSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Travis'
        LIMIT 1
      ];

      //Skills to be added to each service resources
      Skill annottoBaySkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Annotto Bay'
      ];
      Skill autoLoanSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Auto Loan'
      ];

      //Service Resource Skills for each service resource
      ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        annottoBaySkill.Id
      );
      travisAnnottoBaySkill.EffectiveStartDate = todaysDate.addDays(1);
      travisAnnottoBaySkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAnnottoBaySkill);

      ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        autoLoanSkill.Id
      );
      travisAutoLoanSkill.EffectiveStartDate = todaysDate.addDays(1);
      travisAutoLoanSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAutoLoanSkill);

      insert serviceResourceSkills;

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Annotto Bay';
      newLead[0].Service_of_Interest__c = 'JN Bank Auto Loan';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = todaysDate;
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead, todaysDate);
      test.stopTest();

      System.assertEquals(
        salesTeam.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId,
        'New lead should remain with Sales Team'
      );
    }

  }

  //Scenario 3: Assign lead with multiple service resource in System where only one has the appropriate skill
  @isTest
  public static void shouldRouteLeadScenario3() {
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();
    //User to run system
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      //Query Service Resource to be tested
      ServiceResource travisSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Travis'
        LIMIT 1
      ];
      ServiceResource remarioSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Remario'
        LIMIT 1
      ];

      //Skills to be added to each service resources
      Skill annottoBaySkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Annotto Bay'
      ];
      Skill autoLoanSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Auto Loan'
      ];
      Skill catherineHallSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Catherine Hall'
      ];
      Skill creditCardSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Credit Card'
      ];

      //Service Resource Skills for each service resource
      ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        annottoBaySkill.Id
      );
      travisAnnottoBaySkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAnnottoBaySkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAnnottoBaySkill);

      ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        autoLoanSkill.Id
      );
      travisAutoLoanSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAutoLoanSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAutoLoanSkill);

      ServiceResourceSkill remarioCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        creditCardSkill.Id
      );
      remarioCreditCardSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCreditCardSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCreditCardSkill);

      ServiceResourceSkill remarioCatherineHallSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        catherineHallSkill.Id
      );
      remarioCatherineHallSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCatherineHallSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCatherineHallSkill);

      insert serviceResourceSkills;

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Catherine Hall';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = todaysDate;
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead, todaysDate);
      test.stopTest();

      System.assertEquals(
        remarioSR.RelatedRecordId,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId,
        'New Lead should be assigned to user Remario'
      );
    }

  }

  //Scenario 4: Should assign lead where more than 1 service resources have the required skills and the same workload.
  @isTest
  public static void shouldRouteLeadScenario4() {
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();
    //User to run system
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      //Query Service Resource to be tested
      ServiceResource travisSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Travis'
        LIMIT 1
      ];
      ServiceResource remarioSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Remario'
        LIMIT 1
      ];

      //Skills to be added to each service resources
      Skill annottoBaySkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Annotto Bay'
      ];
      Skill autoLoanSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Auto Loan'
      ];
      Skill catherineHallSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Catherine Hall'
      ];
      Skill creditCardSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Credit Card'
      ];

      //Service Resource Skills for each service resource
      ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        annottoBaySkill.Id
      );
      travisAnnottoBaySkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAnnottoBaySkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAnnottoBaySkill);

      ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        autoLoanSkill.Id
      );
      travisAutoLoanSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAutoLoanSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAutoLoanSkill);

      ServiceResourceSkill travisCatherineHallSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        catherineHallSkill.Id
      );
      travisCatherineHallSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisCatherineHallSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisCatherineHallSkill);

      ServiceResourceSkill travisCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        creditCardSkill.Id
      );
      travisCreditCardSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisCreditCardSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisCreditCardSkill);

      ServiceResourceSkill remarioCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        creditCardSkill.Id
      );
      remarioCreditCardSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCreditCardSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCreditCardSkill);

      ServiceResourceSkill remarioCatherineHallSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        catherineHallSkill.Id
      );
      remarioCatherineHallSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCatherineHallSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCatherineHallSkill);

      insert serviceResourceSkills;

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Catherine Hall';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = todaysDate;
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead, todaysDate);
      test.stopTest();

      System.assertNotEquals(
        salesTeam.Id,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId,
        'New Lead should be assigned to one of the users with the appropriate skills'
      );
    }

  }

  //Scenario 5: Should assign lead where more than 1 service resources have the required skills and varying workload. Lead should be assigned to the service resource with the lower workload.
  @isTest
  public static void shouldRouteLeadScenario5() {
    List<ServiceResourceSkill> serviceResourceSkills = new List<ServiceResourceSkill>();
    //User to run system
    User travis = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    System.runAs(travis) {
      Group salesTeam = [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue' AND Name = 'Sales Team'
      ];

      //Query Service Resource to be tested
      ServiceResource travisSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Travis'
        LIMIT 1
      ];
      ServiceResource remarioSR = [
        SELECT Id, Name, RelatedRecordId
        FROM ServiceResource
        WHERE Name = 'Remario'
        LIMIT 1
      ];

      //Skills to be added to each service resources
      Skill annottoBaySkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Annotto Bay'
      ];
      Skill autoLoanSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Auto Loan'
      ];
      Skill catherineHallSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'Catherine Hall'
      ];
      Skill creditCardSkill = [
        SELECT Id
        FROM Skill
        WHERE MasterLabel = 'JN Bank Credit Card'
      ];

      //Service Resource Skills for each service resource
      ServiceResourceSkill travisAnnottoBaySkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        annottoBaySkill.Id
      );
      travisAnnottoBaySkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAnnottoBaySkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAnnottoBaySkill);

      ServiceResourceSkill travisAutoLoanSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        autoLoanSkill.Id
      );
      travisAutoLoanSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisAutoLoanSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisAutoLoanSkill);

      ServiceResourceSkill travisCatherineHallSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        catherineHallSkill.Id
      );
      travisCatherineHallSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisCatherineHallSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisCatherineHallSkill);

      ServiceResourceSkill travisCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
        travisSR.Id,
        creditCardSkill.Id
      );
      travisCreditCardSkill.EffectiveStartDate = todaysDate.addDays(-1);
      travisCreditCardSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(travisCreditCardSkill);

      ServiceResourceSkill remarioCreditCardSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        creditCardSkill.Id
      );
      remarioCreditCardSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCreditCardSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCreditCardSkill);

      ServiceResourceSkill remarioCatherineHallSkill = TestDataFactory.CreateServiceResourceSkill(
        remarioSR.Id,
        catherineHallSkill.Id
      );
      remarioCatherineHallSkill.EffectiveStartDate = todaysDate.addDays(-1);
      remarioCatherineHallSkill.EffectiveEndDate = todaysDate.addDays(5);
      serviceResourceSkills.add(remarioCatherineHallSkill);

      insert serviceResourceSkills;

      //Currently owned leads for Travis workload = 1
      List<Lead> travisLead = TestDataFactory.CreateLeads(1);
      travisLead[0].Escalate_to_Tier2__c = true;
      travisLead[0].OwnerId = travis.Id;
      travisLead[0].Preferred_Location__c = 'Catherine Hall';
      travisLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      travisLead[0].Last_Contact_Made__c = todaysDate.addDays(-3);
      insert travisLead[0];

      List<Lead> newLead = TestDataFactory.CreateLeads(1);
      newlead[0].LastName = 'Travis';
      newLead[0].Preferred_Location__c = 'Catherine Hall';
      newLead[0].Service_of_Interest__c = 'JN Bank Credit Card';
      newLead[0].Escalate_to_Tier2__c = false;
      newLead[0].Last_Contact_Made__c = todaysDate;
      newLead[0].OwnerId = salesTeam.Id;
      newLead[0].Company = 'Annotto Bay Company';
      insert newLead;

      newLead[0].Escalate_to_Tier2__c = true;

      test.startTest();
      SkillsBasedRouting.StartRoutingUsingTier2(newLead, todaysDate);
      test.stopTest();

      System.assertEquals(
        remarioSR.RelatedRecordId,
        [SELECT Id, OwnerId, Company FROM Lead WHERE LastName = 'Travis']
        .OwnerId,
        'New lead should be assigned to Remario since he has lower workload'
      );
    }

  }
}
