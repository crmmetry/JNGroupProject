@isTest
public class TestSkillsBasedRouting {
  @testSetup
  static void setup() {
    //Create a User
    User newUser = TestDataFactory.CreateUser('Travis@test.com');
    newUser.Sales_User__c = false;
    insert newUser;

    Skill test_skill = [SELECT Id FROM Skill WHERE MasterLabel = 'Barbican'];

    ServiceResource serv_res = TestDataFactory.CreateServiceResource(
      newUser.Id
    );
    insert serv_res;

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
      Test.startTest();

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
