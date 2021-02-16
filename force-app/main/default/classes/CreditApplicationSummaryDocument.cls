//Sample Opportunity Id 006f000000PhctcAAB	
//006f000000PhpadAAB	006f000000Pd1E6AAJ
//(SELECT Industry__c FROM Employment__r ORDER BY  id LIMIT 1)

public class CreditApplicationSummaryDocument {  
    //Opportunity ID
    public Id opportunityId{get;set;}
    public Opportunity opportunityObj{get;set;}
	public list<Applicant__c> applicanList{get;set;}
    public list<ApplicantAndEmployementWrapper> applicantAndEmplWrapperList{get;set;}
    
    public CreditApplicationSummaryDocument(){
        applicantAndEmplWrapperList = New list<ApplicantAndEmployementWrapper>();
        //Get the Opportunity id from URL
        opportunityId = ApexPages.currentPage().getParameters().get('Id');
        //Get the list of Applicants of the provided Opportunity Id
        applicanList = getListOfApplicants(opportunityId);
        //Get the opportunity object 
        opportunityObj = getOpportunityObj(opportunityId);
        //Define the list of Account Ids
        list<Id> accountIds = new list<Id>();
        //Define map of Account Id and its related Employment records
        Map<Id, list<FinServ__Employment__c>> emplmntRecordsOfAccount;
		
        //Populate the list of Account Ids. Using these Account Ids the Employements records would be fetched.
        for(Applicant__c applicantObj : applicanList){
            accountIds.add(applicantObj.Account__c);
        }
        //Get a map of Account ID and list of its respective employement records
        if(accountIds!=Null){
        	emplmntRecordsOfAccount = get_MapOfAccountId_And_EmployementRecords(accountIds);    
        }
        
        //populate the applicantAndEmplWrapperList
        for(Applicant__c applicantObj : applicanList){
            
            //Get a list of Employment Records of the Account 
            list<FinServ__Employment__c> employList;
            employList = emplmntRecordsOfAccount.get(applicantObj.Account__c);
            
            //Convert the list of Employment Records into the list of Employment Wrapper Records 
            list<EmploymentWrapper> emploWrapperList = New list<EmploymentWrapper>();
            
            for(FinServ__Employment__c empObj : employList){
                EmploymentWrapper EmpWrapper = new EmploymentWrapper(empObj);
                emploWrapperList.add(EmpWrapper);
            }
            ApplicantAndEmployementWrapper appEmpWrap = new ApplicantAndEmployementWrapper(applicantObj, emploWrapperList);
            applicantAndEmplWrapperList.add(appEmpWrap);
        }
    }
   	
    private Opportunity getOpportunityObj(Id oppId){
          if(oppId!=Null){
            Opportunity oppObj = new Opportunity();
            oppObj = [SELECT ID, 
                      Request_ADJ_Exception_for_Credit__c, 
                      Exception_Approved_by__c, 
                      Date_of_Approval__c 
                      FROM Opportunity 
                      WHERE Id =:oppId];
            return oppObj;
        }
        return null;
    }
    
    private list<Loan_Calculation_Product__c> getListOfLoanCalProdcts(Id oppId){
        list<Loan_Calculation_Product__c> loanCalProduct = new list<Loan_Calculation_Product__c>();
        Loan_Calculator__c loanCalculator = new Loan_Calculator__c();
        loanCalculator = [SELECT id 
                   FROM Loan_Calculator__c 
                   WHERE Opportunity__c =:oppId LIMIT 1];
        
        if(loanCalculator!= Null){
        	loanCalProduct = [SELECT Loan_Purpose_List__c, 
                              		Years_Number__c, 
                              		Interest_Rate_Number__c, 
                              		Market_Value_of_Vehicle_Number__c,
                              		Purchase_Price_of_Vehicle_Number__c,
                              		Vehicle_Classification_list__c,
                              		Make_and_Model_of_Motor_Vehicle_text__c,
                              		Repayment_Method_List__c,
                              		Applicable_Processing_Fee_Number__c,
                              		Loan_Amount_Number__c,
                              		JN_Life_Creditor_Life_Premium_Number__c,
                              		Processing_Fees_including_GCT_Number__c,
                              		Total_Loan_Amount_Number__c,
                              		Monthly_PI_Loan_Amount_Number__c,
                              		Monthly_P_I_Life_Insurance_Premium__c,
                              		Monthly_PI_Processing_Fee_Flag__c,
                              		Monthly_P_I_JNGI_Motor_Premium_Number__c,
                              		Monthly_JNGI_Motor_Premium_Number__c,
                              		Total_Monthly_PI_Loan_Payment_Number__c,
                              		Monthly_Compulsory_Savings_Number__c,
                              		Total_Monthly_Saving_Loan_Payment_Number__c,
                              		Total_Compulsory_Savings_Balance_Number__c,
                              		Total_Interest_Payment_Repayment_Number__c,
                              		Collateral_Type_List__c,
                              		Requested_Credit_Limit_Number__c,
                              		Starting_Limit_Number__c,
                              		Financial_Institution_List__c,
                              		Account_Holder_s_text__c,
                              		Annual_Interest_Rate_Deposit_Acct_Number__c,
                              		Deposit_Account_Balance_Number__c,
                              		Existing_Loan_Balance_Number__c,
                              		Account_Hypothecated_list__c
                              FROM Loan_Calculation_Product__c
                              WHERE Loan_Calculation_Id__c =:loanCalculator.Id];    
        }
        if(loanCalProduct!=Null){
            if(loanCalProduct.size()>0){
                return loanCalProduct;
            }
        }
        return Null;
    }
        
    private list<Applicant__c> getListOfApplicants(Id oppId) {
        
        list<Applicant__c> applicantList = new list<Applicant__c>();
        applicantList = [SELECT Account__c,Account__r.Name,
                         		Account__r.FinServ__Age__pc,
                         		Account__r.FinServ__Gender__pc,
                         		Account__r.Marital_Status__c,
                         		Account__r.Highest_Level_of_Education_attained__pc,
                         		Account__r.FinServ__NumberOfDependents__pc,
                         		Account__r.Status_of_Address__pc,
                         		Account__r.Years_at_Residence__pc,
                         		Account__r.Political_Exposure__pc,
                         		Account__r.PersonBirthdate,
                         		Statutory_Deductions_Numbers__c,
                         		Rent_Strata_Maintenance__c,
                         		Personal_Expenses_Monthly_Prior_Loan__c,
                         		Savings_Pension_Insurance_Number__c,
                         		Real_Estate_Monthly_Payment_Number__c,
                         		Motor_Vehicle_Monthly_Payment_Number__c,
                         		Other_Asset_Monthly_Payment_Number__c,
                          		Other_Loan_Monthly_Payment_Number__c,
                                Gross_Monthly_Income__c,
                                Rent_Board_Monthly_Prior_Loan__c,
                                Rent_Board_Monthly_After_Loan__c,
                                Strata_Maintenance_Monthly_Prior_Loan__c,
                                Strata_Maintenance_Monthly_After_Loan__c,
                                Gross_Monthly_IncomeC__c,
                         		CRIF_Rating__c,
                         		CreditInfo_Rating__c,
                         		Overall_Credit_Bureau_Rating__c,
                         		Credit_History_in_last_24_Months__c,
                         		Assessment_of_Applicant_Net_Worth__c,
                         		Is_applicant_KYC_Compliant__c,
                         		Time_as_Member_Months__c, 
                         		Rim_Number__c,
                         		Sanction_Screening_has_Negative_Trace__c,
                         		Affiliation_Type__c,
                         		JN_Group_Employee__c,
                         //-----FINANCIAL & RISK ASSESSMENT------//
                         //-----Assets Prior to Proposed Loan-----//
                         		Real_Estate_Market_Value_Number__c,
                         		Motor_Vehicle_Market_Value_Number__c,
                         		Other_Asset_Market_Value_Number__c,
                         		Life_Insurance_Cash_Value__c,
                         		Savings_Current_Account_s_Investment_VER__c,
                         		Savings_Deposit_Investments__c,
                         		Pension__c,
                         //-----Market Value of Asset on Proposed Loan-----//
                         		Market_Value_Number__c,		
                         
                         //-----Total Liabilities--------//
                         		Real_Estate_Loan_Balance_Number__c,
                         		Motor_Vehicle_Loan_Balance_Number__c,
                         		Other_Asset_Loan_Balance_Number__c,
                         		Other_Loan_Loan_Balance_Number__c,
                         		Average_Credit_Card_Balances_Number__c,
                         		Average_Line_of_Credit_Balance_Number__c,
                         
                         		Total_Inflows__c,
                         		Total_Outflows__c,
                         //-----Existing Monthly Instalment Payments--------//
                         		Cell_Phone_Landline_Monthly_Prior_Loan__c,
                         		Child_Care_Costs_Monthly_Prior_Loan__c,
                         		Cooking_Gas_Monthly_Prior_Loan__c,
                         		Education_Tax_Monthly_Prior_Loan__c,
                         		Electricity_Monthly_Prior_Loan__c,
                         		Fares_Monthly_Prior_Loan__c,
                         		Food_Cost_Monthly_Prior_Loan__c,
                         		Health_Costs_Monthly_Prior_Loan__c
                         		
                         		
                              FROM Applicant__c
                              WHERE Opportunity__c = :oppId];
        if (applicantList != null) {
            return applicantList;
        }else{
            return Null;   
        }
    }
    
    private Map<Id, list<FinServ__Employment__c>> get_MapOfAccountId_And_EmployementRecords(list<Id> account_Ids){
		Map<Id, list<FinServ__Employment__c>> employmentRecordsOfAccount = new Map<ID, list<FinServ__Employment__c>>();        
        For(Account act: [SELECT Id, 
                          		(SELECT Industry__c, 
                                      		Professional_Category__c, 
                                      		Nature_of_Engagement__c, 
                                      		Assessment_of_Business_Working_Capita__c,
                                 			Length_of_Trade__c,			
                                 			Assessment_of_Business__c,
                                 			Assessment_of_Statement__c,
                                 			FinServ__EmploymentStatus__c,
                                 			FinServ__LengthOfEmployment__c
                                 FROM Employment__r) 
                          FROM Account 
                          WHERE Id IN :account_Ids]){
            employmentRecordsOfAccount.put(act.Id, act.Employment__r);
        }
        return employmentRecordsOfAccount;       
    }
}