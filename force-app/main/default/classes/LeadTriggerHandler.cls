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
    
    public static void init(List<Lead> leads, Map<Id, Lead> oldMap){
        LeadTriggerHandler.leads = leads;
        LeadTriggerHandler.oldMap = oldMap;
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
                AccountList.FinServ__CountryOfBirth__pc = objlead.Place_of_Birth__c;
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
    /*
* Responsible for assigning converted leads fields to account, contact and opportunity 
*/
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
                account.FinServ__CountryOfBirth__pc = newRecord.Place_of_Birth__c;
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
    
    /*
* Create a event when a lead is created
*/ 
    public static void leadActivityEvent(){
        List<Event> events = new List<Event>();
        for(Lead newRecord: leads){
            
            if(newRecord.Preferred_Time_of_Contact__c != null && newRecord.Preferred_Date_of_Contact__c!= null){
                Event thisEvent = new Event();
                thisEvent.StartDateTime  = createDateTime(newRecord.Preferred_Time_of_Contact__c, newRecord.Preferred_Date_of_Contact__c);
                if(newRecord.Preferred_Contact_Method__c != null) {
                    thisEvent.Subject = 'Contact ' + newRecord.FirstName + ' ' + newRecord.LastName + ' @'+getContactNumber(newRecord.Preferred_Contact_Method__c, newRecord);
                } else {
                    thisEvent.Subject = 'Contact cannot be made, because there is none.';
                }
                thisEvent.WhoId = newRecord.Id;
                thisEvent.OwnerId = UserInfo.getUserId();  
                thisEvent.DurationInMinutes = 60;
                events.add(thisEvent);
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
    
}