/**
 * @File Name          : crmm_CreateEmploymentOnConversion.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/5/2019, 1:04:06 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/5/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_CreateEmploymentOnConversion on Lead (after update) {
    FinServ__Employment__c objEmpCurrent= new FinServ__Employment__c();
   FinServ__Employment__c objEmpPrevious= new FinServ__Employment__c();
   String EmpCurrAddress;
   String EmpPrevAddress;
    for(Lead objLead : Trigger.new){
        Lead leadObjOld = Trigger.oldMap.get(objLead.Id);
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