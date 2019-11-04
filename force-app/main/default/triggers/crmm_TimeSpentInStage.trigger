/**
 * @File Name          : crmm_TimeSpentInStage.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/9/2019, 10:26:03 AM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/6/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_TimeSpentInStage on Lead (before update) {
 for(Lead ObjLead : Trigger.new){
        Lead leadObjOld = Trigger.oldMap.get(ObjLead.Id);

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