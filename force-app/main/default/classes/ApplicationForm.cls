public class ApplicationForm {
    Public static integer isFirst=1;
    public List<WrapperApplicationForm> lst{get;set;}
    public List<Loan_Calculator__c> ProductDetails{get;set;}
    Integer Appcount=1;
    public Date currentDate{get;set;}
    public Boolean isAutoFound{get;set;}
    public Boolean isUnFound{get;set;}
    public Boolean isCcFound{get;set;}
    public Boolean isLocFound{get;set;}
    public List<Account> emergencyContacts{get;set;}
    public Integer totalNumberOfAppli{get;set;}
    public string mypdf='';
    public  ApplicationForm(){
        lst = new List<WrapperApplicationForm>();
        ProductDetails = new List<Loan_Calculator__c>();
        currentDate = system.today();  
        isAutoFound=false;
        isUnFound=false;
        isCcFound=false;
        isLocFound=false;
        totalNumberOfAppli=0;
        
        if(ApexPages.currentPage().getParameters().containsKey('oppid')){
            string oppid=ApexPages.currentPage().getParameters().get('oppid');
            system.debug('oppid ====>'+oppid);
            if(string.isNotBlank(oppid)){
                ApplicationForm(oppid); 
                fillProductDetails(oppid);
               // if(!CreditScoreHelper.FirstRun){
                   // CreditScoreHelper.FirstRun=true;
                    //saveAttachement(oppid);
                    
                //}
                
            }     
        }
    }
    public void ApplicationForm1(){
        lst = new List<WrapperApplicationForm>();
        ProductDetails = new List<Loan_Calculator__c>();
        currentDate = system.today();  
        isAutoFound=false;
        isUnFound=false;
        isCcFound=false;
        isLocFound=false;
        totalNumberOfAppli=0;
        
        if(ApexPages.currentPage().getParameters().containsKey('oppid')){
            string oppid=ApexPages.currentPage().getParameters().get('oppid');
            system.debug('oppid ====>'+oppid);
            if(string.isNotBlank(oppid)){
                ApplicationForm(oppid); 
                fillProductDetails(oppid);
                
            }     
        }
    }
    
    
    Public void ApplicationForm(string oppid){
        Map<id,List<FinServ__ContactContactRelation__c>> AccidVsEmrConLst = new  Map<id,List<FinServ__ContactContactRelation__c>>();
        Map<id,List<FinServ__Employment__c>> AccidVsEmpLst = new  Map<id,List<FinServ__Employment__c>>();
        Map<id,List<FinServ__ContactContactRelation__c>> MapPoliExpo = new  Map<id,List<FinServ__ContactContactRelation__c>>();
        Map<id,List<FinServ__ContactContactRelation__c>> MapBankAff = new  Map<id,List<FinServ__ContactContactRelation__c>>();
        set<id> accid = new set<id>();
        set<id> conid = new set<id>();
        List<Applicant__c> lstapp = [select Account__c,Account__r.FinServ__PrimaryContact__c,Account__r.PersonContactId from Applicant__c where Opportunity__c=:oppid];
        if(lstapp.size()>0){
            totalNumberOfAppli = lstapp.size();
            
            
            for(Applicant__c a:lstapp){
                accid.add(a.Account__c);
                conid.add(a.Account__r.PersonContactId);        
            }
            
        }
        system.debug('accid======'+accid);
        system.debug('conid============='+conid);   
        if(conid.size()>0){
            Set<id> accountIds = new Set<Id>();
            List<FinServ__ContactContactRelation__c> EmergencyContactlst = [select FinServ__RelatedContact__c,
                                                                            FinServ__Contact__r.FirstName,
                                                                            FinServ__RelatedContact__r.Account.Id,
                                                                            FinServ__RelatedContact__r.LastName,
                                                                            FinServ__RelatedContact__r.MiddleName,
                                                                            FinServ__RelatedContact__r.Account.Emergency_Contact_Relationship__pc,
                                                                            FinServ__RelatedContact__r.Account.Street_1__pc,
                                                                            FinServ__RelatedContact__r.Account.Street_2__pc,
                                                                            FinServ__RelatedContact__r.Account.Street_3__pc,
                                                                            FinServ__RelatedContact__r.Account.City_Town__pc,
                                                                            FinServ__RelatedContact__r.Account.Residential_Area_District__pc,
                                                                            FinServ__RelatedContact__r.Account.Post_Office_Zip_Code__pc,        
                                                                            FinServ__RelatedContact__r.Account.Province_Parish_State__pc,
                                                                            FinServ__RelatedContact__r.Account.PersonMobilePhone,
                                                                            FinServ__RelatedContact__r.Account.Business_Phone__pc,
                                                                            FinServ__RelatedContact__r.Account.PersonHomePhone,
                                                                            FinServ__RelatedContact__r.Account.Personal_Email__c,
                                                                            FinServ__RelatedContact__r.Account.PersonOtherPhone,
                                                                            FinServ__RelatedContact__r.Account.FinServ__CountryOfBirth__pc
                                                                            from FinServ__ContactContactRelation__c where FinServ__RelatedContact__c IN:conid 
                                                                            and FinServ__Role__r.Name='Emergency Contact' ];
            system.debug('EmergencyContactlst===>'+EmergencyContactlst);
            Set<id> emergencyAccountIds = new Set<Id>();
            if(EmergencyContactlst.size()>0){
                for(FinServ__ContactContactRelation__c c:EmergencyContactlst){
                    emergencyAccountIds.add(c.FinServ__RelatedContact__r.Account.Id);
                    if(AccidVsEmrConLst.containsKey(c.FinServ__RelatedContact__c)){
                        List<FinServ__ContactContactRelation__c> aclst = AccidVsEmrConLst.get(c.FinServ__RelatedContact__c);
                        if(aclst.size()<2){
                            aclst.add(c);
                            AccidVsEmrConLst.put(c.FinServ__RelatedContact__c,aclst);
                        }
                    }
                    else{
                        List<FinServ__ContactContactRelation__c> aclst = new List<FinServ__ContactContactRelation__c>();
                        aclst.add(c);
                        AccidVsEmrConLst.put(c.FinServ__RelatedContact__c,aclst);
                    }
                }
            }
            this.emergencyContacts = [SELECT  Id,
             FirstName,
             LastName,
             MiddleName,
             Emergency_Contact_Relationship__pc,
             Street_1__pc,
             Street_2__pc,FinServ__CountryOfBirth__pc,
                                      Street_3__pc,
                                      City_Town__pc,
                                      Residential_Area_District__pc,
                                      Post_Office_Zip_Code__pc,        
                                      Province_Parish_State__pc,
                                      PersonMobilePhone,
                                      Business_Phone__pc,
                                      PersonHomePhone,
                                      Personal_Email__c,
                                      PersonOtherPhone
                                      
             from Account where id in :emergencyAccountIds];
            
            
            List<FinServ__ContactContactRelation__c> PoliExpolst = [select FinServ__RelatedContact__c,
                                                                    FinServ__Contact__r.FirstName,
                                                                    FinServ__Contact__r.LastName,
                                                                    FinServ__Contact__r.MiddleName,
                                                                    FinServ__Contact__r.Political_Exposure__c,
                                                                    FinServ__Contact__r.Account.Political_Affiliation_Role__pc,
                                                                    FinServ__Contact__r.Account.Political_Affiliation_Relationship__pc
                                                                    from FinServ__ContactContactRelation__c where FinServ__RelatedContact__c IN:conid and FinServ__Role__r.Name='Political Affiliation'];
            
            if(PoliExpolst.size()>0){
                for(FinServ__ContactContactRelation__c pa:PoliExpolst){
                    List<FinServ__ContactContactRelation__c> lst = new List<FinServ__ContactContactRelation__c>();
                    lst.add(pa);
                    MapPoliExpo.put(pa.FinServ__RelatedContact__c,lst);
                }
            }
            
            
            
            List<FinServ__ContactContactRelation__c> BankAffilst = [select FinServ__RelatedContact__c,
                                                                    FinServ__Contact__r.FirstName,
                                                                    FinServ__Contact__r.LastName,
                                                                    FinServ__Contact__r.MiddleName,
                                                                    FinServ__Contact__r.JN_Bank_Affiliation__c,
                                                                    FinServ__Contact__r.Account.JN_Bank_Affiliated_Location__pc,
                                                                    FinServ__Contact__r.Account.JN_Bank_Affiliation_Relationship__pc
                                                                    from FinServ__ContactContactRelation__c where FinServ__RelatedContact__c IN:conid and FinServ__Role__r.Name='JN Affiliation'];
            
            if(BankAffilst.size()>0){
                for(FinServ__ContactContactRelation__c pa:BankAffilst){
                    List<FinServ__ContactContactRelation__c> lst = new List<FinServ__ContactContactRelation__c>();
                    lst.add(pa);
                    MapBankAff.put(pa.FinServ__RelatedContact__c,lst);
                }
            }
            
        }
        
        if(accid.size()>0){   
            List<FinServ__Employment__c>  Employmentlst = [select id,
                                                           RecordType.Name,
                                                           Income_Type__c,
                                                           Account__c,
                                                           Current_Employment__c,
                                                           Name,
                                                           FinServ__Position__c,
                                                           FinServ__EmploymentStatus__c,
                                                           Professional_Category__c,
                                                           FinServ__StartDate__c,
                                                           FinServ__EndDate__c,
                                                           Industry__c,
                                                           Time_in_Industry__c,
                                                           Time_Employed_in_Present_Industry_Months__c,
                                                           FinServ__Occupation__c,
                                                           Business_Number_1__c,
                                                           Business_Number_2__c,
                                                           Street_1__c,
                                                           Street_2__c,
                                                           Street_3__c,
                                                           City_Town__c,
                                                           Residential_Area_District__c,
                                                           Post_Office_Zip_Code__c,
                                                           Province_Parish_State__c,
                                                           Country__c,
                                                           Length_of_Trade__c,
                                                           Nature_of_Engagement__c,
                                                           Type_of_Business__c,Time_Employed_with_Current_Employer__c,
                                                           Date_of_Incorporation__c,Time_Employed_in_Present_Employer_M__c
                                                           from FinServ__Employment__c where Account__c IN:accid];
            
            if(Employmentlst.size()>0) {
                SetCalendarValues(Employmentlst);
                for(FinServ__Employment__c c:Employmentlst){
                    if(AccidVsEmpLst.containsKey(c.Account__c)){
                        List<FinServ__Employment__c> aclst = AccidVsEmpLst.get(c.Account__c);
                        aclst.add(c);
                        AccidVsEmpLst.put(c.Account__c,aclst);
                    }
                    else{
                        List<FinServ__Employment__c> aclst = new List<FinServ__Employment__c>();
                        aclst.add(c);
                        AccidVsEmpLst.put(c.Account__c,aclst);
                    }
                }
            } 
            
            List<Account> ApplicantPersonAccount =[select id,
                                                   FinServ__PrimaryContact__c,
                                                   Salutation,
                                                   FirstName,
                                                   LastName,
                                                   MiddleName,
                                                   Middle_Name__pc,
                                                   FinServ__Gender__pc,
                                                   Suffix__pc,
                                                   FinServ__MaritalStatus__pc,
                                                   Date_of_Birth__pc,
                                                   Place_of_Birth__pc,
                                                   FinServ__MotherMaidenName__pc,
                                                   FinServ__NumberOfDependents__pc,
                                                   Number_of_Dependent_Children__c,
                                                   Country_of_Citizenship__pc,
                                                   Country_of_Residency__pc,
                                                   Highest_Level_of_Education_attained__pc,
                                                   Primary_Employment_Type__pc,
                                                   Identification_Type__pc,
                                                   Identification_Number__pc,
                                                   Identification_Type_Expiration__pc,
                                                   Identification_Type_Country_of_issue__pc,
                                                   Jamaican_Tax_Registration_Number__pc,
                                                   Street_1__pc,
                                                   Street_2__pc,
                                                   Street_3__pc,
                                                   City_Town__pc,
                                                   Residential_Area_District__pc,
                                                   Post_Office_Zip_Code__pc,
                                                   Province_Parish_State__pc,
                                                   FinServ__CountryOfBirth__pc,
                                                   Years_at_Residence__pc,
                                                   Status_of_Address__c,
                                                   PersonMobilePhone,
                                                   PersonHomePhone,
                                                   Business_Phone__pc,
                                                   Personal_Email__c,
                                                   PersonOtherPhone
                                                   from Account where id IN:accid];
            if(ApplicantPersonAccount.size()>0){
                for(Account a:ApplicantPersonAccount){
                    Account pa = new Account();
                    List<FinServ__ContactContactRelation__c> EmerConlst = new List<FinServ__ContactContactRelation__c>();
                    List<FinServ__Employment__c>  emplst = new List<FinServ__Employment__c>();
                    List<FinServ__ContactContactRelation__c> PoliEx = new List<FinServ__ContactContactRelation__c>();
                    List<FinServ__ContactContactRelation__c> BankAff = new List<FinServ__ContactContactRelation__c>();
                    pa = a;
                    system.debug('Account id ==>'+a.id);
                    if(AccidVsEmrConLst.containsKey(a.FinServ__PrimaryContact__c)){
                        EmerConlst=AccidVsEmrConLst.get(a.FinServ__PrimaryContact__c);
                    }
                    if(AccidVsEmpLst.containsKey(a.id)){
                        emplst = AccidVsEmpLst.get(a.id);
                    }
                    if(MapPoliExpo.containsKey(a.FinServ__PrimaryContact__c)){
                        PoliEx=MapPoliExpo.get(a.FinServ__PrimaryContact__c);
                    }
                    if(MapBankAff.containsKey(a.FinServ__PrimaryContact__c)){
                        BankAff=MapBankAff.get(a.FinServ__PrimaryContact__c);
                    }
                    
                    system.debug('Person Account ==>'+pa);
                    system.debug('EmerConlst ==>'+EmerConlst);
                    system.debug('emplst ==>'+emplst);
                    system.debug('PoliticalExp ==>'+PoliEx);
                    system.debug('BankAff ==>'+BankAff);
                    
                    lst.add(new WrapperApplicationForm(Appcount,pa,EmerConlst,emplst,PoliEx,BankAff));
                    Appcount= Appcount+1;
                }
            }
        }
        system.debug('Final Wrapper =======>'+lst);
    }
    private static void SetCalendarValues(List<FinServ__Employment__c>  records){
        Map<String, Integer> values;
        for(FinServ__Employment__c record: records){
            if(record.Current_Employment__c){
            values = Util.GetYearValues(record.FinServ__StartDate__c, Date.today());
            record.Time_Employed_with_Current_Employer__c  = values.get('years');
            record.Time_Employed_in_Present_Employer_M__c  = values.get('months');
            } else {
                            record.Time_Employed_with_Current_Employer__c  = 0;
            record.Time_Employed_in_Present_Employer_M__c  = 0;
            }
        }
    }
    public class WrapperApplicationForm{
        public Integer Appcount{get;set;}
        public Account ApplicantPersonAccount{get;set;}
        public string howLongMonth{get;set;}
        public List<FinServ__ContactContactRelation__c> ApplicantPAEmergencyContact{get;set;}
        public List<FinServ__Employment__c> EmploymentDetails{get;set;}
        public List<FinServ__ContactContactRelation__c> PoliticalExposure{get;set;}
        public List<FinServ__ContactContactRelation__c> BankAffiliation{get;set;}
        WrapperApplicationForm(Integer Appcount,Account ApplicantPersonAccount1,List<FinServ__ContactContactRelation__c> ApplicantPAEmergencyContact1,List<FinServ__Employment__c> EmploymentDetails1,List<FinServ__ContactContactRelation__c> PoliticalExposure1,List<FinServ__ContactContactRelation__c> BankAffiliation1){
            this.Appcount = Appcount;
            this.ApplicantPersonAccount=ApplicantPersonAccount1;
            this.ApplicantPAEmergencyContact=ApplicantPAEmergencyContact1;
            this.EmploymentDetails=EmploymentDetails1;
            this.PoliticalExposure = PoliticalExposure1;
            this.BankAffiliation = BankAffiliation1;
            if(ApplicantPersonAccount1.Years_at_Residence__pc !=NULL){
                system.debug('==============='+ApplicantPersonAccount1.Years_at_Residence__pc);
                this.howLongMonth='';
                string aa = string.valueOf(ApplicantPersonAccount1.Years_at_Residence__pc);
                String afterDecimal = aa.substringAfter('.');
                system.debug('arrayOfProducts==============='+afterDecimal);
                Integer b = Integer.valueOf(afterDecimal);
                if(b>0)
                    this.howLongMonth = afterDecimal; 
                else
                    this.howLongMonth = '0';
            }
        }
    }
    
    public void fillProductDetails(string oppid){
        List<opportunity> opplst = [select Product_Details__c from opportunity where id=:oppid];
        if(opplst.size()>0){
            if(string.isNotBlank(opplst[0].Product_Details__c)){
                string loanid = opplst[0].Product_Details__c;
                system.debug('loanid====='+loanid);
                ProductDetails = [select id,
                                  Nick_Name_Of_Calculation__c,
                                  Will_card_used_by_authorized_cardholders__c,
                                  Lead_and_Referral__c,
                                  Opportunity__c,
                                  Monthly_Gross_Income__c,
                                  Existing_Monthly_Credit_Payment__c,
                                  Auto_Loan_Purpose__c,
                                  Market_Value_of_Vehicle__c,
                                  Motor_Vehicle_Deposit__c,
                                  Motor_Vehicle_Deposit_Percentage__c,
                                  Interested_in_programme__c,
                                  Include_first_year_premium_in_loan_amt__c,
                                  Monthly_Premium__c,
                                  Interested_in_Creditor_Life__c,
                                  Coverage_Type__c,
                                  Include_in_Loan_Amount_jnlife__c,
                                  Waive_Process_Fee__c,
                                  Include_in_Loan_Amount_Processing_Fee__c,
                                  Indicate_applicable_process_fee_percent__c,
                                  Include_a_moratorium_of_Loan_Payment__c,
                                  Moratorium_Indicate_Term__c,
                                  Proposed_Savings__c,
                                  Proposed_SavingsPercentage__c,
                                  Interest_Rate__c,
                                  Years__c,
                                  Months__c,
                                  Loan_Amount__c,
                                  Deduct_1st_moth_Payment_from_Loan__c,
                                  unsecure_Loan_Purpose__c,
                                  unsecure_Jn_Life_Creditor_Life_Insurance__c,
                                  Unsecure_Coverage_Type__c,
                                  Unsecure_Include_in_Loan_Amount__c,
                                  Unsecure_Waive_Processing_Fee__c,
                                  Unsecure_Indcate_applicable_process_fee__c,
                                  Unsecure_Loan_Savings_currency__c,
                                  Unsecure_Proposed_Savings__c,
                                  Unsecure_Proposed_Savings_percentage__c,
                                  Unsecure_Market_Per_Annum__c,
                                  Unsecure_Years__c,
                                  Unsecure_Months__c,
                                  PC_Credit_Limit__c,
                                  PC_Credit_Limit_Amount__c,
                                  Reqeusted_Limit__c,
                                  PC_Interest_Rate__c,
                                  Number_of_Supplementary_Applicant__c,
                                  PC_Collateral_Type__c,
                                  PC_Type_of_Cash_Secured_Collateral__c,
                                  PC_Deposit_Account_Balance__c,
                                  PC_Account_Hypothecated_for_another_Loan__c,
                                  PC_Total_existing_Loan_Balance__c,
                                  Proposed_Starting_Limit__c,
                                  PCL_Requested_Credit_Limit__c,
                                  PLC_Credit_Limit_Currency__c,
                                  PCL_Interest_Rate__c,
                                  PCL_Collateral_Type__c,
                                  PCL_Type_of_Cash_Secured_Collateral__c,
                                  PCL_Deposit_Account_Balance__c,
                                  PCL_Account_Hypothecated_another_Loan__c,
                                  PCL_Total_Existing_Loan_Balance__c,
                                  Purchase_Price_of_Vehicle__c,
                                  Processing_Fees_including_GCT__c,
                                  Total_Loan_Amount__c,
                                  Monthly_Loan_Savings__c,
                                  Monthly_loan_Payment_Monthly_Savings__c,
                                  Total_Loan_Savings_Balance__c,
                                  Total_Interest_Payment__c,
                                  Legal_Fees_Including_GCT__c,
                                  Stamp_Duty__c,
                                  Total_Auto_Loan_Fees_Charges__c,
                                  Indicate_Type__c,
                                  JN_Staff1_intereste_rate__c,
                                  JN_Staff1_loan_term__c,
                                  JN_Life_Creditor_Life_Premium__c,
                                  JN_life_Creditor_Life_Premium_moratorium__c,
                                  Monthly_JNGI_Motor_Premium_moratorium__c,
                                  Monthly_JNGI_Motor_Premium_1_12_Pay__c,
                                  Monthly_JN_Life_Creditor_Life_Premium__c,
                                  Monthly_Processing_Fees_moratorium__c,
                                  Monthly_Loan_Payment__c,
                                  Unsecured_Loan_Amount__c,
                                  Unsecure_Fee_Include_in_Loan_Amount__c,
                                  unsecure_Total_Loan_Amount__c,
                                  Unsecure_Monthly_Loan_Payment__c,
                                  unsecure_Monthly_Loan_Savings__c,
                                  unsecure_Total_Loan_Savings_Balance__c,
                                  unsecure_Total_Interest_Payment__c,
                                  unsecure_Legal_Fees_Including_GCT__c,
                                  Stamp_Duty_Security_Documents__c,
                                  Total_unsecured_Loan_Fee_Charges__c,
                                  JNGI_Motor_Premium_1st_Year__c,
                                  Staff1_Mthly_Loan_Payment_D_Moratorium__c,
                                  Staff1_Mthly_Loan_Payment_A_Moratorium__c,
                                  Staff2_Mthly_Loan_Payment_D_Moratorium__c,
                                  Staff2_Mthly_Loan_Payment_A_Moratorium__c,
                                  Staff3_Mthly_Loan_Payment_D_Moratorium__c,
                                  Staff3_Mthly_Loan_Payment_A_Moratorium__c,
                                  Desired_Monthly_Repayment_Date__c,
                                  Make_and_Model_of_Motor_Vehicle__c,
                                  Repayment_Method_Auto__c,
                                  Vehicle_Classification__c,
                                  Year_of_Motor_Vehicle__c,
                                  Desired_Monthly_Repayment_Date_UL__c,
                                  Repayment_Method_UL__c,
                                  interest_in_JN_Life_CC_Creditor_Life_iIn__c,
                                  Account_Number__c,
                                  Account_Holders__c,
                                  Account_Type__c,
                                  Annual_Interest_Rate_on_Deposit_Account__c,
                                  Financial_Institution__c,
                                  Financial_Institution_LOC__c,
                                  Account_Holders_LOC__c,
                                  Annual_Interest_Rate_on_Deposit_Acc_LOC__c,
                                  Desired_Monthly_Repayment_Date_LOC__c,
                                  Name_of_Valuer__c,
                                  Occupancy_Type__c,
                                  Property_Classification__c,
                                  Property_Title_Information_Folio__c,
                                  Property_Title_information_Vol__c,
                                  Forced_Sale_Value__c,
                                  Insurer__c,
                                  Is_a_Lien_on_Property__c,
                                  Is_Property_a_Strata__c,
                                  Replacement_Value__c,
                                  Security_Address__c,
                                  Market_Value_of_Property__c,
                                  unsecure_JN_Life_Creditor_Life_Premium__c,
                                  JN_Promotion_Auto__c,
                                  JN_Promotion_UL__c,
                                  JN_Promotion_CC__c,
                                  JN_Promotion_LOC__c,
                                  Desired_Statement_Date__c,
                                  Legal_Related_Activities__c,
                                  Date_of_Last_Valuation__c,
                                  JN_Promotion_Auto__r.name,
                                  JN_Promotion_UL__r.name,
                                  JN_Promotion_CC__r.name,
                                  JN_Promotion_LOC__r.name
                                  from Loan_Calculator__c where id =:loanid and RecordType.Name='Product Details' order by createddate desc];
                if(ProductDetails.size()>0){
                    isAutoFound= (ProductDetails[0].Auto_Loan_Purpose__c != NULL)?True:False;
                    isUnFound= (ProductDetails[0].unsecure_Loan_Purpose__c != NULL)?True:False;
                    isCcFound= (ProductDetails[0].PC_Credit_Limit_Amount__c != NULL)?True:False;
                    isLocFound= (ProductDetails[0].PCL_Requested_Credit_Limit__c != NULL)?True:False;
                }
                system.debug('ProductDetails====='+ProductDetails);
            }
        }
    }
    
   /* public void callfuturemethod(){
        string OppId;
        if(ApexPages.currentPAge().getParameters().get('oppid')!=null){
            OppId = ApexPages.currentPAge().getParameters().get('oppid');
            // ApplicationForm1();
            
            creatingPdfBlob();
            //PageReference mypage = Page.ApplicationForm;
              //mypage.getParameters().put('oppid', OppId);
            
            //blob body = blob.toPDF(str);// mypage.getContentAsPDF(); //
            //system.debug('Myblob 1====>'+body); 
            saveAttachement(oppid);
            
        } 
    }*/
    //@Future(callout=true)
    public static void saveAttachement(string oppid){
         PageReference mypage = Page.ApplicationForm;
              mypage.getParameters().put('oppid', oppid);
        blob body = mypage.getContentAsPDF();
        //id PageOppId;
        //  if(ApexPages.currentPAge().getParameters().get('oppid')!=null){
        // PageOppId = ApexPages.currentPAge().getParameters().get('oppid');
        //ApplicationForm1();
        system.debug('attach===='+OppId);
        //PageReference pdf = Page.ApplicationForm;
        Attachment attach = new Attachment();
        //Blob body;
        //body = pdf.getContentAsPDF();
        attach.Body = body;
        attach.ContentType='application/pdf';
        
        attach.Name = 'ApplicationForm.pdf';
        attach.IsPrivate = false;
        attach.ParentId = oppid;
        insert attach;
        system.debug('attach===='+attach);
        //}
    }  
    
    public string str='';
    public void creatingPdfBlob(){
        str +='<div class="footer">';
        str +='<div style="text-align:left;font-size:15px;">'+Label.ApplicationFormText+'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
        str +='<span class="pagenumber"/> of <span class="pagecount"/>   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Applicant Initial:';
        str +=' </div>';
        str +='<div style="text-align:right;">_____________________&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>';
        str +=' </div>';
        str +='';
    }
    
}