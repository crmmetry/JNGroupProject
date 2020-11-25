public class ProductDetailService {
    
    /*
    * Creates the personal Credit Score Map.
    * @return {Map<string, Personal_Credit_Score_Model__mdt>}
    */
    public  Map<String, List<Personal_Credit_Score_Model__mdt>> getPersonalCreditScoreMap() {
        List<personalCreditScoreMap> personalCreditScoreList = JNConfigurations.getPersonalCreditScore();
        Map<string, List<Personal_Credit_Score_Model__mdt>> personalCreditScoreMap = new Map<string, List<Personal_Credit_Score_Model__mdt>>();
        for(Personal_Credit_Score_Model__mdt personalCreditScore :personalCreditScoreList) {
            if(personalCreditScoreMap.containsKey(personalCreditScore.Type__c)) {
                personalCreditScoreMap.get(personalCreditScore.Type__c).add(personalCreditScore);
            }else{
                personalCreditScoreMap.put(personalCreditScore.Type__c, new List<Personal_Credit_Score_Model__mdt>{personalCreditScore});
            }
        }
        return personalCreditScoreMap;
    }    
    /*
    * Parse the age range according to the subcriteria option
    * @return {Map<string, Personal_Credit_Score_Model__mdt>}
    */
    public  string parseAgeRange(Integer age
                            , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		for(Personal_Credit_Score_Model__mdt creditScore :personalCreditScore) {
			if(isWithinBound(creditScore.Sub_Criteria_Option__c,age)) {
                return creditScore.Sub_Criteria_Option__c;
            }
		}
        return null;
    }

    /*
     * Get the Subcriteria option for years at residence field.
     * @param {Integer} fieldValue - actual value stored in field
     * @param {List<Personal_Credit_Score_Model__mdt>} personalCreditScore- list of custom metadata
     * @return {string} - return the value stored in subcriteria option of custom metadata
    */
	public  string parseNumberOfYearsAtResidence(Integer fieldValue
                                              , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Options__c!= null) {
                String years = personalCreditScoreModel.Sub_Criteria_Options__c.remove('years');
                System.debug(years);
                if(isWithinRange(fieldValue,years)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Options__c;
                    break;
                }
             } 
        }
        return subCriteriaOption;   
    }

     /*
     * Get the Subcriteria option for length of current employment field.
     * @param {Integer} fieldValue - actual value stored in field
     * @param {List<Personal_Credit_Score_Model__mdt>} personalCreditScore- list of custom metadata
     * @return {string} - return the value stored in subcriteria option of custom metadata
    */
    public  string parseLengthOfCurrentEmployment( Integer fieldValue
                                                , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Options__c!= null) {
                String years = personalCreditScoreModel.Sub_Criteria_Options__c.remove('years');
                if(isWithinRange(fieldValue,years)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Options__c;
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
    public  string parseLoanToValue( Integer fieldValue
                                  , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Options__c!= null) {
                String percentage = personalCreditScoreModel.Sub_Criteria_Options__c.remove('%');
                if(isWithinRange(fieldValue,percentage)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Options__c;
                    break;
                }
             }
        }
        return subCriteriaOption;      
     }

     /*
     * Get the Subcriteria option for ability to service field.
     * @param {Integer} fieldValue - actual value stored in field
     * @param {List<Personal_Credit_Score_Model__mdt>} personalCreditScore- list of custom metadata
     * @return {string} - return the value stored in subcriteria option of custom metadata
    */
    public  string parseAbilityToService( Integer fieldValue
                                       , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
        String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Options__c!= null) {
                String subStringAfter = personalCreditScoreModel.Sub_Criteria_Options__c.subStringAfter('(');
                subStringAfter = subStringAfter.subStringBefore(')');
                String percentage = subStringAfter.replaceAll('%','');
                if(isWithinRange(fieldValue,percentage.trim())) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Options__c;
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
    public  string parseLengthOfTrade( String fieldValue) {
        return getLengthOfTrade(fieldValue);  
    }

    /*
     * Get the Subcriteria option for length of trade field.
     * @param {Integer} fieldValue - actual value stored in field
     * @param {String} range - 
     * @return {boolean} - return boolean value to show if given value is within range or not
    */
    public  boolean isWithinRange(Integer fieldValue, String range) {
        Boolean flag = false;
        if((range.contains('>') && fieldValue > Integer.ValueOf(range.remove('>').trim()))) {
            flag = true;
        }else if((range.contains('-'))) {
            if(isWithinBound(range,fieldValue)) {
                flag = true;
            }
        }else {
            flag = true;
        }
        return flag;
    }

    /**
   * Splits range into an upper and a lower boundary.
   * @param {String} range - range of matrix record.
   * @return {void}
   */
    public  boolean isWithinBound(String range, integer fieldValue) {
        Boolean flag = false;
        if(range.contains('-')) {
            List<String> ranges = range.split('-');
            Integer lowerBound = Integer.valueOf(ranges[0].trim());
            Integer upperBound = Integer.valueOf(ranges[1].trim());
            if(fieldValue >= lowerBound && fieldValue <= upperBound) {
               flag = true; 
            }
        }
		return flag;
    }       
    
    /*
     * Get the Subcriteria option for length of trade field.
     * @param {String} fieldValue - actual value stored in field
     * @return {string} - return the value stored in subcriteria option of custom metadata
    */
    public  string getLengthOfTrade(String fieldValue) {
        String subCriteriaOption ;
        System.debug('fieldValue =>'+fieldValue);
        if(fieldValue.equalsIgnoreCase('Less than a 1 year')) {
            subCriteriaOption = '<1 year';
        }else if(fieldValue.equalsIgnoreCase('Between 1-3 years')){
            subCriteriaOption =  '1-3 years';
        }else if(fieldValue.equalsIgnoreCase('Between 3-5 years')) {
            subCriteriaOption = '3-5 years';
        }else {
            subCriteriaOption = '>5 years';
        }
        return subCriteriaOption;
    }
    /*
     * Get the formate of SubCriteriaOption.
     * @return {string}
    */
    public String getSubCriteriaOption(String fieldName, String fieldValue) {
        String subCriteriaOption;
        Map<String,List<Personal_Credit_Score_Model__mdt>> personalCreditModelMap = getPersonalCreditScoreMap();
        if(fieldName != null && fieldValue != null && personalCreditModelMap != null) {
            if(fieldName.equalsIgnoreCase(Constants.AGE)){
                if(personalCreditModelMap.containsKey(Constants.AGE)) {
                    subCriteriaOption = parseAgeRange(Integer.ValueOf(fieldValue),personalCreditModelMap.get(Constants.AGE)); 
                }else {
                    subCriteriaOption = fieldValue;
                }
            }else if(fieldName.equalsIgnoreCase(Constants.YEARS_AT_RESIDENCE)){
                if(personalCreditModelMap.containsKey(Constants.YEARS_AT_RESIDENCE)) {
                    subCriteriaOption = parseNumberOfYearsAtResidence(Integer.ValueOf(fieldValue),personalCreditModelMap.get(Constants.YEARS_AT_RESIDENCE)); 
                }else {
                    subCriteriaOption = fieldValue;
                } 
            }else if(fieldName.equalsIgnoreCase(Constants.LENGTH_OF_EMPLOYMENT)) {
                if(personalCreditModelMap.containsKey(Constants.LENGTH_OF_EMPLOYMENT)) {
                    subCriteriaOption = parseLengthOfCurrentEmployment(Integer.ValueOf(fieldValue),personalCreditModelMap.get(Constants.LENGTH_OF_EMPLOYMENT));
                }else {
                    subCriteriaOption = fieldValue;
                }  
            }else if(fieldName.equalsIgnoreCase(Constants.LOAN_TO_VALUE)) {
                if(personalCreditModelMap.containsKey(Constants.LOAN_TO_VALUE)) {
                    subCriteriaOption = parseLoanToValue(Integer.ValueOf(fieldValue),personalCreditModelMap.get(Constants.LOAN_TO_VALUE));
                }else{
                    subCriteriaOption = fieldValue;
                }  
            }else if(fieldName.equalsIgnoreCase(Constants.ABILITY_TO_SERVICE)) {
                if(personalCreditModelMap.containsKey(Constants.ABILITY_TO_SERVICE)) {
                    subCriteriaOption = parseAbilityToService (Integer.valueOf(fieldValue),personalCreditModelMap.get(Constants.ABILITY_TO_SERVICE));
                }else {
                    subCriteriaOption = fieldValue;
                } 
            }else if(fieldName.equalsIgnoreCase(Constants.LENGTH_OF_TRADE)) {
                if(personalCreditModelMap.containsKey(Constants.LENGTH_OF_TRADE)) {
                    subCriteriaOption = parseLengthOfTrade(fieldValue);
                }else{
                    subCriteriaOption = fieldValue;
                } 
            }else {
                subCriteriaOption = fieldValue;
            }
        }
    System.debug('subCriteriaOption == >+'+subCriteriaOption);
    return subCriteriaOption;
    }
    
    /*
     * Get the SubCriteriaOptionsWrapper.
     * @param {Id} oppId - opportunityId
     * @return {SubCriteriaOptionWrapper} - subcriteriaoptions wrapper with values
    */
    public static SubCriteriaOptionWrapper getSubcriteriaOptions(Id oppId){
        //SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper();
        OpportunityWrapper oppWrapper = ProductDetailSelector.getOpportunityDetails(oppId);
        AccountWrapper accWrapper = ProductDetailSelector.getAccount(oppWrapper.accountId);
        List<LoanCalculationsWrapper> loanCalculationsList = ProductDetailSelector.getLoanCalculations(oppId);
        EmploymentWrapper empWrapper = ProductDetailSelector.getEmployemntDetails(oppWrapper.accountId);
        List<ApplicantWrapper> applicantWrapper = ProductDetailSelector.getApplicantDetails(oppId);
        SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper(accWrapper
                                                                                  ,oppWrapper
                                                                                  ,loanCalculationsList[0]
                                                                                  ,empWrapper
                                                                                  ,applicantWrapper[0]);
        return subCriteriaOptions;
    }

    /*
     * Get the SubCriteriaOptionsWrapper.
     * @param {Id} oppId - opportunityId
     * @return {RiskRatingWrapper} - riskRatingWrapper wrapper having final rating
    */
    public static RiskRatingWrapper getRiskRatingWrapper(Id oppId){
        SubCriteriaOptionWrapper subCriteriaOptions = getSubcriteriaOptions(oppId);
        CreditScoreModelWrapper creditWrapper = new CreditScoreModelWrapper(subCriteriaOptions);
        RiskRatingWrapper riskRating = creditWrapper.riskRating;
        return riskRating;
    }
}