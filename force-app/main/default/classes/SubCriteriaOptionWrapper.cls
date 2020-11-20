public class SubCriteriaOptionWrapper {
    public Map<string, Personal_Credit_Score_Model__mdt> personalCreditScoreMap = getPersonalCreditScoreMap();
    public string subcriteria;
    public integer subcriteriaoption;
    public boolean isSalaried;
    public Integer riskscore;
    public decimal weight;
    
    public SubCriteriaOptionWrapper(string subcriteria,integer subcriteriaoption,boolean isSalaried) {
        this.subcriteria = subcriteria;
        this.isSalaried = isSalaried;
        this.subcriteriaoption = subcriteriaoption;
        this.riskscore = getRiskScore(subcriteria, subcriteriaoption, isSalaried);
        this.weight = getWeight(subcriteria);
    }
    
    public Integer getRiskScore(string subcriteria,integer subcriteriaoption,boolean isSalaried) {
        string key = subcriteria + ':' + subcriteriaoption;
        return isSalaried ? personalCreditScoreMap.get(key).Salaried_Score_Number__c : personalCreditScoreMap.get(key).Self_Employed_Score_Number__c;
    }
    
    public decimal getWeight(string subcriteria,integer subcriteriaoption) {
        string key = subcriteria + ':' + subcriteriaoption;
        return personalCreditScoreMap.get(key).Sub_Criteria_Weight_Numbr__c;
    }
    
    public Map<string, Personal_Credit_Score_Model__mdt> getPersonalCreditScoreMap() {
        Personal_Credit_Score_Model__mdt[] personalCreditScoreList = JNConfigurations.getPersonalCreditScore();
        Map<string, Personal_Credit_Score_Model__mdt> personalCreditScoreMap = new Map<string, Personal_Credit_Score_Model__mdt>();
        
        for(Personal_Credit_Score_Model__mdt personalCreditScore :personalCreditScoreList) {
            string key = personalCreditScore.label +':'+ personalCreditScore.Sub_Criteria_Option__c;
            personalCreditScoreMap.put(key, personalCreditScore);
        }
        
        return personalCreditScoreMap;
    }
}


