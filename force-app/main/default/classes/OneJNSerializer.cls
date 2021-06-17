/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 06-17-2021
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

  public OneJNSerializer(
    List<Applicant__c> ApplicantList,
    Map<Id, FinServ__Employment__c> EmploymentMap,
    Map<Id, Account> AccountMap,
    Application__c ApplicationRecord,
    Opportunity OpportunityRecord,
    OpportunityLineItem OpportunityProductRecord,
    Loan_Calculation_Product__c LoanCalculationProductRecord
  ) {
    Applicant__c primaryApplicant = new Applicant__c();
    this.Applicant = new List<ApplicantDataWrapper>();

    for (Applicant__c applicantRecord : ApplicantList) {
      if (applicantRecord.Primary_Applicant_Flag__c) {
        primaryApplicant = applicantRecord;
      }
      Account accountRecord = new Account();
      FinServ__Employment__c employmentRecord = new FinServ__Employment__c();
      if (String.isNotBlank(applicantRecord.Account__c)) {
        if (AccountMap.containsKey(applicantRecord.Account__c)) {
          accountRecord = AccountMap.get(applicantRecord.Account__c);
        }
        if (EmploymentMap.containsKey(applicantRecord.Account__c)) {
          employmentRecord = EmploymentMap.get(applicantRecord.Account__c);
        }
      }
      this.Applicant.add(
        new ApplicantDataWrapper(
          applicantRecord,
          employmentRecord,
          accountRecord,
          OpportunityRecord,
          OpportunityProductRecord
        )
      );
    }
    this.AppData = new AppDataWrapper(
      ApplicationRecord,
      OpportunityRecord,
      primaryApplicant,
      OpportunityProductRecord,
      LoanCalculationProductRecord
    );
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
    public Long ApplicationDate;
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
    public decimal ApprovedLoanAmount;
    @AuraEnabled
    public string AdjudicationDecision;
    @AuraEnabled
    public String PhoenixId;
    @AuraEnabled
    public Decimal InterestRateForApplication;
    AppDataWrapper(
      Application__c ApplicationRecord,
      Opportunity OpportunityRecord,
      Applicant__c ApplicantRecord,
      OpportunityLineItem OpportunityProductRecord,
      Loan_Calculation_Product__c LoanCalculationProductRecord
    ) {
      if (ApplicationRecord != null) {
        this.PhoenixId = applicationRecord.ApplicantNameID__r.RIM_no__c;
        this.ApplicationId = applicationRecord.Application_ID__c;
        this.ApprovedTenure = applicationRecord.IDM_Tenure_Date__c;
        this.ApprovedLoanAmount = applicationRecord.IDM_Loan_Amount_Number__c;
        this.AdjudicationDecision = applicationRecord.Adjudication_Decision_picklist__c; // Datatype not provided
        this.InterestRateForApplication = applicationRecord.IDM_Interest_Rate_Number__c;
        this.ApplicationDate = getUnixTime(applicationRecord.CreatedDate);
      }
      if (ApplicantRecord != null) {
        this.IsJointApplication = OneJNSerializer.getBooleanValueFromString(
          applicantRecord.Joint_Application_flag__c
        );
      }
      if (OpportunityProductRecord != null) {
        this.ProductType = opportunityProductRecord.Product_Family__c;
        this.SubProductType = opportunityProductRecord.Product2.Name;
      }
      if (OpportunityRecord != null) {
        this.CurrencyType = opportunityRecord.CurrencyIsoCode;
        this.BranchRegion = opportunityRecord.Preferred_Location__c;
      }
      if (LoanCalculationProductRecord != null) {
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
    public boolean IsSupplimental;
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
    @AuraEnabled
    public decimal NPreviousRejectApplication12m;
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
    ApplicantDataWrapper(
      Applicant__c applicantRecord,
      FinServ__Employment__c employmentRecord,
      Account accountRecord,
      Opportunity OpportunityRecord,
      OpportunityLineItem OpportunityProductRecord
    ) {
      if (accountRecord != null) {
        this.PhoenixId = accountRecord.RIM_no__c;
        this.IsPEP = accountRecord.Politically_Affiliated__c;
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
      this.NPreviousRejectApplication12m = applicantRecord.Number_of_Rejected_Applications_Number__c;
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
}
