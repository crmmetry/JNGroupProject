@isTest
public class TestDataFactory {
    // test variables
    public static final String PHONE = '(876) 754-7845';
    public static List<Contact> CreateBasicContacts(Integer count, String lastName){
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < count; i++){
            Contact c = new Contact(FirstName = 'Test ' + i +1, LastName = lastName);
            contacts.add(c);
        }
        return contacts;
    }
    public static Sobject CreateMappedRecord(Map<String,Object> info, String typeOfObject){
        Sobject c = getNewSobject(typeOfObject);
        for(String key: info.keySet()){          
            c.put(key, info.get(key));
        }
        return c;
    }
    public static List<Account> CreateBasicAccounts(Integer count, String lastName){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < count; i++){
            Account c = new Account(FirstName = 'Test ' + i, LastName = lastName);
            accounts.add(c);
        }
        return accounts;
    }
    
    public static List<Opportunity> CreateOpportunities(Integer count){
        List<Opportunity> records = new List<Opportunity>();
        for(Integer i = 0; i < count; i++){
            Opportunity c = new Opportunity();
            records.add(c);
        }
        return records;
    }
    public static void CreateLeads(){
        
    }
    public static void CreateApplicants(){
        
    }
    public static void CreateEmployments(){
        
    }
    public static void CreateSupplementaryCardHolders(){
        
    }
    public static void CreateRoles(){
        
    }
    public static SObject getNewSobject(String typeOfObject) {
        
        /* Call global describe to get the map of string to token. */
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        
        /* Get the token for the sobject based on the type. */
        Schema.SObjectType st = gd.get(typeOfObject);
        System.assert(st != null,'Type provided: "' + typeOfObject + '" doesnt map to an sobject token in this org.');
        
        /* Instantiate the sobject from the token. */
        return st.newSobject();
    }
    
}