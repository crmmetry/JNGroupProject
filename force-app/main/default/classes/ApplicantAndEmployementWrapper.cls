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
    
       
    public ApplicantAndEmployementWrapper(Applicant__c record, list<EmploymentWrapper> emploWrapperList){
        appWrp = new ApplicantWrapper(record);
        applicantName = record.Account__r.Name;
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
}