public class ProductDetailService {
  /*
   * Creates the personal Credit Score Map.
   * @return {Map<string, Personal_Credit_Score_Model__mdt>}
   */
  public Map<String, List<PersonalCreditScoreModelWrapper>> getPersonalCreditScoreMap() {
    List<PersonalCreditScoreModelWrapper> personalCreditScoreWrapperList = JNConfigurations.getPersonalCreditScore();
    Map<string, List<PersonalCreditScoreModelWrapper>> personalCreditScoreMap = new Map<string, List<PersonalCreditScoreModelWrapper>>();
    for (
      PersonalCreditScoreModelWrapper personalCreditScore : personalCreditScoreWrapperList
    ) {
      if (personalCreditScoreMap.containsKey(personalCreditScore.type)) {
        personalCreditScoreMap.get(personalCreditScore.type)
          .add(personalCreditScore);
      } else {
        personalCreditScoreMap.put(
          personalCreditScore.type,
          new List<PersonalCreditScoreModelWrapper>{ personalCreditScore }
        );
      }
    }
    return personalCreditScoreMap;
  }
  /*
   * Parse the age range according to the subcriteria option
   * @return {Map<string, Personal_Credit_Score_Model__mdt>}
   */
  public string parseAgeRange(
    Integer age,
    List<PersonalCreditScoreModelWrapper> personalCreditScore
  ) {
    for (PersonalCreditScoreModelWrapper creditScore : personalCreditScore) {
      if (isWithinBound(creditScore.subCriteriaOption, age)) {
        return creditScore.subCriteriaOption;
      }
    }
    return null;
  }

  /*
   * Get the Subcriteria option for years at residence field.
   * @param {Integer} fieldValue - actual value stored in field
   * @param {List<PersonalCreditScoreModelWrapper>} personalCreditScore- list of custom metadata
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseNumberOfYearsAtResidence(
    Integer fieldValue,
    List<PersonalCreditScoreModelWrapper> personalCreditScore
  ) {
    String subCriteriaOption;
    for (
      PersonalCreditScoreModelWrapper personalCreditScoreModel : personalCreditScore
    ) {
      if (personalCreditScoreModel.subCriteriaOptions != null) {
        String years = personalCreditScoreModel.subCriteriaOptions.contains(
            Constants.YEARS
          )
          ? personalCreditScoreModel.subCriteriaOptions.remove(Constants.YEARS)
          : personalCreditScoreModel.subCriteriaOptions.remove(Constants.YEAR);
        if (isWithinRange(fieldValue, years)) {
          subCriteriaOption = personalCreditScoreModel.subCriteriaOptions;
          break;
        }
      }
    }
    return subCriteriaOption;
  }

  /*
   * Get the Subcriteria option for length of current employment field.
   * @param {Integer} fieldValue - actual value stored in field
   * @param {List<PersonalCreditScoreModelWrapper>} personalCreditScore- list of custom metadata
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseLengthOfCurrentEmployment(
    Integer fieldValue,
    List<PersonalCreditScoreModelWrapper> personalCreditScore
  ) {
    String subCriteriaOption;
    for (
      PersonalCreditScoreModelWrapper personalCreditScoreModel : personalCreditScore
    ) {
      if (personalCreditScoreModel.subCriteriaOptions != null) {
        String years = personalCreditScoreModel.subCriteriaOptions.contains(
            Constants.YEARS
          )
          ? personalCreditScoreModel.subCriteriaOptions.remove(Constants.YEARS)
          : personalCreditScoreModel.subCriteriaOptions.remove(Constants.YEAR);
        if (isWithinRange(fieldValue, years)) {
          subCriteriaOption = personalCreditScoreModel.subCriteriaOptions;
          break;
        }
      }
    }
    return subCriteriaOption;
  }

  /*
   * Get the Subcriteria option for loan to value field.
   * @param {Integer} fieldValue - actual value stored in field
   * @param {List<Personal_Credit_Score_Model__mdt>} personalCreditScore- list of custom metadata
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseLoanToValue(
    Integer fieldValue,
    List<PersonalCreditScoreModelWrapper> personalCreditScore
  ) {
    String subCriteriaOption;
    for (
      PersonalCreditScoreModelWrapper personalCreditScoreModel : personalCreditScore
    ) {
      if (personalCreditScoreModel.subCriteriaOptions != null) {
        String percentage = personalCreditScoreModel.subCriteriaOptions.remove(
          '%'
        );
        if (isWithinRange(fieldValue, percentage)) {
          subCriteriaOption = personalCreditScoreModel.subCriteriaOptions;
          break;
        }
      }
    }
    return subCriteriaOption;
  }

  /*
   * Get the Subcriteria option for ability to service field.
   * @param {Integer} fieldValue - actual value stored in field
   * @param {List<PersonalCreditScoreModelWrapper>} personalCreditScore- list of custom metadata
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseAbilityToService(
    Integer fieldValue,
    List<PersonalCreditScoreModelWrapper> personalCreditScore
  ) {
    String subCriteriaOption;
    for (
      PersonalCreditScoreModelWrapper personalCreditScoreModel : personalCreditScore
    ) {
      if (personalCreditScoreModel.subCriteriaOptions != null) {
        String subStringAfter = personalCreditScoreModel.subCriteriaOptions.subStringAfter(
          '('
        );
        subStringAfter = subStringAfter.subStringBefore(')');
        String percentage = subStringAfter.replaceAll('%', '');
        if (isWithinRange(fieldValue, percentage.trim())) {
          subCriteriaOption = personalCreditScoreModel.subCriteriaOptions;
          break;
        }
      }
    }
    return subCriteriaOption;
  }
  /*
   * Get the Subcriteria option for length of trade field.
   * @param {String} fieldValue - actual value stored in field
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseLengthOfTrade(String fieldValue) {
    return getLengthOfTrade(fieldValue);
  }

  /*
   * Get the Subcriteria option for length of trade field.
   * @param {Integer} fieldValue - actual value stored in field
   * @param {String} range -
   * @return {boolean} - return boolean value to show if given value is within range or not
   */
  public boolean isWithinRange(Integer fieldValue, String range) {
    Boolean flag = false;
    if (range.contains('>')) {
      if (fieldValue > Integer.ValueOf(range.remove('>').trim())) {
        flag = true;
      }
    } else if ((range.contains('-'))) {
      if (isWithinBound(range, fieldValue)) {
        flag = true;
      }
    } else {
      if (fieldValue < Integer.ValueOf(range.remove('<').trim())) {
        flag = true;
      }
    }
    return flag;
  }

  /**
   * Splits range into an upper and a lower boundary.
   * @param {String} range - range of matrix record.
   * @return {void}
   */
  public boolean isWithinBound(String range, integer fieldValue) {
    Boolean flag = false;
    if (range.contains('-')) {
      List<String> ranges = range.split('-');
      Integer lowerBound = Integer.valueOf(ranges[0].trim());
      Integer upperBound = Integer.valueOf(ranges[1].trim());
      if (fieldValue >= lowerBound && fieldValue <= upperBound) {
        flag = true;
      }
    }
    return flag;
  }
  /*
   * Get the Subcriteria option for education.
   * @param {String} fieldValue - actual value stored in field
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string parseEducation(String fieldValue) {
    String subCriteriaOption;
    if (fieldValue.contains(Constants.POST_GRADUATE)) {
      subCriteriaOption = Constants.POST_GRADUATE;
    } else if (fieldValue.contains(Constants.UNDERGRADUATE_GRADUATE)) {
      subCriteriaOption = Constants.UNDERGRADUATE_GRADUATE;
    } else if (fieldValue.contains(Constants.VOCATIONAL)) {
      subCriteriaOption = Constants.VOCATIONAL;
    } else {
      subCriteriaOption = fieldValue;
    }
    return subCriteriaOption;
  }

  /*
   * Get the Subcriteria option for length of trade field.
   * @param {String} fieldValue - actual value stored in field
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string getLengthOfTrade(String fieldValue) {
    String subCriteriaOption;
    if (fieldValue.equalsIgnoreCase(Constants.LESS_THAN_YEAR)) {
      subCriteriaOption = Constants.LT_1_YEAR;
    } else if (fieldValue.equalsIgnoreCase(Constants.BETWEEN_1_3_YEARS)) {
      subCriteriaOption = Constants.ONE_TO_THREE_YEARS;
    } else if (fieldValue.equalsIgnoreCase(Constants.BETWEEN_3_5_YEARS)) {
      subCriteriaOption = Constants.THREE_TO_FIVE_YEARS;
    } else {
      subCriteriaOption = Constants.GT_5_YEARS;
    }
    return subCriteriaOption;
  }

  /*
   * Get the Subcriteria option for length of trade field.
   * @param {String} fieldValue - actual value stored in field
   * @return {string} - return the value stored in subcriteria option of custom metadata
   */
  public string getFinacialPerformance(String fieldValue) {
    String subCriteriaOption;
    if (fieldValue.equalsIgnoreCase(Constants.THREE_TO_FOUR_YEARS)) {
      subCriteriaOption = Constants.THREE_TO_FOUR_YEARS_AND_OR;
    } else if (fieldValue.equalsIgnoreCase(Constants.UP_TO_TWO_YEARS)) {
      subCriteriaOption = Constants.UP_TO_TWO_YEARS_AND_OR;
    } else if (fieldValue.equalsIgnoreCase(Constants.INCONSISTANT)) {
      subCriteriaOption = Constants.INCONSISTANT_AND_OR;
    } else if (fieldValue.equalsIgnoreCase(Constants.INADEQUATE)) {
      subCriteriaOption = Constants.INADEQUATE_AND_OR;
    }
    return subCriteriaOption;
  }

  /*
   * Get the formate of SubCriteriaOption.
   * @return {string}
   */
  public String getSubCriteriaOption(String fieldName, String fieldValue) {
    String subCriteriaOption;
    Map<String, List<PersonalCreditScoreModelWrapper>> personalCreditModelMap = getPersonalCreditScoreMap();
    if (
      fieldName != null &&
      fieldValue != null &&
      personalCreditModelMap != null
    ) {
      if (fieldName.equalsIgnoreCase(Constants.AGE)) {
        if (personalCreditModelMap.containsKey(Constants.AGE)) {
          subCriteriaOption = parseAgeRange(
            Integer.ValueOf(fieldValue),
            personalCreditModelMap.get(Constants.AGE)
          );
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.YEARS_AT_RESIDENCE)) {
        if (personalCreditModelMap.containsKey(Constants.YEARS_AT_RESIDENCE)) {
          subCriteriaOption = parseNumberOfYearsAtResidence(
            Integer.ValueOf(fieldValue),
            personalCreditModelMap.get(Constants.YEARS_AT_RESIDENCE)
          );
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.LENGTH_OF_EMPLOYMENT)) {
        if (
          personalCreditModelMap.containsKey(Constants.LENGTH_OF_EMPLOYMENT)
        ) {
          subCriteriaOption = parseLengthOfCurrentEmployment(
            Integer.ValueOf(fieldValue),
            personalCreditModelMap.get(Constants.LENGTH_OF_EMPLOYMENT)
          );
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.LOAN_TO_VALUE)) {
        if (personalCreditModelMap.containsKey(Constants.LOAN_TO_VALUE)) {
          subCriteriaOption = parseLoanToValue(
            Integer.ValueOf(fieldValue),
            personalCreditModelMap.get(Constants.LOAN_TO_VALUE)
          );
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.ABILITY_TO_SERVICE)) {
        if (personalCreditModelMap.containsKey(Constants.ABILITY_TO_SERVICE)) {
          subCriteriaOption = parseAbilityToService(
            Integer.valueOf(fieldValue),
            personalCreditModelMap.get(Constants.ABILITY_TO_SERVICE)
          );
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.LENGTH_OF_TRADE)) {
        if (personalCreditModelMap.containsKey(Constants.LENGTH_OF_TRADE)) {
          subCriteriaOption = parseLengthOfTrade(fieldValue);
        } else {
          subCriteriaOption = fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.STATUS_OF_ADDRESS)) {
        if (personalCreditModelMap.containsKey(Constants.STATUS_OF_ADDRESS)) {
          subCriteriaOption = fieldValue.contains(Constants.OWN)
            ? Constants.OWN
            : fieldValue;
        }
      } else if (fieldName.equalsIgnoreCase(Constants.EDUCATION)) {
        if (personalCreditModelMap.containsKey(Constants.EDUCATION)) {
          subCriteriaOption = parseEducation(fieldValue);
        }
      } else if (fieldName.equalsIgnoreCase(Constants.FINANCIAL_PERFORMANCE)) {
        if (personalCreditModelMap.containsKey(Constants.FINANCIAL_PERFORMANCE)) {
          subCriteriaOption = getFinacialPerformance(fieldValue);
        }
      } else {
        subCriteriaOption = fieldValue;
      }
    }
    return subCriteriaOption;
  }
  /** *
   * Get the SubCriteriaOptionsWrapper.
   * @param {Id} oppId - opportunityId
   * @param {Integer} ltv
   * @param {Integer} tdsr
   * @param {String} repaymentMethod
   * @param {String} collateral
   * @return {SubCriteriaOptionWrapper} - subcriteriaoptions wrapper with values
   */
  public static SubCriteriaOptionWrapper getSubcriteriaOptionsV2(
    Id oppId,
    Integer ltv,
    Integer tdsr,
    String repaymentMethod,
    String collateral
  ) {
    //TODO: VALUES ARE PASSED FROM THE PRODUCT DETAIL AURA COMPONENT CURRENTLY
    OpportunityWrapper oppWrapper = ProductDetailSelector.getOpportunityDetails(
      oppId
    );
    oppWrapper.loanToValueCC = ltv;
    oppWrapper.collateralCC = collateral;
    AccountWrapper accWrapper = ProductDetailSelector.getAccount(
      oppWrapper.accountId
    );
    /* List<LoanCalculationsWrapper> loanCalculationsList = ProductDetailSelector.getLoanCalculations(
      oppId
    );
    //TODO: VALUES ARE PASSED FROM THE PRODUCT DETAIL AURA COMPONENT CURRENTLY
    LoanCalculationsWrapper loanCalculatins = loanCalculationsList.size() > 0
      ? loanCalculationsList[0]
      : null;
      */
    LoanCalculationsWrapper loanCalWrapper = new LoanCalculationsWrapper();
    loanCalWrapper.repaymentMethod = repaymentMethod;
    loanCalWrapper.abilityToServiceCC = tdsr;
    EmploymentWrapper empWrapper = ProductDetailSelector.getEmployemntDetails(
      oppWrapper.accountId
    );
    List<ApplicantWrapper> applicantWrapper = ProductDetailSelector.getApplicantDetails(
      oppId
    );
    ApplicantWrapper applicant = applicantWrapper.size() > 0
      ? applicantWrapper[0]
      : null;
    SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper(
      accWrapper,
      oppWrapper,
      loanCalWrapper,
      empWrapper,
      applicant
    );
    System.debug('SubCriteriaOptionWrapper = ' + subCriteriaOptions);
    return subCriteriaOptions;
  }
  /** *
   * Get the SubCriteriaOptionsWrapper.
   * @param {Id} oppId - opportunityId
   * @return {SubCriteriaOptionWrapper} - subcriteriaoptions wrapper with values
   */
  public static SubCriteriaOptionWrapper getSubcriteriaOptions(Id oppId) {
    OpportunityWrapper oppWrapper = ProductDetailSelector.getOpportunityDetails(
      oppId
    );
    AccountWrapper accWrapper = ProductDetailSelector.getAccount(
      oppWrapper.accountId
    );
    List<LoanCalculationsWrapper> loanCalculationsList = ProductDetailSelector.getLoanCalculations(
      oppId
    );
    LoanCalculationsWrapper loanCalculatins = loanCalculationsList.size() > 0
      ? loanCalculationsList[0]
      : null;
    EmploymentWrapper empWrapper = ProductDetailSelector.getEmployemntDetails(
      oppWrapper.accountId
    );
    List<ApplicantWrapper> applicantWrapper = ProductDetailSelector.getApplicantDetails(
      oppId
    );
    ApplicantWrapper applicant = applicantWrapper.size() > 0
      ? applicantWrapper[0]
      : null;
    SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper(
      accWrapper,
      oppWrapper,
      loanCalculatins,
      empWrapper,
      applicant
    );
    return subCriteriaOptions;
  }

  /*
   * Get the SubCriteriaOptionsWrapper.
   * @param {Id} oppId - opportunityId
   * @return {RiskRatingWrapper} - riskRatingWrapper wrapper having final rating
   */
  public static RiskRatingWrapper getRiskRatingWrapper(Id oppId) {
    SubCriteriaOptionWrapper subCriteriaOptions = getSubcriteriaOptions(oppId);
    CreditScoreModelWrapper creditWrapper = new CreditScoreModelWrapper(
      subCriteriaOptions
    );
    RiskRatingWrapper riskRating = creditWrapper.riskRating;
    return riskRating;
  }
  /** *
   * Get the SubCriteriaOptionsWrapper.
   * @param {Id} oppId - opportunityId
   * @param {Integer} ltv
   * @param {Integer} tdsr
   * @param {String} repaymentMethod
   * @param {String} collateral
   * @return {RiskRatingWrapper} - riskRatingWrapper wrapper having final rating
   */
  public static RiskRatingWrapper getRiskRatingWrapperV2(
    Id oppId,
    Integer ltv,
    Integer tdsr,
    String repaymentMethod,
    String collateral
  ) {
    SubCriteriaOptionWrapper subCriteriaOptions = getSubcriteriaOptionsV2(
      oppId,
      ltv,
      tdsr,
      repaymentMethod,
      collateral
    );
    CreditScoreModelWrapper creditWrapper = new CreditScoreModelWrapper(
      subCriteriaOptions
    );
    RiskRatingWrapper riskRating = creditWrapper.riskRating;
    return riskRating;
  }
}