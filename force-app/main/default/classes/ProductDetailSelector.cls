/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     24/11/2020      Ishwari G.(thinqloud)  Selector for the Product Details related Object
 **/
public with sharing class ProductDetailSelector {
  /*
   * gives the account details
   * @param {Id} accountId - account Id
   * @return {AccountWrapper} - account details in wrapper format
   */
  public static AccountWrapper getAccount(Id accountId) {
    AccountWrapper accWrapper;
    Account accountObj = [
      SELECT
        Status_of_Address__c,
        Years_at_Residence__c,
        Highest_Level_of_Education__c,
        FinServ__Age__pc,
        PersonBirthdate
      FROM Account
      WHERE Id = :accountId
    ];
    if (accountObj != null) {
      accWrapper = new AccountWrapper(accountObj);
    }

    return accWrapper;
  }

  /*
   * gives the employment details
   * @param {Id} accountId - account Id
   * @return {EmploymentWrapper} - employment details in wrapper format
   */
  public static EmploymentWrapper getEmployemntDetails(Id accountId) {
    EmploymentWrapper empWrapper;
    FinServ__Employment__c employment = [
      SELECT
        Id,
        FinServ__EmploymentStatus__c,
        Employment_Status__c,
        Industry__c,
        FinServ__LengthOfEmployment__c,
        Professional_Category__c,
        Assessment_of_Business_Working_Capita__c,
        Nature_of_Engagement__c,
        Assessment_of_Business__c,
        Assessment_of_Statement__c,
        Length_of_Trade__c,
        RecordTypeId
      FROM FinServ__Employment__c
      WHERE Account__c = :accountId AND Current_Employment__c = TRUE
    ];
    if (employment != null) {
      empWrapper = new EmploymentWrapper(employment);
    }

    return empWrapper;
  }

  /*
   * gives the applicant details
   * @param {Id} oppId - opportunity Id
   * @return {List<ApplicantWrapper>} - returns list of applicants in wrapper format
   */
  public static List<ApplicantWrapper> getApplicantDetails(Id oppId) {
    List<Applicant__c> applicantList = [
      SELECT
        Id,
        Credit_History_in_last_24_Months__c,
        Assessment_of_Applicant_Net_Worth__c,
        Account__r.PersonBirthdate
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];
    List<ApplicantWrapper> applicantWrappers = new List<ApplicantWrapper>();
    if (!applicantList.isEmpty() && applicantList.size() > 0) {
      for (Applicant__c applicant : applicantList) {
        ApplicantWrapper appWrapper = new ApplicantWrapper(applicant);
        applicantWrappers.add(appWrapper);
      }
    }

    return applicantWrappers;
  }

  /*
   * gives the loan calculations details
   * @param {Id} oppId - opportunity Id
   * @return {List<LoanCalculationsWrapper>} - returns list of loan calculations in wrapper format
   */
  public static List<LoanCalculationsWrapper> getLoanCalculations(Id oppId) {
    List<Loan_Calculator__c> loanCalculations = [
      SELECT
        Ability_to_Service_CC__c,
        Ability_to_Service_LOC__c,
        Repayment_Method_CC__c,
        Repayment_Method_LOC__c
      FROM Loan_Calculator__c
      WHERE Opportunity__c = :oppId
    ];
    List<LoanCalculationsWrapper> loanCalcWrappers = new List<LoanCalculationsWrapper>();
    if (!loanCalculations.isEmpty() && loanCalculations.size() > 0) {
      for (Loan_Calculator__c loanCalculation : loanCalculations) {
        LoanCalculationsWrapper loanWrapper = new LoanCalculationsWrapper(
          loanCalculation
        );
        loanCalcWrappers.add(loanWrapper);
      }
    }
    return loanCalcWrappers;
  }

  /*
   * gives the opportunity details
   * @param {Id} oppId - opportunity Id
   * @return {OpportunityWrapper} - returns  opportunity details in wrapper format
   */
  public static OpportunityWrapper getOpportunityDetails(Id oppId) {
    OpportunityWrapper oppWrapper;
    Opportunity oppObj = [
      SELECT
        AccountId,
        Collateral_CC__c,
        Collateral_LOC__c,
        Loan_to_Value_CC__c,
        Loan_to_Value_LOC__c
      FROM opportunity
      WHERE Id = :oppId
    ];
    if (oppObj != null) {
      oppWrapper = new OpportunityWrapper(oppObj);
    }

    return oppWrapper;
  }
}
