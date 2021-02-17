public with sharing class ApplicantAndEmployementWrapper {
	
    Public String type_of_Industry{get;set;}
    Public String professional_Category{get;set;}
    Public String nature_of_Engagement{get;set;}
    Public String assment_of_Business_Working_Capital{get;set;}
    Public String length_of_Trade{get;set;}
    Public String assment_of_Business_Financial_Performance{get;set;}
    Public String assment_of_Business_Financial_Statement_Support{get;set;}
    
    Public String applicantName{get;set;}
    Public Integer ageOfApplicant{get;set;}
    Public String genderOfApplicant{get;set;}
    Public String maritalStatusOfApplicant{get;set;}
    Public String highestEducationOfApplicant{get;set;}
    Public Double numberOfDependent{get;set;}
    public String statusOfAddress {get;set;}
    public Double timeLivingAtAddress {get;set;}
    
    public String crif_Rating {get;set;}
    public String creditInfo_Rating {get;set;}
    public String overAllCreditBureau {get;set;}
    public String is_KYC {get;set;} 
    public Decimal timeAsMember {get;set;} 
    public String RIM_Number {get;set;} 
    public String hasNegativeScreening{get;set;}
    public String affiliationType {get;set;}
    public Boolean pep {get;set;}
    public String pepString {get;set;}
    public String jnGroup {get;set;}
    
    public ApplicantWrapper appWrp;
    
    public Decimal totalAssetsPriorLoan {get;set;}
    public Decimal totalAssetsAfterLoan {get;set;}
    public Decimal totalLiabilitiesPriorLoan {get;set;}
    public Decimal totalLiabilitiesAfterLoan {get;set;}
    public Decimal netWorthPriorLoan {get;set;}
    public Decimal netWorthAfterLoan {get;set;}
    
    public Decimal monthlyInflowsPriorLoan {get;set;}
    public Decimal monthlyInflowsAfterLoan {get;set;}
    public Decimal monthlyOutflowsPriorLoan {get;set;}
    public Decimal monthlyOutflowsAfterLoan {get;set;}
    public Decimal residualIncomePriorLoan {get;set;}
    public Decimal residualIncomeAfterLoan {get;set;}
    
    public Decimal realEstateMktValue {get;set;}
    public string currencyCode {get;set;}
    
    public Decimal grossMonthlyIncomePriorLoan {get;set;}
    public Decimal grossMonthlyIncomeAfterLoan {get;set;}
    
    public Decimal existingMonthlyPaymntsPriorLoan {get;set;}
    public Decimal existingMonthlyPaymntsAfterLoan {get;set;}
    
    public Decimal sum_Total_Market_Value {get;set;}
    public Decimal sum_Account_Balance {get;set;}
    public Decimal sum_Total_Contributions_to_Date {get;set;}
    public Decimal sum_Asset_Credit_Balance {get;set;}
    
    public ApplicantAndEmployementWrapper(Applicant__c record, list<EmploymentWrapper> emploWrapperList, Decimal sumTotalMarketValue, Decimal sumAccountBalance, Decimal sumTotalContributionstoDate, Decimal sumTotalAssetCreditBalance){        
        sum_Total_Market_Value = sumTotalMarketValue;
        sum_Account_Balance = sumAccountBalance;
        sum_Total_Contributions_to_Date = sumTotalContributionstoDate;
        sum_Asset_Credit_Balance = sumTotalAssetCreditBalance;
            
        appWrp = new ApplicantWrapper(record);
        applicantName = record.Account__r.Name;
        currencyCode = record.CurrencyIsoCode;
        genderOfApplicant = record.Account__r.FinServ__Gender__pc;
        ageOfApplicant = appWrp.age;
        maritalStatusOfApplicant = record.Account__r.Marital_Status__c;
        highestEducationOfApplicant = record.Account__r.Highest_Level_of_Education_attained__pc;
        numberOfDependent = record.Account__r.FinServ__NumberOfDependents__pc;
        statusOfAddress = record.Account__r.Status_of_Address__pc;
        timeLivingAtAddress = record.Account__r.Years_at_Residence__pc;
        crif_Rating = record.CRIF_Rating__c;
        creditInfo_Rating = record.CreditInfo_Rating__c;
        overAllCreditBureau = record.Overall_Credit_Bureau_Rating__c;
        is_KYC = record.Is_applicant_KYC_Compliant__c;
        timeAsMember = record.Time_as_Member_Months__c;
        RIM_Number = record.Rim_Number__c;
        hasNegativeScreening = record.Sanction_Screening_has_Negative_Trace__c;
        affiliationType = record.Affiliation_Type__c;
        pep = record.Account__r.Political_Exposure__pc;
        if(pep){
            pepString = 'Yes';
        }else{
            pepString = 'No';
        }
        
        grossMonthlyIncomePriorLoan = 0;
        if(record.Gross_Monthly_Income__c!=Null){
            grossMonthlyIncomePriorLoan = record.Gross_Monthly_Income__c;
        }
        
        grossMonthlyIncomeAfterLoan = 0;
        if(record.Gross_Monthly_Income__c!=Null){
            grossMonthlyIncomeAfterLoan = record.Gross_Monthly_Income__c;
        }
        
        monthlyInflowsPriorLoan = 0;
        if(record.Total_Inflows__c!=Null){
            monthlyInflowsPriorLoan = record.Total_Inflows__c;
        }
        monthlyInflowsAfterLoan = 0;
        if(record.Total_Inflows__c!=Null){
            monthlyInflowsAfterLoan = record.Total_Inflows__c;
        }
        getMonthlyOutFlowsPriorLoan(record);
        getMonthlyOutFlowsAfterLoan(record);
        
        residualIncomePriorLoan = monthlyInflowsPriorLoan - monthlyOutflowsPriorLoan;
        residualIncomeAfterLoan = monthlyInflowsAfterLoan - monthlyOutflowsAfterLoan;
        
        getTotalAssetsPriorToLoan(record);
        getTotalAssetsAfterLoan(record);
        getTotalLiabilitiesPriorToLoan(record);
        getTotalLiabilitiesAfterLoan(record);
        getExistingmnthlyPaymnt(record);
        netWorthPriorLoan = totalAssetsPriorLoan - totalLiabilitiesPriorLoan;
        netWorthAfterLoan = totalAssetsAfterLoan - totalLiabilitiesAfterLoan;
        jnGroup = record.JN_Group_Employee__c;
        Assign_Value_To_Employement_Fields(emploWrapperList);
    }
    
    public void Assign_Value_To_Employement_Fields(list<EmploymentWrapper> empWrpList){
        type_of_Industry ='';
        professional_Category='';
        nature_of_Engagement='';
        assment_of_Business_Working_Capital='';
        length_of_Trade = '';
        assment_of_Business_Financial_Performance = '';
        assment_of_Business_Financial_Statement_Support = '';
        
        if(empWrpList!=Null){
            if(empWrpList.size()>0){
                type_of_Industry = empWrpList.get(0).industry;
                professional_Category = empWrpList.get(0).professionalCategory;
                nature_of_Engagement = empWrpList.get(0).natureOfEngagement;
                assment_of_Business_Working_Capital = empWrpList.get(0).assessmentOfBusinessWorkingCapita;
                length_of_Trade = empWrpList.get(0).lengthOfTrade;
                assment_of_Business_Financial_Performance = empWrpList.get(0).assessmentOfBusiness;
                assment_of_Business_Financial_Statement_Support = empWrpList.get(0).assessmentOfStatement;
            }
        }
    }
    
    public void getTotalAssetsPriorToLoan(Applicant__c record){
        Decimal real_Estate_MktValue;
        Decimal motor_Vehicle_MktValue;
        Decimal other_Asset_MktValue;
        Decimal life_Insurance_Cash_Value;
        Decimal savings_Deposit_Investments;
        Decimal pension;
        totalAssetsPriorLoan = 0.0;

        if(record.Real_Estate_Market_Value_Number__c!=Null){
        	real_Estate_MktValue = record.Real_Estate_Market_Value_Number__c;     
        }else{
            real_Estate_MktValue = 0;
        }
        if(record.Motor_Vehicle_Market_Value_Number__c!=Null){
        	motor_Vehicle_MktValue = record.Motor_Vehicle_Market_Value_Number__c;     
        }else{
            motor_Vehicle_MktValue = 0;
        }
        if(record.Other_Asset_Market_Value_Number__c!=Null){
        	other_Asset_MktValue = record.Other_Asset_Market_Value_Number__c;     
        }else{
            other_Asset_MktValue = 0;
        }
        if(record.Life_Insurance_Cash_Value__c!=Null){
        	life_Insurance_Cash_Value = record.Life_Insurance_Cash_Value__c;     
        }else{
            life_Insurance_Cash_Value = 0;
        }
        if(record.Savings_Deposit_Investments__c!=Null){
        	savings_Deposit_Investments = record.Savings_Deposit_Investments__c;     
        }else{
            savings_Deposit_Investments = 0;
        }
        if(record.Pension_IRS_Total_Contribution__c!=Null){
        	pension = record.Pension_IRS_Total_Contribution__c;     
        }else{
            pension = 0;
        }
        totalAssetsPriorLoan =  sum_Total_Market_Value + 
            					sum_Account_Balance +
            					sum_Total_Contributions_to_Date +
            					motor_Vehicle_MktValue + 					
            					other_Asset_MktValue + 					
            					real_Estate_MktValue + 
            					life_Insurance_Cash_Value + 
            					savings_Deposit_Investments + 
            					pension;
    }
    
    public void getTotalAssetsAfterLoan(Applicant__c record){
        Double mrktValue;
        totalAssetsAfterLoan = 0.0;
        
        if(record.Market_Value_Number__c!=Null){
        	mrktValue = record.Market_Value_Number__c;     
        }else{
            mrktValue = 0;
        }
        
        totalAssetsAfterLoan = totalAssetsPriorLoan + mrktValue;
    }
    
    public void getTotalLiabilitiesPriorToLoan(Applicant__c record){
        Double real_Estate_loan;
        Double motor_Vehicle_loan;
        Double other_Asset_loan;
        Double other_loan;
        Double credit_Card_loan;
        Double lineofCredit_loan;
        totalLiabilitiesPriorLoan = 0.0;
        
        if(record.Real_Estate_Loan_Balance_Number__c!=Null){
        	real_Estate_loan = record.Real_Estate_Loan_Balance_Number__c;     
        }else{
            real_Estate_loan = 0;
        }
        
        if(record.Motor_Vehicle_Loan_Balance_Number__c!=Null){
        	motor_Vehicle_loan = record.Motor_Vehicle_Loan_Balance_Number__c;     
        }else{
            motor_Vehicle_loan = 0;
        }
        
        if(record.Other_Asset_Loan_Balance_Number__c!=Null){
        	other_Asset_loan = record.Other_Asset_Loan_Balance_Number__c;     
        }else{
            other_Asset_loan = 0;
        }
        
        if(record.Other_Loan_Loan_Balance_Number__c!=Null){
        	other_loan = record.Other_Loan_Loan_Balance_Number__c;     
        }else{
            other_loan = 0;
        }
        
        if(record.Average_Credit_Card_Balances_Number__c!=Null){
        	credit_Card_loan = record.Average_Credit_Card_Balances_Number__c;     
        }else{
            credit_Card_loan = 0;
        }
        
        if(record.Average_Line_of_Credit_Balance_Number__c!=Null){
        	lineofCredit_loan = record.Average_Line_of_Credit_Balance_Number__c;     
        }else{
            lineofCredit_loan = 0;
        }
        
        totalLiabilitiesPriorLoan = sum_Asset_Credit_Balance + 
            						real_Estate_loan + 
            						motor_Vehicle_loan + 
            						other_Asset_loan +
            						other_loan +
            						credit_Card_loan +
            						lineofCredit_loan;
    }
    
    public void getTotalLiabilitiesAfterLoan(Applicant__c record){
        totalLiabilitiesAfterLoan = 0.0;
        //---coming soon---
        //find the specific field for "Loan Balance on Prosposed Loan"
    }
    public void getMonthlyOutFlowsPriorLoan(Applicant__c record){
        monthlyOutflowsPriorLoan = 0;
        if(record.Property_Tax_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Property_Tax_Monthly_Prior_Loan__c;     
        }
        if(record.Property_Insurance_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Property_Insurance_Monthly_Prior_Loan__c;     
        }
        if(record.Property_Maintenance_Monthly_Prior_loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Property_Maintenance_Monthly_Prior_loan__c;     
        }
        if(record.Personal_Expenses_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Personal_Expenses_Monthly_Prior_Loan__c;     
        }
        if(record.Food_Cost_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Food_Cost_Monthly_Prior_Loan__c;     
        }
        if(record.Child_Care_Costs_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Child_Care_Costs_Monthly_Prior_Loan__c;     
        }
        if(record.School_Costs_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.School_Costs_Monthly_Prior_Loan__c;     
        }
        if(record.Health_Costs_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Health_Costs_Monthly_Prior_Loan__c;     
        }
        if(record.Other_Personal_Family_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Personal_Family_Monthly_Prior_Loan__c;     
        }
        if(record.Electricity_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Electricity_Monthly_Prior_Loan__c;     
        }
        if(record.Water_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Water_Monthly_Prior_Loan__c;     
        }
        if(record.Cell_Phone_Landline_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Cell_Phone_Landline_Monthly_Prior_Loan__c;     
        }
        if(record.Internet_Cable_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Internet_Cable_Monthly_Prior_Loan__c;     
        }
        if(record.Cooking_Gas_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Cooking_Gas_Monthly_Prior_Loan__c;     
        }
        if(record.House_Keeping_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.House_Keeping_Monthly_Prior_Loan__c;     
        }
        if(record.Other_Utilities_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Utilities_Monthly_Prior_Loan__c;     
        }

        if(record.Fares_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Fares_Monthly_Prior_Loan__c;     
        }
        if(record.Petrol_Fuel_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Petrol_Fuel_Monthly_Prior_Loan__c;     
        }
        if(record.Toll_Fees_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Toll_Fees_Monthly_Prior_Loan__c;     
        }
        if(record.Motor_V_Insurance_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_V_Insurance_Monthly_Prior_Loan__c;     
        }
        if(record.Motor_Vehicle_Reg_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_Vehicle_Reg_Monthly_Prior_Loan__c;     
        }
        if(record.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_Vehicle_Fitness_Monthly_Prior_Loan__c;     
        }
        if(record.Motor_V_Maintenance_Monthly_Before_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_V_Maintenance_Monthly_Before_Loan__c;     
        }
        if(record.Other_Transport_Costs_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Transport_Costs_Monthly_Prior_Loan__c;     
        }
        if(record.Savings_Pension_Insurance_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Savings_Pension_Insurance_Number__c;     
        }        
        if(record.Personal_Expenses_Monthly_Prior_Loan__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Personal_Expenses_Monthly_Prior_Loan__c;     
        }
        if(record.Statutory_Deductions_Numbers__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Statutory_Deductions_Numbers__c;     
        }
        if(record.Rent_Strata_Maintenance__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Rent_Strata_Maintenance__c;     
        }
        if(record.Motor_Vehicle_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_Vehicle_Monthly_Payment_Number__c;     
        }
        if(record.Other_Asset_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Asset_Monthly_Payment_Number__c;     
        }
        if(record.Other_Loan_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Loan_Monthly_Payment_Number__c;     
        }
        if(record.Real_Estate_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Real_Estate_Monthly_Payment_Number__c;     
        }
    }
    public void getMonthlyOutFlowsAfterLoan(Applicant__c record){
        monthlyOutflowsAfterLoan = 0;
        if(record.Cell_Phone_Landline_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Cell_Phone_Landline_Monthly_After_Loan__c;     
        }
        if(record.Child_Care_Costs_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Child_Care_Costs_Monthly_After_Loan__c;     
        }
        if(record.Cooking_Gas_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Cooking_Gas_Monthly_After_Loan__c;     
        }
        if(record.Electricity_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Electricity_Monthly_After_Loan__c;     
        }
        if(record.Fares_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Fares_Monthly_After_Loan__c;     
        }
		if(record.Food_Costs_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Food_Costs_Monthly_After_Loan__c;     
        }
        if(record.Health_Costs_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Health_Costs_Monthly_After_Loan__c;     
        }
        if(record.House_Keeping_Costs_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.House_Keeping_Costs_Monthly_After_Loan__c;     
        }
        if(record.Internet_Cable_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Internet_Cable_Monthly_After_Loan__c;     
        }
        if(record.Motor_V_Insurance_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Motor_V_Insurance_Monthly_After_Loan__c;     
        }
        if(record.Motor_V_Maintenance_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Motor_V_Maintenance_Monthly_After_Loan__c;     
        }
        if(record.Motor_Vehicle_Fitness_Monthly_After_Loan__c !=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Motor_Vehicle_Fitness_Monthly_After_Loan__c;     
        }
        if(record.Motor_Vehicle_Monthly_After_Loan__c !=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Motor_Vehicle_Monthly_After_Loan__c;     
        }
        if(record.Motor_Vehicle_Reg_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Motor_Vehicle_Reg_Monthly_After_Loan__c;     
        }
        if(record.Other_Personal_Family_Costs_Prior_After__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Other_Personal_Family_Costs_Prior_After__c;     
        }
        if(record.Other_Transport_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Other_Transport_Monthly_After_Loan__c;     
        }
        if(record.Other_Utilities_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Other_Utilities_Monthly_After_Loan__c;     
        }
        if(record.Personal_Expenses_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Personal_Expenses_Monthly_After_Loan__c;     
        }
        if(record.Petrol_Fuel_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Petrol_Fuel_Monthly_After_Loan__c;     
        }
        if(record.Property_Insurance_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Property_Insurance_Monthly_After_Loan__c;     
        }
        if(record.Property_Maintenance_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Property_Maintenance_Monthly_After_Loan__c;     
        }
        if(record.Property_Tax_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Property_Tax_Monthly_After_Loan__c;     
        }
        if(record.Rent_Board_Strata_After_TDSR__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Rent_Board_Strata_After_TDSR__c;     
        }
        if(record.Rent_Board_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Rent_Board_Monthly_After_Loan__c;     
        }
        if(record.School_Costs_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.School_Costs_Monthly_After_Loan__c;     
        }
        if(record.Strata_Maintenance_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Strata_Maintenance_Monthly_After_Loan__c;     
        }
        if(record.Toll_Fees_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Toll_Fees_Monthly_After_Loan__c;     
        }
        if(record.Water_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Water_Monthly_After_Loan__c;     
        }
        if(record.Savings_Pension_Insurance_Number__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Savings_Pension_Insurance_Number__c;     
        }
        if(record.Personal_Expenses_Monthly_After_Loan__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Personal_Expenses_Monthly_After_Loan__c;     
        }
        if(record.Statutory_Deductions_Numbers__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Statutory_Deductions_Numbers__c;     
        }
        if(record.Rent_Strata_Maintenance__c!=Null){
            monthlyOutflowsAfterLoan = monthlyOutflowsAfterLoan + record.Rent_Strata_Maintenance__c;     
        }
        if(record.Motor_Vehicle_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Motor_Vehicle_Monthly_Payment_Number__c;     
        }
        if(record.Other_Asset_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Asset_Monthly_Payment_Number__c;     
        }
        if(record.Other_Loan_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Other_Loan_Monthly_Payment_Number__c;     
        }
        if(record.Real_Estate_Monthly_Payment_Number__c!=Null){
            monthlyOutflowsPriorLoan = monthlyOutflowsPriorLoan + record.Real_Estate_Monthly_Payment_Number__c;     
        }
    }
    
    public void getExistingmnthlyPaymnt(Applicant__c record){
        existingMonthlyPaymntsPriorLoan = 0;
        existingMonthlyPaymntsAfterLoan = 0;
        
        if(record.Cell_Phone_Landline_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Cell_Phone_Landline_Monthly_Prior_Loan__c;     
        }
		
        if(record.Child_Care_Costs_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Child_Care_Costs_Monthly_Prior_Loan__c;     
        }
        
        if(record.Cooking_Gas_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Cooking_Gas_Monthly_Prior_Loan__c;     
        }
        
        if(record.Education_Tax_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Education_Tax_Monthly_Prior_Loan__c;     
        }
        
        if(record.Electricity_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Electricity_Monthly_Prior_Loan__c;     
        }
        
        if(record.Fares_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Fares_Monthly_Prior_Loan__c;     
        }
        
        if(record.Food_Cost_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Food_Cost_Monthly_Prior_Loan__c;     
        }
        
        if(record.Health_Costs_Monthly_Prior_Loan__c!=Null){
        	existingMonthlyPaymntsPriorLoan = existingMonthlyPaymntsPriorLoan 
                							+ record.Health_Costs_Monthly_Prior_Loan__c;     
        }    
        existingMonthlyPaymntsAfterLoan = existingMonthlyPaymntsPriorLoan;
    }
}