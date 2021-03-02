/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Kirti R.(thinqloud)   Wrapper class of Personal_Credit_Score_Model__mdt
 **/
public class SubCriteriaOptionWrapper {
  @AuraEnabled
  public Decimal age;
  @AuraEnabled
  public String employmentType;
  @AuraEnabled
  public String education;
  @AuraEnabled
  public String residentialStatus;
  @AuraEnabled
  public Decimal yearsAtCurrentResidence;
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

  public SubCriteriaOptionWrapper(
    AccountWrapper accWrapper,
    OpportunityWrapper oppWrapper,
    LoanCalculationsWrapper loanCalcWrapper,
    EmploymentWrapper empWrapper,
    ApplicantWrapper applicantWrapper
  ) {
    if (applicantWrapper != null) {
      this.creditHistory = applicantWrapper.creditHistoryInLast24Month;
      this.netWorth = applicantWrapper.assessmentOfApplicantNetWorth;
      this.creditHistory = applicantWrapper.creditHistoryInLast24Month;
      this.netWorth = applicantWrapper.assessmentOfApplicantNetWorth;
    }
    if (empWrapper != null) {
      this.employmentType = empWrapper.employmentType;
      this.employmentStatus = empWrapper.employmentStatus;
      this.industryOfEmployment = empWrapper.industry;
      this.lengthOfCurrentEmployment = empWrapper.lengthOfEmployment;
      this.professionalCategory = empWrapper.professionalCategory;
      this.workingCapital = empWrapper.assessmentOfBusinessWorkingCapita;
      this.natureOfEngagement = empWrapper.natureOfEngagement;
      this.typeOfIndustry = empWrapper.industry;
      this.financialPerformance = empWrapper.assessmentOfBusiness;
      this.financialStatementSupport = empWrapper.assessmentOfStatement;
      this.lengthOfTrade = empWrapper.lengthOfTrade;
    }
    if (accWrapper != null) {
      this.education = accWrapper.highestLevelOfEducation;
      this.residentialStatus = accWrapper.statusOfAddress;
      this.yearsAtCurrentResidence = accWrapper.yearsAtResident;
      this.age = accWrapper.age;
    }

    if (oppWrapper != null) {
      this.collateral = oppWrapper.collateralCC;
      this.loanToValue = oppWrapper.loanToValueCC;
    }
    if (loanCalcWrapper != null) {
      this.ablitityToService = loanCalcWrapper.abilityToServiceCC;
      this.repaymentMethod = loanCalcWrapper.repaymentMethod;
    }
  }
}
