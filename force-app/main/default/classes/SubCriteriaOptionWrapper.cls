/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Kirti R.(thinqloud)   Wrapper class of Personal_Credit_Score_Model__mdt  
**/
public class SubCriteriaOptionWrapper {
    
    public Map<string, Personal_Credit_Score_Model__mdt> personalCreditScoreMap = getPersonalCreditScoreMap();
    @AuraEnabled
    public string subCriteria;
    @AuraEnabled
    public string subCriteriaOption;
    @AuraEnabled
    public boolean isSalaried;
    @AuraEnabled
    public decimal riskScore;
    @AuraEnabled
    public decimal weight;
    /**
     * Represents subCriteriaOptions of personal credit score model.
     * @constructor
     * @param {string} subCriteria - sub criteria of personal credit score model
     * @param {string} subcriteriaOption - sub criteria options of personal credit score model
     * @param {boolean} isSalaried - employement type of personal credit score model
    */  
    public subCriteriaOptionWrapper(string subCriteria,string subCriteriaOption,boolean isSalaried) {
        this.subCriteria = subCriteria;
        this.isSalaried = isSalaried;
        this.subCriteriaOption = subCriteria == 'Age' ? getSubCriteriaOption(subCriteria) : subCriteriaOption;
        this.riskScore = getRiskScore(subCriteria, subCriteriaOption, isSalaried);
        this.weight = getWeight(subCriteria,subCriteriaOption);
    }
    /**
     * Gets the risk score.
     * @param {string} subCriteria - sub criteria of personal credit score model
     * @param {string} subcriteriaOption - sub criteria options of personal credit score model
     * @param {boolean} isSalaried - employement type of personal credit score model
	 * @return {decimal}
    */
    public decimal getRiskScore(string subCriteria,String subCriteriaOption,boolean isSalaried) {
        string key = subCriteria + ':' + subCriteriaOption;
        return isSalaried ? personalCreditScoreMap.get(key).Salaried_Score_Number__c : personalCreditScoreMap.get(key).Self_Employed_Score_Number__c;
    }
    /**
     * Gets the weight.
     * @param   {string} subCriteria - sub criteria of personal credit score model
     * @param  {string} subcriteriaOption - sub criteria options of personal credit score model
     * @return {decimal} returns the sub criteria weight number 
    */
    public decimal getWeight(string subCriteria,String subCriteriaOption) {
        string key = subCriteria + ':' + subCriteriaOption;
        return personalCreditScoreMap.get(key).Sub_Criteria_Weight_Numbr__c;
    }
    /*
     *Creates the personal Credit Score Map.
     * @return {Map<string, Personal_Credit_Score_Model__mdt>}
    */
    public Map<string, Personal_Credit_Score_Model__mdt> getPersonalCreditScoreMap() {
        Personal_Credit_Score_Model__mdt[] personalCreditScoreList = JNConfigurations.getPersonalCreditScore();
        Map<string, Personal_Credit_Score_Model__mdt> personalCreditScoreMap = new Map<string, Personal_Credit_Score_Model__mdt>();
        
        for(Personal_Credit_Score_Model__mdt personalCreditScore :personalCreditScoreList) {
            string key = personalCreditScore.type__c +':'+ personalCreditScore.Sub_Criteria_Option__c;
            personalCreditScoreMap.put(key, personalCreditScore);
        }
        
        return personalCreditScoreMap;
    }
    /*
     * Get the formate of SubCriteriaOption.
     * @return {void}
    */
    public String getSubCriteriaOption(String age) {
        String subCriteriaOption;
        for(String key :personalCreditScoreMap.keySet()) {
            List<String> ranges = personalCreditScoreMap.get(key) != null ? personalCreditScoreMap.get(key).Sub_Criteria_Option__c.split('-') : null;
            if(ranges == null) {
                this.subCriteriaOption = null;
            }
            if(Integer.valueOf(ranges[0]) <= Integer.ValueOf(age) 
                || Integer.valueOf(ranges[0]) >= Integer.ValueOf(age)) {
                    subCriteriaOption = personalCreditScoreMap.get(key).Sub_Criteria_Option__c;
            }
        }
        return subCriteriaOption;
    }      
}