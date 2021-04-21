/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-21-2021
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

    User newUser1 = TestDataFactory.CreateUser('Travis2@test.com');
    newUser1.Sales_User__c = false;
    newUsers.add(newUser1);

    User newUser2 = TestDataFactory.CreateUser('Travis2@test.com');
    newUser2.Sales_User__c = false;
    newUsers.add(newUser2);

    User newUser3 = TestDataFactory.CreateUser('Travis3@test.com');
    newUser3.Sales_User__c = false;
    newUsers.add(newUser3);

    insert newUsers;

    //List of Skill names to query
    List<String> skillNamesOfProducts = new List<String>{
      'Annotto Bay',
      'Barbican',
      'Catherine Hall'
    };
    List<String> skillNamesOfLocations = new List<String>{
      '	JN Bank Auto Loan',
      'JN Bank Credit Card',
      'JN Bank Line Of Credit'
    };

    Skill test_location_skills = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel IN :skillNamesOfLocations
    ];

    Skill test_product_skills = [
      SELECT Id
      FROM Skill
      WHERE MasterLabel IN :skillNamesOfProducts
    ];

    //Create service resource for each user
    List<ServiceResource> serviceResources = new List<ServiceResource>();

    ServiceResource serv_res1 = TestDataFactory.CreateServiceResource(
      newUser1.Id
    );
    serviceResources.add(serv_res1);

    ServiceResource serv_res2 = TestDataFactory.CreateServiceResource(
      newUser1.Id
    );
    serviceResources.add(serv_res2);

    ServiceResource serv_res3 = TestDataFactory.CreateServiceResource(
      newUser1.Id
    );
    serviceResources.add(serv_res3);

    ServiceResourceSkill serv_res_skill = TestDataFactory.CreateServiceResourceSkill(
      serv_res.Id,
      test_skill.Id
    );
    insert serv_res_skill;
  }

  @isTest
  public static void shouldrouteUsingSkillsTier2() {
    Integer count = 3;
    User newUser = [SELECT Id FROM User WHERE UserName = 'Travis@test.com'];
    User newUser2 = TestDataFactory.CreateUser('Travis2@test.com');
    insert newUser2;
    //Group salesDevTeam = [SELECT Id FROM Group WHERE Type='Queue' AND Name='Sales Development Team'];
    Group salesTeam = [
      SELECT Id
      FROM Group
      WHERE Type = 'Queue' AND Name = 'Sales Team'
    ];

    System.runAs(newUser) {
      //Create Group members for group
      GroupMember sales_team_member = new GroupMember();
      sales_team_member.UserOrGroupId = newUser.Id;
      sales_team_member.GroupId = salesTeam.Id;
      insert sales_team_member;

      List<Lead> leadRecord = TestDataFactory.CreateLeads(count);
      insert leadRecord;

      for (Integer i = 0; i < count; i++) {
        //leadRecord[0].Preferred_Location__c = 'Barbican';
        leadRecord[i].Broker_Name__c = 'Travis';
        leadRecord[i].Escalate_to_Tier2__c = true;
        leadRecord[i].Last_Contact_Made__c = System.now();
        leadRecord[i].OwnerId = salesTeam.Id;
      }
      Test.startTest();
      leadRecord[0].Preferred_Location__c = 'Barbican';
      leadRecord[1].Preferred_Location__c = 'Junction';
      leadRecord[2].Preferred_Location__c = 'Gayle';
      update leadRecord;

      leadRecord[0].OwnerId = newUser.Id;
      leadRecord[1].OwnerId = newUser2.Id;
      leadRecord[2].OwnerId = newUser.Id;
      update leadRecord;
    }

    Test.stopTest();
  }
}
