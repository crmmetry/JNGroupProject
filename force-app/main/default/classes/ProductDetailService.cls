public class ProductDetailService {
    
    /*
    * Creates the personal Credit Score Map.
    * @return {Map<string, Personal_Credit_Score_Model__mdt>}
    */
    public  Map<String, List<Personal_Credit_Score_Model__mdt>> getPersonalCreditScoreMap() {
        Personal_Credit_Score_Model__mdt[] personalCreditScoreList = JNConfigurations.getPersonalCreditScore();
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
    public  string parseAgeRange(Integer age
                            , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		for(Personal_Credit_Score_Model__mdt creditScore :personalCreditScore) {
			if(isWithinBound(creditScore.Sub_Criteria_Option__c,age)) {
                return creditScore.Sub_Criteria_Option__c;
            }
		}
        return null;
    }
	public  string parseNumberOfYearsAtResidence(Integer fieldValue
                                              , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Option__c!= null) {
                String years = personalCreditScoreModel.Sub_Criteria_Option__c.remove('years');
                if(isWithinRange(fieldValue,years)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Option__c;
                    break;
                }
             } 
        }
        return subCriteriaOption;   
    }
    public  string parseLengthOfCurrentEmployment( Integer fieldValue
                                                , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Option__c!= null) {
                String years = personalCreditScoreModel.Sub_Criteria_Option__c.remove('years');
                if(isWithinRange(fieldValue,years)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Option__c;
                    break;
                }
             }
        }
        return subCriteriaOption;      
    }
    public  string parseLoanToValue( Integer fieldValue
                                  , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
		String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Option__c!= null) {
                String percentage = personalCreditScoreModel.Sub_Criteria_Option__c.remove('%');
                if(isWithinRange(fieldValue,percentage)) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Option__c;
                    break;
                }
             }
        }
        return subCriteriaOption;      
     }
    public  string parseAbilityToService( Integer fieldValue
                                       , List<Personal_Credit_Score_Model__mdt> personalCreditScore) {
        String subCriteriaOption;
        for(Personal_Credit_Score_Model__mdt personalCreditScoreModel :personalCreditScore) {
            if(personalCreditScoreModel.Sub_Criteria_Option__c!= null) {
                String percentage = personalCreditScoreModel.Sub_Criteria_Option__c.replaceAll('TDSR()%','');
                if(isWithinRange(fieldValue,percentage.trim())) {
                    subCriteriaOption = personalCreditScoreModel.Sub_Criteria_Option__c;
                    break;  
                }
            }
        }
        return subCriteriaOption;      
    }
    public  string parseLengthOfTrade( String fieldValue) {
        return getLengthOfTrade(fieldValue);  
    }
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
        return false;
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
            Integer lowerBound = Integer.valueOf(ranges[0]);
            Integer upperBound = Integer.valueOf(ranges[1]);
            if(fieldValue >= lowerBound && fieldValue <= upperBound) {
               flag = true; 
            }
        }
		return flag;
    }       
    

    public  string getLengthOfTrade(String fieldValue) {
        String subCriteriaOption ;
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
            if(fieldName.equalsIgnoreCase('Age')){
                if(personalCreditModelMap.containsKey('Age')) {
                    subCriteriaOption = parseAgeRange(Integer.ValueOf(fieldValue),personalCreditModelMap.get('Age')); 
                }else {
                    subCriteriaOption = fieldValue;
                }
            }else if(fieldName.equalsIgnoreCase('Years at Current Residence')){
                if(personalCreditModelMap.containsKey('Years at Current Residence')) {
                    subCriteriaOption = parseNumberOfYearsAtResidence(Integer.ValueOf(fieldValue),personalCreditModelMap.get('Age')); 
                }else {
                    subCriteriaOption = fieldValue;
                } 
            }else if(fieldName.equalsIgnoreCase('Length of Current Employment')) {
                if(personalCreditModelMap.containsKey('Length of Current Employment')) {
                    subCriteriaOption = parseLengthOfCurrentEmployment(Integer.ValueOf(fieldValue),personalCreditModelMap.get('Length of Current Employment'));
                }else {
                    subCriteriaOption = fieldValue;
                }  
            }else if(fieldName.equalsIgnoreCase('Loan to Value CC/Loan to Value LOC')) {
                if(personalCreditModelMap.containsKey('Loan to Value CC/Loan to Value LOC')) {
                    subCriteriaOption = parseLoanToValue(Integer.ValueOf(fieldValue),personalCreditModelMap.get('Length of Current Employment'));
                }else{
                    subCriteriaOption = fieldValue;
                }  
            }else if(fieldName.equalsIgnoreCase('Ability to Service CC/Ability to Service LOC')) {
                if(personalCreditModelMap.containsKey('Ability to Service CC/Ability to Service LOC')) {
                    subCriteriaOption = parseAbilityToService (Integer.ValueOf(fieldValue),personalCreditModelMap.get('Length of Current Employment'));
                }else {
                    subCriteriaOption = fieldValue;
                } 
            }else if(fieldName.equalsIgnoreCase('Length of Trade')) {
                if(personalCreditModelMap.containsKey('Length of Trade')) {
                    subCriteriaOption = parseLengthOfTrade(fieldValue);
                }else{
                    subCriteriaOption = fieldValue;
                } 
            }else {
                subCriteriaOption = fieldValue;
            }
        }
    return subCriteriaOption;
    }
    /*public static SubCriteriaOptionWrapper getSubcriteriaOptions(Id oppId){
        //SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper();
        OpportunityWrapper oppWrapper = ProductDetailSelector.getOpportunityDetails(oppId);
        AccountWrapper accWrapper = ProductDetailSelector.getAccount(oppWrapper.accountId);
        List<LoanCalculationsWrapper> loanCalculationsList = ProductDetailSelector.getLoanCalculations(oppId);
        EmploymentWrapper empWrapper = ProductDetailSelector.getEmployemntDetails(oppId);
        List<ApplicantWrapper> applicantWrapper = ProductDetailSelector.getApplicantDetails(oppId);
        SubCriteriaOptionWrapper subCriteriaOptions = new SubCriteriaOptionWrapper(accWrapper
                                                                                  ,oppWrapper,loanCalculationsList[0],
        empWrapper,applicantWrapper);
        return subCriteriaOptions;
    }*/
}