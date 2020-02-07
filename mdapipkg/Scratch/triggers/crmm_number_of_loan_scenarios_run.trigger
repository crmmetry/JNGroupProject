/**
 * @File Name          : crmm_number_of_loan_scenarios_run.trigger
 * @Description        : 
 * @Author             : Jermaine Byfield
 * @Group              : 
 * @Last Modified By   : Jermaine Byfield
 * @Last Modified On   : 9/12/2019, 9:18:13 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    9/12/2019   Jermaine Byfield     Initial Version
**/
trigger crmm_number_of_loan_scenarios_run on Loan_Calculator__c (after insert,after delete) {
 	system.debug('Trigger called========================================>');
    Set<Id> leadid = new Set<Id>();
    for (Loan_Calculator__c lc : (Trigger.IsInsert)?Trigger.new:Trigger.old) {
        system.debug('lc.Lead_and_Referral__c===>'+lc.Lead_and_Referral__c);
        if(string.isNotEmpty(lc.Lead_and_Referral__c))
            leadid.add(lc.Lead_and_Referral__c);
    }
    Map<id,Integer> leadToLoanCountMap = new Map<Id,Integer>();
    if(leadid.size()>0){
        AggregateResult[] groupedResults = [SELECT count(id) num_ref,Lead_and_Referral__c from Loan_Calculator__c where Lead_and_Referral__c IN:leadid GROUP BY Lead_and_Referral__c ];
        system.debug('groupedResults===>'+groupedResults);
        List<Lead> lstlead =[Select Number_of_Loans_Scenerios_Run__c from Lead where Id IN:leadid];
        system.debug('lstlead===>'+lstlead);
        if(groupedResults.size()>0){
            for(AggregateResult aggr: groupedResults){
                if(aggr.get('num_ref')!=null && aggr.get('Lead_and_Referral__c')!=null){
                    id Lead_Id=(ID)(aggr.get('Lead_and_Referral__c'));
                    leadToLoanCountMap.put(Lead_Id, (Integer)aggr.get('num_ref'));
                }
            }
        }
        List<Lead> lstToUpdate = new List<Lead>();
        if(lstlead.size()>0){
            for(Lead l:lstlead){
                if(leadToLoanCountMap.containsKey(l.Id)){
                    Integer count = leadToLoanCountMap.get(l.Id);
                    if(count != l.Number_of_Loans_Scenerios_Run__c){
                        l.Number_of_Loans_Scenerios_Run__c = count;
                        lstToUpdate.add(l);
                    }       
                }
            }          
        }
        
        if(lstToUpdate.size()>0)
            update lstToUpdate;
        
    
        
        
        
    }//*/


    
//Map <String,Loan_Calculator__c> getVal = new Map<String,Loan_Calculator__c>();    
/* for(Loan_Calculator__c getObj : trigger.new){

        AggregateResult[] groupedResults = [SELECT count(Lead_and_Referral__c) num_ref from Loan_Calculator__c where Lead_and_Referral__c=:getObj.Lead_and_Referral__c];
        Lead upLead =[Select Number_of_Loans_Scenerios_Run__c from Lead where Id =:getObj.Lead_and_Referral__c];
       // Decimal num_ref = Integer.valueOf(groupedResults[0].get('num_ref'));
       
       // if(getObj.Lead_and_Referral__c!=null){
           if( Integer.valueOf(groupedResults[0].get('num_ref'))>0){
               system.debug(' Value it should have '+ groupedResults[0].get('num_ref'));
                uplead.Number_of_Loans_Scenerios_Run__c = Integer.valueOf(groupedResults[0].get('num_ref'));
               update uplead;
           }
        //}
 }//*/ //27/9/2019
 
//       if(getObj.Lead_and_Referral__c!=null){
//         getVal.put(getObj.Lead_and_Referral__c,getObj);

  
//           if(getVal.isEmpty()==false){
//         AggregateResult[] groupedResults = [SELECT count(Lead_and_Referral__c) num_ref from Loan_Calculator__c where Lead_and_Referral__c=:getVal.get('Lead_and_Referral__c').Lead_and_Referral__c];
          
    
//             if(groupedResults.isEmpty()==false){
//             Lead upLead =[Select Number_of_Loans_Scenerios_Run__c from Lead where Id =:getVal.get('Lead_and_Referral__c').Lead_and_Referral__c];
//             Decimal num_ref = Integer.valueOf(groupedResults[0].get('num_ref'));
//             uplead.Number_of_Loans_Scenerios_Run__c = num_ref;
//             update uplead;
//             }
//           }
// } 
}