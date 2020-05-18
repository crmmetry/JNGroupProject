@isTest
public class TestEmergencyContactsMockupAction {
    
    @isTest
    public static void shouldMockBlankRecords(){
        
        Integer amount = 3;
        
        List <EmergencyContactsMockupAction.FlowInputParameters> flowInput = new List<EmergencyContactsMockupAction.FlowInputParameters>();
        EmergencyContactsMockupAction.FlowInputParameters input = new EmergencyContactsMockupAction.FlowInputParameters();
        
        input.amount = amount;
        
        flowInput.add(input);
        
        EmergencyContactsMockupAction.MockBlankRecords(flowInput);
        
    }

}