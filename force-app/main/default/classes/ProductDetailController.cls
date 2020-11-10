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
      SELECT Id, Account__r.Date_of_Birth__pc
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
}
