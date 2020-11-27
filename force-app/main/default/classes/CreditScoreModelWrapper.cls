/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Calculates the Risk rating score
 **/
public class CreditScoreModelWrapper {
  @AuraEnabled
  public SubCriteriaOptionWrapper subCriteriaOption;
  @AuraEnabled
  public Decimal finalScore;
  @AuraEnabled
  public Boolean isSalaried;
  @AuraEnabled
  public RiskRatingWrapper riskRating;
  @AuraEnabled
  public Map<String, List<PersonalCreditScoreModelWrapper>> personalCreditScoreMap;
  @AuraEnabled
  public ProductDetailService psd;

  /**
   * Constructor of the class
   * Initializes all the values
   * @param {SubCriteriaOptionWrapper} subCriteriaOption - instance of subcriteriaoptionswrapper class
   */
  public creditScoreModelWrapper(SubCriteriaOptionWrapper subCriteriaOption) {
    psd = new ProductDetailService();
    personalCreditScoreMap = psd.getPersonalCreditScoreMap();
    this.subCriteriaOption = subCriteriaOption;
    this.isSalaried = subCriteriaOption.employmentType == Constants.EMPLOYED
      ? true
      : false;
    finalScore = getRiskScore(this.subCriteriaOption);
    riskRating = getRiskRating();
  }

  /**
   * Function to oveall the risk score
   * @param {SubCriteriaOptionWrapper} subCriteriaOption - instance of subcriteriaoptionswrapper class
   * @return {Decimal} - return the final calculated score
   */
  public Decimal getRiskScore(SubCriteriaOptionWrapper subCriteriaOption) {
    Decimal finalScore = 0;
    if (subCriteriaOption.age != null) {
      finalScore = calculateScore(
        personalCreditScoreMap.get(Constants.AGE),
        psd.getSubCriteriaOption(
          Constants.AGE,
          String.valueOf(subCriteriaOption.age)
        )
      );
    }
    if (subCriteriaOption.residentialStatus != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.STATUS_OF_ADDRESS),
        psd.getSubCriteriaOption(
          Constants.STATUS_OF_ADDRESS,
          subCriteriaOption.residentialStatus
        )
      );
    }
    if (subCriteriaOption.yearsAtCurrentResidence != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.YEARS_AT_RESIDENCE),
        psd.getSubCriteriaOption(
          Constants.YEARS_AT_RESIDENCE,
          String.valueOf(subCriteriaOption.yearsAtCurrentResidence)
        )
      );
    }
    if (subCriteriaOption.creditHistory != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.CREDIT_HISTORY),
        psd.getSubCriteriaOption(
          Constants.CREDIT_HISTORY,
          subCriteriaOption.creditHistory
        )
      );
    }
    if (subCriteriaOption.netWorth != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.NET_WORTH),
        psd.getSubCriteriaOption(
          Constants.NET_WORTH,
          subCriteriaOption.netWorth
        )
      );
    }
    if (subCriteriaOption.employmentStatus != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.EMPLOYMENT_STATUS),
        psd.getSubCriteriaOption(
          Constants.EMPLOYMENT_STATUS,
          subCriteriaOption.employmentStatus
        )
      );
    }
    if (subCriteriaOption.industryOfEmployment != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.INDUSTRY),
        psd.getSubCriteriaOption(
          Constants.INDUSTRY,
          subCriteriaOption.industryOfEmployment
        )
      );
    }
    if (subCriteriaOption.lengthOfCurrentEmployment != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.LENGTH_OF_EMPLOYMENT),
        psd.getSubCriteriaOption(
          Constants.LENGTH_OF_EMPLOYMENT,
          String.valueOf(subCriteriaOption.lengthOfCurrentEmployment)
        )
      );
    }
    if (subCriteriaOption.professionalCategory != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.PROFESSIONAL_CATEGORY),
        psd.getSubCriteriaOption(
          Constants.PROFESSIONAL_CATEGORY,
          subCriteriaOption.professionalCategory
        )
      );
    }
    if (subCriteriaOption.natureOfEngagement != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.NATURE_OF_ENGAGEMENT),
        psd.getSubCriteriaOption(
          Constants.NATURE_OF_ENGAGEMENT,
          subCriteriaOption.natureOfEngagement
        )
      );
    }
    if (subCriteriaOption.typeOfIndustry != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.INDUSTRY),
        psd.getSubCriteriaOption(
          Constants.INDUSTRY,
          subCriteriaOption.typeOfIndustry
        )
      );
    }
    if (subCriteriaOption.financialPerformance != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.FINANCIAL_PERFORMANCE),
        psd.getSubCriteriaOption(
          Constants.FINANCIAL_PERFORMANCE,
          subCriteriaOption.financialPerformance
        )
      );
    }
    if (subCriteriaOption.financialStatementSupport != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.FINACIAL_STATEMENT),
        psd.getSubCriteriaOption(
          Constants.FINACIAL_STATEMENT,
          subCriteriaOption.financialStatementSupport
        )
      );
    }
    if (subCriteriaOption.lengthOfTrade != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.LENGTH_OF_TRADE),
        psd.getSubCriteriaOption(
          Constants.LENGTH_OF_TRADE,
          subCriteriaOption.lengthOfTrade
        )
      );
    }
    if (subCriteriaOption.collateral != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.COLLATERAL),
        psd.getSubCriteriaOption(
          Constants.COLLATERAL,
          subCriteriaOption.collateral
        )
      );
    }
    if (subCriteriaOption.loanToValue != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.LOAN_TO_VALUE),
        psd.getSubCriteriaOption(
          Constants.LOAN_TO_VALUE,
          String.valueOf(subCriteriaOption.loanToValue)
        )
      );
    }
    if (subCriteriaOption.ablitityToService != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.ABILITY_TO_SERVICE),
        psd.getSubCriteriaOption(
          Constants.ABILITY_TO_SERVICE,
          String.valueOf(subCriteriaOption.ablitityToService)
        )
      );
    }
    if (subCriteriaOption.repaymentMethod != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.REPAYMENT_METHOD),
        psd.getSubCriteriaOption(
          Constants.REPAYMENT_METHOD,
          subCriteriaOption.repaymentMethod
        )
      );
    }
    if (subCriteriaOption.workingCapital != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.WORKING_CAPITA),
        psd.getSubCriteriaOption(
          Constants.WORKING_CAPITA,
          subCriteriaOption.workingCapital
        )
      );
    }
    if (subCriteriaOption.education != null) {
      finalScore += calculateScore(
        personalCreditScoreMap.get(Constants.EDUCATION),
        psd.getSubCriteriaOption(
          Constants.EDUCATION,
          subCriteriaOption.education
        )
      );
    }
    return finalScore;
  }

  /**
   * Function to calculate the risk score for each fields value
   * @param {List<PersonalCreditScoreModelWrapper>} creditScoreModelList - list of personal credit score model record of same type
   * @param {String} subCriteriaOption - sub criteria option mentioned in the custom metadata
   * @return {Decimal} - return the calculated score each field
   */
  public Decimal calculateScore(
    List<PersonalCreditScoreModelWrapper> creditScoreModelList,
    String subCriteriaOption
  ) {
    Decimal score = 0;
    for (PersonalCreditScoreModelWrapper creditScore : creditScoreModelList) {
      if (
        (creditScore.subCriteriaOption != null &&
        creditScore.subCriteriaOption.equalsIgnoreCase(subCriteriaOption)) ||
        (creditScore.subCriteriaOptions != null &&
        creditScore.subCriteriaOptions.equalsIgnoreCase(subCriteriaOption))
      ) {
        score = getScore(isSalaried, creditScore);
      }
    }
    return score;
  }

  private Decimal getScore(
    Boolean isSalaried,
    PersonalCreditScoreModelWrapper creditModelWrapper
  ) {
    Decimal score;
    if (isSalaried) {
      score = creditModelWrapper.salariedScore != null
        ? creditModelWrapper.salariedScore
        : 0;
    } else {
      score = creditModelWrapper.selfEmployedScore != null
        ? creditModelWrapper.selfEmployedScore
        : 0;
    }
    return score * creditModelWrapper.subCriteriaWeight / 100;
  }

  /*
   * to get the risk rating
   * @return {RiskRatingWrapper}
   */
  public RiskRatingWrapper getRiskRating() {
    RiskRatingWrapper riskRating = new RiskRatingWrapper(finalScore);
    return riskRating;
  }
}
