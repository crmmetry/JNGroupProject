/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-08-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public class OneJNSerializer {
  @AuraEnabled
  public AppDataWrapper appData;
  @AuraEnabled
  public ApplicantDataWrapper applicant;

  public OneJNSerializer(
    Applicant__c applicantRecord,
    FinServ__Employment__c employmentRecord,
    Account accountRecord,
    Application__c applicationRecord,
    Opportunity opportunityRecord,
    OpportunityLineItem opportunityProductRecord,
    Loan_Calculation_Product__c loanCalculationProductRecord
  ) {
    this.appData = new AppDataWrapper(
      applicationRecord,
      opportunityRecord,
      applicantRecord,
      opportunityProductRecord,
      loanCalculationProductRecord
    );
    this.applicant = new ApplicantDataWrapper(
      applicantRecord,
      employmentRecord,
      accountRecord
    );
  }
  class AppDataWrapper {
    @AuraEnabled
    public string applicationId;
    @AuraEnabled
    public boolean isJointApplication;
    @AuraEnabled
    public string productType;
    @AuraEnabled
    public string subProductType;
    @AuraEnabled
    public string currencyType;
    @AuraEnabled
    public string applicationDate;
    @AuraEnabled
    public decimal amount;
    @AuraEnabled
    public decimal interestRate;
    @AuraEnabled
    public decimal requestedTenure;
    @AuraEnabled
    public string loanPurpose;
    @AuraEnabled
    public string branchRegion;
    @AuraEnabled
    public string feeFinancing;
    @AuraEnabled
    public decimal minMonthlyRepayment;

    AppDataWrapper(
      Application__c applicationRecord,
      Opportunity opportunityRecord,
      Applicant__c applicantRecord,
      OpportunityLineItem opportunityProductRecord,
      Loan_Calculation_Product__c loanCalculationProductRecord
    ) {
      if (applicationRecord != null) {
        this.applicationId = applicationRecord.Application_ID__c;
        //this.applicationDate = '';
      }
      if (applicantRecord != null) {
        this.isJointApplication = OneJNSerializer.getBooleanValueFromString(
          applicantRecord.Joint_Application_flag__c
        );
      }
      if (opportunityProductRecord != null) {
        this.productType = opportunityProductRecord.Product_Family__c;
        this.subProductType = opportunityProductRecord.Name;
      }
      if (opportunityRecord != null) {
        this.currencyType = opportunityRecord.CurrencyIsoCode;
        this.branchRegion = opportunityRecord.Preferred_Location__c;
      }
      if (loanCalculationProductRecord != null) {
        this.amount = loanCalculationProductRecord.Loan_Amount_Number__c;
        this.interestRate = loanCalculationProductRecord.Interest_Rate_Number__c;
        this.requestedTenure = loanCalculationProductRecord.Months_Number__c;
        this.loanPurpose = loanCalculationProductRecord.Loan_Purpose_List__c;
        this.feeFinancing = loanCalculationProductRecord.Method_of_Fee_Payment_List__c;
        this.minMonthlyRepayment = loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c;
      }
    }
  }
  class ApplicantDataWrapper {
    @AuraEnabled
    public String rim;
    @AuraEnabled
    public boolean isJointHolder;
    @AuraEnabled
    public String applicantType;
    @AuraEnabled
    public boolean isGuarantor;
    @AuraEnabled
    public boolean isVIP;
    @AuraEnabled
    public boolean isPEP;
    @AuraEnabled
    public boolean isSupplimental;
    @AuraEnabled
    public String entityType;
    @AuraEnabled
    public boolean creditorLife;
    @AuraEnabled
    public decimal timeinMonthsInCurrentResidency;
    @AuraEnabled
    public String occupationProffessionalCategory;
    @AuraEnabled
    public String position;
    @AuraEnabled
    public String employmentIndustryType;
    @AuraEnabled
    public String placeOfEmployment;
    @AuraEnabled
    public String employmentStatus;
    @AuraEnabled
    public decimal timeAtCurrentEmployment;
    @AuraEnabled
    public decimal timeEmployedWithPreviousEmployer;
    @AuraEnabled
    public decimal monthsEmployedPrevious12months;
    @AuraEnabled
    public String highestLevelOfEducation;
    @AuraEnabled
    public decimal nDependents;
    @AuraEnabled
    public decimal nPreviousRejectApplication12m;
    @AuraEnabled
    public string isPublicSectorEmployee;
    @AuraEnabled
    public integer bankruptCurrent;
    @AuraEnabled
    public boolean bankruptEver;
    @AuraEnabled
    public boolean dateLastRejection;
    @AuraEnabled
    public decimal monthlyIncomeUnverified;
    @AuraEnabled
    public decimal otherIncomeUnverified;
    @AuraEnabled
    public decimal totalAssetsUnverified;
    @AuraEnabled
    public decimal totalLiabilitiesUnverified;
    @AuraEnabled
    public decimal totalLiabilitiesConsolidatedUnverified;
    @AuraEnabled
    public decimal totalMonthlyPaymentsUnverified;
    @AuraEnabled
    public decimal totalPaymentsConsolidatedUnverified;
    @AuraEnabled
    public decimal totalNetworthUnverified;
    @AuraEnabled
    public decimal monthlyExpensesNonCreditUnverified;
    @AuraEnabled
    public decimal monthlyIncomeVerified;
    @AuraEnabled
    public decimal otherIncomeVerified;
    @AuraEnabled
    public decimal totalAssetsVerified;
    @AuraEnabled
    public decimal totalLiabilitiesVerified;
    @AuraEnabled
    public decimal totalLiabilitiesConsolidatedVerified;
    @AuraEnabled
    public decimal totalMonthlyPaymentsVerified;
    @AuraEnabled
    public decimal totalPaymentsConsolidatedVerified;
    @AuraEnabled
    public decimal totalNetworthVerified;
    @AuraEnabled
    public decimal monthlyExpensesNonCreditVerified;
    ApplicantDataWrapper(
      Applicant__c applicantRecord,
      FinServ__Employment__c employmentRecord,
      Account accountRecord
    ) {
      if (accountRecord != null) {
        //this.rim = ''; // need to create a new field
        this.isVIP = OneJNSerializer.getBooleanValueFromString(
          accountRecord.Premier_Customer_List__c
        );
        this.isPEP = accountRecord.Politically_Affiliated__c;
        //this.CreditorLife = '' // need to create new Field on Person Account
        this.timeinMonthsInCurrentResidency = accountRecord.MonthsResidence_Number__c;
        this.nDependents = accountRecord.FinServ__NumberOfDependents__pc;
        this.highestLevelOfEducation = accountRecord.Highest_Level_of_Education_attained__pc;
      }
      //this.entityType = ''; // Person Accout Record Type
      if (applicantRecord != null) {
        //this.isJointHolder = ''; // need to create a new field on Applicant
        this.applicantType = applicantRecord.Primary_Applicant_Flag__c
          ? 'Primary'
          : 'Co-Applicant';
        //this.isGuarantor = '';  // need to create a new field on Applicant
        this.nPreviousRejectApplication12m = applicantRecord.Number_of_Rejected_Applications_Number__c;
        this.isPublicSectorEmployee = applicantRecord.Public_Sector_or_Civil_Servant_List__c;
        this.bankruptCurrent = OneJNSerializer.getIntegerValueFromString(
          applicantRecord.Are_you_currently_in_bankruptcy_list__c
        );
        this.bankruptEver = OneJNSerializer.getBooleanValueFromString(
          applicantRecord.Declared_bankrupt_list__c
        );
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
        this.totalPaymentsConsolidatedVerified = applicantRecord.Total_Monthly_Payment_VERIFIED_Number__c;
        this.totalNetworthVerified = applicantRecord.Net_Worth_VERIFIED_Calc__c;
        this.monthlyExpensesNonCreditVerified = applicantRecord.Total_Expenses_VERIFIED_Calc__c;
      }
      if (employmentRecord != null) {
        this.occupationProffessionalCategory = employmentRecord.Professional_Category__c;
        this.position = employmentRecord.Position_List__c;
        this.employmentIndustryType = employmentRecord.Industry__c;
        this.placeOfEmployment = employmentRecord.Name;
        this.employmentStatus = employmentRecord.FinServ__EmploymentStatus__c;
        this.timeAtCurrentEmployment = employmentRecord.Time_Employed_in_Present_Employer_M__c;
        this.timeEmployedWithPreviousEmployer = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
        this.monthsEmployedPrevious12months = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
      }
    }
  }
  /**
   * @description to return boolean value for string values Yes/No
   * @author Trupti Zende (Thinqloud) | 06-03-2021
   * @param strValue
   * @return Boolean
   **/
  public static Boolean getBooleanValueFromString(String strValue) {
    Boolean isChecked;
    isChecked = strValue == 'Yes' ? true : false;
    return isChecked;
  }
  /**
   * @description to return interger value for string values Yes/No
   * @author Trupti Zende (Thinqloud) | 06-03-2021
   * @param strValue
   * @return Integer
   **/
  public static Integer getIntegerValueFromString(String strValue) {
    Integer isChecked;
    isChecked = strValue == 'Yes' ? 1 : 0;
    return isChecked;
  }

  /**
   * @description : to get the Unix timestamp from the Datetime passed
   * @author Ishwari Gaikwad(Thinqloud) | 06-08-2021
   * @param dateTimeVar
   * @return Long
   **/
  public static Long getUnixTime(DateTime dateTimeVar) {
    Long l = dateTimeVar.getTime() / 1000;
    return l;
  }
}
