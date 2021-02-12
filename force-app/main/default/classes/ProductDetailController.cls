/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  returns the supplementary card holder details
 **/
public with sharing class ProductDetailController {
  /**
   * gets the credit and risk score ratings for applicants linked to opportunity
   * @param {Id} opportunity Id
   * @param {Integer} - ltv Loan to Value
   * @param {Integer} tdsrBefore
   * @param {String} repaymentMethod
   * @param {String} collateral
   * @return {RiskRatingWrapper}
   */
  @AuraEnabled
  public static RiskRatingWrapper getCreditRiskRating(
    Id oppId,
    Decimal ltv,
    Decimal tdsrBefore,
    String repaymentMethod,
    String collateral
  ) {
    try {
      RiskRatingWrapper wrapper = ProductDetailService.getRiskRatingWrapperV2(
        oppId,
        (Integer) ltv,
        (Integer) tdsrBefore,
        repaymentMethod,
        collateral
      );
      return wrapper;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }

  /**
   * Return a Product Selection Object consisting of an opportunity product name and family.
   * @param {Id} - oppId
   * @return Object
   */
  @AuraEnabled
  public static Object getSingleProductFamilySelection(Id oppId) {
    List<OpportunityLineItem> records = Util.getOpportunityProducts(oppId);
    if (records.size() == 1) {
      ProductSelectionWrapper selection = new ProductSelectionWrapper(
        records[0]
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
  public static Object getApplicantsRating(Id oppId, Decimal tenure) {
    List<ApplicantWrapper> applicants = ProductDetailSelector.getApplicantDetails(
      oppId
    );
    if (applicants.size() > 0) {
      applicants = getApplicantsCreditRating(applicants, tenure);
      return applicants;
    }
    return -1;
  }

  /**
   * return a map of wrapper records belonging to applicant and their assets/liabilities
   * @param {Id} oppId - opportunity Id.
   * @return {Map}
   */
  @AuraEnabled
  public static List<Object> getApplicantsAssetsAndLiabilities(Id oppId) {
    List<ApplicantWrapper> applicants = ProductDetailSelector.getApplicantDetails(
      oppId
    );
    List<Object> wrappers = new List<Object>();
    Map<String, Object> wrapperMap = new Map<String, Object>();
    for (ApplicantWrapper record : applicants) {
      if (record.applicationAssetLiabilities != null) {
        for (
          Application_Asset_Liability__c record2 : record.applicationAssetLiabilities
        ) {
          ApplicantAssetsAndLiabilitiesWrapper assetAndLiabilityWrapper = new ApplicantAssetsAndLiabilitiesWrapper(
            record2
          );
          wrappers.add(assetAndLiabilityWrapper);
        }
      }
      wrappers.add(record);
    }
    return wrappers;
  }

  /**
   * JN1-3969
   * return a map of wrapper records belonging to applicant and their assets/liabilities
   * @param {Id} oppId - opportunity Id.
   * @return {List<SupplementaryCardHolderWrapper>} - returns  supplementary card holder details in wrapper format
   */
  @AuraEnabled
  public static List<SupplementaryCardHolderWrapper> getSupplementaryCardHolders(
    Id oppId
  ) {
    try {
      List<SupplementaryCardHolderWrapper> supplementaryWrapperList = ProductDetailSelector.getSupplementaryCardHolder(
        oppId
      );
      return supplementaryWrapperList;
    } catch (Exception e) {
      throw new AuraHandledException(e.getStackTraceString());
    }
  }
  /** *
   * retrievesrisk rating matrix.
   * @return Map
   */
  @AuraEnabled
  public static Map<String, Decimal> getRiskRatingMap() {
    Map<String, Decimal> riskRatingMap = new Map<String, Decimal>();
    List<Risk_Rating_Factor__mdt> riskRatingFactors = [
      SELECT Risk_Rating_List__c, Score_Range_Number__c
      FROM Risk_Rating_Factor__mdt
    ];
    for (Risk_Rating_Factor__mdt record : riskRatingFactors) {
      riskRatingMap.put(
        record.Risk_Rating_List__c,
        record.Score_Range_Number__c
      );
    }
    return riskRatingMap;
  }
  /** *
   * JN1-4001
   * Saves product details information
   * @param {Id} opportunityId
   * @param {List<String>} productRecordTypes
   * @return {Integer}
   */
  @AuraEnabled
  public static Integer saveProductDetails(
    Id opportunityId,
    List<String> productRecordTypes,
    Map<String, Object> loanCalculationFields,
    Map<String, Object> loanCalculationProductFields
  ) {
    try {
      String loanCalculationFieldsString = JSON.serialize(
        loanCalculationFields
      );
      String loanCalculationProductFieldsString = JSON.serialize(
        loanCalculationProductFields
      );
      ProductDetailsSerializer loanCalculation = (ProductDetailsSerializer) JSON.deserializeStrict(
        loanCalculationFieldsString,
        ProductDetailsSerializer.class
      );
      ProductDetailsSerializer loanCalculationProduct = (ProductDetailsSerializer) JSON.deserializeStrict(
        loanCalculationProductFieldsString,
        ProductDetailsSerializer.class
      );
      LoanCalculationUnwrapper loanCalculationUnwrapper = new LoanCalculationUnwrapper(
        loanCalculation
      );
      Id loanCalculationId = loanCalculationUnwrapper.save(opportunityId);
      LoanCalculationProductUnwrapper loanCalculationProductUnwrapper = new LoanCalculationProductUnwrapper(
        loanCalculationProduct,
        productRecordTypes
      );
      loanCalculationProductUnwrapper.save(loanCalculationId);
      return Constants.STATUS_SUCCESS_CODE;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
