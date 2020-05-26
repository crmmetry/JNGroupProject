/*  
 * Sr#  Ticket#      Modified By      Modified Date       Description
 *   1  JN1-2755     Priyanka A.(TQ)  02/06/2020      TDSR - Auto Loan Before
 * */


public class MultiProductCalculatorController {
    
    @AuraEnabled
    Public static decimal JNlifeCalculation(string agegroup, decimal term){
        system.debug('agegroup======='+agegroup);
        decimal intrestrate;
        Creditor_Life_Matrix__mdt[] threatMappings = [SELECT MasterLabel,X0_5__c,X1__c,X1_5__c,X2__c,X2_5__c,
                                                      X3__c,X3_5__c,X4__c,X4_5__c,X5__c,X5_5__c,X6__c,X6_5__c,
                                                      X7__c,X7_5__c,X8__c,X8_5__c,X9__c,X9_5__c,X10__c 
                                                      FROM Creditor_Life_Matrix__mdt
                                                      WHERE MasterLabel =: agegroup];
        if(term==0.5)
            intrestrate=threatMappings[0].X0_5__c;
        else if(term==1)
            intrestrate=threatMappings[0].X1__c;
        else if(term==1.5)
            intrestrate=threatMappings[0].X1_5__c;
        else if(term==2)
            intrestrate=threatMappings[0].X2__c;
        else if(term==2.5)
            intrestrate=threatMappings[0].X2_5__c;
        else if(term==3)
            intrestrate=threatMappings[0].X3__c;
        else if(term==3.5)
            intrestrate=threatMappings[0].X3_5__c;
        else if(term==4)
            intrestrate=threatMappings[0].X4__c;
        else if(term==4.5)
            intrestrate=threatMappings[0].X4_5__c;
        else if(term==5)
            intrestrate=threatMappings[0].X5__c;
        else if(term==5.5)
            intrestrate=threatMappings[0].X5_5__c;
        else if(term==6)
            intrestrate=threatMappings[0].X6__c;
        else if(term==6.5)
            intrestrate=threatMappings[0].X6_5__c;
        else if(term==7)
            intrestrate=threatMappings[0].X7__c;
        else if(term==7.5)
            intrestrate=threatMappings[0].X7_5__c;
        else if(term==8)
            intrestrate=threatMappings[0].X8__c;
        else if(term==8.5)
            intrestrate=threatMappings[0].X8_5__c;
        else if(term==9)
            intrestrate=threatMappings[0].X9__c;
        else if(term==9.5)
            intrestrate=threatMappings[0].X9_5__c;
        else if(term==10)
            intrestrate=threatMappings[0].X10__c;
        else 
            intrestrate=0;
        return intrestrate;
    }
    @AuraEnabled
    public static List<sObject> searchRecord(String objectAPIName, String fieldAPIName, 
                                             List<String> moreFields, String searchText,
                                             Integer recordLimit){
                                                 
                                                 List<sObject> objectList =  new List<sObject>();
                                                 
                                                 searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                                                 
                                                 String soqlQuery = 'SELECT Id, Name';
                                                 if(!moreFields.isEmpty()){
                                                     soqlQuery = soqlQuery + ',' + String.join(moreFields, ',') ;
                                                 }
                                                 soqlQuery = soqlQuery + ' FROM ' + objectAPIName + ' WHERE ' +
                                                     + fieldAPIName +' LIKE '+ searchText + ' LIMIT '+ recordLimit;
                                                 objectList = Database.query(soqlQuery);
                                                 return objectList;
                                             }
    @AuraEnabled
    public static string SaveOnlyLoanCalculation (Loan_Calculator__c loancalculation){
        string returnStr='';
        try{
            System.debug('Only loancalculation for save============'+loancalculation);
            if(loancalculation != null){
                Id rtID = Schema.SObjectType.Loan_Calculator__c.getRecordTypeInfosByName().get('Multi Product').getRecordTypeId();
                loancalculation.recordTypeId =rtID;
                system.debug('SaveLoanCalculation=='+loancalculation);
                system.debug('SaveLoanCalculation=='+loancalculation.Stamp_duty__c);
                insert loancalculation;
                returnStr=string.valueOf(loancalculation.Id);
                system.debug('SaveLoanCalculation=='+loancalculation);
            }
            
        } catch (Exception ex){
            returnStr=ex.getMessage();
            system.debug('Exception =>'+ex.getMessage() +'  Line Number => '+ex.getLineNumber());
        }
        return returnStr;
    }
    @AuraEnabled
    public static string SaveLoanCalculation(Loan_Calculator__c loancalculation, Opportunity Opptoupdate){
        string returnStr='';
        try{
            
            System.debug('loancalculation with opportunity for save============'+loancalculation);
            if(loancalculation != null){
                Id rtID = Schema.SObjectType.Loan_Calculator__c.getRecordTypeInfosByName().get('Product Details').getRecordTypeId();
                loancalculation.recordTypeId =rtID;
                loancalculation.Annual_Membership_Per_sulpplementary__c=string.valueOf(loancalculation.Annual_Membership_Per_sulpplementary__c);
                loancalculation.Annual_Membership__c=string.valueOf(loancalculation.Annual_Membership__c);
                insert loancalculation;
                
                system.debug('SaveLoanCalculation=='+loancalculation.Id);
                System.debug('Opptoupdate============'+Opptoupdate);
                Opptoupdate.Product_Details__c=loancalculation.Id;
                update Opptoupdate;
                System.debug('Opptoupdate1============'+Opptoupdate);
                returnStr=string.valueOf(loancalculation.Id);
                //set<Id> oppset= new set<Id>();
                //oppset.add(Opptoupdate.Id);
                //CreditScoreHelper csh= new CreditScoreHelper();
                //csh.CreditScoreFromOpp(oppset);
            }
            
        } catch (Exception ex){
            returnStr=ex.getMessage();
            system.debug('Exception =>'+ex.getMessage() +'  Line Number => '+ex.getLineNumber());
        }
        return returnStr;
    }
    @AuraEnabled
    Public static list<Applicant__c> FetchApplicant(String oppId ){
        system.debug('oppId========='+oppId);
        list<Applicant__c> applst=new list<Applicant__c>();
        applst = [Select id, Account__r.firstname,Account__r.lastname, Account__r.PersonBirthdate, Account__r.JN_Bank_Affiliation__pc, Account__r.Gross_Monthly_Income__pc,Opportunity__r.Existing_monthly_debts_being_serviced__c  from Applicant__c where Opportunity__c=:oppId];
        system.debug('applst========='+applst);
        return applst;
    }
    @AuraEnabled
    Public static string getproductselection(String oppId ){
        set<string> productset= new set<string>();
        string selection='0';
        Set<String> set1 = new Set<String>{'JN Bank Auto Loan'};
            Set<String> set2 = new Set<String>{'JN Bank Unsecured Loan'};
                Set<String> set3 = new Set<String>{'JN Visa - Classic'};
                    Set<String> set4 = new Set<String>{'JN Bank Line Of Credit'};
                        Set<String> set5 = new Set<String>{'JN Bank Auto Loan', 'JN Bank Unsecured Loan'};
                            Set<String> set6 = new Set<String>{'JN Bank Auto Loan', 'JN Visa - Classic'};
                                Set<String> set7 = new Set<String>{'JN Bank Auto Loan', 'JN Bank Line Of Credit'};
                                    Set<String> set8 = new Set<String>{'JN Bank Unsecured Loan', 'JN Visa - Classic'};
                                        Set<String> set9 = new Set<String>{'JN Bank Unsecured Loan', 'JN Bank Line Of Credit'};
                                            Set<String> set10 = new Set<String>{'JN Visa - Classic', 'JN Bank Line Of Credit'};
                                                Set<String> set11 = new Set<String>{'JN Bank Auto Loan', 'JN Bank Unsecured Loan','JN Visa - Classic'};
                                                    Set<String> set12 = new Set<String>{'JN Bank Auto Loan', 'JN Bank Unsecured Loan','JN Bank Line Of Credit'};
                                                        Set<String> set13 = new Set<String>{'JN Bank Auto Loan', 'JN Visa - Classic', 'JN Bank Line Of Credit'};
                                                            Set<String> set14 = new Set<String>{'JN Bank Unsecured Loan', 'JN Visa - Classic', 'JN Bank Line Of Credit'};
                                                                Set<String> set15 = new Set<String>{'JN Bank Auto Loan', 'JN Bank Unsecured Loan', 'JN Visa - Classic', 'JN Bank Line Of Credit'};
                                                                    list<OpportunityLineItem> lstlineItem=new list<OpportunityLineItem>();
        lstlineItem  =  [select Product2.Name from OpportunityLineItem where Opportunityid =: oppid];
        for(OpportunityLineItem ol:lstlineItem){
            String  Productname=ol.Product2.Name;
            if(Productname =='JN Bank Auto Loan')
                productset.add('JN Bank Auto Loan');
            if(Productname =='JN Bank Unsecured Loan')
                productset.add('JN Bank Unsecured Loan');
            if(Productname.contains('JN Visa'))
                productset.add('JN Visa - Classic');
            if(Productname =='JN Bank Line Of Credit')
                productset.add('JN Bank Line Of Credit');
        }
        if(productset.size()==1){
            if(productset.equals(set1))
                selection='1';
            if(productset.equals(set2))
                selection='2';
            if(productset.equals(set3))
                selection='3';
            if(productset.equals(set4))
                selection='4';
        }
        if(productset.size()==2){
            if(productset.equals(set5))
                selection='5';
            if(productset.equals(set6))
                selection='6';
            if(productset.equals(set7))
                selection='7';
            if(productset.equals(set8))
                selection='8';
            if(productset.equals(set9))
                selection='9';
            if(productset.equals(set10))
                selection='10';
        }
        if(productset.size()==3){
            if(productset.equals(set11))
                selection='11';
            if(productset.equals(set12))
                selection='12';
            if(productset.equals(set13))
                selection='13';
            if(productset.equals(set14))
                selection='14';
            
            
        }
        if(productset.size()==4){
            if(productset.equals(set15))
                selection='15';
        }
        
        return selection;
    }
    @AuraEnabled
    Public static list<Wrappercls> FetchAllApplicant(String oppId ){
        List<Wrappercls> retlst = new List<Wrappercls>();
        system.debug('oppId========='+oppId);
        Set<id> accid = new set<id>();
        list<Applicant__c> applst=new list<Applicant__c>();
        applst = [Select id, Account__c,Account__r.firstname,Account__r.lastname, Account__r.PersonBirthdate,Gross_Monthly_IncomeC__c,
                  Account__r.JN_Bank_Affiliation__pc,Account__r.Gross_Monthly_Income__pc,Account__r.Id  from Applicant__c where Opportunity__c=:oppId];
        if(applst.size()>0){
            system.debug('applst========='+applst);
            for(Applicant__c a:applst)
                accid.add(a.Account__c);
        }
        system.debug('accid========='+accid);
        Decimal EMCPayment=0;
        list<Opportunity> lstopp=new list<Opportunity>();
        lstopp = [Select id, Accountid,Existing_monthly_debts_being_serviced__c  from Opportunity where id=:oppId];
        if(lstopp.size()>0){
            system.debug('lstopp========='+lstopp);
            for(Opportunity a:lstopp){
                //accid.add(a.Accountid);
                if(a.Existing_monthly_debts_being_serviced__c !=NULL)
                    EMCPayment = a.Existing_monthly_debts_being_serviced__c;
            }
        }
        system.debug('EMCPayment========='+EMCPayment);
        list<Account> lstacc=new list<Account>();
        //lstacc = [Select id, firstname,lastname, PersonBirthdate,JN_Bank_Affiliation__pc,Gross_Monthly_Income__pc  from Account where id IN:accid];
        
        for(Applicant__c a:applst){
            retlst.add( new Wrappercls(a.Account__r.firstname,a.Account__r.lastname,
                                       a.Account__r.PersonBirthdate,a.Gross_Monthly_IncomeC__c,//AK::a.Account__r.Gross_Monthly_Income__pc,
                                       EMCPayment,a.Account__r.JN_Bank_Affiliation__pc,a.Account__r.Id,a.Id));
            
        }
        
        
        system.debug('retlst========='+retlst);
        return retlst;
    }
    
    public class Wrappercls{
        @AuraEnabled
        public string First_Name{get;set;}
        @AuraEnabled
        public string Last_Name{get;set;}
        @AuraEnabled
        public Date DateOf_Birth{get;set;}
        @AuraEnabled
        public Decimal GM_Income{get;set;}
        @AuraEnabled
        public Decimal EMC_Payment{get;set;}
        @AuraEnabled
        public Boolean IsJNEmp{get;set;}
        @AuraEnabled
        public String accountId{get;set;}
        @AuraEnabled
        public String applicantId{get;set;}
        Wrappercls(string FirstName,string LastName,Date DateOfBirth,Decimal GMIncome,
                   Decimal EMCPayment,Boolean IsJNEmployee, String accountId,
                   String applicantId){
                       this.First_Name=FirstName;
                       this.Last_Name=LastName;
                       this.DateOf_Birth=DateOfBirth;
                       this.GM_Income=GMIncome;
                       this.EMC_Payment=EMCPayment;
                       this.IsJNEmp=IsJNEmployee;
                       this.accountId=accountId;
                       this.applicantId = applicantId;
                   }
    }
    
    /* 
public static Boolean isRequiredFieldMissingForScore(string oppid){
Boolean flag=false;
Boolean autoProfound=false;
Boolean unProfound=false;
Boolean ccProfound=false;
Boolean locProfound=false;
List<OpportunityLineItem> lstlineItem  =  [select name,Opportunityid,Product2.Name,TotalPrice from OpportunityLineItem where Opportunityid =: oppid];
if(lstlineItem.size()>0){
for(OpportunityLineItem item:lstlineItem){
if(item.Name =='JN Bank Auto Loan'){// 'Auto Loan';
autoProfound=true;
}
else if(item.Name =='JN Bank Unsecured Loan'){// 'Unsecured Loan';
unProfound=true;
}
else if(item.Name =='JN Visa - Classic'){// 'Credit Card';
ccProfound=true;
}
else if(item.Name =='JN Bank Line Of Credit'){// 'Line of Credit';
locProfound=true;
}
}
}
if(!locProfound && !unProfound && !ccProfound && !locProfound){
return true;
}

List<opportunity> lstopp = [select id,Collateral__r.RecordType.Name from opportunity where id=:oppid limit 1];
if(lstopp.size()>0){
system.debug('Naresh## lstopp================>'+lstopp);
if(autoProfound){

}
if(unProfound){

}
if(ccProfound){

}
if(locProfound){

}
}

set<id> accid = new set<id>();
List<Applicant__c> lstapp = [select Account__c, 
Account__r.Jamaican_Tax_Registration_Number__pc,
Account__r.Political_Exposure__pc,
Account__r.FinServ__Age__pc,
Account__r.Highest_Level_of_Education_attained__pc,
Account__r.Status_of_Address__c,
Account__r.Years_at_Residence__c,
Account__r.Industry_of_Employment__pc,
Gross_Monthly_IncomeC__c,
Sanction_Screening_has_Negative_Trace__c,
Credit_History_in_last_24_Months__c,
Assessment_of_Applicant_Net_Worth__c
from Applicant__c where Opportunity__c=:oppid];
//if salared
// Industry_of_Employment__pc
// 
if(lstapp.size()>0){
system.debug('Naresh## lstapp================>'+lstapp);
for(Applicant__c a:lstapp){
accid.add(a.Account__c);
}
}



List<FinServ__Employment__c> lstemp = [select
Income_type__c,
FinServ__EmploymentStatus__c,
Industry__c,
FinServ__LengthOfEmployment__c,
Account__c,
Professional_Category__c,
Assessment_of_Business_Working_Capita__c,
Nature_of_Engagement__c,
Financial_Preformance__c,
Financial_Statement_Support__c,
Length_of_Trade__c


from FinServ__Employment__c where Account__c IN:accid and Current_Employment__c=true];

if(lstemp.size()>0){
system.debug('Naresh## lstemp================>'+lstemp);
}

/*if Salared
//FinServ__EmploymentStatus__c,
//
//Professional_Category__c

*/
    /*(if Primary Income Type = Salaried ANDEmployment Status ≠Unemployed)"
FinServ__LengthOfEmployment__c,

*/
    /*
* "Y
(if Primary Income Type = Self-Employed)"
* Assessment_of_Business_Working_Capita__c
* Nature_of_Engagement__c
* Industry__c
* Financial_Preformance__c,
* Financial_Statement_Support__c
* Length_of_Trade__c
* 

return flag;
} */
    
    @AuraEnabled
    Public static List<CreditScoreHelper.WrapperScore> CalculateScore(String CalType,string oppid,string Total_Loan_Amount,string Market_Value_of_Vehicle, string Proposed_Starting_Limit,string PC_Deposit_Account_Balance,string Line_of_Credit_Starting_Limit,string PCL_Deposit_Account_Balance){
        system.debug('CalculateScore ==========called=>'+CalType+'......oppid...'+oppid);
        CreditScoreHelper csh = new CreditScoreHelper();
        List<CreditScoreHelper.WrapperScore> retlst = new List<CreditScoreHelper.WrapperScore>();
        retlst = csh.calculateScoreOnOpp(oppid,Total_Loan_Amount,Market_Value_of_Vehicle, Proposed_Starting_Limit, PC_Deposit_Account_Balance, Line_of_Credit_Starting_Limit, PCL_Deposit_Account_Balance);
        system.debug('retlst ==========called=>'+retlst);
        isRequiredFieldMissingForScore(oppid);
        return retlst;
    }
    
    @AuraEnabled  
    public static Boolean isRequiredFieldMissingForScore(string oppid){
        Boolean autoProfound=false;
        Boolean unProfound=false;
        Boolean ccProfound=false;
        Boolean locProfound=false;
        List<OpportunityLineItem> lstlineItem  =  [select name,Opportunityid,Product2.Name,TotalPrice from OpportunityLineItem where Opportunityid =: oppid];
        if(lstlineItem.size()>0){
            system.debug('Naresh## lstlineItem================>'+lstlineItem);
            for(OpportunityLineItem item:lstlineItem){
                system.debug('Naresh## item================>'+item.Name);
                if(item.Product2.Name =='JN Bank Auto Loan'){// 'Auto Loan';
                    autoProfound=true;
                }
                else if(item.Product2.Name =='JN Bank Unsecured Loan'){// 'Unsecured Loan';
                    unProfound=true;
                }
                else if(item.Product2.Name =='JN Visa - Classic'){// 'Credit Card';
                    ccProfound=true;
                }
                else if(item.Product2.Name =='JN Bank Line Of Credit'){// 'Line of Credit';
                    locProfound=true;
                }
            }
        }
        if(!locProfound && !unProfound && !ccProfound && !locProfound){
            system.debug('Required missing ===============>1');
            return true;
        }
        
        List<opportunity> lstopp = [select id,Collateral__r.RecordType.Name,
                                    Collateral_Personal_Line_of_Credit__r.RecordType.Name,
                                    Collateral_Personal_Credit_Card__r.RecordType.Name,
                                    Repayment_Method_Auto__c,
                                    Repayment_Method_CC__c,
                                    Repayment_Method_LOC__c,
                                    Repayment_Method_UL__c 
                                    from opportunity where id=:oppid limit 1];
        if(lstopp.size()>0){
            system.debug('Naresh## lstopp================>'+lstopp);
            if(autoProfound){
                if(lstopp[0].Collateral__r.RecordType.Name!='Motor Vehicle' || string.isEmpty(lstopp[0].Repayment_Method_Auto__c)){
                    system.debug('Required missing ===============>2');
                    return true;
                }
            }
            if(unProfound){
                if(string.isEmpty(lstopp[0].Repayment_Method_UL__c)){
                    system.debug('Required missing ===============>3'); 
                    return true;
                }
            }
            if(ccProfound){
                if(lstopp[0].Collateral_Personal_Credit_Card__r.RecordType.Name!='Savings/Current Accounts and Investments' || string.isEmpty(lstopp[0].Repayment_Method_CC__c)){
                    system.debug('Required missing ===============>4');
                    return true;
                }
            }
            if(locProfound){
                if(lstopp[0].Collateral_Personal_Line_of_Credit__r.RecordType.Name!='Real Estate' || string.isEmpty(lstopp[0].Repayment_Method_LOC__c)){
                    system.debug('Required missing ===============>5');
                    return true;
                }
            }
        }
        
        set<id> accid = new set<id>();
        List<Applicant__c> lstapp = [select Account__c, 
                                     Gross_Monthly_IncomeC__c,
                                     Credit_History_in_last_24_Months__c,
                                     Assessment_of_Applicant_Net_Worth__c
                                     from Applicant__c where Opportunity__c=:oppid];
        if(lstapp.size()>0){
            system.debug('Naresh## lstapp================>'+lstapp);
            for(Applicant__c a:lstapp){
                accid.add(a.Account__c);
                if(a.Gross_Monthly_IncomeC__c ==Null || string.isEmpty(a.Credit_History_in_last_24_Months__c) || string.isEmpty(a.Assessment_of_Applicant_Net_Worth__c)){
                    system.debug('Required missing ===============>6');
                    return true;
                }
            }
        }
        else{
            system.debug('Required missing ===============>7');
            return true;
        }
        
        
        
        List<FinServ__Employment__c> lstemp = [select
                                               Income_type__c,
                                               FinServ__EmploymentStatus__c,
                                               Industry__c,
                                               FinServ__LengthOfEmployment__c,
                                               Account__c,
                                               Professional_Category__c,
                                               Assessment_of_Business_Working_Capita__c,
                                               Nature_of_Engagement__c,
                                               Financial_Preformance__c,
                                               Financial_Statement_Support__c,
                                               Length_of_Trade__c,
                                               Account__r.Jamaican_Tax_Registration_Number__pc,                                              
                                               Account__r.FinServ__Age__pc,
                                               Account__r.Highest_Level_of_Education_attained__pc,
                                               Account__r.Status_of_Address__c,
                                               Account__r.Years_at_Residence__c,
                                               Account__r.Industry_of_Employment__pc
                                               from FinServ__Employment__c where Account__c IN:accid and Current_Employment__c=true];
        
        if(lstemp.size()>0){
            system.debug('Naresh## lstemp================>'+lstemp);
            for(FinServ__Employment__c e:lstemp){
                string cat = '';
                if(string.isEmpty(e.Income_type__c)){
                    system.debug('Required missing ===============>8');
                    return true;
                }else {
                    /*if(e.Account__r.FinServ__Age__pc==NULL || string.isEmpty(e.Account__r.Highest_Level_of_Education_attained__pc) || string.isEmpty(e.Account__r.Status_of_Address__c) || e.Account__r.Years_at_Residence__c ==NULL || string.isEmpty(e.Account__r.Jamaican_Tax_Registration_Number__pc)){
                        system.debug('Required missing ===============>9');
                        return true;
                    }*/
                    if(e.Income_type__c=='Salaried'){
                        if(string.isEmpty(e.Account__r.Industry_of_Employment__pc) || string.isEmpty(e.FinServ__EmploymentStatus__c) || string.isEmpty(e.Professional_Category__c)){
                            system.debug('Required missing ===============>10');
                            return true;
                        }
                    }
                    if(e.Income_type__c=='Salaried' && e.FinServ__EmploymentStatus__c!='Unemployed'){
                        if(e.FinServ__LengthOfEmployment__c==NULL){
                            system.debug('Required missing ===============>11');
                            return true;
                        }
                    }
                    if(e.Income_type__c=='Self-Employed'){
                        if(string.isEmpty(e.Industry__c) || e.Assessment_of_Business_Working_Capita__c ==NULL || string.isEmpty(e.Nature_of_Engagement__c) || string.isEmpty(e.Financial_Preformance__c) || string.isEmpty(e.Financial_Statement_Support__c) || string.isEmpty(e.Length_of_Trade__c)){
                            system.debug('Required missing ===============>12');
                            return true;
                        }
                    }
                }
            }
        }
        else{
            system.debug('Required missing ===============>13');
            return true;
        }
        /*if salared
Industry_of_Employment__pc//
FinServ__EmploymentStatus__c,//
Professional_Category__c//
if (Primary Income Type = Salaried AND Employment Status ≠Unemployed)"
FinServ__LengthOfEmployment__c,//



if (Primary Income Type = Self-Employed)
* Assessment_of_Business_Working_Capita__c//
* Nature_of_Engagement__c//
* Industry__c//
* Financial_Preformance__c,//
* Financial_Statement_Support__c//
* Length_of_Trade__c//
* */
        system.debug('Required missing ===============>No');
        return false;
    }  
    
    /* public class WrapperScore{
@AuraEnabled
public string Name{get;set;}
@AuraEnabled
public string Score{get;set;}
@AuraEnabled
public string Rating{get;set;}

WrapperScore(string Name1,string Score1,string Rating1){
this.Name=Name1;
this.Score=Score1;
this.Rating=Rating1;
}
}*/
    
    @AuraEnabled  
    public static Boolean SaveApplicationFormInOpp(string oppid){
        try{
            PageReference mypage = Page.ApplicationForm;
            mypage.getParameters().put('oppid', oppid);
            blob body = mypage.getContentAsPDF();
            system.debug('attach===='+OppId);
            Attachment attach = new Attachment();
            attach.Body = body;
            attach.ContentType='application/pdf';            
            attach.Name = 'ApplicationForm.pdf';
            attach.IsPrivate = false;
            attach.ParentId = oppid;
            insert attach;
            system.debug('attach===='+attach);
            return true;
        }
        catch(Exception ex){
            system.debug('Exception ======'+ex.getMessage()+'....Line Number=>'+ex.getLineNumber());           
        }
        return false;
    }
    @AuraEnabled  
    public static Boolean SaveMultiCalculatorpdf(string loancalcid,string idToSave){
        try{
            system.debug('idToSave===='+idToSave+'====loancalcid==>'+loancalcid);
            PageReference mypage = Page.MultiProductCalculatorDoc;
            mypage.getParameters().put('loanid', loancalcid);
            blob body = mypage.getContentAsPDF();
            
            Attachment attach = new Attachment();
            attach.Body = body;
            attach.ContentType='application/pdf';            
            attach.Name = 'MultiCalculatorpdf.pdf';
            attach.IsPrivate = false;
            attach.ParentId = idToSave;
            insert attach;
            system.debug('attach===='+attach);
            return true;
        }
        catch(Exception ex){
            system.debug('Exception ======'+ex.getMessage()+'....Line Number=>'+ex.getLineNumber());           
        }
        return false;
    }
    
    
    //public static Boolean SaveCreditScoringModelPDF(string oppid,string productname,string numberOfApplicant,string loanAmount,string Total_Loan_Amount1,string Market_Value_of_Vehicle1,string Proposed_Starting_Limit1,string PC_Deposit_Account_Balance1,string Line_of_Credit_Starting_Limit1,string PCL_Deposit_Account_Balance1){
    @AuraEnabled  
    public static Boolean SaveCreditScoringModelPDF(string oppid,string productname,string numberOfApplicant){
        try{
            system.debug('SaveCreditScoringModelPDF===='+oppid);
            PageReference mypage = Page.CreditScoringModel;
            mypage.getParameters().put('productName', productname);
            mypage.getParameters().put('numberOfApplicant', numberOfApplicant);
            //mypage.getParameters().put('loanAmount', loanAmount);
            mypage.getParameters().put('oppid', oppid);
            //mypage.getParameters().put('Total_Loan_Amount', Total_Loan_Amount1);
            //mypage.getParameters().put('marketValue', Market_Value_of_Vehicle1);
            //mypage.getParameters().put('proposedStarting', Proposed_Starting_Limit1);
            //mypage.getParameters().put('pcDeposit', PC_Deposit_Account_Balance1);
            //mypage.getParameters().put('locStarting', Line_of_Credit_Starting_Limit1);
            //mypage.getParameters().put('pclDeposit', PCL_Deposit_Account_Balance1);
            
            blob body = mypage.getContentAsPDF();
            
            Attachment attach = new Attachment();
            attach.Body = body;
            attach.ContentType='application/pdf';            
            attach.Name = 'CreditScoringModel'+productname.replaceAll(' ','')+'.pdf';
            attach.IsPrivate = false;
            attach.ParentId = oppid;
            insert attach;
            system.debug('attach===='+attach);
            return true;
        }
        catch(Exception ex){
            system.debug('Exception ======'+ex.getMessage()+'....Line Number=>'+ex.getLineNumber());           
        }
        return false;
    }
    
    @AuraEnabled  
    public static Boolean SaveCreditCalculationSavePDF(string oppid,string loanid){
        try{
            system.debug('SaveCreditCalculationSavePDF===='+oppid);
            PageReference mypage = Page.CreditCalculations;
            mypage.getParameters().put('oppid', oppid);
            mypage.getParameters().put('loanid', loanid);
            
            blob body = mypage.getContentAsPDF();
            
            Attachment attach = new Attachment();
            attach.Body = body;
            attach.ContentType='application/pdf';            
            attach.Name = 'CreditCalculation.pdf';
            attach.IsPrivate = false;
            attach.ParentId = oppid;
            insert attach;
            system.debug('attach===='+attach);
            return true;
        }
        catch(Exception ex){
            system.debug('Exception ======'+ex.getMessage()+'....Line Number=>'+ex.getLineNumber());           
        }
        return false;
    }
    @AuraEnabled  
    public static list<WrapperclsAssets> getApplicantAsset(string oppid){
        list<WrapperclsAssets> wrapperlstAssets= new list<WrapperclsAssets>();
        Loan_Calculator__c loanCalculation;
        Opportunity thisOpportunity = [SELECT Id,AccountId, Product_Details__c   from Opportunity where id = :oppid];
         System.debug('oppid'+oppid);
        System.debug('thisOpportunity'+thisOpportunity.Product_Details__c);
        
        
        Loan_Calculator__c[] productDetails = [SELECT Id, Market_Value_of_Vehicle__c, Total_Loan_Amount__c,
                                               Monthly_Loan_Payment__c, Unsecured_Loan_Amount__c,App_3_Monthly_Payment_UL__c,
                                               Unsecure_Monthly_Loan_Payment__c, Line_of_Credit_Starting_Limit__c,
                                               Minimum_Payment_as_per_Credit_Limit__c ,Type_of_LOC__c,App_3_Monthly_Payment_A__c,
                                               unsecure_Monthly_n_Loan_Savings__c , Monthly_Loan_Savings__c,App1_Loan_Amt_Alloc_UL__c,
                                               App_3_Loan_Amount_A__c,App_2_Loan_Amount_A__c,Minimum_Payment__c ,JN_Life_Creditor_Life_Premium__c,
                                               App_1_Loan_Amount_A__c,App_3_Min_Payment_LOC__c, App_1_Min_Payment__c,JNGI_Motor_Premium_1st_Year__c,
                                               App_2_Min_Payment_LOC__c, App1_Monthly_Payment_A__c, App_2_Monthly_Payment_A__c 
                                               FROM Loan_Calculator__c WHERE Id =: thisOpportunity.Product_Details__c ];
        if(productDetails.size() > 0) {
            loanCalculation = productDetails.get(0);
        } else {
            loanCalculation = new Loan_Calculator__c();
        }
        System.debug('loanCalculation'+loanCalculation);
        System.debug('loanCalculation'+thisOpportunity.Product_Details__c);
        //JN1-2755#1 :: Added new fields in the query
        list<Application_Asset_Liability__c> lst = [select Monthly_Payment_Prior__c,
                                                    Minimum_Payment__c,
                                                    Application__c,
                                                    Monthly_Payment_Prior_Calc_App_Portion__c,
                                                    Monthly_Payment_After_Calc_App_Portion__c,
                                                    Minimum_Payment_After__c,
                                                    Assets_and_Liabilities__r.RecordType.Name,
                                                    Assets_and_Liabilities__r.RecordType.DeveloperName,
                                                    Assets_and_Liabilities__r.Monthly_Payment_Prior__c,
                                                    Assets_and_Liabilities__r.Minimum_Payment__c,
                                                    Assets_and_Liabilities__r.Monthly_Payment__c,
                                                    Assets_and_Liabilities__r.Minimum_Payment_After__c,
                                                    Assets_and_Liabilities__r.Percent_Applicant_Portion__c
                                                    from Application_Asset_Liability__c where Application__r.Opportunity__c =:oppid];
        
        // JN1-2755#1 
        //list<Applicant__c> applst = [select id,Account__c,Gross_Monthly_IncomeC__c from Applicant__c where Opportunity__c=:oppid order by CreatedDate];
        list<Applicant__c> applst = [select id,Account__c,Gross_Monthly_IncomeC__c,Rent_Board_Strata_Before_TDSR__c,Rent_Board_Strata_After_TDSR__c from Applicant__c where Opportunity__c=:oppid order by CreatedDate];
        
        
        wrapperlstAssets.add( new WrapperclsAssets(lst, applst, loanCalculation, thisOpportunity.AccountId));
        system.debug('wrapperlstAssets'+wrapperlstAssets);
        return wrapperlstAssets;
    }
    public class WrapperclsAssets{
        @AuraEnabled
        public list<Application_Asset_Liability__c> ApplicationAssetLiability {get;set;}
        @AuraEnabled
        public list<Applicant__c> Applicantlst{get;set;}
        @AuraEnabled
        public Loan_Calculator__c  loanCalculation{get;set;}
        @AuraEnabled
        public String accountId{get;set;}
        WrapperclsAssets(list<Application_Asset_Liability__c> Application_Asset_Liability, list<Applicant__c> Applst){
            this.ApplicationAssetLiability=Application_Asset_Liability;
            this.Applicantlst=Applst;
            
        }
        WrapperclsAssets(list<Application_Asset_Liability__c> Application_Asset_Liability, 
                         list<Applicant__c> Applst, Loan_Calculator__c  loanCalculation, String accountId)
        {
            this.ApplicationAssetLiability=Application_Asset_Liability;
            this.Applicantlst=Applst;
            this.loanCalculation=loanCalculation;
            this.accountId=accountId;         
            
        }
    }
    @AuraEnabled
    Public static List<string> getLocationValues(){
        List<string> optionlist= new list<string>();
        Schema.DescribeFieldResult F = Lead.Preferred_Location__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();
        List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry pv : entries) {
            optionlist.add(pv.getValue());
        }
        optionlist.add('Choose one...');
        return optionlist;
    }
}