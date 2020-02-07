/**
 * @File Name          : crmm_lead_trigger_conversion.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/30/2019, 6:02:43 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/30/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_lead_trigger_conversion on lead (after update) {
    Boolean IsConverted = false;
    Account AccountList = new Account();
    for(lead objLead : Trigger.new){
       Boolean OldConvertedState = Trigger.oldMap.get(objlead.Id).IsConverted;
         
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