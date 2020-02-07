public class EmergencyContactsSearchAction {
    private static final String TAG = 'EmergencyContactsAction';
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        
        @InvocableVariable(label='Last Name' required = true)
        public string lastName;
        
        @InvocableVariable(label='First Name' required = true)
        public string firstName;
        
        @InvocableVariable(label='Mobile Phone' required = true)
        public String mobile;
        
    }
    /* Output parameters of the Apex action */
    public class FlowOutputParameters{
        
        public FlowOutputParameters(){
            records = new List<Account>();
                names = new List<String>();
            	ids = new List<String>();
             }
        
        @InvocableVariable(label='Record Collection')
        public Account[] records;
        
        @InvocableVariable(label='Names')
        public String[] names;
        
        @InvocableVariable(label='Account Ids')
        public String[] ids;
        
        @InvocableVariable(label='Contact Ids')
        public String[] contactIds;
        
        @InvocableVariable(label='Record Size')
        public Integer size;
    }
    
    @InvocableMethod(label='Search Emergency Contacts')
    public static FlowOutputParameters[] SaveRecords(FlowInputParameters[] inputs){
        FlowOutputParameters[] outputs = new FlowOutputParameters[]{};
        FlowInputParameters instance = inputs.get(0);
        
        FlowOutputParameters output = new FlowOutputParameters();
        List<String> names = new List<String>();
        List<String> ids = new List<String>();
        List<String> contactIds = new List<String>();
        List<Account> accounts = new List<Account>();
        String phone;
        if(instance != null){
            for (Account record: [SELECT Id, PersonContactId, FirstName, LastName,Mobile_Number__pc FROM Account 
                                      WHERE (FirstName =:instance.firstName 
                                             AND   LastName =:instance.lastName)
                                  OR   (FirstName =:instance.firstName 
                                             AND   LastName =:instance.lastName AND Mobile_Number__pc =:instance.mobile)
                                  OR  Mobile_Number__pc =:instance.mobile
                                   order by FirstName,LastName]){
                                      if(record.Mobile_Number__pc != null) {
                                          phone = record.Mobile_Number__pc;
                                      } else {
                                          phone = 'None';
                                      }
                      names.add(record.FirstName + ' ' + record.LastName + ' - ' +  phone);
                      ids.add(record.Id);
                      accounts.add(record);
                      contactIds.add(record.PersonContactId);
            }
            output.names = names;
            output.ids = ids;
            output.records = accounts;
            output.contactIds = contactIds;
            output.size = accounts.size();
            outputs.add(output);
        }
        return outputs;
    }
}