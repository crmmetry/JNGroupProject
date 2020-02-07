public class CreditScoringModelController {
    Public List<CreditScoreHelper.WrapperCreditScoringModel> WrapperScoringModellst{get;set;}
    public List<List<CreditScoreHelper.WrapperScoringModel>> AppProductScore_lst{get;set;} 
    public string product_Name{get;set;}
    public string applicationID{get;set;}
    public string typeOfApplication{get;set;}
    public string applicationStatus{get;set;}
    public string numberOfApplicant{get;set;}
    public string dateOfApplication{get;set;}
    public string loanAmount{get;set;}
    public string dateOfApplication1{get;set;}
    
    public string finalScore{get;set;}
    public string rating{get;set;}
    
    
    public CreditScoringModelController(){
        WrapperScoringModellst = new List<CreditScoreHelper.WrapperCreditScoringModel>();
        AppProductScore_lst = new List<List<CreditScoreHelper.WrapperScoringModel>>();
        product_Name = '';
        typeOfApplication = 'Personal';
        applicationStatus='Prior to Review';
        numberOfApplicant = '';
        loanAmount = '';
        applicationID='App-0001';
        
        
        date myDate = system.today();
        dateOfApplication = myDate.format();
        dateOfApplication1 = DateTime.newInstance(myDate.year(),myDate.month(),myDate.day()).format('dd-MMM-YYYY');
        
        
        
        finalScore='';
        rating='';
        
        
        system.debug('CreditScoringModelController=========================================1');
        //ProductSelection='Auto Loan';
        //ProductSelection='Unsecured Loan';
        //ProductSelection='Credit Card';
        //ProductSelection='Line of Credit';
        
        string Total_Loan_Amount1='0'; 
        string Market_Value_of_Vehicle1='0';
        string Proposed_Starting_Limit1='0';
        string PC_Deposit_Account_Balance1='0';
        string Line_of_Credit_Starting_Limit1='0';
        string PCL_Deposit_Account_Balance1='0';        
        
      /*  
        if(ApexPages.currentPage().getParameters().containsKey('Total_Loan_Amount')){
            Total_Loan_Amount1 = ApexPages.currentPage().getParameters().get('Total_Loan_Amount');
        }
        if(ApexPages.currentPage().getParameters().containsKey('marketValue')){
            Market_Value_of_Vehicle1 = ApexPages.currentPage().getParameters().get('marketValue');
        }
        if(ApexPages.currentPage().getParameters().containsKey('proposedStarting')){
            Proposed_Starting_Limit1 = ApexPages.currentPage().getParameters().get('proposedStarting');
        }
        if(ApexPages.currentPage().getParameters().containsKey('pcDeposit')){
            PC_Deposit_Account_Balance1 = ApexPages.currentPage().getParameters().get('pcDeposit');
        }
        if(ApexPages.currentPage().getParameters().containsKey('locStarting')){
            Line_of_Credit_Starting_Limit1 = ApexPages.currentPage().getParameters().get('locStarting');
        }
        if(ApexPages.currentPage().getParameters().containsKey('pclDeposit')){
            PCL_Deposit_Account_Balance1 = ApexPages.currentPage().getParameters().get('pclDeposit');
        }        
        */
        
     List<CreditScoreHelper.MainScoringModel> MainScoringModellst = new List<CreditScoreHelper.MainScoringModel>();
        if(ApexPages.currentPage().getParameters().containsKey('productName')){
            product_Name = ApexPages.currentPage().getParameters().get('productName');
        }
        if(ApexPages.currentPage().getParameters().containsKey('numberOfApplicant')){
            numberOfApplicant = ApexPages.currentPage().getParameters().get('numberOfApplicant');
        }
        /*if(ApexPages.currentPage().getParameters().containsKey('loanAmount')){
            loanAmount = ApexPages.currentPage().getParameters().get('loanAmount');
        }*/
        if(ApexPages.currentPage().getParameters().containsKey('oppid')){
            
            string oppid=ApexPages.currentPage().getParameters().get('oppid');
            opportunity opp=[select Product_Details__r.Loan_Amount__c,
                             Product_Details__r.PC_Collateral_Type__c,
                             Product_Details__r.PCL_Collateral_Type__c,
                             Product_Details__r.Unsecured_Loan_Amount__c,
                             Product_Details__r.Market_Value_of_Property__c,
                         Product_Details__r.Minimum_MV_PP__c,
                             Product_Details__r.Market_Value_of_Vehicle__c,
                         Product_Details__r.Proposed_Starting_Limit__c,
                         Product_Details__r.PC_Deposit_Account_Balance__c,
                         Product_Details__r.Line_of_Credit_Starting_Limit__c,
                         Product_Details__r.PCL_Deposit_Account_Balance__c from opportunity where id=:oppid limit 1];
            Total_Loan_Amount1=string.valueof(opp.Product_Details__r.Loan_Amount__c==null?0:opp.Product_Details__r.Loan_Amount__c); 
            Market_Value_of_Vehicle1=string.valueof(opp.Product_Details__r.Market_Value_of_Vehicle__c==null?0:opp.Product_Details__r.Market_Value_of_Vehicle__c);
            //Market_Value_of_Vehicle1=string.valueof(opp.Product_Details__r.Minimum_MV_PP__c==null?0:opp.Product_Details__r.Minimum_MV_PP__c);
            Proposed_Starting_Limit1=string.valueof(opp.Product_Details__r.Proposed_Starting_Limit__c==null?0:opp.Product_Details__r.Proposed_Starting_Limit__c);
            //if(opp.Product_Details__r.PC_Collateral_Type__c=='None')
            //    PC_Deposit_Account_Balance1='0';
            //if(opp.Product_Details__r.PC_Collateral_Type__c=='Cash/Investment')
                PC_Deposit_Account_Balance1=string.valueof(opp.Product_Details__r.PC_Deposit_Account_Balance__c==null?0:opp.Product_Details__r.PC_Deposit_Account_Balance__c);           
            Line_of_Credit_Starting_Limit1=string.valueof(opp.Product_Details__r.Line_of_Credit_Starting_Limit__c==null?0:opp.Product_Details__r.Line_of_Credit_Starting_Limit__c);
            //if(opp.Product_Details__r.PCL_Collateral_Type__c=='None')
            //PCL_Deposit_Account_Balance1='0'; 
           //if(opp.Product_Details__r.PCL_Collateral_Type__c=='Cash/Investment')
          PCL_Deposit_Account_Balance1=string.valueof(opp.Product_Details__r.PCL_Deposit_Account_Balance__c==null?0:opp.Product_Details__r.PCL_Deposit_Account_Balance__c);
            //if(opp.Product_Details__r.PCL_Collateral_Type__c=='Real-Estate')  
              //  PCL_Deposit_Account_Balance1=string.valueof(opp.Product_Details__r.Market_Value_of_Property__c==null?0:opp.Product_Details__r.Market_Value_of_Property__c);
            if(product_Name=='Auto Loan'){
                      loanAmount=string.valueof(opp.Product_Details__r.Loan_Amount__c==null?0:opp.Product_Details__r.Loan_Amount__c); 
                    }
                    if(product_Name=='Unsecured Loan'){
                      loanAmount=string.valueof(opp.Product_Details__r.Unsecured_Loan_Amount__c==null?0:opp.Product_Details__r.Unsecured_Loan_Amount__c);
                    }
                    if(product_Name=='Credit Card'){
                       loanAmount=string.valueof(opp.Product_Details__r.Proposed_Starting_Limit__c==null?0:opp.Product_Details__r.Proposed_Starting_Limit__c);
                    }
                    if(product_Name=='Line of Credit'){
                       loanAmount=string.valueof(opp.Product_Details__r.Line_of_Credit_Starting_Limit__c==null?0:opp.Product_Details__r.Line_of_Credit_Starting_Limit__c);
                    }
            system.debug('oppid========================================='+oppid);
            CreditScoreHelper csh = new CreditScoreHelper();
            MainScoringModellst = csh.ScoringModelApplicantDetails(product_Name,oppid,Total_Loan_Amount1,Market_Value_of_Vehicle1,Proposed_Starting_Limit1,PC_Deposit_Account_Balance1,Line_of_Credit_Starting_Limit1,PCL_Deposit_Account_Balance1);
            
           // List<List<WrapperScoringModel>> AppProductScore
            
            system.debug('MainScoringModellst========================================='+MainScoringModellst);
            if(MainScoringModellst.size()>0){
                 List<CreditScoreHelper.WrapperScore> lstRetingscore = new List<CreditScoreHelper.WrapperScore>(); 
                WrapperScoringModellst = MainScoringModellst[0].WrapperScoringModellst;
                AppProductScore_lst = MainScoringModellst[0].AppProductScore;
                lstRetingscore = MainScoringModellst[0].lstscore;
                              
                
                system.debug('Name  WrapperScoringModellst====='+WrapperScoringModellst);
                system.debug('Name  AppProductScore_lst====='+AppProductScore_lst);
                system.debug('Name  lstRetingscore====='+lstRetingscore);
                
              Boolean count=true;
                string taxnumber='';
                for(CreditScoreHelper.WrapperCreditScoringModel c:WrapperScoringModellst){
                    if(count){
                      taxnumber  =c.taxNumber;
                    }
                    count=false;
                    //system.debug('taxNumber====='+c.taxNumber);
                    //system.debug('grossIncome====='+c.grossIncome);
                    //system.debug('incomeType====='+c.incomeType);
                    //system.debug('politcallyExposed====='+c.politcallyExposed);
                    //system.debug('sanctionScreening====='+c.sanctionScreening);
                    system.debug('AppScore====='+c.AppScore);
                    List<CreditScoreHelper.WrapperScoringModel> mylst =new List<CreditScoreHelper.WrapperScoringModel>();
                    //mylst=c.AppScore;
                    
                    for(List<CreditScoreHelper.WrapperScoringModel> m:c.AppScore){
                        system.debug('Appplicant score ================'+m);
                        for(CreditScoreHelper.WrapperScoringModel b:m){
                            if(b.heading=='Credit History in last 24 Months'){
                                b.inputValue = CreditHistory(b.inputValue);
                            }
                            if(b.heading=='Years at Current Residence'){
                                b.inputValue = CurrentResidence(Decimal.valueOf(b.inputValue));
                            }
                            
                            
                           // system.debug('score### heading================'+b.heading);
                            //system.debug('score### inputValue================'+b.inputValue);
                            //system.debug('score### range================'+b.range);
                            //system.debug('score### score================'+b.score);
                            //system.debug('score### weight================'+b.weight);
                            //system.debug('########================########');
                        }
                    }
                     
                    
                    
                }
                for(List<CreditScoreHelper.WrapperScoringModel> c:AppProductScore_lst){
                    system.debug('Product====='+c);
                    for(CreditScoreHelper.WrapperScoringModel b:c){
                        system.debug('score### heading================'+b.heading);
                        system.debug('score### inputValue================'+b.inputValue);
                        system.debug('score### score================'+b.score);
                        system.debug('score### weight================'+b.weight);
                        if(b.heading=='Collateral')
                            b.index=1;
                        if(b.heading=='Repayment Method')
                            b.index=4;
                        
                        if(b.heading=='Loan to Value'){
                            b.inputValue = LoantoValue(Decimal.valueOf(b.inputValue));
                            b.index=2;
                        }
                        if(b.heading=='Ability to Service'){
                            b.inputValue = AbilitytoService(Decimal.valueOf(b.inputValue));
                            b.index=3;
                        }
                    }
                }
                
                for(CreditScoreHelper.WrapperScore c:lstRetingscore){
                    system.debug('lstRetingscore====='+c);
                    if(product_Name=='Auto Loan'){
                        if(c.Name=='AUTO'){
                            finalScore=string.valueOf(c.Score);
                            rating = c.Rating;
                        }
                    }
                    if(product_Name=='Unsecured Loan'){
                        if(c.Name=='UN'){
                            finalScore=string.valueOf(c.Score);
                            rating = c.Rating;
                        }
                    }
                    if(product_Name=='Credit Card'){
                        if(c.Name=='CreditCard'){
                            finalScore=string.valueOf(c.Score);
                            rating = c.Rating;
                        }
                    }
                    if(product_Name=='Line of Credit'){
                        if(c.Name=='LOC'){
                            finalScore=string.valueOf(c.Score);
                            rating = c.Rating;
                        }
                    }
                }
                
                
                if(product_Name=='Auto Loan'){
                    applicationID = 'C1-'+taxnumber+'-'+dateOfApplication;
                    
                }
                if(product_Name=='Unsecured Loan'){
                    applicationID = 'C3-'+taxnumber+'-'+dateOfApplication;
                }
                if(product_Name=='Credit Card'){
                    applicationID = 'C4-'+taxnumber+'-'+dateOfApplication;
                    
                }
                if(product_Name=='Line of Credit'){
                    applicationID = 'C5-'+taxnumber+'-'+dateOfApplication;
                    
                }
                
                
            }
        }
        
        
        
    }
    
   public string CreditHistory(string str){
        string data='-1';       
        if(str =='0')
            return 'No Delinquency';
        else if(str =='10')
            return '1 - 10 days Delinquent';
        else if(str =='30')
            return '11 - 30 days Delinquent';
        else if(str =='60')
            return '31 - 60 days Delinquent';
        else if(str =='90')
            return '61 - 90 days Delinquent';
        else if(str =='91')
            return 'Over 90 days Delinquent';
        else if(str =='101')
            return 'No Credit History';       
        return data;
    }
    
    public string CurrentResidence(Decimal str){
        string data='-1';       
        if(str <=0)
            return '< 1 year';
        else if(str >1 && str <=3)
            return '1 - 3 year';
        else if(str >3)
            return '> 3 year';
              
        return data;
    }
    public string AbilitytoService(Decimal str){
        string data='-1';       
        if(str <=25)
            return 'TDSR(1% - 25%)';
        else if(str >=26 && str <=40)
            return 'TDSR(26% - 40%)';
        else if(str >=41 && str <=50)
            return 'TDSR(41% - 50%)';
        else if(str >50)
            return 'TDSR(>50%)';
             
        return data;
    }
     public string LoantoValue(Decimal str){
        string data='-1';       
        if(str <=60)
            return '<60%';
        else if(str >=61 && str <=85)
            return '61% - 85%';
        else if(str >=86 && str <=90)
            return '86% - 90%';
         else if(str >=91 && str <=95)
            return '91% - 95%';
        else if(str >95)
            return '>95%';
             
        return data;
    }
    
    
    
}