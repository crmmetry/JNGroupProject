public with sharing class ProductDetailController {
  /**
   * Return a Product Selection Object consisting of an opportunity product name and family.
   * @param {Id} - oppId
   * @return Object
   */
  @AuraEnabled
  public static Object getSingleProductFamilySelection(Id oppId) {
    System.debug('Controller');
    OpportunityLineItem oppProduct = Util.getOpportunityProducts(oppId);
    if (oppProduct != null) {
      Wrappers.ProductSelectionWrapper selection = new Wrappers.ProductSelectionWrapper(
        oppProduct
      );
      return selection;
    }
    return Constants.NONE;
  }
  /**
   * retrieves default Jn custom meta data configuration
   * @return {JNConfiguration}
   */
  @AuraEnabled
  public static JNConfiguration GetJNConfigs() {
    try {
      return JNConfigurations.GetDefaultConfiguration();
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  /**
   * return a list of applicant wrappers related to an oppurtunity
   * @param {Id} oppId - Id of selected opportunity.
   * @return {creditRatingMap}
   */
  private static List<ApplicantWrapper> getApplicants(Id oppId) {
    List<ApplicantWrapper> applicantWrappers = new List<ApplicantWrapper>();
    List<Applicant__c> applicants = [
      SELECT Id, Account__r.PersonBirthdate
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];
    for (Applicant__c applicant : applicants) {
      ApplicantWrapper appWrapper = new ApplicantWrapper(applicant);
      applicantWrappers.add(appWrapper);
    }
    return applicantWrappers;
  }

  /**
   * return a map with applicants and their respective ratings
   * @param {List<ApplicantWrapper>} applicants - List of applicants.
   * @return {Map}
   */

  private static List<ApplicantWrapper> getApplicantsCreditRating(
    List<ApplicantWrapper> applicants,
    Decimal tenure
  ) {
    List<ApplicantWrapper> applicantsWithRating = new List<ApplicantWrapper>();
    List<CreditorLifeMatrixWrapper> creditorLifeMatrixWrappers = JNConfigurations.getCreditorLifeMatrix();
    Decimal rating;
    for (ApplicantWrapper applicantWrapper : applicants) {
      for (
        CreditorLifeMatrixWrapper creditorLifeMatrixWrapper : creditorLifeMatrixWrappers
      ) {
        if (creditorLifeMatrixWrapper.isAgeWithinBound(applicantWrapper.age)) {
          applicantWrapper.rating = creditorLifeMatrixWrapper.getCreditRating(
            applicantWrapper.age,
            tenure
          );
          applicantsWithRating.add(applicantWrapper);
        }
      }
    }
    return applicantsWithRating;
  }

  @AuraEnabled
  public static List<ApplicantWrapper> getApplicantsRating(
    Id oppId,
    Decimal tenure
  ) {
    List<ApplicantWrapper> applicants = getApplicants(oppId);
    applicants = getApplicantsCreditRating(applicants, tenure);
    return applicants;
  }

  /**
   * return a map of wrapper records belonging to applicant and their assets/liabilities
   * @param {Id} oppId - opportunity Id.
   * @return {Map}
   */
  @AuraEnabled
  public static List<Object> getApplicantsAssetsAndLiabilities(Id oppId) {
    List<Applicant__c> applicants = [
      SELECT
        Id,
        Credit_History_in_last_24_Months__c,
        Assessment_of_Applicant_Net_Worth__c,
        Statutory_Deductions_Numbers__c,
        Rent_Strata_Maintenance__c,
        Personal_Expenses_Monthly_Prior_Loan__c,
        Savings_Pension_Insurance_Number__c,
        Real_Estate_Monthly_Payment_Number__c,
        Motor_Vehicle_Monthly_Payment_Number__c,
        Other_Asset_Monthly_Payment_Number__c,
        Other_Loan_Monthly_Payment_Number__c,
        Gross_Monthly_Income__c,
        Account__r.PersonBirthdate,
        (SELECT Id, Minimum_Payment__c FROM Application_Assets_Liabilities__r)
      FROM Applicant__c
      WHERE Opportunity__c = :oppId
    ];
    System.debug(applicants);
    List<Object> wrappers = new List<Object>();
    Map<String, Object> wrapperMap = new Map<String, Object>();

    for (Applicant__c record : applicants) {
      if (record.Application_Assets_Liabilities__r != null) {
        for (
          Application_Asset_Liability__c record2 : record.Application_Assets_Liabilities__r
        ) {
          ApplicantAssetsAndLiabilitiesWrapper assetAndLiabilityWrapper = new ApplicantAssetsAndLiabilitiesWrapper(
            record2
          );
          wrappers.add(assetAndLiabilityWrapper);
        }
      }
      ApplicantWrapper appWrapper = new ApplicantWrapper(record);

      wrappers.add(appWrapper);
    }
    return wrappers;
  }
}
