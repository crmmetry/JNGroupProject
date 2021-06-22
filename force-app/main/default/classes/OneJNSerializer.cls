/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-21-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   05-26-2021   Remario Richards   Initial Version
 **/
public class OneJNSerializer {
  @AuraEnabled
  public AppDataWrapper AppData;
  @AuraEnabled
  public List<ApplicantDataWrapper> Applicant;

  /**
   * @description constructor
   * @author Remario Richards | 06-18-2021
   * @param ApplicantList
   * @param EmploymentMap
   * @param AccountMap
   * @param ApplicationRecord
   * @param OpportunityRecord
   * @param OpportunityProductRecord
   * @param LoanCalculationProductRecord
   **/
  public OneJNSerializer(
    List<Applicant__c> applicantList,
    Map<Id, FinServ__Employment__c> employmentMap,
    Map<Id, Account> accountMap,
    Application__c applicationRecord,
    Opportunity opportunityRecord,
    OpportunityLineItem opportunityProductRecord,
    Loan_Calculation_Product__c loanCalculationProductRecord
  ) {
    this.Applicant = new List<ApplicantDataWrapper>();
    Applicant__c primaryApplicant = this.setupApplicants(
      applicantList,
      employmentMap,
      opportunityRecord,
      opportunityProductRecord,
      accountMap
    );
    this.AppData = new AppDataWrapper(
      applicationRecord,
      opportunityRecord,
      primaryApplicant,
      opportunityProductRecord,
      loanCalculationProductRecord
    );
  }
  /**
   * @description init all applications for serialization
   * @author Remario Richards | 06-18-2021
   * @param ApplicantList
   * @param EmploymentMap
   * @param OpportunityRecord
   * @param OpportunityProductRecord
   * @param AccountMap
   * @return Applicant__c
   **/
  private Applicant__c setupApplicants(
    List<Applicant__c> applicantList,
    Map<Id, FinServ__Employment__c> employmentMap,
    Opportunity opportunityRecord,
    OpportunityLineItem opportunityProductRecord,
    Map<Id, Account> accountMap
  ) {
    Applicant__c primaryApplicant = new Applicant__c();
    for (Applicant__c applicantRecord : applicantList) {
      if (applicantRecord.Primary_Applicant_Flag__c) {
        primaryApplicant = applicantRecord;
      }
      Account accountRecord = new Account();
      FinServ__Employment__c employmentRecord = new FinServ__Employment__c();
      if (String.isNotBlank(applicantRecord.Account__c)) {
        if (accountMap.containsKey(applicantRecord.Account__c)) {
          accountRecord = AccountMap.get(applicantRecord.Account__c);
        }
        if (employmentMap.containsKey(applicantRecord.Account__c)) {
          employmentRecord = EmploymentMap.get(applicantRecord.Account__c);
        }
      }
      //add all applicant records
      this.Applicant.add(
        new ApplicantDataWrapper(
          applicantRecord,
          employmentRecord,
          accountRecord,
          opportunityRecord,
          opportunityProductRecord
        )
      );
    }
    return primaryApplicant;
  }
  public class AppDataWrapper {
    @AuraEnabled
    public string ApplicationId;
    @AuraEnabled
    public boolean IsJointApplication;
    @AuraEnabled
    public string ProductType;
    @AuraEnabled
    public string SubProductType;
    @AuraEnabled
    public string CurrencyType;
    @AuraEnabled
    public String ApplicationDate;
    @AuraEnabled
    public decimal Amount;
    @AuraEnabled
    public decimal InterestRate;
    @AuraEnabled
    public decimal RequestedTenure;
    @AuraEnabled
    public string LoanPurpose;
    @AuraEnabled
    public string BranchRegion;
    @AuraEnabled
    public string FeeFinancing;
    @AuraEnabled
    public decimal MinMonthlyRepayment;
    @AuraEnabled
    public decimal ApprovedTenure;
    @AuraEnabled
    public decimal ApprovedCreditAmount;
    @AuraEnabled
    public string AdjudicationDecision;
    @AuraEnabled
    public String PhoenixId;
    @AuraEnabled
    public Decimal InterestRateForApplication;
    /**
     * @description constructor
     * @author Remario Richards | 06-18-2021
     * @param ApplicationRecord
     * @param OpportunityRecord
     * @param ApplicantRecord
     * @param OpportunityProductRecord
     * @param LoanCalculationProductRecord
     **/
    AppDataWrapper(
      Application__c applicationRecord,
      Opportunity opportunityRecord,
      Applicant__c applicantRecord,
      OpportunityLineItem opportunityProductRecord,
      Loan_Calculation_Product__c loanCalculationProductRecord
    ) {
      if (applicationRecord != null) {
        this.PhoenixId = applicationRecord.ApplicantNameID__r.RIM_no__c;
        this.ApplicationId = applicationRecord.Application_ID__c;
        this.ApprovedTenure = applicationRecord.IDM_Tenure_Date__c;
        this.ApprovedCreditAmount = applicationRecord.IDM_Loan_Amount_Number__c;
        this.AdjudicationDecision = applicationRecord.Adjudication_Decision_picklist__c;
        this.InterestRateForApplication = applicationRecord.IDM_Interest_Rate_Number__c;
        this.ApplicationDate = buildDate(applicationRecord.CreatedDate);
      }
      if (applicantRecord != null) {
        this.IsJointApplication = OneJNSerializer.getBooleanValueFromString(
          applicantRecord.Joint_Application_flag__c
        );
      }
      if (opportunityProductRecord != null) {
        this.ProductType = opportunityProductRecord.Product_Family__c;
        this.SubProductType = opportunityProductRecord.Product2.Name;
      }
      if (opportunityRecord != null) {
        this.CurrencyType = opportunityRecord.CurrencyIsoCode;
        this.BranchRegion = opportunityRecord.Preferred_Location__c;
      }
      if (loanCalculationProductRecord != null) {
        this.Amount = loanCalculationProductRecord.Loan_Amount_Number__c;
        this.InterestRate = loanCalculationProductRecord.Interest_Rate_Number__c;
        this.FeeFinancing = loanCalculationProductRecord.Method_of_Fee_Payment_List__c;
        this.LoanPurpose = loanCalculationProductRecord.Loan_Purpose_List__c;
        this.RequestedTenure = loanCalculationProductRecord.Months_Number__c;
        this.MinMonthlyRepayment = loanCalculationProductRecord.Minimum_Payment_per_Credit_Limit_Number__c;
      }
    }
  }
  public class ApplicantDataWrapper {
    @AuraEnabled
    public String PhoenixId;
    @AuraEnabled
    public String ApplicantType;
    @AuraEnabled
    public boolean IsPEP;
    @AuraEnabled
    public String EntityType;
    @AuraEnabled
    public decimal TimeinMonthsInCurrentResidency;
    @AuraEnabled
    public String OccupationProffessionalCategory;
    @AuraEnabled
    public String Position;
    @AuraEnabled
    public String EmploymentIndustryType;
    @AuraEnabled
    public String PlaceOfEmployment;
    @AuraEnabled
    public String EmploymentStatus;
    @AuraEnabled
    public decimal TimeAtCurrentEmployment;
    @AuraEnabled
    public decimal TimeEmployedWithPreviousEmployer;
    @AuraEnabled
    public decimal MonthsEmployedPrevious12months;
    @AuraEnabled
    public String HighestLevelOfEducation;
    @AuraEnabled
    public decimal NDependents;
    //@AuraEnabled
    //public decimal NPreviousRejectApplication12m;
    @AuraEnabled
    public string IsPublicSectorEmployee;
    @AuraEnabled
    public integer BankruptCurrent;
    @AuraEnabled
    public boolean BankruptEver;
    @AuraEnabled
    public decimal MonthlyIncomeUnverified;
    @AuraEnabled
    public decimal OtherIncomeUnverified;
    @AuraEnabled
    public decimal TotalAssetsUnverified;
    @AuraEnabled
    public decimal TotalLiabilitiesUnverified;
    @AuraEnabled
    public decimal TotalLiabilitiesConsolidatedUnverified;
    @AuraEnabled
    public decimal TotalMonthlyPaymentsUnverified;
    @AuraEnabled
    public decimal TotalPaymentsConsolidatedUnverified;
    @AuraEnabled
    public decimal TotalNetworthUnverified;
    @AuraEnabled
    public decimal MonthlyExpensesNonCreditUnverified;
    @AuraEnabled
    public decimal MonthlyIncomeVerified;
    @AuraEnabled
    public decimal OtherIncomeVerified;
    @AuraEnabled
    public decimal TotalAssetsVerified;
    @AuraEnabled
    public decimal TotalLiabilitiesVerified;
    @AuraEnabled
    public decimal TotalLiabilitiesConsolidatedVerified;
    @AuraEnabled
    public decimal TotalMonthlyPaymentsVerified;
    @AuraEnabled
    public decimal TotalPaymentsConsolidatedVerified;
    @AuraEnabled
    public decimal TotalNetworthVerified;
    @AuraEnabled
    public decimal MonthlyExpensesNonCreditVerified;
    /**
     * @description constructor
     * @author Remario Richards | 06-18-2021
     * @param applicantRecord
     * @param employmentRecord
     * @param accountRecord
     * @param OpportunityRecord
     * @param OpportunityProductRecord
     **/
    ApplicantDataWrapper(
      Applicant__c applicantRecord,
      FinServ__Employment__c employmentRecord,
      Account accountRecord,
      Opportunity opportunityRecord,
      OpportunityLineItem opportunityProductRecord
    ) {
      if (accountRecord != null) {
        this.PhoenixId = accountRecord.RIM_no__c;
        this.IsPEP = setDefaultBooleanValue(
          accountRecord.Politically_Affiliated__c
        );
        this.TimeinMonthsInCurrentResidency = accountRecord.MonthsResidence_Number__c;
        this.NDependents = accountRecord.FinServ__NumberOfDependents__pc;
        this.HighestLevelOfEducation = accountRecord.Highest_Level_of_Education_attained__pc;
        this.EntityType = accountRecord.RecordType.Name;
      }
      if (employmentRecord != null) {
        this.OccupationProffessionalCategory = employmentRecord.Professional_Category__c;
        this.Position = employmentRecord.Position_List__c;
        this.EmploymentIndustryType = employmentRecord.Industry__c;
        this.PlaceOfEmployment = employmentRecord.Name;
        this.EmploymentStatus = employmentRecord.FinServ__EmploymentStatus__c;
        this.TimeAtCurrentEmployment = employmentRecord.Time_Employed_in_Present_Employer_M__c;
        this.TimeEmployedWithPreviousEmployer = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
        this.MonthsEmployedPrevious12months = employmentRecord.Time_Employed_with_Previous_Employer_M__c;
      }
      this.applicantType = applicantRecord.Primary_Applicant_Flag__c
        ? 'Primary'
        : 'Co-Applicant';
      //this.NPreviousRejectApplication12m = applicantRecord.Number_of_Rejected_Applications_Number__c;
      this.IsPublicSectorEmployee = applicantRecord.Public_Sector_or_Civil_Servant_List__c;
      this.BankruptCurrent = OneJNSerializer.getIntegerValueFromString(
        applicantRecord.Are_you_currently_in_bankruptcy_list__c
      );
      this.BankruptEver = OneJNSerializer.getBooleanValueFromString(
        applicantRecord.Declared_bankrupt_list__c
      );
      this.MonthlyIncomeUnverified = applicantRecord.Gross_Monthly_Income__c;
      this.OtherIncomeUnverified = applicantRecord.Other_Income__c;
      this.TotalAssetsUnverified = applicantRecord.Total_Assets_Calc__c;
      this.TotalLiabilitiesUnverified = applicantRecord.Total_Liabilities_Calc__c;
      this.TotalLiabilitiesConsolidatedUnverified = applicantRecord.Total_Amount_Consolidated__c;
      this.TotalMonthlyPaymentsUnverified = applicantRecord.Total_Monthly_Loan_Payments_Number__c;
      this.TotalPaymentsConsolidatedUnverified = applicantRecord.Total_Monthly_Payment__c;
      this.TotalNetworthUnverified = applicantRecord.Net_Worth_Calc__c;
      this.MonthlyExpensesNonCreditUnverified = applicantRecord.Total_Expenses_Calc__c;
      this.OtherIncomeVerified = applicantRecord.Other_Income_VERIFIED_Number__c;

      this.MonthlyExpensesNonCreditVerified = applicantRecord.Total_Expenses_VERIFIED_Calc__c;
      this.MonthlyIncomeVerified = applicantRecord.Gross_Monthly_Income_VERIFIED_Number__c;
      this.TotalAssetsVerified = applicantRecord.Total_Assets_VERIFIED_Calc__c;
      this.TotalLiabilitiesConsolidatedVerified = applicantRecord.Total_Amount_Consolidation_VERIFIED__c;
      this.TotalLiabilitiesVerified = applicantRecord.Total_Liabilities_VERIFIED_Calc__c;
      this.TotalMonthlyPaymentsVerified = applicantRecord.Total_Monthly_Loan_Payments_VERIFIED__c;
      this.TotalNetworthVerified = applicantRecord.Net_Worth_VERIFIED_Calc__c;
      this.TotalPaymentsConsolidatedVerified = applicantRecord.Total_Monthly_Payment_VERIFIED_Number__c;
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
   * @description : to get the Unix timestamp from the Datetime or Date  passed
   * @author Ishwari Gaikwad(Thinqloud) | 06-08-2021
   * @param dateTimeVar
   * @return Long
   **/
  public static Long getUnixTime(DateTime dateTimeVar) {
    if (dateTimeVar == null)
      return null;
    return dateTimeVar.getTime();
  }
  /**
   * @description contruct date format for external system
   * @author Remario Richards | 06-17-2021
   * @param dateVar
   * @return String
   **/
  public static String buildDate(DateTime dateVar) {
    if (dateVar == null)
      return null;
    DateTime dt = DateTime.newInstance(
      dateVar.year(),
      dateVar.month(),
      dateVar.day()
    );
    return dt.format('yyyy-MM-dd');
  }

  /**
   * @description default value for the boolean
   * @author Remario Richards | 06-18-2021
   * @param field
   * @return Boolean
   **/
  public static Boolean setDefaultBooleanValue(Boolean field) {
    return (field == null ? false : field);
  }
}
