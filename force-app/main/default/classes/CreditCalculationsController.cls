public class CreditCalculationsController {
    public List<Loan_Calculator__c> ProductDetails{get;set;}
    public Boolean isAutoFound{get;set;}
    public Boolean isUnFound{get;set;}
    public Boolean isCcFound{get;set;}
    public Boolean isLocFound{get;set;}
    public string productName{get;set;}
    public Date currentDate{get;set;}
    public String officername {get; set;}
    public list<Applicant__c>  applst{get;set;}
    map<id, Applicant__c>  mapapplst;
    public List<WrapperAssets> assetslst{get;set;}
    public CreditCalculationsController(){
        applst=new list<Applicant__c>();
        assetslst=new List<WrapperAssets>();
        ProductDetails = new List<Loan_Calculator__c>();
        isAutoFound=false;
        isUnFound=false;
        isCcFound=false;
        isLocFound=false;
        currentDate = system.today(); 
        officername=UserInfo.getName();
        if(ApexPages.currentPage().getParameters().containsKey('loanid')){
            string loanid = ApexPages.currentPage().getParameters().get('loanid');
            fillProductDetailsFromOppAndLead(loanid);
        }
        if(ApexPages.currentPage().getParameters().containsKey('oppid')){
            string oppid=ApexPages.currentPage().getParameters().get('oppid');
            Fetchapplicantlist(oppid);
            system.debug('oppid==============='+oppid);
            system.debug('mapapplst==============='+mapapplst);
            FillAssets(oppid);
        }
        
    }
    private void Fetchapplicantlist(String oppid){
        mapapplst= new map<id, Applicant__c>([Select id, Account__r.name,
                                              Account__r.PersonBirthdate,
                                              Account__r.FinServ__Age__pc,
                                              Account__r.FinServ__Gender__pc,
                                              Account__r.Marital_Status__c,
                                              Account__r.Highest_Level_of_Education_attained__pc,
                                              Account__r.FinServ__NumberOfDependents__pc,
                                              Account__r.Status_of_Address__pc,
                                              Account__r.Years_at_Residence__pc,
                                              CRIF_Rating__c,
                                              CreditInfo_Rating__c,
                                              Overall_Credit_Bureau_Rating__c,
                                              Credit_History_in_last_24_Months__c,
                                              Assessment_of_Applicant_Net_Worth__c,
                                              Is_applicant_KYC_Compliant__c,
                                              Time_as_Member_Months__c,
                                              Time_as_Member_Years__c,
                                              /*Rim_Number__c,*/
                                              Primary_Relationship_Tier__c,
                                              Affiliation_Type__c,
                                              Sanction_Screening_Completed__c,
                                              JN_Group_Employee__c,
                                              JN_Employee_Loan_Benefit__c,
                                              Gross_Monthly_IncomeC__c,
                                              Salary_and_Allowances_as_per_pay_slips__c,
                                              Gratuity_in_lieu_of_Pension__c,
                                              Performance_Based_PayC__c,
                                              Net_Profit_Sole_Trader__c,
                                              Director_s_Emoluments_Director__c,
                                              Share_of_Profit_Partnership__c,
                                              Share_of_Profit_Shareholder__c ,
                                              Pension__c,
                                              Existing_Real_Estate_Rental_IC__c,
                                              Existing_Real_estate_Rental_II__c,
                                              Projected_Real_Estate_Rental__c,
                                              Other_Income__c,
                                              Income_Tax_Monthly_Payment_Prior_Loan__c,
                                              NIS_Contribution_Monthly_Prior_Loan__c,
                                              NHT_Contributions_Monthly_Prior_Loan__c,
                                              Education_Tax_Monthly_Prior_Loan__c,
                                              Food_Cost_Monthly_Prior_Loan__c,
                                              Personal_Expenses_Monthly_Prior_Loan__c,
                                              Child_Care_Costs_Monthly_Prior_Loan__c,
                                              School_Costs_Monthly_Prior_Loan__c,
                                              Health_Costs_Monthly_Prior_Loan__c,
                                              Other_Personal_Family_Costs_Prior_After__c,
                                              Rent_Board_Monthly_Prior_Loan__c,
                                              Strata_Maintenance_Monthly_Prior_Loan__c,
                                              Property_Tax_Monthly_Prior_Loan__c,
                                              Property_Insurance_Monthly_Prior_Loan__c,
                                              Property_Maintenance_Monthly_Prior_loan__c,
                                              Electricity_Monthly_Prior_Loan__c,
                                              Water_Monthly_Prior_Loan__c,
                                              Cell_Phone_Landline_Monthly_Prior_Loan__c,
                                              Internet_Cable_Monthly_Prior_Loan__c,
                                              Motor_V_Insurance_Monthly_Prior_Loan__c,
                                              Motor_Vehicle_Fitness_Monthly_Prior_Loan__c,
                                              Motor_V_Maintenance_Monthly_Before_Loan__c,
                                              Other_Transport_Costs_Monthly_Prior_Loan__c ,
                                              Cooking_Gas_Monthly_Prior_Loan__c,
                                              House_Keeping_Monthly_Prior_Loan__c,
                                              Other_Utilities_Monthly_Prior_Loan__c,
                                              Fares_Monthly_Prior_Loan__c,
                                              Toll_Fees_Monthly_Prior_Loan__c,
                                              Motor_Vehicle_Reg_Monthly_Prior_Loan__c,
                                              Basic_monthly_pay_no_allowances__c,
                                              Other_Transport_Monthly_After_Loan__c,
                                              Motor_V_Maintenance_Monthly_After_Loan__c,
                                              Motor_Vehicle_Reg_Monthly_After_Loan__c,
                                              Motor_V_Insurance_Monthly_After_Loan__c,
                                              Petrol_Fuel_Monthly_After_Loan__c,
                                              Toll_Fees_Monthly_After_Loan__c,
                                              Fares_Monthly_After_Loan__c,
                                              Other_Utilities_Monthly_After_Loan__c,
                                              House_Keeping_Costs_Monthly_After_Loan__c,
                                              Cooking_Gas_Monthly_After_Loan__c,
                                              Internet_Cable_Monthly_After_Loan__c,
                                              Cell_Phone_Landline_Monthly_After_Loan__c,
                                              Water_Monthly_After_Loan__c,
                                              Electricity_Monthly_After_Loan__c,
                                              Property_Maintenance_Monthly_After_Loan__c,
                                              Property_Insurance_Monthly_After_Loan__c,
                                              Property_Tax_Monthly_After_Loan__c,
                                              Strata_Maintenance_Monthly_After_Loan__c,
                                              Rent_Board_Monthly_After_Loan__c,
                                              Health_Costs_Monthly_After_Loan__c,
                                              School_Costs_Monthly_After_Loan__c,
                                              Child_Care_Costs_Monthly_After_Loan__c,
                                              Personal_Expenses_Monthly_After_Loan__c,
                                              Food_Costs_Monthly_After_Loan__c,
                                              Total_unsecured_Balance_Installment_and__c
                                              from Applicant__c where Opportunity__c=:oppId]);
        for(Applicant__c a: mapapplst.values()){
            system.debug('Education ='+a.Account__r.Highest_Level_of_Education_attained__pc+' ....Of.....=>'+a.Account__c);
        }
    }
    private void FillAssets(string oppid){
        map <id,list<Application_Asset_Liability__c>> appidVsAssetslst=new map<id,list<Application_Asset_Liability__c>>();
        list<Application_Asset_Liability__c> lst = [select 
                                                    Application__c,
                                                    Loan_Balance_Prior__c,
                                                    Assets_and_Liabilities__r.RecordType.Name,
                                                    Assets_and_Liabilities__r.Total_Market_Value__c,
                                                    Assets_and_Liabilities__r.Cash_Value__c,
                                                    Assets_and_Liabilities__r.Account_Balance__c,
                                                    Assets_and_Liabilities__r.Total_Contributions_to_Date__c,
                                                    Assets_and_Liabilities__r.Loan_Balance_Prior__c,
                                                    Assets_and_Liabilities__r.Asset_Credit_Balance__c,
                                                    Assets_and_Liabilities__r.Loan_Balance_After__c,
                                                    Assets_and_Liabilities__r.Asset_Credit_Balance_After__c,
                                                    Assets_and_Liabilities__r.Overdraft_Limit__c,
                                                    Assets_and_Liabilities__r.Monthly_Payment_Prior__c,
                                                    Assets_and_Liabilities__r.Minimum_Payment__c,
                                                    Assets_and_Liabilities__r.Monthly_Payment__c ,
                                                    Assets_and_Liabilities__r.Minimum_Payment_After__c
                                                    from Application_Asset_Liability__c where Application__r.Opportunity__c =:oppid]; 
        if(lst.size()>0){
            for(Application_Asset_Liability__c a:lst){
                if(appidVsAssetslst.containsKey(a.Application__c)){
                    list<Application_Asset_Liability__c> lstid = appidVsAssetslst.get(a.Application__c);
                    lstid.add(a);
                    appidVsAssetslst.put(a.Application__c, lstid);
                }
                else{
                    List<Application_Asset_Liability__c> lstid = new List<Application_Asset_Liability__c>();
                    lstid.add(a);
                    appidVsAssetslst.put(a.Application__c, lstid);
                }
            }
        }
        if(mapapplst.keySet().size()>0){
            for(id appid:mapapplst.keySet()){
                list<Application_Asset_Liability__c> appviselist=new list<Application_Asset_Liability__c>();
                if(appidVsAssetslst.containskey(appid))
                    appviselist=appidVsAssetslst.get(appid);
                Applicant__c applicant=mapapplst.get(appid);
                Decimal TotalAssetsPrior=0.00;
                Decimal TotalAssetsAfter=0.00;
                Decimal TotalLiabilitiesPrior=0.00;
                Decimal TotalLiabilitiesAfter=0.00;
                Decimal NetWorthPrior=0.00;
                Decimal NetWorthAfter=0.00;
                Decimal GrossMonthlyIncomePrior=0.00;
                Decimal GrossMonthlyIncomeAfter=0.00;
                Decimal ExistingMonthlyInstallmentPrior=0.00;
                Decimal ExistingMonthlyInstallmentAfter=0.00;
                Decimal MonthlyInflowsPrior=0.00;
                Decimal MonthlyInflowsAfter=0.00;
                Decimal MonthlyOutflowsPrior=0.00;
                Decimal MonthlyOutflowsAfter=0.00;
                Decimal ResidualIncomePrior=0.00;
                Decimal ResidualIncomeAfter=0.00;
                Decimal BasicMonthlyPayPrior=0.00;
                Decimal BasicMonthlyPayAfter=0.00;
                Decimal TotalUnsecuredCreditPrior=0.00;
                Decimal TotalUnsecuredCreditAfter=0.00;
                if(appviselist.size()>0){
                    for(Application_Asset_Liability__c asl:appviselist){
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Real Estate' || asl.Assets_and_Liabilities__r.RecordType.Name=='Motor Vehicle' || asl.Assets_and_Liabilities__r.RecordType.Name=='Other Assets'){
                            TotalAssetsPrior +=asl.Assets_and_Liabilities__r.Total_Market_Value__c==null?0:asl.Assets_and_Liabilities__r.Total_Market_Value__c;
                            TotalAssetsAfter +=asl.Assets_and_Liabilities__r.Total_Market_Value__c==null?0:asl.Assets_and_Liabilities__r.Total_Market_Value__c;
                            TotalLiabilitiesPrior +=asl.Loan_Balance_Prior__c==null?0:asl.Loan_Balance_Prior__c;
                            TotalLiabilitiesAfter +=asl.Assets_and_Liabilities__r.Loan_Balance_After__c==null?0:asl.Assets_and_Liabilities__r.Loan_Balance_After__c;
                            ExistingMonthlyInstallmentPrior+=asl.Assets_and_Liabilities__r.Monthly_Payment_Prior__c==null?0:asl.Assets_and_Liabilities__r.Monthly_Payment_Prior__c;
                            ExistingMonthlyInstallmentAfter+=asl.Assets_and_Liabilities__r.Monthly_Payment__c==null?0:asl.Assets_and_Liabilities__r.Monthly_Payment__c;
                        }
                        // Chnage Assets_and_Liabilities__r.Loan_Balance_Prior__c To Loan_Balance_Prior__c JN1-2497
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Life Insurance Policies'){
                            TotalAssetsPrior += asl.Assets_and_Liabilities__r.Cash_Value__c==null?0:asl.Assets_and_Liabilities__r.Cash_Value__c;
                            TotalAssetsAfter +=asl.Assets_and_Liabilities__r.Cash_Value__c==null?0:asl.Assets_and_Liabilities__r.Cash_Value__c;
                        }
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Savings/Current Accounts and Investments'){
                            TotalAssetsPrior +=asl.Assets_and_Liabilities__r.Account_Balance__c==null?0:asl.Assets_and_Liabilities__r.Account_Balance__c;
                            TotalAssetsAfter +=asl.Assets_and_Liabilities__r.Account_Balance__c==null?0:asl.Assets_and_Liabilities__r.Account_Balance__c;
                            TotalLiabilitiesPrior +=asl.Assets_and_Liabilities__r.Overdraft_Limit__c==null?0:asl.Assets_and_Liabilities__r.Overdraft_Limit__c;
                            TotalLiabilitiesAfter +=asl.Assets_and_Liabilities__r.Overdraft_Limit__c==null?0:asl.Assets_and_Liabilities__r.Overdraft_Limit__c;
                        }
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Pension Contributions or Individual Retirement Schemes'){
                            TotalAssetsPrior +=asl.Assets_and_Liabilities__r.Total_Contributions_to_Date__c==null?0:asl.Assets_and_Liabilities__r.Total_Contributions_to_Date__c;
                            TotalAssetsAfter +=asl.Assets_and_Liabilities__r.Total_Contributions_to_Date__c==null?0:asl.Assets_and_Liabilities__r.Total_Contributions_to_Date__c;
                        }
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Credit Cards' || asl.Assets_and_Liabilities__r.RecordType.Name=='Lines of Credit'){
                            TotalLiabilitiesPrior +=asl.Assets_and_Liabilities__r.Asset_Credit_Balance__c==null?0:asl.Assets_and_Liabilities__r.Asset_Credit_Balance__c; 
                            TotalLiabilitiesAfter +=asl.Assets_and_Liabilities__r.Asset_Credit_Balance_After__c==null?0:asl.Assets_and_Liabilities__r.Asset_Credit_Balance_After__c;
                            ExistingMonthlyInstallmentPrior+=asl.Assets_and_Liabilities__r.Minimum_payment__c==null?0:asl.Assets_and_Liabilities__r.Minimum_payment__c;
                            ExistingMonthlyInstallmentAfter+=asl.Assets_and_Liabilities__r.Minimum_payment_after__c==null?0:asl.Assets_and_Liabilities__r.Minimum_payment_after__c; 
                        }
                        if(asl.Assets_and_Liabilities__r.RecordType.Name=='Other Loans'){
                            TotalLiabilitiesPrior +=asl.Loan_Balance_Prior__c==null?0:asl.Loan_Balance_Prior__c;
                            TotalLiabilitiesAfter +=asl.Assets_and_Liabilities__r.Loan_Balance_After__c==null?0:asl.Assets_and_Liabilities__r.Loan_Balance_After__c;
                            ExistingMonthlyInstallmentPrior+=asl.Assets_and_Liabilities__r.Monthly_Payment_Prior__c==null?0:asl.Assets_and_Liabilities__r.Monthly_Payment_Prior__c;
                            ExistingMonthlyInstallmentAfter+=asl.Assets_and_Liabilities__r.Monthly_Payment__c==null?0:asl.Assets_and_Liabilities__r.Monthly_Payment__c;
                        }// Chnage Assets_and_Liabilities__r.Loan_Balance_Prior__c To Loan_Balance_Prior__c JN1-2497
                    }
                }
                NetWorthPrior=TotalAssetsPrior-TotalLiabilitiesPrior;
                NetWorthAfter=TotalAssetsAfter-TotalLiabilitiesAfter;
                GrossMonthlyIncomePrior=applicant.Gross_Monthly_IncomeC__c==null?0:applicant.Gross_Monthly_IncomeC__c;
                GrossMonthlyIncomeAfter=applicant.Gross_Monthly_IncomeC__c==null?0:applicant.Gross_Monthly_IncomeC__c;
                MonthlyInflowsPrior=(applicant.Salary_and_Allowances_as_per_pay_slips__c==null?0:applicant.Salary_and_Allowances_as_per_pay_slips__c)+
                    (applicant.Gratuity_in_lieu_of_Pension__c==null?0:applicant.Gratuity_in_lieu_of_Pension__c)+
                    (applicant.Performance_Based_PayC__c==null?0:applicant.Performance_Based_PayC__c)+
                    (applicant.Net_Profit_Sole_Trader__c==null?0:applicant.Net_Profit_Sole_Trader__c)+
                    (applicant.Director_s_Emoluments_Director__c==null?0:applicant.Director_s_Emoluments_Director__c)+
                    (applicant.Share_of_Profit_Partnership__c==null?0:applicant.Share_of_Profit_Partnership__c)+
                    (applicant.Share_of_Profit_Shareholder__c==null?0:applicant.Share_of_Profit_Shareholder__c)+
                    (applicant.Pension__c==null?0:applicant.Pension__c)+
                    (applicant.Existing_Real_Estate_Rental_IC__c==null?0:applicant.Existing_Real_Estate_Rental_IC__c)+
                    (applicant.Existing_Real_estate_Rental_II__c==null?0:applicant.Existing_Real_estate_Rental_II__c)+
                    (applicant.Projected_Real_Estate_Rental__c==null?0:applicant.Projected_Real_Estate_Rental__c)+
                    (applicant.Other_Income__c==null?0:applicant.Other_Income__c) ;
                
                MonthlyInflowsAfter=(applicant.Salary_and_Allowances_as_per_pay_slips__c==null?0:applicant.Salary_and_Allowances_as_per_pay_slips__c)+
                    (applicant.Gratuity_in_lieu_of_Pension__c==null?0:applicant.Gratuity_in_lieu_of_Pension__c)+
                    (applicant.Performance_Based_PayC__c==null?0:applicant.Performance_Based_PayC__c)+
                    (applicant.Net_Profit_Sole_Trader__c==null?0:applicant.Net_Profit_Sole_Trader__c)+
                    (applicant.Director_s_Emoluments_Director__c==null?0:applicant.Director_s_Emoluments_Director__c)+
                    (applicant.Share_of_Profit_Partnership__c==null?0:applicant.Share_of_Profit_Partnership__c)+
                    (applicant.Share_of_Profit_Shareholder__c==null?0:applicant.Share_of_Profit_Shareholder__c)+
                    (applicant.Pension__c==null?0:applicant.Pension__c)+
                    (applicant.Existing_Real_Estate_Rental_IC__c==null?0:applicant.Existing_Real_Estate_Rental_IC__c)+
                    (applicant.Existing_Real_estate_Rental_II__c==null?0:applicant.Existing_Real_estate_Rental_II__c)+
                    (applicant.Projected_Real_Estate_Rental__c==null?0:applicant.Projected_Real_Estate_Rental__c)+
                    (applicant.Other_Income__c==null?0:applicant.Other_Income__c) ;
                
                MonthlyOutflowsPrior=(applicant.Income_Tax_Monthly_Payment_Prior_Loan__c==null?0.00:applicant.Income_Tax_Monthly_Payment_Prior_Loan__c)+
                    (applicant.NIS_Contribution_Monthly_Prior_Loan__c==null?0.00:applicant.NIS_Contribution_Monthly_Prior_Loan__c)+
                    (applicant.NHT_Contributions_Monthly_Prior_Loan__c==null?0.00:applicant.NHT_Contributions_Monthly_Prior_Loan__c)+
                    (applicant.Education_Tax_Monthly_Prior_Loan__c==null?0.00:applicant.Education_Tax_Monthly_Prior_Loan__c)+
                    (applicant.Food_Cost_Monthly_Prior_Loan__c==null?0.00:applicant.Food_Cost_Monthly_Prior_Loan__c)+
                    (applicant.Personal_Expenses_Monthly_Prior_Loan__c==null?0.00:applicant.Personal_Expenses_Monthly_Prior_Loan__c)+
                    (applicant.Child_Care_Costs_Monthly_Prior_Loan__c==null?0.00:applicant.Child_Care_Costs_Monthly_Prior_Loan__c)+
                    (applicant.School_Costs_Monthly_Prior_Loan__c==null?0.00:applicant.School_Costs_Monthly_Prior_Loan__c)+
                    (applicant.Health_Costs_Monthly_Prior_Loan__c==null?0.00:applicant.Health_Costs_Monthly_Prior_Loan__c)+
                    (applicant.Other_Personal_Family_Costs_Prior_After__c==null?0.00:applicant.Other_Personal_Family_Costs_Prior_After__c)+
                    (applicant.Rent_Board_Monthly_Prior_Loan__c==null?0.00:applicant.Rent_Board_Monthly_Prior_Loan__c)+
                    (applicant.Strata_Maintenance_Monthly_Prior_Loan__c==null?0.00:applicant.Strata_Maintenance_Monthly_Prior_Loan__c)+
                    (applicant.Property_Tax_Monthly_Prior_Loan__c==null?0.00:applicant.Property_Tax_Monthly_Prior_Loan__c)+
                    (applicant.Property_Insurance_Monthly_Prior_Loan__c==null?0.00:applicant.Property_Insurance_Monthly_Prior_Loan__c)+
                    (applicant.Property_Maintenance_Monthly_Prior_loan__c==null?0.00:applicant.Property_Maintenance_Monthly_Prior_loan__c)+
                    (applicant.Electricity_Monthly_Prior_Loan__c==null?0.00:applicant.Electricity_Monthly_Prior_Loan__c)+
                    (applicant.Water_Monthly_Prior_Loan__c==null?0.00:applicant.Water_Monthly_Prior_Loan__c)+
                    (applicant.Cell_Phone_Landline_Monthly_Prior_Loan__c==null?0.00:applicant.Cell_Phone_Landline_Monthly_Prior_Loan__c)+
                    (applicant.Internet_Cable_Monthly_Prior_Loan__c==null?0.00:applicant.Internet_Cable_Monthly_Prior_Loan__c)+
                    (applicant.Motor_V_Insurance_Monthly_Prior_Loan__c==null?0.00:applicant.Motor_V_Insurance_Monthly_Prior_Loan__c)+
                    (applicant.Motor_Vehicle_Reg_Monthly_Prior_Loan__c==null?0.00:applicant.Motor_Vehicle_Reg_Monthly_Prior_Loan__c)+
                    (applicant.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c==null?0.00:applicant.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c)+
                    (applicant.Motor_V_Maintenance_Monthly_Before_Loan__c==null?0.00:applicant.Motor_V_Maintenance_Monthly_Before_Loan__c)+
                    (applicant.Other_Transport_Costs_Monthly_Prior_Loan__c ==null?0.00:applicant.Other_Transport_Costs_Monthly_Prior_Loan__c)+
                    (applicant.Cooking_Gas_Monthly_Prior_Loan__c==null?0.00:applicant.Cooking_Gas_Monthly_Prior_Loan__c)+
                    (applicant.House_Keeping_Monthly_Prior_Loan__c==null?0.00:applicant.House_Keeping_Monthly_Prior_Loan__c)+
                    (applicant.Other_Utilities_Monthly_Prior_Loan__c==null?0.00:applicant.Other_Utilities_Monthly_Prior_Loan__c)+
                    (applicant.Fares_Monthly_Prior_Loan__c==null?0.00:applicant.Fares_Monthly_Prior_Loan__c)+
                    (applicant.Toll_Fees_Monthly_Prior_Loan__c==null?0.00:applicant.Toll_Fees_Monthly_Prior_Loan__c);
                
                MonthlyOutflowsAfter=(applicant.Other_Transport_Monthly_After_Loan__c==null?0.00:applicant.Other_Transport_Monthly_After_Loan__c)+
                    (applicant.Motor_V_Maintenance_Monthly_After_Loan__c==null?0.00:applicant.Motor_V_Maintenance_Monthly_After_Loan__c)+
                    (applicant.Motor_Vehicle_Reg_Monthly_After_Loan__c==null?0.00:applicant.Motor_Vehicle_Reg_Monthly_After_Loan__c)+
                    (applicant.Motor_V_Insurance_Monthly_After_Loan__c==null?0.00:applicant.Motor_V_Insurance_Monthly_After_Loan__c)+
                    (applicant.Petrol_Fuel_Monthly_After_Loan__c==null?0.00:applicant.Petrol_Fuel_Monthly_After_Loan__c)+
                    (applicant.Toll_Fees_Monthly_After_Loan__c==null?0.00:applicant.Toll_Fees_Monthly_After_Loan__c)+
                    (applicant.Fares_Monthly_After_Loan__c==null?0.00:applicant.Fares_Monthly_After_Loan__c)+
                    (applicant.Other_Utilities_Monthly_After_Loan__c==null?0.00:applicant.Other_Utilities_Monthly_After_Loan__c)+
                    (applicant.House_Keeping_Costs_Monthly_After_Loan__c==null?0.00:applicant.House_Keeping_Costs_Monthly_After_Loan__c)+
                    (applicant.Cooking_Gas_Monthly_After_Loan__c==null?0.00:applicant.Cooking_Gas_Monthly_After_Loan__c)+
                    (applicant.Internet_Cable_Monthly_After_Loan__c==null?0.00:applicant.Internet_Cable_Monthly_After_Loan__c)+
                    (applicant.Cell_Phone_Landline_Monthly_After_Loan__c==null?0.00:applicant.Cell_Phone_Landline_Monthly_After_Loan__c)+
                    (applicant.Water_Monthly_After_Loan__c==null?0.00:applicant.Water_Monthly_After_Loan__c)+
                    (applicant.Electricity_Monthly_After_Loan__c==null?0.00:applicant.Electricity_Monthly_After_Loan__c)+
                    (applicant.Property_Maintenance_Monthly_After_Loan__c==null?0.00:applicant.Property_Maintenance_Monthly_After_Loan__c)+
                    (applicant.Property_Insurance_Monthly_After_Loan__c==null?0.00:applicant.Property_Insurance_Monthly_After_Loan__c)+
                    (applicant.Property_Tax_Monthly_After_Loan__c==null?0.00:applicant.Property_Tax_Monthly_After_Loan__c)+
                    (applicant.Strata_Maintenance_Monthly_After_Loan__c==null?0.00:applicant.Strata_Maintenance_Monthly_After_Loan__c)+
                    (applicant.Rent_Board_Monthly_After_Loan__c==null?0.00:applicant.Rent_Board_Monthly_After_Loan__c)+
                    (applicant.Other_Personal_Family_Costs_Prior_After__c==null?0.00:applicant.Other_Personal_Family_Costs_Prior_After__c)+
                    (applicant.Health_Costs_Monthly_After_Loan__c==null?0.00:applicant.Health_Costs_Monthly_After_Loan__c)+
                    (applicant.School_Costs_Monthly_After_Loan__c==null?0.00:applicant.School_Costs_Monthly_After_Loan__c)+
                    (applicant.Child_Care_Costs_Monthly_After_Loan__c==null?0.00:applicant.Child_Care_Costs_Monthly_After_Loan__c)+
                    (applicant.Personal_Expenses_Monthly_After_Loan__c==null?0.00:applicant.Personal_Expenses_Monthly_After_Loan__c)+
                    (applicant.Food_Costs_Monthly_After_Loan__c==null?0.00:applicant.Food_Costs_Monthly_After_Loan__c);
                system.debug('MonthlyOutflowsAfter======='+MonthlyOutflowsAfter);
                ResidualIncomePrior=MonthlyInflowsPrior-MonthlyOutflowsPrior;
                ResidualIncomeAfter=MonthlyInflowsAfter-MonthlyOutflowsAfter;
                BasicMonthlyPayPrior=applicant.Basic_monthly_pay_no_allowances__c==null?0.00:applicant.Basic_monthly_pay_no_allowances__c ;
                BasicMonthlyPayAfter=applicant.Basic_monthly_pay_no_allowances__c==null?0.00:applicant.Basic_monthly_pay_no_allowances__c ;
                //JN1-2400
                TotalUnsecuredCreditPrior=applicant.Total_unsecured_Balance_Installment_and__c ==null?0.00:applicant.Total_unsecured_Balance_Installment_and__c  ;
                decimal apploanamt=0.00;
                if(ProductDetails.size()>0){
                 if(applicant.Account__r.PersonBirthdate!=null && applicant.Account__r.name!=null && ProductDetails[0].Applicant_1_Name__c!=null && applicant.Account__r.name==ProductDetails[0].Applicant_1_Name__c && applicant.Account__r.PersonBirthdate==ProductDetails[0].Applicant_1_Date_of_Birth__c)
                    apploanamt=(ProductDetails[0].App1_Loan_Amt_Alloc_UL__c ==null?0.00:ProductDetails[0].App1_Loan_Amt_Alloc_UL__c)+(ProductDetails[0].App1_Portion_LOC_Lim__c==null?0.00:ProductDetails[0].App1_Portion_LOC_Lim__c);
                else if(applicant.Account__r.PersonBirthdate!=null && applicant.Account__r.name!=null && ProductDetails[0].Applocant_2_Name__c!=null && applicant.Account__r.name==ProductDetails[0].Applocant_2_Name__c && applicant.Account__r.PersonBirthdate==ProductDetails[0].Applicant_2_Date_of_Birth__c)
                    apploanamt=(ProductDetails[0].App2_Loan_Amt_Alloc_UL__c  ==null?0.00:ProductDetails[0].App2_Loan_Amt_Alloc_UL__c )+(ProductDetails[0].App2_Portion_LOC_Lim__c==null?0.00:ProductDetails[0].App2_Portion_LOC_Lim__c);
                else if(applicant.Account__r.PersonBirthdate!=null && applicant.Account__r.name!=null && ProductDetails[0].Applicant_1_Name__c!=null && applicant.Account__r.name==ProductDetails[0].Applicant_1_Name__c && applicant.Account__r.PersonBirthdate==ProductDetails[0].Applicant_3_Date_of_Birth__c)
                    apploanamt=(ProductDetails[0].App3_Loan_Amt_Alloc_UL__c  ==null?0.00:ProductDetails[0].App3_Loan_Amt_Alloc_UL__c )+(ProductDetails[0].App3_Portion_LOC_Lim__c==null?0.00:ProductDetails[0].App3_Portion_LOC_Lim__c);
                }
                TotalUnsecuredCreditAfter=(applicant.Total_unsecured_Balance_Installment_and__c ==null?0.00:applicant.Total_unsecured_Balance_Installment_and__c)+apploanamt;  
                system.debug('apploanamt============'+apploanamt);
                system.debug('applicant.Account__r.name============'+applicant.Account__r.name);
                system.debug('1====='+TotalAssetsPrior+'==='+TotalAssetsAfter+'==='+TotalLiabilitiesPrior+'==='+TotalLiabilitiesAfter
                             +'==='+NetWorthPrior+'==='+NetWorthAfter+'==='+GrossMonthlyIncomePrior+'==='+GrossMonthlyIncomeAfter
                             +'==='+ExistingMonthlyInstallmentPrior+'==='+ExistingMonthlyInstallmentAfter+'==='+MonthlyInflowsPrior+'==='+MonthlyInflowsAfter
                             +'==='+MonthlyOutflowsPrior+'==='+MonthlyOutflowsAfter+'==='+ResidualIncomePrior+'==='+ResidualIncomeAfter
                             +'==='+BasicMonthlyPayPrior+'==='+BasicMonthlyPayAfter+'==='+TotalUnsecuredCreditPrior+'==='+TotalUnsecuredCreditAfter+'==='+applicant);
                assetslst.add(new WrapperAssets(TotalAssetsPrior,TotalAssetsAfter, TotalLiabilitiesPrior, TotalLiabilitiesAfter, NetWorthPrior, NetWorthAfter, GrossMonthlyIncomePrior, GrossMonthlyIncomeAfter,ExistingMonthlyInstallmentPrior,ExistingMonthlyInstallmentAfter,MonthlyInflowsPrior, MonthlyInflowsAfter, MonthlyOutflowsPrior, MonthlyOutflowsAfter, ResidualIncomePrior, ResidualIncomeAfter, BasicMonthlyPayPrior, BasicMonthlyPayAfter, TotalUnsecuredCreditPrior, TotalUnsecuredCreditAfter,applicant));
                system.debug('assetslst====='+assetslst);
            }
        }
        
    }
    public class WrapperAssets{
        public Decimal TotalAssetsPrior{get;set;}
        public Decimal TotalAssetsAfter{get;set;}
        public Decimal TotalLiabilitiesPrior{get;set;}
        public Decimal TotalLiabilitiesAfter{get;set;}
        public Decimal NetWorthPrior{get;set;}
        public Decimal NetWorthAfter{get;set;}
        public Decimal GrossMonthlyIncomePrior{get;set;}
        public Decimal GrossMonthlyIncomeAfter{get;set;}
        public Decimal ExistingMonthlyInstallmentPrior{get;set;}
        public Decimal ExistingMonthlyInstallmentAfter{get;set;}
        public Decimal MonthlyInflowsPrior{get;set;}
        public Decimal MonthlyInflowsAfter{get;set;}
        public Decimal MonthlyOutflowsPrior{get;set;}
        public Decimal MonthlyOutflowsAfter{get;set;}
        public Decimal ResidualIncomePrior{get;set;}
        public Decimal ResidualIncomeAfter{get;set;}
        public Decimal BasicMonthlyPayPrior{get;set;}
        public Decimal BasicMonthlyPayAfter{get;set;}
        public Decimal TotalUnsecuredCreditPrior{get;set;}
        public Decimal TotalUnsecuredCreditAfter{get;set;}
        public Applicant__c applicant{get;set;}
        WrapperAssets(Decimal TotalAssetsPrior,Decimal TotalAssetsAfter, Decimal TotalLiabilitiesPrior, Decimal TotalLiabilitiesAfter, Decimal NetWorthPrior, Decimal NetWorthAfter, Decimal GrossMonthlyIncomePrior, Decimal GrossMonthlyIncomeAfter, Decimal ExistingMonthlyInstallmentPrior, Decimal ExistingMonthlyInstallmentAfter, Decimal MonthlyInflowsPrior, Decimal MonthlyInflowsAfter, Decimal MonthlyOutflowsPrior, Decimal MonthlyOutflowsAfter, Decimal ResidualIncomePrior, Decimal ResidualIncomeAfter, Decimal BasicMonthlyPayPrior, Decimal BasicMonthlyPayAfter, Decimal TotalUnsecuredCreditPrior, Decimal TotalUnsecuredCreditAfter, Applicant__c appl){
            this.TotalAssetsPrior=TotalAssetsPrior;
            this.TotalAssetsAfter=TotalAssetsAfter;
            this.TotalLiabilitiesPrior=TotalLiabilitiesPrior;
            this.TotalLiabilitiesAfter=TotalLiabilitiesAfter;
            this.NetWorthPrior=NetWorthPrior;
            this.NetWorthAfter=NetWorthAfter;
            this.GrossMonthlyIncomePrior=GrossMonthlyIncomePrior;
            this.GrossMonthlyIncomeAfter=GrossMonthlyIncomeAfter;
            this.ExistingMonthlyInstallmentPrior=ExistingMonthlyInstallmentPrior;
            this.ExistingMonthlyInstallmentAfter=ExistingMonthlyInstallmentAfter;
            this.MonthlyInflowsPrior=MonthlyInflowsPrior;
            this.MonthlyInflowsAfter=MonthlyInflowsAfter;
            this.MonthlyOutflowsPrior=MonthlyOutflowsPrior;
            this.MonthlyOutflowsAfter=MonthlyOutflowsAfter;
            this.ResidualIncomePrior=ResidualIncomePrior;
            this.ResidualIncomeAfter=ResidualIncomeAfter;
            this.BasicMonthlyPayPrior=BasicMonthlyPayPrior;
            this.BasicMonthlyPayAfter=BasicMonthlyPayAfter;
            this.TotalUnsecuredCreditPrior=TotalUnsecuredCreditPrior;
            this.TotalUnsecuredCreditAfter=TotalUnsecuredCreditAfter;
            this.applicant=appl; 
            
        }
    }
    public void fillProductDetailsFromOppAndLead(string loanid){
        system.debug('loanid====='+loanid);
        ProductDetails = [select id,
                          Total_Monthly__c,
                          Unsecure_Interest_Rate__c,
                          Unsecure_Monthly_Loan_Payment_Market__c,
                          Unsecure_Monthly_Processing_Fees__c,
                          Deposit_Account_Number_LOC__c,
                          Date_of_Last_Valuation__c,
                          Year_of_Motor_Vehicle__c,
                          Loan_to_Value_Auto__c,
                          Exception_Granted_Auto__c,
                          Collateral_Personal_Line_of_Credit__c,
                          Requested_Limit_LOC__c,
                          Exception_Approved_by_Auto__c,
                          Exception_Approval_Date_Auto__c,
                          Exception_Granted_UL__c,
                          Exception_Approval_Date_UL__c,
                          Exception_Approved_by_UL__c,
                          Exception_Granted_CC__c,
                          Exception_Approval_Date_CC__c,
                          Exception_Approved_by_CC__c,
                          Exception_Granted_LOC__c,
                          Exception_Approved_by_LOC__c,
                          Exception_Approval_Date_LOC__c,
                          Ability_to_Service_Auto__c,
                          Ability_to_Service_Auto_After__c,
                          Credit_Risk_Score_Auto__c,
                          Credit_Risk_Rating_Auto__c,
                          Ability_to_Service_UL__c,
                          Ability_to_Service_UL_After__c,
                          Credit_Risk_Rating_Prior_UL__c,
                          Credit_Risk_Rating_UL__c,
                          Ability_to_Service_CC__c,
                          Ability_to_Service_CC_After__c,
                          Credit_Risk_Score_CC__c,
                          Credit_Risk_Rating_CC__c,
                          Ability_to_Service_LOC__c,
                          Ability_to_Service_LOC_After__c,
                          Credit_Risk_Score_LOC__c,
                          Credit_Risk_Rating_LOC__c,
                          Staff_1_Loan_amount_and_calculations__c,
                          JN_Staff2_interest_rate__c,
                          Staff_1_Loan_term__c,
                          Staff_2_Loan_amount_and_calculations__c,
                          JN_Staff3_Interest_rate__c,
                          Staff_3_Loan_term__c,
                          Staff_3_Loan_amount_and_calculations__c,
                          Unsecure_JN_Staff_1_Loan_Amount__c,
                          unsecure_JN_Staff2_Loan_Amount__c,
                          unsecure_JN_Staff_3_Loan_Amount__c,
                          Monthly_Processing_Fees_During_moratoriu__c,
                          unsecure_JN_Life_Creditor_Life_Premium__c,
                          Unsecure_Monthly_Loan_Payment_staff1__c,
                          unsecure_JN_Staff_2_Monthly_Loan_Payment__c,
                          unsecure_JN_Staff_3_Monthly_Loan_Payment__c,
                          Annual_Facility_Fee__c,
                          Policy_Limit__c,
                          Pior_to_Proposed_Credit__c,
                          After_Proposed_Credit__c,
                          Type_of_Card__c,
                          Applicant_1_Name__c,
                          Applocant_2_Name__c,
                          Applicant_3_Name__c,
                          Applicant_1_Date_of_Birth__c,
                          Applicant_1_Gross_Monthly_Income__c,
                          Applicant_1_Existing_Monthly_Payment__c,
                          Applicant_1_Jn_Employee__c,
                          Applicant_2_Date_of_Birth__c,
                          Applicant_2_Gross_Monthly_income__c,
                          Applicant_2_existing_monthly_credit__c,
                          Applicant_2_JN_Employee__c,
                          Applicant_3_Date_of_Birth__c,
                          Applicant_3_Gross_Monthly_income__c,
                          Applicant_3_Existing_Monthly__c,
                          Applicant_3_Jn_Employee__c,
                          Nick_Name_Of_Calculation__c,
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
                          App_1_Loan_Amount_A__c,
                          App_2_Loan_Amount_A__c,
                          App_3_Loan_Amount_A__c,
                          App1_Monthly_Payment_A__c,
                          App_2_Monthly_Payment_A__c,
                          App_3_Monthly_Payment_A__c,
                          App_1_LOC_limit__c,
                          App_2_LOC_Limit__c,
                          App_3_LOC_Limit__c,
                          App_1_Min_Payment__c,
                          App_2_Min_Payment_LOC__c,
                          App_3_Min_Payment_LOC__c,
                          App_1_Loan_Amount_UL__c,
                          App_2_Loan_Amount_UL__c,
                          App_3_Loan_Amount_UL__c,
                          App_1_Monthly_Payment_UL__c,
                          App_2_Monthly_Payment_UL__c,
                          App_3_Monthly_Payment_UL__c,
                          App1_Loan_Amt_Alloc_UL__c,
                          App2_Loan_Amt_Alloc_UL__c,
                          App3_Loan_Amt_Alloc_UL__c,
                          App1_Mnthly_Pmt_Alloc_UL__c,
                          App2_Mnthly_Pmt_Alloc_UL__c,
                          App3_Mnthly_Pmt_Alloc_UL__c,
                          App1_Loan_Amt_Alloc__c,
                          App2_Loan_Amt_Alloc__c,
                          App3_Loan_Amt_Alloc__c,
                          App1_Mnthly_Pmt_Alloc__c,
                          App2_Mnthly_Pmt_Alloc__c,
                          App3_Mnthly_Pmt_Alloc__c,
                          App1_Portion_LOC_Lim__c,
                          App2_Portion_LOC_Lim__c,
                          App3_Portion_LOC_Lim__c,
                          App1_Portion_Min_Pay_LOC__c,
                          App2_Portion_Min_Pay_LOC__c,
                          App3_Portion_Min_Pay_LOC__c,
                          Make_and_Model_of_Motor_Vehicle__c,
                          Repayment_Method_Auto__c,
                          Vehicle_Classification__c,
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
                          JN_Promotion_Auto__r.name,
                          JN_Promotion_UL__r.name,
                          JN_Promotion_CC__r.name,
                          JN_Promotion_LOC__r.name,
                          Othee_post_moratorium__c,
                          unsecure_Monthly_n_Loan_Savings__c,
                          Minimum_Payment__c,
                          Annual_Membership__c,
                          Annual_Membership_Per_sulpplementary__c,
                          Line_of_Credit_Starting_Limit__c,
                          Minimum_Payment_as_per_Credit_Limit__c
                          from Loan_Calculator__c where id =:loanid and RecordType.Name='Product Details' limit 1];
        if(ProductDetails.size()>0){
            isAutoFound= (ProductDetails[0].Auto_Loan_Purpose__c != NULL)?True:False;
            isUnFound= (ProductDetails[0].unsecure_Loan_Purpose__c != NULL)?True:False;
            isCcFound= (ProductDetails[0].PC_Credit_Limit_Amount__c != NULL)?True:False;
            isLocFound= (ProductDetails[0].PCL_Requested_Credit_Limit__c != NULL)?True:False;
            
        }
        string str='';
        if(isAutoFound){
            productName='Auto Loan';
        }
        if(isUnFound){
            if(string.isEmpty(productName))
                productName+='Unsecured Loan';
            else
                productName+=', Unsecured Loan';  
        }
        if(isCcFound){
            if(string.isEmpty(productName))
                productName+='Credit Card';
            else 
                productName+=', Credit Card';
        }
        if(isLocFound){
            if(string.isEmpty(productName))
                productName+='Line of Credit';
            else
                productName+=' & Line of Credit';
        }
    }
    
}