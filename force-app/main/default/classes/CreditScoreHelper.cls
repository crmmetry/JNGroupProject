public class CreditScoreHelper {
    
    public static Boolean FirstRun=false;
    public static Boolean FirstRunAcc=false;
    string category=''; 
    string Age1='0'; 
    string Education=''; 
    string ResidentialStatus=''; 
    string Yearsatcurrentresidence1='0'; 
    string CreditHistory1='0'; 
    string NetWorth=''; 
    string EmploymentStatus=''; 
    string IndustryofEmployment=''; 
    string ProfessionalCategory=''; 
    string Collateral=''; 
    Decimal LoantoValue1=0;
    Decimal Abilitytoservice1=0;
    string RepaymentMethod='';
    string LengthofCurrentEmployment1='0'; 
    string ProductSelection='';  
    String WorkingCapital=''; 
    string NatureEngagement='';
    string TypeIndustry='';
    string FinancialPerformance=''; 
    string FinancialSupport=''; 
    string LengthTrade1='0'; 
    string PoliticallyExposed=''; 
    string NegaticeTrace=''; 
    List<opportunity> lstopp = new  List<opportunity>();
    List<Account> lstacc = new List<Account>();
    List<FinServ__Employment__c> lstemp = new List<FinServ__Employment__c>();
    List<OpportunityLineItem> lstlineItem = new List<OpportunityLineItem>();
    
    Map<id,Account> accmap = new Map<id,Account>();
    Map<id,FinServ__Employment__c> empmap = new Map<id,FinServ__Employment__c>();
    Map<id,List<OpportunityLineItem>> oppLineItem = new Map<id,List<OpportunityLineItem>>();
    set<id> accid = new set<id>();
    Map<id,List<id>> oppIdVsAccidLst = new Map<id,List<id>>();
    Map<id,List<FinServ__AssetsAndLiabilities__c>> accVsAssets = new Map<id,List<FinServ__AssetsAndLiabilities__c>>();
    map<string, Decimal> tdsrmapacc= new map<string, Decimal>();
    public List<Credit_Calculation__mdt> metalst = new List<Credit_Calculation__mdt>();
    public List<Credit_Calculation__mdt> metalsta2s = new List<Credit_Calculation__mdt>();
    public List<Credit_Calculation__mdt> metalst2oppProduct = new List<Credit_Calculation__mdt>();
    Map<id,Applicant__c> accidvsApplication = new Map<id,Applicant__c>();
    Map<id,Loan_Calculator__c> PdIDVsProductDetails = new Map<id,Loan_Calculator__c>();
    set<id> loancalcid = new set<id>();
    
    public Decimal Total_Loan_Amount=0;
    public Decimal Market_Value_of_Vehicle=0;
    public Decimal Proposed_Starting_Limit=0;
    public Decimal PC_Deposit_Account_Balance=0;
    public Decimal Line_of_Credit_Starting_Limit=0;
    public Decimal PCL_Deposit_Account_Balance=0;
    List<Credit_Rating__mdt> lstRating = new List<Credit_Rating__mdt>();
    //==================Credit Scoring Model ===============================
    public List<List<WrapperScoringModel>> AppScore = new List<List<WrapperScoringModel>>();
    
    public string ProductTypeOfScoringModel='';
    
    public List<WrapperScoringModel> ApplicantScorelist = new List<WrapperScoringModel>();
    Map<string,List<WrapperScoringModel>> MapAppScore = new Map<string,List<WrapperScoringModel>>();   
    
    Map<string,List<WrapperScoringModel>> MapProductScore = new Map<string,List<WrapperScoringModel>>();   
    
    
    public void CreditScoreFromOpp(Set<id> oppid){
        system.debug('Test## Credit score Helper called  with opp id = '+oppid);
        List<opportunity> lstToUpdate = new List<opportunity>();
        Map<id,Account> accMaptoUpdate = new Map<id,Account>();
        fillmetalst();
        fillOpp(oppid);
        FillAssets(oppid);
        fillLoanCalculators();
        fillProductType(oppid);
        fillApplicant(oppid);
        
        if(accid.size()>0){
            fillAcc(accid);
            fillAssets(accid);
            fillEmp(accid);
            //getAbilitytoServicePerApplicant();
        }
        
        if(lstopp.size()>0){
            for(opportunity o:lstopp){
                system.debug('Test## Account accosted with opportunity have application =======opp is ======>'+o);
                if(accidvsApplication.containsKey(o.AccountId)){
                    system.debug('Test## Account accosted with opportunity have application =============>');
                    AppScore = new List<List<WrapperScoringModel>>();
                    Decimal Applicant1SubTotalWeightedScore =0;
                    Decimal Applicant2SubTotalWeightedScore=0;
                    Decimal Applicant3SubTotalWeightedScore=0;
                    Integer count=1;
                    Integer numberOfApplicant=0;
                    Decimal TotalIncome=0;
                    Decimal Applicant1GrossMonthlyIncome=0;
                    Decimal Applicant2GrossMonthlyIncome=0;
                    Decimal Applicant3GrossMonthlyIncome=0;
                    
                    Decimal Applicant1PortionOfTotalIncome=0;
                    Decimal Applicant2PortionOfTotalIncome=0;
                    Decimal Applicant3PortionOfTotalIncome=0;
                    Decimal IncomeWeight1=0;
                    Decimal IncomeWeight2=0;
                    Decimal IncomeWeight3=0;
                    Decimal AllApplicantsSubTotalWeightedScore =0;
                    Boolean Politically_ExposedApp1=false;
                    
                    string name='';
                    string taxNumber=''; 
                    string grossIncome=''; 
                    string incomeType=''; 
                    string politcallyExposed='';
                    
                    
                    if(oppIdVsAccidLst.containsKey(o.Id)){
                        List<id> relatedAcc = oppIdVsAccidLst.get(o.Id);
                        system.debug('======================00===relatedAcc=='+relatedAcc);
                        if(relatedAcc.size()>0){
                             
                            
                            numberOfApplicant =relatedAcc.size();
                            for(id AcID:relatedAcc){
                                if(accmap.containsKey(AcID)){
                                    setBlank();
                                    Account acc = accmap.get(AcID);
                                    system.debug('Test## ========Account found==>'+acc);
                                    //=====================Score Model
                                    name = acc.Name;
                                    taxNumber = acc.Jamaican_Tax_Registration_Number__pc;
                                    politcallyExposed = (acc.Political_Exposure__pc)?'Yes':'No';
                                    //=====================Score 
                                    if(acc.FinServ__Age__pc != Null)
                                        Age1 = string.valueOf(acc.FinServ__Age__pc);
                                    if(string.isNotEmpty(acc.Highest_Level_of_Education_attained__pc))
                                        Education = EducationMaping(acc.Highest_Level_of_Education_attained__pc);
                                    if(string.isNotEmpty(acc.Status_of_Address__c))
                                        ResidentialStatus=StatusOfAddress(acc.Status_of_Address__c);
                                    if(acc.Years_at_Residence__c !=NUll)
                                        Yearsatcurrentresidence1= string.valueOf(acc.Years_at_Residence__c);
                                    if(string.isNotEmpty(acc.Industry_of_Employment__pc))
                                        IndustryofEmployment= acc.Industry_of_Employment__pc;
                                    
                                    
                                    if(accidvsApplication.containsKey(acc.id)){
                                        Applicant__c app= accidvsApplication.get(acc.id);
                                        
                                        if(app.Assessment_of_Applicant_Net_Worth__c != NULL)
                                            NetWorth= string.valueOf(app.Assessment_of_Applicant_Net_Worth__c);
                                        if(string.isNotEmpty(app.Sanction_Screening_has_Negative_Trace__c))
                                            NegaticeTrace = app.Sanction_Screening_has_Negative_Trace__c;
                                        if(string.isNotEmpty(app.Credit_History_in_last_24_Months__c))
                                            CreditHistory1=CreditHistory(app.Credit_History_in_last_24_Months__c);
                                        if(app.Gross_Monthly_IncomeC__c != null){
                                            TotalIncome += app.Gross_Monthly_IncomeC__c;
                                            grossIncome = string.valueOf(app.Gross_Monthly_IncomeC__c);
                                        }
                                        
                                        if(count==1){
                                            if(app.Gross_Monthly_IncomeC__c != null)
                                                Applicant1GrossMonthlyIncome = app.Gross_Monthly_IncomeC__c;
                                        }
                                        else if(count==2){
                                            if(app.Gross_Monthly_IncomeC__c != null)
                                                Applicant2GrossMonthlyIncome = app.Gross_Monthly_IncomeC__c;
                                        }
                                        else if(count==3){
                                            if(app.Gross_Monthly_IncomeC__c != null)
                                                Applicant3GrossMonthlyIncome = app.Gross_Monthly_IncomeC__c;
                                        }
                                    }
                                    
                                    if(empmap.containsKey(acc.id)){
                                        FinServ__Employment__c emp = empmap.get(acc.id);
                                        system.debug('Test## ========Employment found==>'+emp);
                                        if(!string.isEmpty(emp.Income_type__c)){
                                            category = emp.Income_type__c;
                                            incomeType = emp.Income_type__c;
                                        }
                                        if(string.isNotEmpty(emp.FinServ__EmploymentStatus__c))
                                            EmploymentStatus= emp.FinServ__EmploymentStatus__c;
                                        if(string.isNotEmpty(emp.Industry__c))
                                            TypeIndustry= emp.Industry__c;
                                        if(emp.FinServ__LengthOfEmployment__c != NULL)
                                            LengthofCurrentEmployment1=string.valueOf(emp.FinServ__LengthOfEmployment__c);
                                        if(emp.Length_of_Trade__c != NULL)
                                            LengthTrade1=string.valueOf(emp.Length_of_Trade__c);
                                        if(string.isNotEmpty(emp.Assessment_of_Business_Working_Capita__c))
                                            WorkingCapital= emp.Assessment_of_Business_Working_Capita__c;
                                        if(string.isNotEmpty(emp.Nature_of_Engagement__c))
                                            NatureEngagement= emp.Nature_of_Engagement__c;
                                        if(string.isNotEmpty(emp.Financial_Preformance__c))
                                            FinancialPerformance= emp.Financial_Preformance__c;
                                        if(string.isNotEmpty(emp.Financial_Statement_Support__c))
                                            FinancialSupport= emp.Financial_Statement_Support__c;
                                        if(string.isNotEmpty(emp.Professional_Category__c))
                                            ProfessionalCategory= emp.Professional_Category__c;
                                    }                              
                                    
                                    system.debug('Test## category====================>'+category);
                                    system.debug('Test## Age1====================>'+Age1);
                                    system.debug('Test## Education====================>'+Education);
                                    system.debug('Test## ResidentialStatus====================>'+ResidentialStatus);
                                    system.debug('Test## Yearsatcurrentresidence1====================>'+Yearsatcurrentresidence1);
                                    system.debug('Test## CreditHistory1====================>'+CreditHistory1);
                                    system.debug('Test## NetWorth====================>'+NetWorth);
                                    system.debug('Test## EmploymentStatus====================>'+EmploymentStatus);
                                    system.debug('Test## ProfessionalCategory====================>'+ProfessionalCategory);
                                    system.debug('Test## TotalIncome====================>'+TotalIncome);
                                    system.debug('Test## IndustryofEmployment====================>'+IndustryofEmployment);
                                    system.debug('Test## LengthofCurrentEmployment1====================>'+LengthofCurrentEmployment1);
                                    system.debug('Test## WorkingCapital====================>'+WorkingCapital);
                                    system.debug('Test## NatureEngagement====================>'+NatureEngagement);
                                    system.debug('Test## FinancialPerformance====================>'+FinancialPerformance);
                                    system.debug('Test## FinancialSupport====================>'+FinancialSupport);
                                    system.debug('Test## TypeIndustry====================>'+TypeIndustry); 
                                    system.debug('Test## NegaticeTrace====================>'+NegaticeTrace);  
                                    
                                    //MapAppScore = new Map<string,List<WrapperScoringModel>>(); 
                                    MapAppScore = new Map<string,List<WrapperScoringModel>>();  
                                    Decimal ScoreOfAppli = creditscorePerPersoncalculation(category,Age1,Education,ResidentialStatus,Yearsatcurrentresidence1,CreditHistory1,NetWorth,EmploymentStatus,
                                                                                           IndustryofEmployment,ProfessionalCategory,Collateral,LengthofCurrentEmployment1,ProductSelection,WorkingCapital,NatureEngagement,TypeIndustry,
                                                                                           FinancialPerformance,FinancialSupport,LengthTrade1);
                                    system.debug('ScoreOfApplicant ####################>'+ScoreOfAppli);
                                    if(CreditHistory1=='91'){
                                        if(ScoreOfAppli<479)
                                            ScoreOfAppli=479;
                                        if(ScoreOfAppli>556)
                                            ScoreOfAppli  =556;
                                    }
                                    
                                    
                                    if(count==1){
                                        Applicant1SubTotalWeightedScore = ScoreOfAppli;                               
                                    }
                                    else if(count==2){
                                        Applicant2SubTotalWeightedScore = ScoreOfAppli;
                                    }
                                    else if(count==3){
                                        Applicant3SubTotalWeightedScore = ScoreOfAppli;
                                    }
                                    count = count+1;
                                    List<List<WrapperScoringModel>> AppScore1 = new List<List<WrapperScoringModel>>();
                                    if(mapAppScore.size()>0){
                                        system.debug('mapAppScore.values()====>'+mapAppScore.values());
                                        AppScore1.addAll(mapAppScore.values());
                                    }
                                     system.debug('Test## NegaticeTrace====================1>'+NegaticeTrace);  
                                   WrapperScoringModellst.add(new WrapperCreditScoringModel(name,taxNumber,grossIncome,incomeType,politcallyExposed,NegaticeTrace,AppScore1)); 
                                 
                                    mapAppScore.clear();
                                }
                            }
                        }
                    }
                    if(numberOfApplicant ==1){//For one Applicant
                        AllApplicantsSubTotalWeightedScore = (Applicant1SubTotalWeightedScore*100)/100;
                        system.debug('####################################=1='+AllApplicantsSubTotalWeightedScore);
                    }
                    else if(numberOfApplicant ==2){//For two Applicant IncomeWeight2
                        if(TotalIncome>0){
                            Applicant1PortionOfTotalIncome = Applicant1GrossMonthlyIncome/TotalIncome;
                            Applicant2PortionOfTotalIncome = Applicant2GrossMonthlyIncome/TotalIncome;
                        }
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0)
                            IncomeWeight1 = Applicant1PortionOfTotalIncome/100;//Applicant 1’s Portion of Total Income2.   
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0)
                            IncomeWeight1 = 70.3/100; //In %   
                        If (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0)
                            IncomeWeight1=30/100;  //In %
                        
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0)
                            IncomeWeight2= Applicant2PortionOfTotalIncome/100;// Applicant 2’s Portion of Total Income
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0)
                            IncomeWeight2= 30/100;//IN %
                        If (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0)
                            IncomeWeight2= 70/100;// In %
                        
                        system.debug('Test##======Applicant1SubTotalWeightedScore==================>'+Applicant1SubTotalWeightedScore); 
                        system.debug('Test##======IncomeWeight1==================>'+IncomeWeight1); 
                        system.debug('Test##======Applicant2SubTotalWeightedScore==================>'+Applicant2SubTotalWeightedScore); 
                        system.debug('Test##======IncomeWeight2==================>'+IncomeWeight2);                         
                        AllApplicantsSubTotalWeightedScore = (Applicant1SubTotalWeightedScore * IncomeWeight1) + (Applicant2SubTotalWeightedScore * IncomeWeight2);
                        system.debug('####################################=2='+AllApplicantsSubTotalWeightedScore);
                    }
                    else if(numberOfApplicant ==3){//For three Applicant
                        if(TotalIncome>0){
                            Applicant1PortionOfTotalIncome = Applicant1GrossMonthlyIncome/TotalIncome;
                            Applicant2PortionOfTotalIncome = Applicant2GrossMonthlyIncome/TotalIncome;
                            Applicant3PortionOfTotalIncome = Applicant3GrossMonthlyIncome/TotalIncome;
                        }
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome > 0) 
                            IncomeWeight1 = Applicant1PortionOfTotalIncome/100;//Applicant 1’s Portion of Total Income
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome == 0) 
                            IncomeWeight1= 80/100;// IN %
                        If ((Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0) || (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome > 0)) 
                            IncomeWeight1 = (20/2)/100;//IN %
                        If ((Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0) || (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome > 0)) 
                            IncomeWeight1 = (Applicant1GrossMonthlyIncome*80)/100;
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0) 
                            IncomeWeight1= 20/100;// IN %
                        
                        
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome > 0) 
                            IncomeWeight2=Applicant2PortionOfTotalIncome/100;
                        If ((Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome == 0) || (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome > 0)) 
                            IncomeWeight2= (20/2)/100;
                        If (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0) 
                            IncomeWeight2= 80/100;
                        If ((Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0) || (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0)) 
                            IncomeWeight2= (Applicant2PortionOfTotalIncome*80)/100; //IN %
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome > 0) 
                            IncomeWeight2= 20/100;
                        
                        If (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome > 0) 
                            IncomeWeight3= Applicant3PortionOfTotalIncome/100;
                        If ((Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome == 0) || (Applicant1GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0)) 
                            IncomeWeight3= (20/2)/100;
                        If (Applicant3GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome == 0 && Applicant2GrossMonthlyIncome > 0) 
                            IncomeWeight3= 80/100;
                        If (Applicant3GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0) 
                            IncomeWeight3= 20/100; 
                        If ((Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome == 0 && Applicant3GrossMonthlyIncome > 0) || (Applicant1GrossMonthlyIncome > 0 && Applicant2GrossMonthlyIncome > 0 && Applicant3GrossMonthlyIncome == 0)) 
                            IncomeWeight3= (Applicant3PortionOfTotalIncome* 80)/100;
                        
                        
                        AllApplicantsSubTotalWeightedScore = (Applicant1SubTotalWeightedScore * IncomeWeight1) + (Applicant2SubTotalWeightedScore * IncomeWeight2) + (Applicant3SubTotalWeightedScore * IncomeWeight3);
                        
                        system.debug('####################################=3='+AllApplicantsSubTotalWeightedScore);
                    }
                    
                    system.debug('Test##======IncomeWeight1==================>'+IncomeWeight1); 
                    system.debug('Test##======IncomeWeight2==================>'+IncomeWeight2); 
                    system.debug('Test##======IncomeWeight3==================>'+IncomeWeight3); 
                    if(oppLineItem.containsKey(o.Id)){
                        system.debug('Test##========================>Line item found'); 
                        List<OpportunityLineItem> lstLine =oppLineItem.get(o.Id); 
                        if(lstLine.size()>0){
                            
                            map<string,Decimal> loanToValueMap = new Map<string,Decimal>();
                            loanToValueMap =getLoantoValue();// getLoantoValue(PdIDVsProductDetails.get(o.Product_Details__c));
                            //map<string, string> ats = new map<string, string>();
                            Decimal ats = getAbilitytoService(o.id,TotalIncome);
                            system.debug('Test========================> ats ='+ats); 
                            for(OpportunityLineItem li:lstLine){
                                string item = li.Product2.Name;
                                Decimal TotalPrice = (li.TotalPrice !=NULL)?li.TotalPrice:0;
                                system.debug('Test========================> item Name ='+item); 
                                if(item =='JN Bank Auto Loan'){// 'Auto Loan';
                                    Collateral =o.Collateral_Auto__c; 
                                    LoantoValue1=loanToValueMap.get('AutoLC');    //string.valueOf(getLoantoValue(o, 'Auto', TotalPrice));// 'Auto Loan',li.TotalPrice,o,lstLine
                                    Abilitytoservice1=ats;//.get('AutoTDSR');//   '0';
                                    ProductSelection='Auto Loan';
                                    if(!string.isEmpty(o.Repayment_Method_Auto__c))
                                        RepaymentMethod = o.Repayment_Method_Auto__c;
                                }
                                else if(item =='JN Bank Unsecured Loan'){// 'Unsecured Loan';
                                    Collateral = 'None'; 
                                    LoantoValue1=NULL;
                                    Abilitytoservice1=ats;
                                    ProductSelection='Unsecured Loan';
                                    if(!string.isEmpty(o.Repayment_Method_UL__c))
                                        RepaymentMethod = o.Repayment_Method_UL__c;
                                }
                                else if(item =='JN Visa - Classic'){// 'Credit Card';
                                    Collateral =o.Collateral_CC__c;
                                    LoantoValue1=loanToValueMap.get('CCLC');    
                                    Abilitytoservice1=ats;
                                    ProductSelection='Credit Card';
                                    if(!string.isEmpty(o.Repayment_Method_CC__c))
                                        RepaymentMethod = o.Repayment_Method_CC__c;
                                }
                                else if(item =='JN Bank Line Of Credit'){// 'Line of Credit';
                                    Collateral =o.Collateral_LOC__c;
                                    LoantoValue1=loanToValueMap.get('LOCLC'); 
                                    Abilitytoservice1=ats;//.get('LOCTDSR');//'0';
                                    ProductSelection='Line of Credit';
                                    if(!string.isEmpty(o.Repayment_Method_LOC__c))
                                        RepaymentMethod = o.Repayment_Method_LOC__c;
                                }
                                system.debug('Test### Collateral====================>'+Collateral); 
                                system.debug('Test### LoantoValue1====================>'+LoantoValue1); 
                                system.debug('Test### Abilitytoservice1====================>'+Abilitytoservice1); 
                                system.debug('Test### ProductSelection====================>'+ProductSelection);
                                system.debug('Test### RepaymentMethod====================>'+RepaymentMethod);  
                                
                                
                                Decimal Score = creditscorePerPersoncalculation1(Collateral,LoantoValue1,ProductSelection,Abilitytoservice1,RepaymentMethod);// PoliticallyExposed,NegaticeTrace
                                system.debug('Test### Test item========================>'+item); 
                                
                                
                                Decimal FinalScore = Score+AllApplicantsSubTotalWeightedScore;
                                system.debug('Test### Appli========================>'+AllApplicantsSubTotalWeightedScore);
                                system.debug('Test### FinalScore=========================>'+FinalScore); 
                                if(item =='JN Bank Auto Loan'){// 'Auto Loan';
                                    Decimal myScore = FinalScore.round(System.RoundingMode.HALF_UP);
                                    o.Credit_Score_Auto__c=myScore;
                                    retlst.add(new WrapperScore('AUTO',myScore,Rating(myScore)));
                                    //o.Ability_to_ServiceAuto__c =Decimal.valueOf(ats.get('AutoTDSR'));
                                }
                                else if(item =='JN Bank Unsecured Loan'){// 'Unsecured Loan';
                                    Decimal myScore = FinalScore.round(System.RoundingMode.HALF_UP);
                                    o.Credit_Risk_Score_Unsecured_Loan__c = myScore;
                                    retlst.add(new WrapperScore('UN',myScore,Rating(myScore)));
                                    //o.Ability_to_ServiceUL__c = Decimal.valueOf(ats.get('UnsecuredTDSR'));
                                }
                                else if(item =='JN Visa - Classic'){// 'Credit Card';
                                    Decimal myScore =FinalScore.round(System.RoundingMode.HALF_UP);
                                    o.Credit_Risk_Score_Credit_Card__c = myScore;
                                    retlst.add(new WrapperScore('CreditCard',myScore,Rating(myScore)));
                                    //o.Ability_to_ServiceCC__c = Decimal.valueOf(ats.get('CCTDSR'));
                                }
                                else if(item =='JN Bank Line Of Credit'){// 'Line of Credit';
                                    Decimal myScore =FinalScore.round(System.RoundingMode.HALF_UP);
                                    o.Credit_Risk_Score_Line_of_Credit__c = myScore;
                                    retlst.add(new WrapperScore('LOC',myScore,Rating(myScore)));
                                    //o.Ability_to_ServiceLOC__c = Decimal.valueOf(ats.get('LOCTDSR'));
                                }
                                
                                
                            }
                        }
                        
                       
                        lstToUpdate.add(o);
                    }
                    else{
                        //if opp don't have Product(Line Item)
                    }
                } 
            }        
        } 
        /*system.debug('Test## lstToUpdate =========='+lstToUpdate); 
if(lstToUpdate.size()>0){
FirstRun=true;
update lstToUpdate;
}*/
        //system.debug('Test## accMaptoUpdate =========='+accMaptoUpdate);
        /*   if(accMaptoUpdate.size()>0){
FirstRunAcc=true;
update accMaptoUpdate.values();
}*/
    }    
    
    public void fillOpp(Set<id> oppid){
        lstopp = [select 
                  AccountId,
                  Collateral_Auto__c,
                  Collateral_CC__c,
                  Collateral_LOC__c,
                  Loan_to_Value_Auto__c,
                  Loan_to_Value_CC__c,
                  Loan_to_Value_LOC__c,
                  Ability_to_Service_Auto__c,
                  Ability_to_Service_CC__c,
                  Ability_to_Service_LOC__c,
                  Ability_to_Service_UL__c,
                  Repayment_Method_Auto__c,
                  Repayment_Method_CC__c,
                  Repayment_Method_LOC__c,
                  Repayment_Method_UL__c ,
                  Credit_Score_Auto__c,
                  Credit_Risk_Score_Credit_Card__c,
                  Credit_Risk_Score_Line_of_Credit__c,
                  Credit_Risk_Score_Unsecured_Loan__c,
                  Collateral__r.Account_Balance__c, 
                  Collateral__r.Total_Market_Value_Calc__c, 
                  Collateral_Personal_Credit_Card__r.Account_Balance__c,
                  Collateral_Personal_Credit_Card__r.Total_Market_Value_Calc__c,
                  Collateral_Personal_Line_of_Credit__r.Account_Balance__c,
                  Collateral_Personal_Line_of_Credit__r.Total_Market_Value_Calc__c,
                  Collateral__r.Monthly_Payment_Calc__c,
                  Unsecured_Assets_and_Liabilities__r.Monthly_Payment_Calc__c,
                  Collateral_Personal_Credit_Card__r.Minimum_Payment__c,
                  Collateral_Personal_Line_of_Credit__r.Minimum_Payment__c,
                  Product_Details__c
                  from opportunity where ID IN:oppid ];
        if(lstopp.size()>0){            
            system.debug('Opp List ============>'+lstopp);
            for(opportunity o:lstopp){
                loancalcid.add(o.Product_Details__c);
                //accid.add(o.AccountId);
                /* if(oppIdVsAccidLst.containsKey(o.id)){
List<id> lstid = oppIdVsAccidLst.get(o.id);
lstid.add(o.AccountId);
oppIdVsAccidLst.put(o.id, lstid);
}
else{
List<id> lstid = new List<id>();
lstid.add(o.AccountId);
oppIdVsAccidLst.put(o.id, lstid); 
}*/
            }
            system.debug('accid Set ============>'+accid);
        }       
    }
    
    public void fillLoanCalculators(){
        if(loancalcid.size()>0){
            List<Loan_Calculator__c> lst = [select Total_Loan_Amount__c, 
                                            Market_Value_of_Vehicle__c, 
                                            Proposed_Starting_Limit__c,
                                            PC_Deposit_Account_Balance__c,
                                            Line_of_Credit_Starting_Limit__c,
                                            PCL_Deposit_Account_Balance__c 
                                            from Loan_Calculator__c where id IN:loancalcid];
            if(lst.size()>0){
                for(Loan_Calculator__c c :lst){
                    PdIDVsProductDetails.put(c.id,c);
                }
            }
        }
    }
    
    public void fillAcc(set<id> Accid){
        lstacc = [select Name,
                  Primary_Employment_Type__c,
                  Employment_Type__pc,
                  FinServ__Age__pc,
                  Highest_Level_of_Education_attained__pc,
                  Status_of_Address__c,
                  Years_at_Residence__c,
                  Credit_History_over_the_last_24_months__pc,
                  Net_Worth__pc,
                  Net_Worth_p__pc,
                  Employment_Status__pc,
                  Professional_Category__pc,
                  Political_Exposure__pc,
                  Sanction_Screening_w_Negative_Trace__pc,
                  Gross_Monthly_Income__pc,
                  Credit_Score__pc,
                  Industry_of_Employment__pc,
                  Jamaican_Tax_Registration_Number__pc
                  from Account where ID IN:Accid];
        if(lstacc.size()>0){
            system.debug('Acc List ============>'+lstacc);
            for(Account a:lstacc)
                accmap.put(a.id,a);                           
        }
        system.debug('accmap Map ============>'+accmap);
    }
    
    public void fillEmp(set<id> Accid){
        lstemp = [select Account__c,
                  FinServ__LengthOfEmployment__c,
                  Industry__c,
                  Assessment_of_Business_Working_Capita__c,
                  Financial_Preformance__c,
                  Financial_Statement_Support__c,
                  Nature_of_Engagement__c,
                  Professional_Category__c,
                  Income_type__c,
                  FinServ__EmploymentStatus__c,
                  Length_of_Trade__c
                  from FinServ__Employment__c where Account__c IN:Accid and Current_Employment__c=true];
        if(lstemp.size()>0){
            system.debug('Emp List ============>'+lstemp);
            for(FinServ__Employment__c e : lstemp)
                empmap.put(e.Account__c,e);
        }  
        system.debug('Emp Map ============>'+empmap);
    }
    
    public void fillProductType(Set<id> oppid){
        lstlineItem  =  [select name,Opportunityid,Product2.Name,TotalPrice from OpportunityLineItem where Opportunityid IN: oppid];
        system.debug('lstlineItem ============>'+lstlineItem);
        if(lstlineItem.size()>0){
            for(OpportunityLineItem o:lstlineItem){
                if(oppLineItem.containsKey(o.Opportunityid)){
                    List<OpportunityLineItem> lstItem = oppLineItem.get(o.Opportunityid);                   
                    lstItem.add(o);
                    oppLineItem.put(o.Opportunityid, lstItem);
                }
                else{
                    List<OpportunityLineItem> lstItem = new  List<OpportunityLineItem>();
                    lstItem.add(o);
                    oppLineItem.put(o.Opportunityid, lstItem);
                }              
            }          
        }
        system.debug('lstlineItem MAP ============>'+oppLineItem);
    }
    
    list<Applicant__c> Applicantlst = new list<Applicant__c>();
    
    public void fillApplicant(Set<id> oppid){
        set<id> aid = new set<id>();
        Applicantlst = [select Account__c,Opportunity__c,
                        Credit_History_in_last_24_Months__c,
                        Gross_Monthly_IncomeC__c,
                        Sanction_Screening_has_Negative_Trace__c,
                        Assessment_of_Applicant_Net_Worth__c,
                        Rent_Board_Monthly_Prior_Loan__c,
                        Strata_Maintenance_Monthly_Prior_Loan__c
                        from Applicant__c where Opportunity__c IN:oppid];
        if(Applicantlst.size()>0){
            for(Applicant__c o:Applicantlst){
                accidvsApplication.put(o.Account__c,o);
                accid.add(o.Account__c);
                if(oppIdVsAccidLst.containsKey(o.Opportunity__c)){
                    List<id> lstid = oppIdVsAccidLst.get(o.Opportunity__c);
                    lstid.add(o.Account__c);
                    oppIdVsAccidLst.put(o.Opportunity__c, lstid);
                }
                else{
                    List<id> lstid = new List<id>();
                    lstid.add(o.Account__c);
                    oppIdVsAccidLst.put(o.Opportunity__c, lstid); 
                }
            }
            system.debug('oppIdVsAccidLst MAP ============>'+oppIdVsAccidLst);
        }      
    }
    
    Map<id,list<Application_Asset_Liability__c>> oppisVsAssetslst = new Map<id,list<Application_Asset_Liability__c>>();
    
    public void FillAssets(Set<id> oppid){
        list<Application_Asset_Liability__c> lst = [select 
                                                    Application__r.Opportunity__c,
                                                    Assets_and_Liabilities__r.Monthly_Payment_Prior__c
                                                    from Application_Asset_Liability__c where Application__r.Opportunity__c IN:oppid]; 
        if(lst.size()>0){
            for(Application_Asset_Liability__c a:lst){
                if(oppisVsAssetslst.containsKey(a.Application__r.Opportunity__c)){
                    list<Application_Asset_Liability__c> lstid = oppisVsAssetslst.get(a.Application__r.Opportunity__c);
                    lstid.add(a);
                    oppisVsAssetslst.put(a.Application__r.Opportunity__c, lstid);
                }
                else{
                    List<Application_Asset_Liability__c> lstid = new List<Application_Asset_Liability__c>();
                    lstid.add(a);
                    oppisVsAssetslst.put(a.Application__r.Opportunity__c, lstid);
                }
            }
        }
    }
    
    public void setBlank(){   
        category='';
        Age1='0'; 
        Education=''; 
        ResidentialStatus=''; 
        Yearsatcurrentresidence1='0'; 
        CreditHistory1='0'; 
        NetWorth=''; 
        EmploymentStatus=''; 
        IndustryofEmployment=''; 
        ProfessionalCategory=''; 
        LengthofCurrentEmployment1='0'; 
        WorkingCapital=''; 
        NatureEngagement='';
        TypeIndustry='';
        FinancialPerformance=''; 
        FinancialSupport=''; 
        PoliticallyExposed=''; 
        NegaticeTrace=''; 
    }    
    
    public void fillmetalst(){
        List<Credit_Calculation__mdt>  metalstlocal = [SELECT Sub_Criteria__c,Sub_Criteria_Options__c,Employment_Type__c,Risk_Score__c,Weight_of_Sub_Criteria__c,Min__c,Max__c,Lower_Bound__c,Upper_Bound__c FROM Credit_Calculation__mdt];
        if(metalstlocal.size()>0){
            for(Credit_Calculation__mdt m:metalstlocal){
                if(m.Sub_Criteria__c=='Ability to Service' || m.Sub_Criteria__c=='Loan to Value' || m.Sub_Criteria__c=='Repayment Method' || m.Sub_Criteria__c=='Collateral' ){
                    if(m.Sub_Criteria__c=='Ability to Service'){
                        metalsta2s.add(m);
                    }
                    metalst2oppProduct.add(m);
                }
                else{
                    metalst.add(m);
                }
            }
            system.debug('Test## metalsta2s ===>'+metalsta2s);
            system.debug('Test## metalst2oppProduct ===>'+metalst2oppProduct);
            system.debug('Test## metalst ===>'+metalst);
        }
    }
    
    Public decimal creditscorePerPersoncalculation(string category,string Age1, string Education,string ResidentialStatus,
                                                   string Yearsatcurrentresidence1,string CreditHistory1,string NetWorth,string EmploymentStatus,string IndustryofEmployment,string ProfessionalCategory,string Collateral,
                                                   string LengthofCurrentEmployment1, string ProductSelection,String WorkingCapital, string NatureEngagement, 
                                                   string TypeIndustry,string FinancialPerformance,string FinancialSupport,string LengthTrade1)
    { 
        //system.debug('age========'+Age1);
        //system.debug('LengthofCurrentEmployment1========'+LengthofCurrentEmployment1);
        //system.debug('Yearsatcurrentresidence1========'+Yearsatcurrentresidence1);
        //system.debug('CreditHistory1========'+CreditHistory1);
        //system.debug('category========'+category);
        Decimal Age = Decimal.valueOf(Age1);
        Decimal LengthofCurrentEmployment=Decimal.valueOf(LengthofCurrentEmployment1);
        Decimal Yearsatcurrentresidence = Decimal.valueOf(Yearsatcurrentresidence1);
        Decimal CreditHistory = Decimal.valueOf(CreditHistory1);
        Decimal LengthTrade;
         if(LengthTrade1=='>5 years')
         LengthTrade=6;
        if(LengthTrade1=='3-5 years')
         LengthTrade=4;
         if(LengthTrade1=='1-3 years')
         LengthTrade=2;
         if(LengthTrade1=='<1 year')
         LengthTrade=0;
        decimal creditscore=0;
        // Credit_Calculation__mdt[] threatMappings = [SELECT Sub_Criteria__c,Sub_Criteria_Options__c,Employment_Type__c,Risk_Score__c,Weight_of_Sub_Criteria__c,Min__c,Max__c,Lower_Bound__c,Upper_Bound__c FROM Credit_Calculation__mdt];
        decimal agescore=0;
        decimal educationscore=0;
        decimal Residentialscore=0;
        decimal residenceYearscore=0;
        decimal CreditHistoryscore=0;
        decimal NetWorthscore=0;
        decimal EmploymentStatusscore=0;
        decimal IndustryofEmploymentscore=0;
        decimal ProfessionalCategoryscore=0;
        decimal Collateralscore=0;
        decimal LoantoValuescore=0;
        decimal AbilitytoServicescore=0;
        decimal RepaymentMethodscore=0;
        decimal LengthEmploymentscore=0;
        decimal loantoweight=0;
        decimal repaymentweight=0;
        decimal repaymentriskscore=0;
        decimal LengthTradescore=0;
        decimal FinancialSupportscore=0;
        decimal FinancialPerformancescore=0;
        decimal TypeIndustryscore=0;
        decimal NatureEngagementscore=0;
        decimal WorkingCapitalscore=0;
        //WrapperScoringlst.clear();
        system.debug('Test##      fillmetalst====='+metalst);
        for(Credit_Calculation__mdt cr:metalst){
            if(cr.Risk_Score__c!=null && cr.Weight_of_Sub_Criteria__c!=null){
                if(cr.Sub_Criteria__c=='Age'){
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=Age && cr.Upper_Bound__c>=Age && cr.Employment_Type__c==category){
                        //system.debug('1========'+category);
                        //system.debug('agescore1========'+cr.Risk_Score__c);
                        //system.debug('agescore2========'+cr.Weight_of_Sub_Criteria__c);
                        agescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('agescore========'+agescore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Age),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(agescore)));
                        MapAppScore.put('Age', WrapperScoringlst1);
                        
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=Age && cr.Employment_Type__c==category){
                        agescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('agescore========'+agescore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Age),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(agescore)));
                        MapAppScore.put('Age', WrapperScoringlst1);
                        
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=Age && cr.Employment_Type__c==category){
                        //system.debug('3========');
                        agescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('agescore========'+agescore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Age),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(agescore)));
                        MapAppScore.put('Age', WrapperScoringlst1);
                        
                    }
                    
                    
                }
                
                if(cr.Sub_Criteria__c=='Education'){
                    if(cr.Sub_Criteria_Options__c==Education && cr.Employment_Type__c==category){
                        educationscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('educationscore========'+educationscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Education),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(educationscore)));
                        MapAppScore.put('Education', WrapperScoringlst1);
                         
                    }
                }
                
                if(cr.Sub_Criteria__c=='Residential Status'){
                    if(cr.Sub_Criteria_Options__c==ResidentialStatus && cr.Employment_Type__c==category){
                        Residentialscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('Residentialscore========'+Residentialscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(ResidentialStatus),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(Residentialscore)));
                         MapAppScore.put('Residential Status', WrapperScoringlst1);
                    }
                }
                
                if(cr.Sub_Criteria__c=='Years at current residence'){
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=Yearsatcurrentresidence && cr.Upper_Bound__c>=Yearsatcurrentresidence && cr.Employment_Type__c==category){
                        residenceYearscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('residenceYearscore========'+residenceYearscore);
                       List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Yearsatcurrentresidence),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(residenceYearscore)));
                        MapAppScore.put('Years at current residence', WrapperScoringlst1);
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=Yearsatcurrentresidence && cr.Employment_Type__c==category){
                        residenceYearscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('residenceYearscore========'+residenceYearscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Yearsatcurrentresidence),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(residenceYearscore)));
                    MapAppScore.put('Years at current residence', WrapperScoringlst1);
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=Yearsatcurrentresidence && cr.Employment_Type__c==category){
                        residenceYearscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('residenceYearscore========'+residenceYearscore);
                       List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Yearsatcurrentresidence),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(residenceYearscore)));
                   MapAppScore.put('Years at current residence', WrapperScoringlst1);
                    }
                }
                
                //system.debug('CreditHistoryscore1========'+cr.Lower_Bound__c);
                //system.debug('CreditHistoryscore2========'+cr.Upper_Bound__c);
                
                if(cr.Sub_Criteria__c=='Credit History in last 24 Months'){
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=CreditHistory && cr.Upper_Bound__c>=CreditHistory && cr.Employment_Type__c==category){
                        CreditHistoryscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('CreditHistoryscore========'+CreditHistoryscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(CreditHistory),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(CreditHistoryscore)));
                    MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=CreditHistory && cr.Employment_Type__c==category){
                        CreditHistoryscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('CreditHistoryscore========'+CreditHistoryscore);
                       List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(CreditHistory),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(CreditHistoryscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=CreditHistory && cr.Employment_Type__c==category){
                        CreditHistoryscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('CreditHistoryscore========'+CreditHistoryscore);
                       List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(CreditHistory),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(CreditHistoryscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                           
                }
                
                if(cr.Sub_Criteria__c=='Net Worth'){
                    if(cr.Sub_Criteria_Options__c==NetWorth && cr.Employment_Type__c==category)
                        NetWorthscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                    //system.debug('NetWorthscore========'+NetWorthscore);
                   List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                    WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(NetWorth),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(NetWorthscore))); 
                 MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                }
                //system.debug('category=======================================>0=>'+category+'=0='+cr.Sub_Criteria__c+'==0=='+cr.Risk_Score__c+'=0='+EmploymentStatus);
                if(category=='Salaried'){
                    if(cr.Sub_Criteria__c=='Employment Status'){
                        if(cr.Sub_Criteria_Options__c==EmploymentStatus && cr.Employment_Type__c==category)
                            EmploymentStatusscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('EmploymentStatusscore========'+EmploymentStatusscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(EmploymentStatus),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(EmploymentStatusscore))); 
                    MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    
                    if(cr.Sub_Criteria__c=='Industry of Employment'){
                        if(cr.Sub_Criteria_Options__c==IndustryofEmployment && cr.Employment_Type__c==category)
                            IndustryofEmploymentscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('IndustryofEmploymentscore========'+IndustryofEmploymentscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(IndustryofEmployment),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(IndustryofEmploymentscore))); 
                     MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    system.debug('LengthEmploymentscore=======================================>0=>'+cr.Sub_Criteria__c+'==0=='+cr.Risk_Score__c+'=0='+EmploymentStatus);
                    if(cr.Sub_Criteria__c=='Length of Current Employment' && cr.Risk_Score__c!=null && EmploymentStatus!='Unemployed'){
                        //system.debug('LengthEmploymentscore=======================================>');
                        if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=LengthofCurrentEmployment && cr.Upper_Bound__c>=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                            //system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                           // system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                            //system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                        
                    }
                    
                    if(cr.Sub_Criteria__c=='Professional Category' && EmploymentStatus!='Unemployed'){
                        if(cr.Sub_Criteria_Options__c==ProfessionalCategory && cr.Employment_Type__c==category){
                            ProfessionalCategoryscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                            system.debug('ProfessionalCategoryscore 1========'+ProfessionalCategoryscore);
                            system.debug('ProfessionalCategoryscore score========'+cr.Risk_Score__c);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(ProfessionalCategory),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(ProfessionalCategoryscore))); 
                            MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                    if(cr.Sub_Criteria__c=='Professional Category' && EmploymentStatus=='Unemployed'){
                        if(cr.Sub_Criteria_Options__c==ProfessionalCategory && cr.Employment_Type__c==category){
                            Decimal loantoweightUn=cr.Weight_of_Sub_Criteria__c+4;
                            ProfessionalCategoryscore=percentagevalue(cr.Risk_Score__c, loantoweightUn);
                            
                            system.debug('ProfessionalCategoryscore 2========'+ProfessionalCategoryscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(ProfessionalCategory),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(ProfessionalCategoryscore))); 
                            MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                }
                
                if(cr.Sub_Criteria__c=='Collateral'){
                    if(cr.Sub_Criteria_Options__c==Collateral && cr.Employment_Type__c==category)
                        Collateralscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                    //system.debug('Collateralscore========'+Collateralscore);
                }
                
                
                
                
                //=====self-employed====
                if(category=='Self-Employed'){
                    if(cr.Sub_Criteria__c=='Working Capital'){
                        //system.debug('WorkingCapital========'+WorkingCapital);
                        //system.debug('WorkingCapitalcr.Risk_Score__c========'+cr.Risk_Score__c);
                        //system.debug('WorkingCapitalcr.Weight_of_Sub_Criteria__c========'+cr.Weight_of_Sub_Criteria__c);
                        if(cr.Sub_Criteria_Options__c==WorkingCapital && cr.Employment_Type__c==category)
                            WorkingCapitalscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('WorkingCapitalscore========'+WorkingCapitalscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(WorkingCapital),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(WorkingCapitalscore))); 
                     MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    if(cr.Sub_Criteria__c=='Nature of Engagement'){
                        if(cr.Sub_Criteria_Options__c==NatureEngagement && cr.Employment_Type__c==category)
                            NatureEngagementscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('NatureEngagementscore========'+NatureEngagementscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(NatureEngagement),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(NatureEngagementscore))); 
                    MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    if(cr.Sub_Criteria__c=='Type of Industry'){
                        if(cr.Sub_Criteria_Options__c==TypeIndustry && cr.Employment_Type__c==category)
                            TypeIndustryscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('TypeIndustryscore========'+TypeIndustryscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(TypeIndustry),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(TypeIndustryscore))); 
                     MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    if(cr.Sub_Criteria__c=='Financial Performance'){
                        if(cr.Sub_Criteria_Options__c==FinancialPerformance && cr.Employment_Type__c==category)
                            FinancialPerformancescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('FinancialPerformancescore========'+FinancialPerformancescore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(FinancialPerformance),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(FinancialPerformancescore))); 
                     MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    if(cr.Sub_Criteria__c=='Financial Statement Support'){
                        if(cr.Sub_Criteria_Options__c==FinancialSupport && cr.Employment_Type__c==category)
                            FinancialSupportscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        //system.debug('FinancialSupportscore========'+FinancialSupportscore);
                        List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                        WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(FinancialSupport),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(FinancialSupportscore))); 
                     MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                    }
                    if(cr.Sub_Criteria__c=='Length of Trade'){
                        if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=LengthTrade && cr.Upper_Bound__c>LengthTrade && cr.Employment_Type__c==category){
                            LengthTradescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                            //system.debug('LengthTradescore1========'+LengthTradescore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthTrade),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthTradescore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>LengthTrade && cr.Employment_Type__c==category){
                            LengthTradescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                            //system.debug('LengthTradescore2========'+LengthTradescore);
                           List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthTrade),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthTradescore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=LengthTrade && cr.Employment_Type__c==category){
                            LengthTradescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                            //system.debug('LengthTradescore3========'+LengthTradescore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthTrade),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthTradescore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                    
                    
                }
            }
            
            if(cr.Risk_Score__c!=null ){
                if(category=='Salaried'){
                    //system.debug('LengthEmploymentscore=======================================>0=>'+cr.Sub_Criteria__c+'==0=='+cr.Risk_Score__c+'=0='+EmploymentStatus);
                    if(cr.Sub_Criteria__c=='Length of Current Employment' && cr.Risk_Score__c!=null && EmploymentStatus!='Unemployed'){
                        //system.debug('LengthEmploymentscore=======================================>');
                        if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=LengthofCurrentEmployment && cr.Upper_Bound__c>=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                            //system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                            //system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                         MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=LengthofCurrentEmployment && cr.Employment_Type__c==category){
                            LengthEmploymentscore=percentagevalue(cr.Risk_Score__c, 4);
                           // system.debug('LengthEmploymentscore========'+LengthEmploymentscore);
                           List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LengthofCurrentEmployment),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LengthEmploymentscore)));
                        MapAppScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                        
                    }
                }
                
                
                
                
                
                
                
                
            }
            
            //system.debug('Test##      WrapperScoringlst====='+WrapperScoringlst); 
        }
        //system.debug('Test##      WrapperScoringlst out====='+WrapperScoringlst);
        if(ProductSelection=='Unsecured Loan' && Collateral=='None'){
            decimal weight=loantoweight+ repaymentweight;
            RepaymentMethodscore=percentagevalue(repaymentriskscore,weight);
            system.debug('Test## RepaymentMethodscore========'+RepaymentMethodscore);
        }
        
        
        
        
        
        
        
        
        
        system.debug('Test## agescore========>'+agescore);
        system.debug('Test## educationscore========>'+educationscore);
        system.debug('Test## Residentialscore========>'+Residentialscore);
        system.debug('Test## residenceYearscore========>'+residenceYearscore);
        system.debug('Test## CreditHistoryscore========>'+CreditHistoryscore);
        system.debug('Test## NetWorthscore========>'+NetWorthscore);
        system.debug('Test## EmploymentStatusscore========>'+EmploymentStatusscore);
        system.debug('Test## IndustryofEmploymentscore========>'+IndustryofEmploymentscore);
        system.debug('Test## ProfessionalCategoryscore========>'+ProfessionalCategoryscore);
        system.debug('Test## Collateralscore========>'+Collateralscore);
        system.debug('Test## LoantoValuescore========>'+LoantoValuescore);
        system.debug('Test## AbilitytoServicescore========>'+AbilitytoServicescore);
        system.debug('Test## RepaymentMethodscore========>'+RepaymentMethodscore);
        system.debug('Test## LengthEmploymentscore========>'+LengthEmploymentscore);
        system.debug('Test## LengthTradescore========>'+LengthTradescore);
        system.debug('Test## FinancialSupportscore========>'+FinancialSupportscore);
        system.debug('Test## FinancialPerformancescore========>'+FinancialPerformancescore);
        system.debug('Test## TypeIndustryscore========>'+TypeIndustryscore);
        system.debug('Test## NatureEngagementscore========>'+NatureEngagementscore);
        system.debug('Test## WorkingCapitalscore========>'+WorkingCapitalscore);
        
        creditscore=agescore+educationscore+Residentialscore+residenceYearscore+
            CreditHistoryscore+NetWorthscore+EmploymentStatusscore+IndustryofEmploymentscore+ProfessionalCategoryscore+
            LengthEmploymentscore+LengthTradescore+FinancialSupportscore+FinancialPerformancescore+TypeIndustryscore+NatureEngagementscore+WorkingCapitalscore;
        
        system.debug('creditscore========'+creditscore);
        /*  if(NegaticeTrace=='0'|| PoliticallyExposed=='0' || CreditHistory==91){
if(creditscore<479)
creditscore=479;
if(creditscore>556)
creditscore  =556;
}*/                        
        return creditscore; 
    }
    
    Public decimal creditscorePerPersoncalculation1(string Collateral,Decimal LoantoValue,string ProductSelection,Decimal Abilitytoservice,string RepaymentMethod){
        
        //Decimal Abilitytoservice = Decimal.valueOf(Abilitytoservice1);
        decimal creditscore=0;
        decimal Collateralscore=0;
        decimal LoantoValuescore=0;
        decimal AbilitytoServicescore=0;
        decimal RepaymentMethodscore=0;
        decimal loantoweight=0;
        decimal repaymentriskscore=0;
        decimal repaymentweight=0;
        
        //WrapperScoringlst.clear();
        string ReOption='';
        string Sub_Criteria ='';
        string Risk_Score='';
        
        for(Credit_Calculation__mdt cr:metalst2oppProduct){
            if(ProductSelection=='Unsecured Loan' && Collateral=='None'){
                if(cr.Sub_Criteria__c=='Loan to Value'){
                    system.debug('tesk##########LoantoValue###'+LoantoValue);
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=LoantoValue && cr.Upper_Bound__c>=LoantoValue ){
                        loantoweight=cr.Weight_of_Sub_Criteria__c;
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=LoantoValue ){
                        loantoweight=cr.Weight_of_Sub_Criteria__c;
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=LoantoValue ){
                        loantoweight=cr.Weight_of_Sub_Criteria__c;
                    }
                }
                system.debug('loantoweight2========'+loantoweight);
                if(cr.Sub_Criteria__c=='Repayment Method'){
                    if(cr.Sub_Criteria_Options__c==RepaymentMethod ){
                        repaymentriskscore=cr.Risk_Score__c!=null?cr.Risk_Score__c:0;
                        repaymentweight=cr.Weight_of_Sub_Criteria__c!=null?cr.Weight_of_Sub_Criteria__c:0;
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel('Repayment Method',string.valueOf(RepaymentMethod),string.valueOf(repaymentriskscore),string.valueOf(cr.Risk_Score__c),string.valueOf(repaymentweight)));
                            MapProductScore.put('Repayment Method', WrapperScoringlst1);
                        }
                    }
                }
            }
            
            if(cr.Risk_Score__c!=null && cr.Weight_of_Sub_Criteria__c!=null){
                
                if(cr.Sub_Criteria__c=='Collateral'){
                    system.debug('Collateralscore===============0='+Collateral);
                    system.debug('cr.Risk_Score__c===============0='+cr.Risk_Score__c);
                    system.debug('cr.Weight_of_Sub_Criteria__c===============0='+cr.Weight_of_Sub_Criteria__c);
                    system.debug('cr.Sub_Criteria_Options__c===============0='+cr.Sub_Criteria_Options__c);
                    if(cr.Sub_Criteria_Options__c==Collateral ){
                        Collateralscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('Collateralscore========##=='+Collateralscore);
                        
                        if(ProductTypeOfScoringModel == ProductSelection && ProductSelection !='Unsecured Loan'){
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Collateral),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(cr.Risk_Score__c),string.valueOf(Collateralscore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                        if(ProductTypeOfScoringModel == ProductSelection && ProductSelection =='Unsecured Loan'){
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Collateral),string.valueOf(cr.Sub_Criteria_Options__c),string.valueOf(0),string.valueOf(0)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                }
                
                if(cr.Sub_Criteria__c=='Loan to Value' && ProductSelection!='Unsecured Loan' && Collateral!='None'){
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=LoantoValue && cr.Upper_Bound__c>=LoantoValue ){
                        LoantoValuescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('LoantoValuescore========'+LoantoValuescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LoantoValue),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LoantoValuescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=LoantoValue ){
                        LoantoValuescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('LoantoValuescore========'+LoantoValuescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LoantoValue),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LoantoValuescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=LoantoValue ){
                        LoantoValuescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('loantoweight3========'+cr.Weight_of_Sub_Criteria__c);
                        system.debug('LoantoValuescore========'+LoantoValuescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(LoantoValue),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(LoantoValuescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                    
                }
                
                if(cr.Sub_Criteria__c=='Ability to Service'){
                    if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=Abilitytoservice && cr.Upper_Bound__c>=Abilitytoservice ){
                        AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Abilitytoservice),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(AbilitytoServicescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=Abilitytoservice ){
                        AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Abilitytoservice),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(AbilitytoServicescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=Abilitytoservice ){
                        AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                        system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                        if(ProductTypeOfScoringModel == ProductSelection) {
                            List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                            WrapperScoringlst1.add(new WrapperScoringModel(cr.Sub_Criteria__c,string.valueOf(Abilitytoservice),string.valueOf(cr.Lower_Bound__c +' - '+cr.Upper_Bound__c),string.valueOf(cr.Risk_Score__c),string.valueOf(AbilitytoServicescore)));
                            MapProductScore.put(cr.Sub_Criteria__c, WrapperScoringlst1);
                        }
                    }
                    
                }
                
                if(cr.Sub_Criteria__c=='Repayment Method'){
                    system.debug('pavit2========');
                    if(ProductSelection!='Unsecured Loan' && Collateral!='None'){
                        if(cr.Sub_Criteria_Options__c==RepaymentMethod ){
                            RepaymentMethodscore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                            system.debug('RepaymentMethodscore========'+RepaymentMethodscore);
                            ReOption = cr.Sub_Criteria_Options__c;
                            Sub_Criteria = cr.Sub_Criteria__c;
                            Risk_Score = string.valueOf(cr.Risk_Score__c);
                            if(ProductTypeOfScoringModel == ProductSelection) {
                                List<WrapperScoringModel> WrapperScoringlst1 = new List<WrapperScoringModel>();
                                WrapperScoringlst1.add(new WrapperScoringModel('Repayment Method',string.valueOf(RepaymentMethod),string.valueOf(RepaymentMethodscore),string.valueOf(Risk_Score),string.valueOf(RepaymentMethodscore)));
                                MapProductScore.put('Repayment Method', WrapperScoringlst1);
                            }
                        }
                    }
                }
            }
            
        }
        if(ProductSelection=='Unsecured Loan' && Collateral=='None'){
            decimal weight=loantoweight+ repaymentweight;
            system.debug('loantoweight========>'+loantoweight);
            system.debug('repaymentweight========>'+repaymentweight);
            system.debug('weight========>'+weight);
            RepaymentMethodscore=percentagevalue(repaymentriskscore,weight);
            system.debug('RepaymentMethodscore========>'+RepaymentMethodscore);
        }
        
        
        
        
       // if(ProductTypeOfScoringModel == ProductSelection) 
           // WrapperScoringlst.add(new WrapperScoringModel(Sub_Criteria,string.valueOf(RepaymentMethod),string.valueOf(RepaymentMethodscore),string.valueOf(Risk_Score),string.valueOf(RepaymentMethodscore)));
        
        
        system.debug('Test## ProductSelection========>'+ProductSelection);
        system.debug('Test## Collateralscore========>'+Collateralscore);
        system.debug('Test## LoantoValuescore========>'+LoantoValuescore);
        system.debug('Test## AbilitytoServicescore========>'+AbilitytoServicescore);
        system.debug('Test## RepaymentMethodscore========>'+RepaymentMethodscore);
        if(ProductSelection=='Unsecured Loan' && Collateral=='None')
            LoantoValuescore=0;
        creditscore=Collateralscore+LoantoValuescore+AbilitytoServicescore+RepaymentMethodscore;
        
        return creditscore; 
    }
    
    Public decimal creditscorePerPersoncalculation4Ability2Service(Decimal Abilitytoservice){
        system.debug('Test## #####################A2S========'+Abilitytoservice);
        //Decimal Abilitytoservice = Decimal.valueOf(Abilitytoservice1);
        decimal AbilitytoServicescore=0;
        for(Credit_Calculation__mdt cr:metalsta2s){
            if(cr.Risk_Score__c!=null && cr.Weight_of_Sub_Criteria__c!=null && cr.Sub_Criteria__c=='Ability to Service'){
                if(cr.Lower_Bound__c!=null && cr.Upper_Bound__c!=null && cr.Lower_Bound__c<=Abilitytoservice && cr.Upper_Bound__c>=Abilitytoservice ){
                    AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                    system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                }else if(cr.Lower_Bound__c==null && cr.Upper_Bound__c>=Abilitytoservice ){
                    AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                    system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                }else if(cr.Upper_Bound__c==null && cr.Lower_Bound__c<=Abilitytoservice ){
                    AbilitytoServicescore=percentagevalue(cr.Risk_Score__c, cr.Weight_of_Sub_Criteria__c);
                    system.debug('AbilitytoServicescore========'+AbilitytoServicescore);
                }
            }               
        }             
        system.debug('Test## #####################A2S score========>'+AbilitytoServicescore);
        return AbilitytoServicescore; 
    }
    
    Public decimal getAbilitytoService(ID oppid, Decimal totalincome){ // list<Account> acclist
        list<Application_Asset_Liability__c> assetlst = new list<Application_Asset_Liability__c>();
        if(oppisVsAssetslst.containsKey(oppid)){
            assetlst = oppisVsAssetslst.get(oppid);
        }
        Decimal TDSR=0;
        Decimal totalmonthlypayment=0;
        if(assetlst.size()>0)
            for(Application_Asset_Liability__c al:assetlst){
                if(al.Assets_and_Liabilities__r.Monthly_Payment_Prior__c != NULL)
                    totalmonthlypayment += al.Assets_and_Liabilities__r.Monthly_Payment_Prior__c;
            }
        if(Applicantlst.size()>0)
            for(Applicant__c app:Applicantlst){
                if(app.Rent_Board_Monthly_Prior_Loan__c != NULL && app.Strata_Maintenance_Monthly_Prior_Loan__c != Null)
                    totalmonthlypayment+=app.Rent_Board_Monthly_Prior_Loan__c+app.Strata_Maintenance_Monthly_Prior_Loan__c;
            }
        if(totalmonthlypayment>0 && totalincome>0)
            TDSR=totalmonthlypayment/totalincome;
        return TDSR;
    }
    
    Public map<string, Decimal> getLoantoValue(){
        /*  
system.debug('Test## Loan to value called ===>opp='+opp+'===Product='+Productname+'====TotalPrice='+TotalPrice);
system.debug('Test## Loan to value called ===>opp.Collateral__r.Account_Balance__c='+opp.Collateral__r.Account_Balance__c+'===opp.Collateral__r.Total_Market_Value_Calc__c='+opp.Collateral__r.Total_Market_Value_Calc__c);
decimal loan2value=0;
if((Productname=='Auto' || Productname=='Credit' || Productname=='LineofCredit') && TotalPrice>0){
if(opp!=null){
decimal totalassets=0;              
if(Productname=='Auto')
totalassets=(opp.Collateral__r.Account_Balance__c!=null?opp.Collateral__r.Account_Balance__c:0)+(opp.Collateral__r.Total_Market_Value_Calc__c!=null?opp.Collateral__r.Total_Market_Value_Calc__c:0);
if(Productname=='Credit')
totalassets=(opp.Collateral_Personal_Credit_Card__r.Account_Balance__c!=null?opp.Collateral_Personal_Credit_Card__r.Account_Balance__c:0)+(opp.Collateral_Personal_Credit_Card__r.Total_Market_Value_Calc__c!=null?opp.Collateral_Personal_Credit_Card__r.Total_Market_Value_Calc__c:0);
if(Productname=='LineofCredit')
totalassets=(opp.Collateral_Personal_Line_of_Credit__r.Account_Balance__c!=null?opp.Collateral_Personal_Line_of_Credit__r.Account_Balance__c:0)+(opp.Collateral_Personal_Line_of_Credit__r.Total_Market_Value_Calc__c!=null?opp.Collateral_Personal_Line_of_Credit__r.Total_Market_Value_Calc__c:0);
system.debug('Test## totalassets='+totalassets+'==='+Productname);
system.debug('Test## TotalPrice='+TotalPrice);
if(totalassets>0)
loan2value=TotalPrice/totalassets;
system.debug('Test## Loan to value called ===>loan2value='+loan2value);
}
}*/
        map<string, Decimal> lcmap= new map<string, Decimal>();
        Decimal AutoLC=0;
        Decimal CCLC=0;
        Decimal LOCLC=0;
        /* if(lc !=null) {
if(lc.Total_Loan_Amount__c!=null && lc.Market_Value_of_Vehicle__c!=null && lc.Total_Loan_Amount__c>0 && lc.Market_Value_of_Vehicle__c>0)
AutoLC=lc.Total_Loan_Amount__c/lc.Market_Value_of_Vehicle__c;
if(lc.Proposed_Starting_Limit__c!=null && lc.PC_Deposit_Account_Balance__c!=null && lc.Proposed_Starting_Limit__c>0 && lc.PC_Deposit_Account_Balance__c>0)
CCLC=lc.Proposed_Starting_Limit__c/lc.PC_Deposit_Account_Balance__c;
if(lc.Line_of_Credit_Starting_Limit__c!=null && lc.PCL_Deposit_Account_Balance__c!=null && lc.Line_of_Credit_Starting_Limit__c>0 && lc.PCL_Deposit_Account_Balance__c>0)
LOCLC=lc.Line_of_Credit_Starting_Limit__c/lc.PCL_Deposit_Account_Balance__c;

lcmap.put('AutoLC',AutoLC);
lcmap.put('CCLC',CCLC);
lcmap.put('LOCLC',LOCLC);
}*/
        /*  public Decimal Total_Loan_Amount=0;
public Decimal Market_Value_of_Vehicle=0;
public Decimal Proposed_Starting_Limit=0;
public Decimal PC_Deposit_Account_Balance=0;
public Decimal Line_of_Credit_Starting_Limit=0;
public Decimal PCL_Deposit_Account_Balance=0;
*/
        
        if(Total_Loan_Amount!=null && Market_Value_of_Vehicle!=null && Total_Loan_Amount>0 && Market_Value_of_Vehicle>0)
            AutoLC=Total_Loan_Amount/Market_Value_of_Vehicle;
        if(Proposed_Starting_Limit!=null && PC_Deposit_Account_Balance!=null && Proposed_Starting_Limit>0 && PC_Deposit_Account_Balance>0)
            CCLC=Proposed_Starting_Limit/PC_Deposit_Account_Balance;
        if(Line_of_Credit_Starting_Limit!=null && PCL_Deposit_Account_Balance!=null && Line_of_Credit_Starting_Limit>0 && PCL_Deposit_Account_Balance>0)
            LOCLC=Line_of_Credit_Starting_Limit/PCL_Deposit_Account_Balance;
        
        lcmap.put('AutoLC',AutoLC);
        lcmap.put('CCLC',CCLC);
        lcmap.put('LOCLC',LOCLC);
        
        
        
        
        system.debug('Test## ========lcmap==============='+lcmap);
        
        return lcmap;
    }
   
    private Decimal percentagevalue(Decimal score, decimal percentage){
        decimal val=(score*percentage)/100;
        return val;
    }
    
    public string CreditHistory(string str){
        string data='-1';       
        if(str =='No Delinquency')
            return '0';
        else if(str =='1 - 10 days Delinquent')
            return '10';
        else if(str =='11 - 30 days Delinquent')
            return '30';
        else if(str =='31 - 60 days Delinquent')
            return '60';
        else if(str =='61 - 90 days Delinquent')
            return '90';
        else if(str =='Over 90 days Delinquent')
            return '91';
        else if(str =='No Credit History')
            return '101';       
        return data;
    }
    
    public string EducationMaping(string str){
        string data='';       
        if(str =='None')
            return 'High School';
        else if(str =='Basic')
            return 'High School';
        else if(str =='Primary')
            return 'High School';
        else if(str =='High School')
            return 'High School';
        else if(str =='Vocational Training Institutions')
            return 'Vocational';
        else if(str =='Teacher Training Colleges')
            return 'Undergraduate';
        else if(str =='Community Colleges')
            return 'Undergraduate';  
        else if(str =='Other College/Institutions')
            return 'Undergraduate';
        else if(str =='University: Undergraduate')
            return 'Undergraduate';
        else if(str =='University: Post Graduate')
            return 'Post Graduate';
        return data;
    }
    
    public string StatusOfAddress(string str){
        string data='';       
        if(str =='Own (with mortgage)')
            return 'Own';
        else if(str =='Own (without mortgage)')
            return 'Own';
        else if(str =='Company')
            return 'Other';
        else if(str =='Family')
            return 'Family';
        else if(str =='Rent')
            return 'Rent';
        else if(str =='Other')
            return 'Other';
        
        return data;
    }
    
    public List<WrapperScore> retlst = new List<WrapperScore>();
    
    public List<WrapperScore> calculateScoreOnOpp(string opp_id,string Total_Loan_Amount,string Market_Value_of_Vehicle, string Proposed_Starting_Limit,string PC_Deposit_Account_Balance,string Line_of_Credit_Starting_Limit,string PCL_Deposit_Account_Balance){
        lstRating =[select Rating__c,Classification__c,Credit_Score_Min__c,Credit_Score_Max__c from Credit_Rating__mdt];
        set<id> oppid = new set<id>();
        oppid.add(opp_id); 
        
        if(string.isNotEmpty(Total_Loan_Amount))
            this.Total_Loan_Amount = Decimal.valueOf(Total_Loan_Amount);
        if(string.isNotEmpty(Market_Value_of_Vehicle))
            this.Market_Value_of_Vehicle = Decimal.valueOf(Market_Value_of_Vehicle);
        if(string.isNotEmpty(Proposed_Starting_Limit))
            this.Proposed_Starting_Limit = Decimal.valueOf(Proposed_Starting_Limit);
        if(string.isNotEmpty(PC_Deposit_Account_Balance))
            this.PC_Deposit_Account_Balance = Decimal.valueOf(PC_Deposit_Account_Balance);
        if(string.isNotEmpty(Line_of_Credit_Starting_Limit))
            this.Line_of_Credit_Starting_Limit = Decimal.valueOf(Line_of_Credit_Starting_Limit);
        if(string.isNotEmpty(PCL_Deposit_Account_Balance))
            this.PCL_Deposit_Account_Balance = Decimal.valueOf(PCL_Deposit_Account_Balance);
        
        
        isRequiredFieldMissingForScore(opp_id);
        
        CreditScoreFromOpp(oppid);
        return retlst;
    }
    
    public class WrapperScore{
        @AuraEnabled
        public string Name{get;set;}
        @AuraEnabled
        public Decimal Score{get;set;}
        @AuraEnabled
        public string Rating{get;set;}
        WrapperScore(string Name1,Decimal Score1,string Rating1){
            this.Name=Name1;
            this.Score=Score1;
            this.Rating=Rating1;
        }
    }
    
    public string Rating(Decimal CreditScore){
        string rat='';
        if(lstRating.size()>0){
            for(Credit_Rating__mdt d:lstRating){
                if(CreditScore >= d.Credit_Score_Min__c && CreditScore <=d.Credit_Score_Max__c ){
                    rat =   d.Rating__c;
                }
            }
        }
        return rat;
    }    
    
    public Boolean isRequiredFieldMissingForScore(string oppid){
        Boolean autoProfound=false;
        Boolean unProfound=false;
        Boolean ccProfound=false;
        Boolean locProfound=false;
        List<OpportunityLineItem> lstlineItem  =  [select name,Opportunityid,Product2.Name,TotalPrice from OpportunityLineItem where Opportunityid =: oppid];
        if(lstlineItem.size()>0){
            system.debug('Test## lstlineItem================>'+lstlineItem);
            for(OpportunityLineItem item:lstlineItem){
                system.debug('Test## item================>'+item.Name);
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
            system.debug('Test## lstopp================>'+lstopp);
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
            system.debug('Test## lstapp================>'+lstapp);
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
            system.debug('Test## lstemp================>'+lstemp);
            for(FinServ__Employment__c e:lstemp){
                string cat = '';
                if(string.isEmpty(e.Income_type__c)){
                    system.debug('Required missing ===============>8');
                    return true;
                }else {
                    if(e.Account__r.FinServ__Age__pc==NULL || string.isEmpty(e.Account__r.Highest_Level_of_Education_attained__pc) || string.isEmpty(e.Account__r.Status_of_Address__c) || e.Account__r.Years_at_Residence__c ==NULL || string.isEmpty(e.Account__r.Jamaican_Tax_Registration_Number__pc)){
                        system.debug('Required missing ===============>9');
                        return true;
                    }
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
        
        system.debug('Required missing ===============>No');
        return false;
    }
    
    //======================Credit Scoring Model =========================================
    Public List<WrapperCreditScoringModel> WrapperScoringModellst = new List<WrapperCreditScoringModel>();
    
    Public List<MainScoringModel> ScoringModelApplicantDetails(string ProductType, string opp_id,string Total_Loan_Amount1,string Market_Value_of_Vehicle1,string Proposed_Starting_Limit1,string PC_Deposit_Account_Balance1,string Line_of_Credit_Starting_Limit1,string PCL_Deposit_Account_Balance1){
        lstRating =[select Rating__c,Classification__c,Credit_Score_Min__c,Credit_Score_Max__c from Credit_Rating__mdt];
        ProductTypeOfScoringModel = ProductType;
        set<id> oppid = new set<id>();
        oppid.add(opp_id);
        
        if(string.isNotEmpty(Total_Loan_Amount1))
            this.Total_Loan_Amount = Decimal.valueOf(Total_Loan_Amount1);
        if(string.isNotEmpty(Market_Value_of_Vehicle1))
            this.Market_Value_of_Vehicle = Decimal.valueOf(Market_Value_of_Vehicle1);
        if(string.isNotEmpty(Proposed_Starting_Limit1))
            this.Proposed_Starting_Limit = Decimal.valueOf(Proposed_Starting_Limit1);
        if(string.isNotEmpty(PC_Deposit_Account_Balance1))
            this.PC_Deposit_Account_Balance = Decimal.valueOf(PC_Deposit_Account_Balance1);
        if(string.isNotEmpty(Line_of_Credit_Starting_Limit1))
            this.Line_of_Credit_Starting_Limit = Decimal.valueOf(Line_of_Credit_Starting_Limit1);
        if(string.isNotEmpty(PCL_Deposit_Account_Balance1))
            this.PCL_Deposit_Account_Balance = Decimal.valueOf(PCL_Deposit_Account_Balance1);
        
        
         
        
        
        
        CreditScoreFromOpp(oppid);
        List<List<WrapperScoringModel>> AppProductScore = new List<List<WrapperScoringModel>>();
        
        if(MapProductScore.size()>0){
            system.debug('MapProductScore.values()====>'+MapProductScore.values());
            AppProductScore.addAll(MapProductScore.values());
        }            
        
        system.debug('AppProductScore=====>'+AppProductScore);
         system.debug('retlst=====>'+retlst);
     
        MainScoringModellst.add(new MainScoringModel(WrapperScoringModellst,AppProductScore,retlst));
        // system.debug('WrapperScoringModellst=====>'+WrapperScoringModellst);
        //system.debug('WrapperScoringlst=====>'+WrapperScoringlst);
        //system.debug('AppScore=====>'+AppScore);
        system.debug('MapAppScore=====>'+MapAppScore);
        return MainScoringModellst;
    }
    Public List<MainScoringModel> MainScoringModellst = new List<MainScoringModel>();
    public class MainScoringModel{
        Public List<WrapperCreditScoringModel> WrapperScoringModellst{get;set;}
        public List<List<WrapperScoringModel>> AppProductScore{get;set;}
        public List<WrapperScore> lstscore{get;set;}
        public MainScoringModel(List<WrapperCreditScoringModel> WrapperScoringModellst,List<List<WrapperScoringModel>> AppProductScore,List<WrapperScore> lstscore){
            this.WrapperScoringModellst = WrapperScoringModellst;
            this.AppProductScore = AppProductScore;
            this.lstscore = lstscore;
        }
        
    }
    
    
    
    
    public class WrapperCreditScoringModel{
        public string name{get;set;}
        public string taxNumber{get;set;}
        public string grossIncome{get;set;}
        public string incomeType{get;set;}
        public string politcallyExposed{get;set;}
        public string sanctionScreening{get;set;}
        public List<List<WrapperScoringModel>> AppScore{get;set;}
        
        public WrapperCreditScoringModel(string name,string taxNumber,string grossIncome,string incomeType,string politcallyExposed,string NegaticeTrace,List<List<WrapperScoringModel>> AppScore){
            this.name = name;
            this.taxNumber = taxNumber;
            this.grossIncome=grossIncome;
            this.incomeType = incomeType;
            this.politcallyExposed = politcallyExposed;
            this.sanctionScreening = NegaticeTrace;
            this.AppScore = AppScore;
        }
    }
    Public List<WrapperScoringModel> WrapperScoringlst = new List<WrapperScoringModel>();
    public class WrapperScoringModel{
        public integer index{get;set;}
        public string heading{get;set;}
        public string inputValue{get;set;}
        public string range{get;set;}
        public string score{get;set;}
        public string weight{get;set;}
        public WrapperScoringModel(string name,string inputValue,string range,string score, string weight){
            this.heading = name;
            this.inputValue = inputValue;
            this.range = range;
            this.score = score;
            this.weight = weight;
            index=0;
        }
    }
    
}