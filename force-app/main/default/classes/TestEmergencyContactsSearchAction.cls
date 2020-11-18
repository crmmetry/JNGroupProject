@isTest
public class TestEmergencyContactsSearchAction {
  @isTest
  public static void shouldSaveRecords() {
    Integer amount = 3;

    List<Account> accs = TestDataFactory.CreateBasicAccounts(amount, 'Bonn');

    for (Account acc : accs) {
      acc.Mobile_Number__pc = '18767547845';
      //acc.Mobile ='1235453546';
    }
    insert accs;

    List<EmergencyContactsSearchAction.FlowInputParameters> flowInput = new List<EmergencyContactsSearchAction.FlowInputParameters>();
    EmergencyContactsSearchAction.FlowInputParameters input = new EmergencyContactsSearchAction.FlowInputParameters();

    input.lastName = accs[0].LastName;
    input.firstName = accs[0].FirstName;
    input.mobile = accs[0].Mobile_Number__pc;

    flowInput.add(input);

    EmergencyContactsSearchAction.SaveRecords(flowInput);
  }
}
