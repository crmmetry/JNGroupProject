@isTest
public class TestContactContactTrigger {
  @TestSetup
  static void shouldContacts() {
    List<Id> ids = new List<String>();

    List<FinServ__ReciprocalRole__c> roles = new List<FinServ__ReciprocalRole__c>();
    List<String> roleNames = new List<String>{
      'Emergency Contact',
      'Political Affiliation',
      'JN Affiliation'
    };
    for (String roleName : roleNames) {
      roles.add(TestDataFactory.CreateRole(roleName));
    }
    insert roles;
  }

  @isTest
  public static void shouldInsertContact() {
    Account account = TestDataFactory.CreateBasicAccounts(1, 'Jenkins')[0];
    insert account;

    Contact contact = TestDataFactory.CreateBasicContacts(1, 'Bravo')[0];
    insert contact;

    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'ContactRole'
    );

    Id role1 = mappedRoles.get('Emergency Contact').Id;
    Id role2 = mappedRoles.get('Political Affiliation').Id;
    Id role3 = mappedRoles.get('JN Affiliation').Id;

    List<FinServ__ContactContactRelation__c> contactRecord = new List<FinServ__ContactContactRelation__c>();
    contactRecord.add(
      Util.createContactToContactRelationship(
        account.PersonContactId,
        contact.Id,
        role1
      )
    );
    insert contactRecord;

    System.assert(contactRecord != null, 'No contact relationship added.');
  }

  @isTest
  public static void shouldDeleteContact() {
    Account account = TestDataFactory.CreateBasicAccounts(1, 'Ruby')[0];
    insert account;

    Contact contact = TestDataFactory.CreateBasicContacts(1, 'Rails')[0];
    insert contact;

    Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(
      'ContactRole'
    );

    Id role1 = mappedRoles.get('Emergency Contact').Id;
    Id role2 = mappedRoles.get('Political Affiliation').Id;
    Id role3 = mappedRoles.get('JN Affiliation').Id;

    List<FinServ__ContactContactRelation__c> contactRecord = new List<FinServ__ContactContactRelation__c>();
    contactRecord.add(
      Util.createContactToContactRelationship(
        account.PersonContactId,
        contact.Id,
        role1
      )
    );
    insert contactRecord;

    System.assert(contactRecord != null, 'No contact relationship added.');

    delete contactRecord[0];

    /*Id conId = contacts[1].Id;
        
        FinServ__ContactContactRelation__c delContact = [SELECT Id FROM FinServ__ContactContactRelation__c WHERE Id =: conId];
        System.assert(delContact!=null, 'No contact to delete');
		System.debug('Contact Id to delete = ' + delContact );*/
  }
}
