public class EmergencyContactsMockupAction {
    private static final String TAG = 'EmergencyContactsMockupAction';
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        
        @InvocableVariable(label='Amount' required = true)
        public Integer amount;        
    }
    /* Output parameters of the Apex action */
    public class FlowOutputParameters {
        
        public FlowOutputParameters(){
            records = new List<Account>();
            recordsToSave = new List<Account>();
        }
        
        @InvocableVariable(label='Record Collection')
        public List<Account> records;
        
        @InvocableVariable(label='Records To  Save')
        public List<Account> recordsToSave;
    }
    @InvocableMethod(label = 'Amount to add')
    public static FlowOutputParameters[] MockBlankRecords(FlowInputParameters[] inputs){
        FlowInputParameters instance = inputs.get(0);
        FlowOutputParameters[] outputs = new FlowOutputParameters[]{};
        FlowOutputParameters output = new FlowOutputParameters();
        List<Account> accounts = new List<Account>();
        if(instance != null){
            Integer amount = instance.amount;
            for(Integer i = 0; i < amount; i++){
                Account acc = new Account(FirstName=String.valueOf(System.today()),LastName=String.valueOf(System.today()));
            	accounts.add(acc);
            }
            output.records = accounts;
            output.recordsToSave = new List<Account>();
        }
        outputs.add(output);
        return outputs;
    }
}