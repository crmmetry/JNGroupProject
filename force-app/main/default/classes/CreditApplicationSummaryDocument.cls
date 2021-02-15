//Sample Opportunity Id 006f000000PhctcAAB	
//006f000000PhpadAAB	006f000000Pd1E6AAJ
//(SELECT Industry__c FROM Employment__r ORDER BY  id LIMIT 1)

public class CreditApplicationSummaryDocument {  
    //Opportunity ID
    public Id opportunityId{get;set;}
	public list<Applicant__c> applicanList{get;set;}
    public list<ApplicantAndEmployementWrapper> applicantAndEmplWrapperList{get;set;}
    
    public CreditApplicationSummaryDocument(){
        applicantAndEmplWrapperList = New list<ApplicantAndEmployementWrapper>();
        //Get the Opportunity id from URL
        opportunityId = ApexPages.currentPage().getParameters().get('Id');
        //Get the list of Applicants of the provided Opportunity Id
        applicanList = getListOfApplicants(opportunityId);
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
   
    private list<Applicant__c> getListOfApplicants(Id oppId) {
        
        list<Applicant__c> applicantList = new list<Applicant__c>();
        applicantList = [SELECT Account__c,
                         		Account__r.Name,
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
                         		JN_Group_Employee__c	
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