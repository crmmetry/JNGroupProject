/**
* @Description        : Handler for trigger
* @Author             : Remario Richards
* @Last Modified By   : Remario Richards
* @Created On		  : 10/7/2019
* @Last Modified On   : 10/7/2019
*/
public class LeadTriggerHandler {
    private static final String TAG = 'LeadTriggerHandler';
    private static List<Lead> leads;
    private static Map<Id, Lead> oldMap;
    private static Map<Id, Lead> newMap;
    public static void init(List<Lead> leads, Map<Id, Lead> oldMap, Map<Id, Lead> newMap){
        LeadTriggerHandler.leads = leads;
        LeadTriggerHandler.oldMap = oldMap;
        LeadTriggerHandler.newMap = newMap;
    }
    
    public static void crmm_TimeSpentInStage(){
        for(Lead ObjLead : leads){
            Lead leadObjOld = oldMap.get(ObjLead.Id);
            
            // ((endDate.getTime())/1000/60) - ((sameDayEndDate.getTime())/1000/60);
            // String getStat = leadObjOld.status;
            System.debug('My Old status '+leadObjOld.status);
            switch on leadObjOld.status {
                
                when 'Open'{ 
                    if(ObjLead.Time_in_Open__c>0){
                        ObjLead.Time_in_Open__c = ObjLead.Time_in_Open__c+ ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Open__c =  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                when 'Working'{
                    if(ObjLead.Time_in_Working__c>0){
                        ObjLead.Time_in_Working__c =  ObjLead.Time_in_Working__c+ ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Working__c =   ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                when 'Contact Made'{
                    if( ObjLead.Time_in_Contact_Made__c>0){
                        ObjLead.Time_in_Contact_Made__c =   ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Contact_Made__c =   ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                
                when 'Determine Customers needs goals'{
                    if( ObjLead.Time_in_Determine_Customer_Need_Goals__c >0){
                        ObjLead.Time_in_Determine_Customer_Need_Goals__c =  ObjLead.Time_in_Determine_Customer_Need_Goals__c + ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Determine_Customer_Need_Goals__c = ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                when 'Collect Customers Information'{ 
                    if(ObjLead.Time_in_Collect_Customers_Information__c>0){
                        ObjLead.Time_in_Collect_Customers_Information__c = ObjLead.Time_in_Collect_Customers_Information__c+ ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Collect_Customers_Information__c = ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                when 'Run Loan Scenarios'{
                    if(ObjLead.Time_in_Run_Loan_Scenario__c>0){
                        ObjLead.Time_in_Run_Loan_Scenario__c = ObjLead.Time_in_Run_Loan_Scenario__c + ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Run_Loan_Scenario__c = ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                when 'Disqualified'{
                    if( ObjLead.Time_in_Disqualified__c>0){
                        ObjLead.Time_in_Disqualified__c =   ObjLead.Time_in_Disqualified__c+ ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Disqualified__c =  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                }
                When 'Qualified'{
                    if(ObjLead.Time_in_Qualified__c>0){
                        ObjLead.Time_in_Qualified__c = ObjLead.Time_in_Qualified__c+  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Qualified__c =  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                } 
                When 'Unqualified'{
                    if( ObjLead.Time_in_Qualified__c>0){
                        ObjLead.Time_in_Qualified__c =  ObjLead.Time_in_Qualified__c+ ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Qualified__c =  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                } 
                When 'Nurturing'{
                    if(ObjLead.Time_in_Nurturing__c>0){
                        ObjLead.Time_in_Nurturing__c = ObjLead.Time_in_Nurturing__c+  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }else{
                        ObjLead.Time_in_Nurturing__c =  ((((System.now().getTime())/1000/60)- (( leadObjOld.LastModifiedDate.getTime())/1000/60)));
                    }
                } 
                
            } 
        }
    }
    public static void crmm_TierTwoTrigger(){
        for(Lead leadObj : leads){
            Lead leadObjOld = oldMap.get(leadObj.Id);
            QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from QueueSObject 
                                    WHERE Queue.Type ='Queue' AND Queue.Name ='Sales Team' Limit 1];
            if( leadObj.Escalate_to_Tier2__c==true && leadObjOld.Escalate_to_Tier2__c==false ){
                leadObj.Escalated_By__c = UserInfo.getUserId();
                leadObj.OwnerId= QueueID.Queue.Id; 
            } 
        } 
    }
    public static void crmm_TierOne(){
        for(Lead leadObj : leads){
            QueueSObject QueueID = [Select Queue.Id, Queue.Name, Queue.Type from 
                                    QueueSObject WHERE Queue.Type ='Queue' 
                                    AND Queue.Name ='Sales Development Team' Limit 1];
            User usrID = [Select Id,Sales_User__c from User where Id=:leadObj.OwnerId];
            if( usrID.Sales_User__c==False){
                leadObj.OwnerId= QueueID.Queue.Id; 
            }
        }
    }
    public static void crmm_lead_trigger_conversion(){
        Boolean IsConverted = false;
        Account AccountList = new Account();
        for(lead objLead : leads){
            Boolean OldConvertedState = oldMap.get(objlead.Id).IsConverted;
            
            if(OldConvertedState==false && objlead.IsConverted==true){
                IsConverted =true;
                AccountList.Id = objLead.ConvertedAccountId;
                AccountList.FinServ__Citizenship__pc =objlead.Country_of_Citizenship__c;
                AccountList.Place_Of_Birth__pc = objlead.Place_of_Birth__c;
                AccountList.FinServ__CountryOfResidence__pc = objlead.Country__c;
                AccountList.FinServ__CurrentEmployer__pc = objlead.Name_of_Current_Employer__c;
                AccountList.FinServ__MaritalStatus__pc = objlead.Marital_Status__c;
                AccountList.FinServ__MotherMaidenName__pc = objlead.Mother_s_Maiden_Name__c;
                AccountList.FinServ__Occupation__pc = objlead.Occupation__c;
                AccountList.FirstName = objlead.FirstName;
                AccountList.LastName = objlead.LastName;
                AccountList.MiddleName = objlead.MiddleName;
                AccountList.PersonBirthdate = objlead.Date_of_Birth__c;
                AccountList.PersonLeadSource = objlead.LeadSource;
                AccountList.Salutation = objlead.Salutation;
                AccountList.Suffix = objlead.Suffix;
            }
            
        }
        if(IsConverted){
            update AccountList;
        }
    }
    public static void crmm_CreateEmploymentOnConversion(){
        FinServ__Employment__c objEmpCurrent= new FinServ__Employment__c();
        FinServ__Employment__c objEmpPrevious= new FinServ__Employment__c();
        String EmpCurrAddress;
        String EmpPrevAddress;
        for(Lead objLead : leads){
            Lead leadObjOld = oldMap.get(objLead.Id);
            // Detect Conversion
            if(objLead.ConvertedAccountId!=null && objLead.IsConverted==true ){
                // Get Employee Current address and concat
                
                if(objLead.Employer_Address_Street_1__c!=null){
                    EmpCurrAddress = objLead.Employer_Address_Street_1__c;
                }
                if(objLead.Employer_Address_Street_2__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_Address_Street_2__c;
                }
                if(objLead.Employer_Address_Street_3__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_Address_Street_3__c;
                }
                if(objLead.Employer_Area_District__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_Area_District__c;
                }  
                
                if(objLead.Employer_City_Town__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_City_Town__c;
                }
                if(objLead.Employer_City__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_City__c;
                }
                if(objLead.Employer_Country__c!=null){
                    EmpCurrAddress = EmpCurrAddress+'\n'+objLead.Employer_Country__c;
                }
                // Get Prev employee  address and concat
                
                if(objLead.Employer_Address_Street_1__c!=null){
                    EmpPrevAddress = objLead.Previous_Employer_Street_1__c;
                }
                if(objLead.Previous_Employer_Street_2__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Previous_Employer_Street_2__c;
                }
                if(objLead.Previous_Employer_Street_3__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Previous_Employer_Street_3__c;
                }
                if(objLead.Previous_Employment_Area_District__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Previous_Employment_Area_District__c;
                } 
                
                if(objLead.Previous_Employer_City_Town__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Previous_Employer_City_Town__c;
                }
                if(objLead.Previous_Employer_City__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Previous_Employer_City__c;
                }
                if(objLead.Employer_Country__c!=null){
                    EmpPrevAddress = EmpPrevAddress+'\n'+objLead.Employer_Country__c;
                }
                if(objLead.Name_of_Current_Employer__c!=null){
                    objEmpCurrent.Name = objLead.Name_of_Current_Employer__c;
                    objEmpCurrent.Current_Employment__c =true;
                    objEmpCurrent.FinServ__EmployerAddress__c = EmpCurrAddress;
                    objEmpCurrent.FinServ__EmployerPhoneNumber__c = objLead.Employer_Phone_1__c;
                    objEmpCurrent.FinServ__Position__c = objLead.Current_Position_Held__c;
                    objEmpCurrent.Account__c = objLead.ConvertedAccountId;
                }
                if(objLead.Name_of_Previous_Employer__c!=null){
                    objEmpPrevious.Name = objLead.Name_of_Previous_Employer__c;
                    objEmpPrevious.Current_Employment__c =false;
                    objEmpPrevious.Account__c = objLead.ConvertedAccountId;
                    objEmpPrevious.FinServ__EmployerAddress__c = EmpPrevAddress;
                    objEmpPrevious.FinServ__EmployerPhoneNumber__c = objLead.Previous_Employer_Phone_1__c;
                    objEmpCurrent.FinServ__Position__c = objLead.Last_Position_Held__c;
                }
                /*
Encourage client to add start and end date to employment
*/
            }
        }
        // Insert Current Employment
        if(objEmpCurrent.Name!=null){
            insert objEmpCurrent;
        }
        // Insert Previous Employment
        if(objEmpPrevious.Name!=null){
            insert objEmpPrevious;
        }
        
    }
    
    // Responsible for assigning converted leads fields to account, contact and opportunity 
    
    public static void leadConversionBasic(){
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<sObject> all = new List<sObject>();
        DateTime dt;
        for(Lead newRecord: leads){
            // only converted leads
            if(newRecord.IsConverted) {
                // Account Fields
                Account account = new Account();
                account.Id = newRecord.ConvertedAccountId;
                account.FinServ__Citizenship__pc = newRecord.Country_of_Citizenship__c;
                account.FinServ__ContactPreference__pc = newRecord.Preferred_Contact_Method__c;
                account.Place_of_Birth__pc = newRecord.Place_of_Birth__c;
                account.FinServ__CountryOfResidence__pc = newRecord.Country_of_Residence__c;
                account.FinServ__CurrentEmployer__pc = newRecord.Name_of_Current_Employer__c;
                account.FinServ__Gender__pc = newRecord.Gender__c;
                account.FinServ__HomeOwnership__pc = newRecord.Status_of_Address__c;
                //dt = newRecord.Last_Contact_Made__c;
                //account.FinServ__LastInteraction__c = dt.date();
                account.FinServ__MaritalStatus__pc = newRecord.Marital_Status__c;
                account.FinServ__MotherMaidenName__pc = newRecord.Mother_s_Maiden_Name__c;
                account.FinServ__Occupation__pc = newRecord.Occupation__c;
                account.PersonBirthdate = newRecord.Date_of_Birth__c;
                account.PersonHomePhone = newRecord.Home_Phone__c;
                accounts.add(account); //add account
                
                //Contact fields
                Contact contact = new Contact();
                contact.Id = newRecord.ConvertedContactId;
                contact.Birthdate = newRecord.Date_of_Birth__c;
                contact.FinServ__Citizenship__c = newRecord.Country_of_Citizenship__c;
                contact.FinServ__ContactPreference__c = newRecord.Preferred_Contact_Method__c;
                contact.FinServ__CountryOfBirth__c = newRecord.Place_of_Birth__c;
                contact.FinServ__CountryOfResidence__c = newRecord.Country_of_Residence__c;
                contact.FinServ__CurrentEmployer__c = newRecord.Name_of_Current_Employer__c;
                contact.FinServ__Gender__c = newRecord.Gender__c;
                contact.FinServ__HomeOwnership__c = newRecord.Status_of_Address__c;
                contact.FinServ__MaritalStatus__c = newRecord.Marital_Status__c;
                contact.FinServ__MotherMaidenName__c = newRecord.Mother_s_Maiden_Name__c;
                contact.FinServ__Occupation__c = newRecord.Occupation__c;
                contact.FirstName = newRecord.FirstName;
                contact.HomePhone  = newRecord.Home_Phone__c;
                contact.LastName  = newRecord.LastName;
                contact.MiddleName = newRecord.MiddleName;
                contact.Birthdate = newRecord.Date_of_Birth__c;
                contact.Title = newRecord.Job_Title__c;
                contacts.add(contact); //add contact
            }
        }
        
        all.addAll(accounts);
        all.addAll(contacts);
        Database.SaveResult[] updateResult = Database.update(all, false);
        for (Database.SaveResult sr : updateResult) {           
            if (sr.isSuccess()) {               
                // Operation was successful, so get the ID of the record that was processed                
                System.debug(TAG + ' Successfully inserted record. Record ID: ' + sr.getId());                
            }           
            else {               
                // Operation failed, so get all errors                               
                for(Database.Error err : sr.getErrors()) {                   
                    System.debug(TAG + ' The following error has occurred.');                                       
                    System.debug(TAG + ' ' + err.getStatusCode() + ': ' + err.getMessage());                   
                    System.debug(TAG + ' Record fields that affected this error: ' + err.getFields());
                    
                }
                
            }
            
        }
        
    }
    
    
    //Create a event when a lead is created
    
    public static void leadActivityEvent(){
        List<Event> events = new List<Event>();
        for(Lead newRecord: leads){            
            if(newRecord.Preferred_Time_of_Contact__c != null && newRecord.Preferred_Date_of_Contact__c!= null) {
                Event thisEvent = new Event();
                thisEvent.StartDateTime  = createDateTime(newRecord.Preferred_Time_of_Contact__c, newRecord.Preferred_Date_of_Contact__c);
                if(newRecord.Preferred_Contact_Method__c != null) {
                    thisEvent.Subject = 'Contact ' + newRecord.FirstName + ' ' + newRecord.LastName + ' @ '+getContactNumber(newRecord.Preferred_Contact_Method__c, newRecord);
                    thisEvent.WhoId = newRecord.Id;
                    thisEvent.OwnerId = UserInfo.getUserId();  
                    thisEvent.DurationInMinutes = 60;
                    events.add(thisEvent);
                } 
                
            }
        }
        if(!events.isEmpty()){
            insert events;  
        }
        
    }
    /*
* extract contact information from lead
*/ 
    private static String getContactNumber(String preferredContactMethod, Lead newRecord){
        String contact = '';
        if(preferredContactMethod == 'Mobile') {
            contact = newRecord.MobilePhone;
        }
        else if(preferredContactMethod == 'Home Number') {
            contact = newRecord.Home_Phone__c;
        }
        else if(preferredContactMethod == 'Email') {
            contact = newRecord.Email;
        }
        return contact;
    }
    private static DateTime createDateTime(Time preferredTime_of_Contact, Date preferredDate_of_Contact) {
        return DateTime.newInstance(preferredDate_of_Contact.year(), 
                                    preferredDate_of_Contact.month(), 
                                    preferredDate_of_Contact.day(), 
                                    preferredTime_of_Contact.hour(), 
                                    preferredTime_of_Contact.minute(), 
                                    preferredTime_of_Contact.second());
    }
    
    // convert Lead related person to accounts
    public static void convertLeadRelatedPersons(){
        List<String> leadIds = new List<String>();
        List<String> convertedAccountIds = new List<String>();
        Map<String, Id> recordTypeids = Util.getRecordTypeids('Account');
        for(Lead record: leads){
            //new lead conversion
            if(checkIfNewConversion(record)){
                leadIds.add(record.Id);
                convertedAccountIds.add(record.ConvertedAccountId);
            }
        }
        if(!leadIds.isEmpty()){
            System.debug('Related persons new conversion');
            Map<Id, Lead_Related_Person__c> leadRelatedPersons = new Map<Id, Lead_Related_Person__C>([
                SELECT Id,TRN__c ,TItle__c ,Role__c ,
                Relationship__c ,Mobile_Number__c ,Middle_Name__c ,
                Lead_and_Referral__c ,Last_Name__c ,JN_Location__c ,
                Home_Phone_Number__c ,First_Name__c ,Email__c ,
                Business_Number__c ,Afilliate_Type__c 
                FROM Lead_Related_Person__c WHERE Lead_and_Referral__c in :leadids
            ]);
            
            Lead thisLead;
            Id accountId;
            Id contactId;
            List<Sobject> recordsToInsert = new List<Sobject>();
            Map<String, FinServ__ReciprocalRole__c> mappedRoles = Util.getRoleRelationships(); //get contact roles
            Map<String, Id> recordTypesRole = Util.getRecordTypeids('FinServ__ReciprocalRole__c');

            
            for(Lead_Related_Person__C record: leadRelatedPersons.values()){
                System.debug('found Related persons');
                thisLead = newMap.get(record.Lead_and_Referral__c);
                switch on record.Afilliate_Type__c  {
                    when 'Credit Card Extension' {
                        System.debug('Related persons Credit Card Extension');
                        //create supplementary card holder
                        
                        Map<String, String> mappedData = new Map<String, String>();
                        //create account first
                        mappedData.put('FirstName','First_Name__c');
                        mappedData.put('LastName','Last_Name__c');
                        mappedData.put('MiddleName','Middle_Name__c');
                        mappedData.put('Supplementary_Applicant_Relationship__c','Relationship__c');
                        mappedData.put('Jamaican_Tax_Registration_Number__c','TRN__c');
                        Account newAccount = Util.createAccount(mappedData, record, recordTypeids.get('PersonAccount'));
                        //query
                        
                        Account[] foundAccounts = [SELECT Id from account where FirstName =:record.First_Name__c and LastName =:record.Last_Name__c 
                                                   and Jamaican_Tax_Registration_Number__c=:record.TRN__c];
                        if(!foundAccounts.isEmpty()){
                            accountId = foundAccounts.get(0).Id;
                        } else {
                            insert newAccount;
                            accountId = newAccount.Id;
                        }
                        recordsToInsert.add(Util.createSupplementaryCardHolder(thisLead.ConvertedOpportunityId, accountId));
                    }
                    when 'Political' {
                         System.debug('Related persons Political');
                        // create account with Political role  
                        FinServ__ReciprocalRole__c role = mappedRoles.get('Political Affiliation');
                        role.RecordTypeId = recordTypesRole.get('AccountRole');
                        Map<String, String> mappedData = new Map<String, String>();
                        mappedData.put('FirstName','First_Name__c');
                        mappedData.put('LastName','Last_Name__c');
                        mappedData.put('Political_Affiliation_Role__pc','Role__c');
                        mappedData.put('Political_Affiliation_Relationship__pc','Relationship__c');
                        mappedData.put('PersonMobilePhone','Mobile_Number__c');
                        Account newAccount = Util.createAccount(mappedData, record, recordTypeids.get('PersonAccount'));
                        
                        Account[] foundAccounts = [SELECT Id,PersonContactId from account where FirstName =:record.First_Name__c and LastName =:record.Last_Name__c 
                                                   and Mobile_Number__pc=:record.Mobile_Number__c];
                        if(!foundAccounts.isEmpty()){
                            accountId = foundAccounts.get(0).Id;
                            contactId = foundAccounts.get(0).PersonContactId;
                        } else {
                            insert newAccount;
                            newAccount = [SELECT Id,PersonContactId from account where Id = :newAccount.Id];
                            accountId = newAccount.Id;
                            contactId = newAccount.PersonContactId;
                        }
                        recordsToInsert.add(Util.createContactToContactRelationship(thisLead.ConvertedContactId, contactId, role.Id));
                    }
                    when 'JN Bank' {
                        System.debug('Related persons JN Bank');
                        // create account with JN Bank role 
                        FinServ__ReciprocalRole__c role = mappedRoles.get('JN Affiliation');
                        System.debug('Role Map: '+ role);
                        role.RecordTypeId = '0124P0000011gtiQAA';
                        System.debug('Role Map After: '+ role);
                        Map<String, String> mappedData = new Map<String, String>();
                        mappedData.put('FirstName','First_Name__c');
                        mappedData.put('LastName','Last_Name__c');
                        mappedData.put('Political_Affiliation_Role__pc','Role__c');
                        mappedData.put('JN_Bank_Affiliation_Relationship__pc','Relationship__c');
                        mappedData.put('JN_Bank_Affiliated_Location__pc', 'JN_Location__c');
                        mappedData.put('PersonMobilePhone','Mobile_Number__c');
                        Account newAccount = Util.createAccount(mappedData, record, recordTypeids.get('PersonAccount'));
                        Account[] foundAccounts = [SELECT Id,PersonContactId from account where FirstName =:record.First_Name__c and LastName =:record.Last_Name__c 
                                                   and Mobile_Number__pc=:record.Mobile_Number__c];
                        if(!foundAccounts.isEmpty()){
                            accountId = foundAccounts.get(0).Id;
                            contactId = foundAccounts.get(0).PersonContactId;
                        } else {
                            System.debug('creating account Jn');
                            insert newAccount;
                              newAccount = [SELECT Id,PersonContactId from account where Id = :newAccount.Id];
                            accountId = newAccount.Id;
                            contactId = newAccount.PersonContactId;
                        }
                        recordsToInsert.add(Util.createContactToContactRelationship(thisLead.ConvertedContactId, contactId, role.Id));
                    }
                }
            }
            
            // accountsToInsert.addAll(personAccounts);
            Database.SaveResult[] results = Database.insert(recordsToInsert, true);
            
            for (Database.SaveResult sr : results) {           
                if (sr.isSuccess()) {               
                    // Operation was successful, so get the ID of the record that was processed                
                    System.debug(TAG + ' Successfully inserted account. Record ID: ' + sr.getId());                
                }           
                else {                    
                    // Operation failed, so get all errors                               
                    for(Database.Error err : sr.getErrors()) {                   
                        System.debug(TAG + ' The following error has occurred.');                                       
                        System.debug(TAG + ' ' + err.getStatusCode() + ': ' + err.getMessage());                   
                        System.debug(TAG + ' Record fields that affected this error: ' + err.getFields());
                    }
                    
                }
                
            }
        }
    }
    
    // converted leads with with employment from lead related persion
    // run after [update]
    public static void convertInfoToEmployment(){
        String leadSource ='Online Application Form';
        String creditCard ='JN Bank Credit Card';
        String unsecuredLoan ='JN Bank Unsecured Loan';
        Map<String, Id> recordTypes = Util.getRecordTypeids('FinServ__Employment__c');
        List<String> emptyFieldsForEmployed = new List<String>{'FinServ__Employer__c','Current_Position_Held__c',
            'Time_with_Current_Employer__c','Employer_Industry__c',
            'Time_in_Industry__c','Employment_Status__c'};
                
                List<String> emptyFieldsForSelfEmployed  = new List<String>{'Self_Employed_Company_Name__c','Type_of_Business__c',
                    'Date_of_Incorporation__c','Type_of_Industry_Self_Employed__c',
                    'Nature_of_Engagement__c', 'Self_Employed_Time_in_Present_Industry__c'};
                        
                        List<String> emptyFieldsForUnEmployed = new List<String>{'Unemployed_Previous_Emoployer__c','Unemployed_Last_Position_Held__c','Unemployed_Industry_Previous_Employment__c'};
                            List<FinServ__Employment__c> employments = new List<FinServ__Employment__c>();
        for(Lead record: leads){
            //new lead conversion
            System.debug('Trying to convert with employment' + record);
            if(checkIfNewConversion(record)){
                System.debug('success new conversion');
                //lead is from the JN site
                if(record.LeadSource  ==(leadSource) 
                   && record.Service_of_Interest__c == (creditCard) || record.Service_of_Interest__c == (unsecuredLoan)){
                       System.debug('success lead source and service of interest');
                       switch on record.Primary_Employment_Type__c {
                           when 'Employed' {
                               System.debug('success  employed');
                               if(!Util.areFieldsEmpty(emptyFieldsForEmployed, record)){                               
                                   
                                   System.debug('success employed fields not null');
                                   FinServ__Employment__c employment = new FinServ__Employment__c();
                                   employment.Account__c = record.ConvertedAccountId;
                                   employment.Name = record.Name_of_Current_Employer__c;
                                   employment.FinServ__Position__c = record.Current_Position_Held__c;
                                   employment.Time_Employed_with_Current_Employer__c = record.Time_with_Current_Employer__c;
                                   employment.Industry__c = record.Employer_Industry__c;
                                   employment.Time_in_Industry__c = record.Time_in_Industry__c;
                                   employment.FinServ__EmploymentStatus__c  = record.Employment_Status__c;
                                   employment.Description__c = record.Employment_Description__c;
                                   employment.Street_1__c = record.Employer_Address_Street_1__c;
                                   employment.Street_2__c = record.Employer_Address_Street_2__c;
                                   employment.Street_3__c = record.Employer_Address_Street_3__c;
                                   employment.City_Town__c = record.Employer_City_Town__c;
                                   employment.Residential_Area_District__c = record.Employer_Area_District__c;
                                   employment.Post_Office_Zip_Code__c = record.Post_Office_Zip_Code__c;
                                   employment.Province_Parish_State__c = record.Employer_Province_Parish_State__c;
                                   employment.Country__c = record.Employer_Country__c;
                                   employment.Business_Number_1__c = record.Employer_Phone_1__c;
                                   employment.Business_Number_2__c = record.Employer_Phone_2__c;
                                   employment.Income_Type__c = 'Salaried';
                                   employment.RecordTypeId =  recordTypes.get('Employed');
                                   employments.add(employment);
                               }
                           }
                           when 'Self-Employed' {
                               System.debug('success self employed');
                               if(!Util.areFieldsEmpty(emptyFieldsForSelfEmployed, record)){  
                                   System.debug('success self employed fields not null');
                                   FinServ__Employment__c employment = new FinServ__Employment__c();
                                   employment.Account__c = record.ConvertedAccountId;
                                   employment.Name = record.Self_Employed_Company_Name__c;
                                   employment.Type_of_Business__c = record.Type_of_Business__c;
                                   employment.Date_of_Incorporation__c = record.Date_of_Incorporation__c;
                                   employment.Industry__c = record.Type_of_Industry_Self_Employed__c;
                                   employment.Nature_of_Engagement__c = record.Nature_of_Engagement__c;
                                   employment.Time_in_Industry__c = record.Self_Employed_Time_in_Present_Industry__c;
                                   employment.Street_1__c = record.Self_Employed_Street_1__c;
                                   employment.Street_2__c = record.Self_Employed_Street_2__c;
                                   employment.Street_3__c = record.Self_Employed_Street_3__c;
                                   employment.City_Town__c = record.Employer_City_Town__c;
                                   employment.Residential_Area_District__c = record.Employer_Area_District__c;
                                   employment.Post_Office_Zip_Code__c = record.Employer_Post_Office_Zip_Code__c;
                                   employment.Province_Parish_State__c = record.Employer_Province_Parish_State__c;
                                   employment.Country__c = record.Employer_Country__c;
                                   employment.Business_Number_1__c = record.Employer_Phone_1__c;
                                   employment.Business_Number_2__c = record.Employer_Phone_2__c;
                                   employment.Income_Type__c = 'Self-Employed';
                                   employment.RecordTypeId =  recordTypes.get('Self_Employed');
                                   employments.add(employment);
                               }
                           }
                           when 'Unemployed' {
                               System.debug('success  employed');
                               if(!Util.areFieldsEmpty(emptyFieldsForUnEmployed, record)){   
                                   System.debug('success self UNemployed fields not null');
                                   FinServ__Employment__c employment = new FinServ__Employment__c();
                                   employment.Account__c = record.ConvertedAccountId;
                                   employment.Name = record.Unemployed_Previous_Emoployer__c;
                                   employment.Position__c = record.Unemployed_Last_Position_Held__c;
                                   employment.Date_of_Incorporation__c = record.Date_of_Incorporation__c;
                                   employment.Industry__c = record.Unemployed_Industry_Previous_Employment__c;
                                   employment.Nature_of_Engagement__c = record.Nature_of_Engagement__c;
                                   employment.Time_in_Industry__c = record.Self_Employed_Time_in_Present_Industry__c;
                                   employment.Street_1__c = record.Unemployed_Street_1__c;
                                   employment.Street_2__c = record.Unemployed_Street_2__c;
                                   employment.Street_3__c = record.Unemployed_Street_3__c;
                                   employment.City_Town__c = record.Unemployed_City_Town__c;
                                   employment.Residential_Area_District__c = record.Unemployed_Residential_Area_District__c;
                                   employment.Post_Office_Zip_Code__c = record.Unemployed_Post_Office_Zip__c;
                                   employment.Province_Parish_State__c = record.Unemployed_Province_Parish_State__c;
                                   employment.Country__c = record.Unemployed_Country__c;
                                   employment.Business_Number_1__c = record.Unemployed_Phone_1__c;
                                   employment.Business_Number_2__c = record.Unemployed_Phone_2__c;
                                   employment.Income_Type__c = 'Salaried';
                                   employment.RecordTypeId =  recordTypes.get('Unemployed');
                                   employments.add(employment);
                               }
                           }
                       }
                   }
            }
        }
        if(!employments.isEmpty()){
            insert employments;
        }
    }
    
    private static Boolean checkIfNewConversion(Lead record){
        if(record.ConvertedOpportunityId != null
           && record.ConvertedAccountId != null && record.ConvertedDate != null){
               Lead oldLead = OldMap.get(record.Id);
               if(oldLead.ConvertedOpportunityId == null
                  && oldLead.ConvertedAccountId == null && oldLead.ConvertedDate == null){
                      return true;
                  }
               
           }
        return false;
    }
    
}