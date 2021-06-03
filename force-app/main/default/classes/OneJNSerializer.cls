/**
* @description       :
* @author            : Remario Richards
* @group             :
* @last modified on  : 06-03-2021
* @last modified by  : Trupti Zende (Thinqloud)
* Modifications Log
* Ver   Date         Author             Modification
* 1.0   05-26-2021   Remario Richards   Initial Version
**/
public class OneJNSerializer {
    @AuraEnabled
    Public AppDataWrapper appData;
    @AuraEnabled
    Public ApplicantDataWrapper applicant;
    
    OneJNSerializer(Applicant__c applicantRecord, FinServ__Employment__c employmentRecord, Account accountRecord, Application__c applicationRecord, Opportunity opportunityRecord, OpportunityLineItem opportunityProductRecord, Loan_Calculation_Product__c loanCalculationProductRecord){
        this.appData = new AppDataWrapper(applicationRecord, opportunityRecord, applicantRecord, opportunityProductRecord,loanCalculationProductRecord);
        this.applicant = new ApplicantDataWrapper(applicantRecord, employmentRecord, accountRecord);
    }
    Class AppDataWrapper{
        @AuraEnabled
        Public string applicationId;
        @AuraEnabled
        Public boolean isJointApplication;
        @AuraEnabled
        Public string productType;
        @AuraEnabled
        Public string subProductType;
        @AuraEnabled
        Public decimal currencyType;
        @AuraEnabled
        Public string applicationDate;
        @AuraEnabled
        Public decimal amount;
        @AuraEnabled
        Public decimal interestRate;
        @AuraEnabled
        Public decimal requestedTenure;
        @AuraEnabled
        Public string loanPurpose;
        @AuraEnabled
        Public string branchRegion;
        @AuraEnabled
        Public string feeFinancing;
        @AuraEnabled
        Public decimal minMonthlyRepayment;
        
        AppDataWrapper(Application__c applicationRecord, Opportunity opportunityRecord, Applicant__c applicantRecord, OpportunityLineItem opportunityProductRecord, Loan_Calculation_Product__c loanCalculationProductRecord){
            if(applicationRecord != null){
                this.applicationId = applicationRecord.Application_ID__c;
                //this.applicationDate = '';
            }
            if(applicantRecord != null){
                this.isJointApplication = OneJNSerializer.getBooleanValuesFromString(applicantRecord.Joint_Application_flag__c);
            }
            if(opportunityProductRecord != null){
                this.productType = opportunityProductRecord.Product_Family__c;
                this.subProductType = opportunityProductRecord.Name;
            }
            if(opportunityRecord != null){
                //this.currencyType = opportunityRecord.CurrencyIsoCode;	// reserved word & mismatch data type
                this.branchRegion = opportunityRecord.Preferred_Location__c;
            }
            if(loanCalculationProductRecord != null){
                this.amount = loanCalculationProductRecord.Loan_Amount_Number__c;
                this.interestRate = loanCalculationProductRecord.Interest_Rate_Number__c;
                this.requestedTenure = loanCalculationProductRecord.Months_Number__c;
                this.loanPurpose = loanCalculationProductRecord.Loan_Purpose_List__c;
                this.feeFinancing = loanCalculationProductRecord.Method_of_Fee_Payment_List__c;
                this.minMonthlyRepayment = loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c;
            }
            
            
        }
    }
    Class ApplicantDataWrapper{
        @AuraEnabled
        Public String rim;
        @AuraEnabled
        Public boolean isJointHolder;
        @AuraEnabled
        Public String applicantType;
        @AuraEnabled
        Public boolean isGuarantor;
        @AuraEnabled
        Public boolean isVIP;
        @AuraEnabled
        Public boolean isPEP;
        @AuraEnabled
        Public boolean isSupplimental;
        @AuraEnabled
        Public String entityType;
        @AuraEnabled
        Public boolean creditorLife;
        @AuraEnabled
        Public decimal timeinMonthsInCurrentResidency;
        @AuraEnabled
        Public String occupationProffessionalCategory;
        @AuraEnabled
        Public String position;
        @AuraEnabled
        Public String employmentIndustryType;
        @AuraEnabled
        Public String placeOfEmployment;
        @AuraEnabled
        Public String employmentStatus;
        @AuraEnabled
        Public decimal timeAtCurrentEmployment;
        @AuraEnabled
        Public decimal timeEmployedWithPreviousEmployer;
        @AuraEnabled
        Public decimal monthsEmployedPrevious12months;
        @AuraEnabled
        Public String highestLevelOfEducation;
        @AuraEnabled
        Public decimal nDependents;
        @AuraEnabled
        Public decimal nPreviousRejectApplication12m;
        @AuraEnabled
        Public string isPublicSectorEmployee;// initially mentioned  as Boolean 
        @AuraEnabled
        Public integer bankruptCurrent;
        @AuraEnabled
        Public boolean bankruptEver;
        @AuraEnabled
        Public boolean dateLastRejection;
        @AuraEnabled
        Public decimal monthlyIncomeUnverified;
        @AuraEnabled
        Public decimal otherIncomeUnverified;
        @AuraEnabled
        Public decimal totalAssetsUnverified;
        @AuraEnabled
        Public decimal totalLiabilitiesUnverified;
        @AuraEnabled
        Public decimal totalLiabilitiesConsolidatedUnverified;
        @AuraEnabled
        Public decimal totalMonthlyPaymentsUnverified;
        @AuraEnabled
        Public decimal totalPaymentsConsolidatedUnverified;
        @AuraEnabled
        Public decimal totalNetworthUnverified;
        @AuraEnabled
        Public decimal monthlyExpensesNonCreditUnverified;
        @AuraEnabled
        Public decimal monthlyIncomeVerified;
        @AuraEnabled
        Public decimal otherIncomeVerified;
        @AuraEnabled
        Public decimal totalAssetsVerified;
        @AuraEnabled
        Public decimal totalLiabilitiesVerified;
        @AuraEnabled
        Public decimal totalLiabilitiesConsolidatedVerified;
        @AuraEnabled
        Public decimal totalMonthlyPaymentsVerified;
        @AuraEnabled
        Public decimal totalPaymentsConsolidatedVerified;
        @AuraEnabled
        Public decimal totalNetworthVerified;
        @AuraEnabled
        Public decimal monthlyExpensesNonCreditVerified;
        ApplicantDataWrapper( Applicant__c applicantRecord, FinServ__Employment__c employmentRecord, Account accountRecord ){
            if(accountRecord != null){
                //this.rim = ''; // need to create a new field
                this.isVIP = OneJNSerializer.getBooleanValuesFromString(accountRecord.Premier_Customer_List__c);
                this.isPEP = accountRecord.Political_Exposure__pc;
                //this.CreditorLife = '' // need to create new Field on Person Account
                this.timeinMonthsInCurrentResidency = accountRecord.MonthsResidence_Number__c;
                this.nDependents = accountRecord.FinServ__NumberOfDependents__pc;
            }
            //this.entityType = ''; // Person Accout Record Type
            if(applicantRecord != null){
                //this.isJointHolder = ''; // need to create a new field on Applicant 
                this.applicantType = applicantRecord.Primary_Applicant_Flag__c ?  'Primary': 'Co-Applicant';
                //this.isGuarantor = '';  // need to create a new field on Applicant
                this.nPreviousRejectApplication12m = applicantRecord.Number_of_Rejected_Applications_Number__c;
                this.isPublicSectorEmployee = applicantRecord.Public_Sector_or_Civil_Servant_List__c;
                this.bankruptCurrent = OneJNSerializer.getIntegerValuesFromString(applicantRecord.Are_you_currently_in_bankruptcy_list__c); 
                this.bankruptEver = OneJNSerializer.getBooleanValuesFromString(applicantRecord.Declared_bankrupt_list__c);
                //this.dateLastRejection = applicantRecord.Date_of_Last_Rejection_date__c; mismatch data type
                this.monthlyIncomeUnverified = applicantRecord.Gross_Monthly_Income__c;
                this.otherIncomeUnverified = applicantRecord.Other_Income__c;
                this.totalAssetsUnverified = applicantRecord.Total_Assets_Calc__c;
                this.totalLiabilitiesUnverified = applicantRecord.Total_Liabilities_Calc__c;
                this.totalLiabilitiesConsolidatedUnverified = applicantRecord.Total_Amount_Consolidated__c;
                this.totalMonthlyPaymentsUnverified = applicantRecord.Total_Monthly_Loan_Payments_Number__c;
                this.totalPaymentsConsolidatedUnverified = applicantRecord.Total_Monthly_Payment__c;
                this.totalNetworthUnverified = applicantRecord.Net_Worth_Calc__c;
                this.monthlyExpensesNonCreditUnverified = applicantRecord.Total_Expenses_Calc__c;
                this.monthlyIncomeVerified = applicantRecord.Gross_Monthly_Income_VERIFIED_Number__c;
                this.otherIncomeVerified = applicantRecord.Other_Income_VERIFIED_Number__c;
                this.totalAssetsVerified = applicantRecord.Total_Assets_VERIFIED_Calc__c;
                this.totalLiabilitiesVerified = applicantRecord.Total_Liabilities_VERIFIED_Calc__c;
                this.totalLiabilitiesConsolidatedVerified = applicantRecord.Total_Amount_Consolidation_VERIFIED__c;
                this.totalMonthlyPaymentsVerified = applicantRecord.Total_Monthly_Loan_Payments_VERIFIED__c;
                this.totalPaymentsConsolidatedVerified = applicantRecord.Total_Monthly_Payment_VERIFIED_Number__c ;
                this.totalNetworthVerified = applicantRecord.Net_Worth_VERIFIED_Calc__c;
                this.monthlyExpensesNonCreditVerified = applicantRecord.Total_Expenses_VERIFIED_Calc__c;
            }
            if(employmentRecord != null){
                this.occupationProffessionalCategory = employmentRecord.Professional_Category__c;
                this.position = employmentRecord.Position_List__c;
                this.employmentIndustryType = employmentRecord.Industry__c;
                this.placeOfEmployment = employmentRecord.Name;
                this.employmentStatus = employmentRecord.FinServ__EmploymentStatus__c;
                this.timeAtCurrentEmployment = employmentRecord.Time_Employed_in_Present_Employer_M__c;
                this.timeEmployedWithPreviousEmployer = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
                this.monthsEmployedPrevious12months = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
                //this.highestLevelOfEducation = '';
            }
        }
    }
    /**
    * @description to return boolean value for string values Yes/No
    * @author Trupti Zende (Thinqloud) | 06-03-2021 
    * @param strValue 
    * @return Boolean 
    **/
    public Static Boolean getBooleanValuesFromString(String strValue){
        Boolean isChecked;
        isChecked = strValue == 'Yes' ? true :  false;
        return isChecked;
    }
    /**
    * @description to return interger value for string values Yes/No
    * @author Trupti Zende (Thinqloud) | 06-03-2021 
    * @param strValue 
    * @return Integer 
    **/
    public Static Integer getIntegerValuesFromString(String strValue){
        Integer isChecked;
        isChecked = strValue == 'Yes' ? 1 :  0;
        return isChecked;
    }
}