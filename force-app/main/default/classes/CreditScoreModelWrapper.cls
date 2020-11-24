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
    public Map<String, List<Personal_Credit_Score_Model__mdt>>  personalCreditScoreMap = getPersonalCreditScoreMap();
    @AuraEnabled
    public ProductDetailService psd ;
    
    /**
   * Constructor of the class
   * Initializes all the values
   */
    public creditScoreModelWrapper(SubCriteriaOptionWrapper subCriteriaOption) {
        psd = new ProductDetailService();
        this.subCriteriaOption =  subCriteriaOption;
        this.isSalaried = subCriteriaOption.employmentType == 'Employed' ? true : false;
        finalScore = getRiskScore(this.subCriteriaOption);
        riskRating = getRiskRating();
    }


    public Decimal getRiskScore(SubCriteriaOptionWrapper subCriteriaOption){
        Decimal finalScore=0;
        if(subCriteriaOption.age != NULL){
            finalScore = calculateScore(personalCreditScoreMap.get('Age'),psd.getSubCriteriaOption('Age',String.valueOf(subCriteriaOption.age)));
        }
        if(subCriteriaOption.education != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Highest Level of Education Attained'), psd.getSubCriteriaOption('Highest Level of Education Attained',subCriteriaOption.education));
        }
        if(subCriteriaOption.residentialStatus != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Status of Address'), psd.getSubCriteriaOption('Status of Address',subCriteriaOption.residentialStatus));
        }
        if(subCriteriaOption.yearsAtCurrentResidence != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Years at Residence'), psd.getSubCriteriaOption('Years at Residence',String.valueOf(subCriteriaOption.yearsAtCurrentResidence)));
        }
        if(subCriteriaOption.creditHistory != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Credit History over the last 24 months'), psd.getSubCriteriaOption('Credit History over the last 24 months',subCriteriaOption.creditHistory));
        }
        if(subCriteriaOption.netWorth != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Assessment of Applicant Net Worth'), psd.getSubCriteriaOption('Assessment of Applicant Net Worth',subCriteriaOption.netWorth));
        }
        if(subCriteriaOption.employmentStatus != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Employment Status'),psd.getSubCriteriaOption('Employment Status',subCriteriaOption.employmentStatus));
        }
        if(subCriteriaOption.industryOfEmployment != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Industry'), psd.getSubCriteriaOption('Industry',subCriteriaOption.industryOfEmployment));
        }
        if(subCriteriaOption.lengthOfCurrentEmployment != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Length of Employment'), psd.getSubCriteriaOption('Length of Employment',String.valueOf(subCriteriaOption.lengthOfCurrentEmployment)));
        }
        if(subCriteriaOption.professionalCategory != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Professional Category'), psd.getSubCriteriaOption('Professional Category',subCriteriaOption.professionalCategory));
        }
        if(subCriteriaOption.workingCapital != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Assessment of Business Working Capita'), psd.getSubCriteriaOption('Assessment of Business Working Capita',subCriteriaOption.workingCapital));
        }
        if(subCriteriaOption.natureOfEngagement != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Nature of Engagement'), psd.getSubCriteriaOption('Nature of Engagement',subCriteriaOption.natureOfEngagement));
        }
        if(subCriteriaOption.typeOfIndustry != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Industry'),psd.getSubCriteriaOption('Industry',subCriteriaOption.typeOfIndustry));
        }
        if(subCriteriaOption.financialPerformance != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Assessment of Business Fin Performance'), psd.getSubCriteriaOption('Assessment of Business Fin Performance',subCriteriaOption.financialPerformance));
        }
        if(subCriteriaOption.financialStatementSupport != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Assessment of Business Fin Statement'), psd.getSubCriteriaOption('Assessment of Business Fin Statement',subCriteriaOption.financialStatementSupport));
        }
        if(subCriteriaOption.lengthOfTrade != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Length of Trade'), psd.getSubCriteriaOption('Length of Trade',subCriteriaOption.lengthOfTrade));
        }
        if(subCriteriaOption.collateral != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Collateral CC / Collateral LOC'), psd.getSubCriteriaOption('Collateral CC / Collateral LOC',subCriteriaOption.collateral));
        }
        if(subCriteriaOption.loanToValue != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Loan to ValueCC / Loan to ValueLOC'), psd.getSubCriteriaOption('Loan to ValueCC / Loan to ValueLOC',subCriteriaOption.loanToValue));
        }
        if(subCriteriaOption.ablitityToService != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Ability to Service CC / Ability to Service LOC'), psd.getSubCriteriaOption('Ability to Service CC / Ability to Service LOC',subCriteriaOption.ablitityToService));
        }
        if(subCriteriaOption.repaymentMethod != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get('Repayment Method CC / Repayment Method LOC'), psd.getSubCriteriaOption('Repayment Method CC / Repayment Method LOC',subCriteriaOption.repaymentMethod));
        }
        return finalScore;
    }

    public Decimal calculateScore(List<Personal_Credit_Score_Model__mdt> creditScoreModelList, String subCriteriaOption){
        Decimal score;
        for(Personal_Credit_Score_Model__mdt creditScore:creditScoreModelList){
            if(creditScore.Sub_Criteria_Option__c == subCriteriaOption || creditScore.Sub_Criteria_Options__c == subCriteriaOption){
                score = (isSalaried == true ? creditScore.Salaried_Score_Number__c:creditScore.Self_Employed_Score_Number__c) * creditScore.Sub_Criteria_Weight_Numbr__c / 100;
            }
        }
        return score;
    }
    

    /*
    * Creates the personal Credit Score Map.
    * @return {Map<string, Personal_Credit_Score_Model__mdt>}
    */
    public Map<String, List<Personal_Credit_Score_Model__mdt>> getPersonalCreditScoreMap() {
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
    
    public RiskRatingWrapper getRiskRating() {
        RiskRatingWrapper riskRating = new RiskRatingWrapper(finalScore);
        return riskRating;
    }
    
    
    
    
    
   
    
}