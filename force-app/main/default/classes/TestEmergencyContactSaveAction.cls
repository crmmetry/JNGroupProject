@isTest
public class TestEmergencyContactSaveAction {
  @isTest
  public static void shouldSaveContacts() {
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

    List<Account> accs = TestDataFactory.CreateBasicAccounts(3, 'Belle');
    insert accs;

    List<EmergencyContactSaveAction.FlowInputParameters> flow = new List<EmergencyContactSaveAction.FlowInputParameters>();
    EmergencyContactSaveAction.FlowInputParameters input = new EmergencyContactSaveAction.FlowInputParameters();

    ids.add(accs[1].Id);
    ids.add(accs[2].Id);

    input.accountId = accs[0].Id;
    input.accountIds = ids;
    input.accountsToSave = accs;
    flow.add(input);

    EmergencyContactSaveAction.SaveContacts(flow);
  }
}
