/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Kirti R.(thinqloud)   Wrapper class of Personal_Credit_Score_Model__mdt  
**/
public class SubCriteriaOptionWrapper {
    @AuraEnabled
    public Integer age;
    @AuraEnabled
    public String employmentType;
    @AuraEnabled
    public String education;
    @AuraEnabled
    public String residentialStatus;
    @AuraEnabled
    public Integer yearsAtCurrentResidence;
    @AuraEnabled
    public String creditHistory;
    @AuraEnabled
    public String netWorth;
    @AuraEnabled
    public String employmentStatus;
    @AuraEnabled
    public String industryOfEmployment;
    @AuraEnabled
    public Decimal lengthOfCurrentEmployment;
    @AuraEnabled
    public String professionalCategory;
    @AuraEnabled
    public String workingCapital;
    @AuraEnabled
    public String natureOfEngagement;
    @AuraEnabled
    public String typeOfIndustry;
    @AuraEnabled
    public String financialPerformance;
    @AuraEnabled
    public String financialStatementSupport;
    @AuraEnabled
    public String lengthOfTrade;
    @AuraEnabled
    public String collateral;
    @AuraEnabled
    public Decimal loanToValue;
    @AuraEnabled
    public Decimal ablitityToService;
    @AuraEnabled
    public String repaymentMethod;
  
    public SubCriteriaOptionWrapper(AccountWrapper accWrapper, OpportunityWrapper oppWrapper, 
                                    LoanCalculationsWrapper loanCalcWrapper, 
                                    EmploymentWrapper empWrapper, ApplicantWrapper applicantWrapper) {
        this.age = applicantWrapper.age;
        this.employmentType =empWrapper.employmentType;
        this.education =accWrapper.highestLevelOfEducation;
        this.residentialStatus= accWrapper.statusOfAddress;
        this.yearsAtCurrentResidence= accWrapper.yearsAtResident;
        this.creditHistory= applicantWrapper.creditHistoryInLast24Month;
        this.netWorth= applicantWrapper.assessmentOfApplicantNetWorth;
        this.employmentStatus= empWrapper.employmentStatus;
        this.industryOfEmployment= empWrapper.industry;
        this.lengthOfCurrentEmployment = empWrapper.lengthOfEmployment;
        this.professionalCategory =empWrapper.professionalCategory;
        this.workingCapital = empWrapper.assessmentOfBusinessWorkingCapita;
        this.natureOfEngagement= empWrapper.natureOfEngagement;
        this.typeOfIndustry= empWrapper.industry;
        this.financialPerformance= empWrapper.assessmentOfBusiness;
        this.financialStatementSupport= empWrapper.assessmentOfStatement;
        this.lengthOfTrade= empWrapper.lengthOfTrade;
        this.collateral= oppWrapper.collateralCC;
        this.loanToValue= oppWrapper.loanToValueCC;
        this.ablitityToService= loanCalcWrapper.abilityToServiceCC;
        this.repaymentMethod= loanCalcWrapper.repaymentMethod;
    }
   /* public subCriteriaOptionWrapper(Integer age, String employmentType, String education,String residentialStatus,
                                    Integer yearsAtCurrentResidence, String creditHistory, String netWorth, String employmentStatus,
                                    String industryOfEmployment, Integer lengthOfCurrentEmployment, String professionalCategory,
                                    String workingCapital, String natureOfEngagement, String typeOfIndustry, String financialPerformance,
                                    String financialStatementSupport, String lengthOfTrade, String collateral, Decimal loanToValue,
                                    Decimal ablitityToService, String repaymentMethod) {
        this.age = age;
        this.employmentType =employmentType;
        this.education =education;
        this.residentialStatus= residentialStatus;
        this.yearsAtCurrentResidence= yearsAtCurrentResidence;
        this.creditHistory= creditHistory;
        this.netWorth= netWorth;
        this.employmentStatus= employmentStatus;
        this.industryOfEmployment= industryOfEmployment;
        this.lengthOfCurrentEmployment = lengthOfCurrentEmployment;
        this.professionalCategory = professionalCategory;
        this.workingCapital = workingCapital;
        this.natureOfEngagement= natureOfEngagement;
        this.typeOfIndustry= typeOfIndustry;
        this.financialPerformance= financialPerformance;
        this.financialStatementSupport= financialStatementSupport;
        this.lengthOfTrade= lengthOfTrade;
        this.collateral= collateral;
        this.loanToValue= loanToValue;
        this.ablitityToService= ablitityToService;
        this.repaymentMethod= repaymentMethod;
    }*/

        
}