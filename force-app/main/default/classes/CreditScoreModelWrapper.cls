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
    public Map<String, List<Personal_Credit_Score_Model__mdt>>  personalCreditScoreMap;
    @AuraEnabled
    public ProductDetailService psd ;
    
    /**
   * Constructor of the class
   * Initializes all the values
   * @param {SubCriteriaOptionWrapper} subCriteriaOption - instance of subcriteriaoptionswrapper class
   */
    public creditScoreModelWrapper(SubCriteriaOptionWrapper subCriteriaOption) {
        psd = new ProductDetailService();
        personalCreditScoreMap = psd.getPersonalCreditScoreMap();
        for(String key :personalCreditScoreMap.keySet()) {
            System.debug(key+ '==='+Key);
            for(Personal_Credit_Score_Model__mdt pd :personalCreditScoreMap.get(key)){
                System.debug(pd);
            }
        }
        this.subCriteriaOption =  subCriteriaOption;
        this.isSalaried = subCriteriaOption.employmentType == 'Employed' ? true : false;
        finalScore = getRiskScore(this.subCriteriaOption);
        riskRating = getRiskRating();
    }


    /**
   * Function to oveall the risk score 
   * @param {SubCriteriaOptionWrapper} subCriteriaOption - instance of subcriteriaoptionswrapper class
   * @return {Decimal} - return the final calculated score
   */
    public Decimal getRiskScore(SubCriteriaOptionWrapper subCriteriaOption){
        Decimal finalScore=0;
        if(subCriteriaOption.age != NULL){
            finalScore = calculateScore(personalCreditScoreMap.get(Constants.AGE),psd.getSubCriteriaOption(Constants.AGE,String.valueOf(subCriteriaOption.age)));
        }
        if(subCriteriaOption.residentialStatus != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.STATUS_OF_ADDRESS), psd.getSubCriteriaOption(Constants.STATUS_OF_ADDRESS,subCriteriaOption.residentialStatus));
        }
        if(subCriteriaOption.yearsAtCurrentResidence != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.YEARS_AT_RESIDENCE), psd.getSubCriteriaOption(Constants.YEARS_AT_RESIDENCE,String.valueOf(subCriteriaOption.yearsAtCurrentResidence)));
        }
        if(subCriteriaOption.creditHistory != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.CREDIT_HISTORY), psd.getSubCriteriaOption(Constants.CREDIT_HISTORY,subCriteriaOption.creditHistory));
        }
        if(subCriteriaOption.netWorth != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.NET_WORTH), psd.getSubCriteriaOption(Constants.NET_WORTH,subCriteriaOption.netWorth));
        }
        if(subCriteriaOption.employmentStatus != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.EMPLOYMENT_STATUS),psd.getSubCriteriaOption(Constants.EMPLOYMENT_STATUS,subCriteriaOption.employmentStatus));
        }
        if(subCriteriaOption.industryOfEmployment != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.INDUSTRY), psd.getSubCriteriaOption(Constants.INDUSTRY,subCriteriaOption.industryOfEmployment));
        }
        if(subCriteriaOption.lengthOfCurrentEmployment != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.LENGTH_OF_EMPLOYMENT), psd.getSubCriteriaOption(Constants.LENGTH_OF_EMPLOYMENT,String.valueOf(subCriteriaOption.lengthOfCurrentEmployment)));
        }
        if(subCriteriaOption.professionalCategory != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.PROFESSIONAL_CATEGORY), psd.getSubCriteriaOption(Constants.PROFESSIONAL_CATEGORY,subCriteriaOption.professionalCategory));
        }
        if(subCriteriaOption.natureOfEngagement != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.NATURE_OF_ENGAGEMENT), psd.getSubCriteriaOption(Constants.NATURE_OF_ENGAGEMENT,subCriteriaOption.natureOfEngagement));
        }
        if(subCriteriaOption.typeOfIndustry != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.INDUSTRY),psd.getSubCriteriaOption(Constants.INDUSTRY,subCriteriaOption.typeOfIndustry));
        }
        if(subCriteriaOption.financialPerformance != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.FINANCIAL_PERFORMANCE), psd.getSubCriteriaOption(Constants.FINANCIAL_PERFORMANCE,subCriteriaOption.financialPerformance));
        }
        if(subCriteriaOption.financialStatementSupport != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.FINACIAL_STATEMENT), psd.getSubCriteriaOption(Constants.FINACIAL_STATEMENT,subCriteriaOption.financialStatementSupport));
        }
        if(subCriteriaOption.lengthOfTrade != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.LENGTH_OF_TRADE), psd.getSubCriteriaOption(Constants.LENGTH_OF_TRADE,subCriteriaOption.lengthOfTrade));
        }
        if(subCriteriaOption.collateral != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.COLLATERAL), psd.getSubCriteriaOption(Constants.COLLATERAL,subCriteriaOption.collateral));
        }
        if(subCriteriaOption.loanToValue != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.LOAN_TO_VALUE), psd.getSubCriteriaOption(Constants.LOAN_TO_VALUE,String.valueOf(subCriteriaOption.loanToValue)));
        }
        if(subCriteriaOption.ablitityToService != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.ABILITY_TO_SERVICE), psd.getSubCriteriaOption(Constants.ABILITY_TO_SERVICE,String.valueOf(subCriteriaOption.ablitityToService)));
        }
        if(subCriteriaOption.repaymentMethod != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.REPAYMENT_METHOD), psd.getSubCriteriaOption(Constants.REPAYMENT_METHOD,subCriteriaOption.repaymentMethod));
        }
        if(subCriteriaOption.workingCapital != NULL){
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.WORKING_CAPITA), psd.getSubCriteriaOption(Constants.WORKING_CAPITA,subCriteriaOption.workingCapital));
        }
        if(subCriteriaOption.education != NULL){
            System.debug(Constants.EDUCATION);
            System.debug(personalCreditScoreMap.containsKey(Constants.EDUCATION));
            System.debug(personalCreditScoreMap.get(Constants.EDUCATION));
            finalScore += calculateScore(personalCreditScoreMap.get(Constants.EDUCATION), psd.getSubCriteriaOption(Constants.EDUCATION,subCriteriaOption.education));
        }
        return finalScore;
    }

    
    /**
   * Function to calculate the risk score for each fields value
   * @param {List<Personal_Credit_Score_Model__mdt>} creditScoreModelList - list of personal credit score model record of same type
   * @param {String} subCriteriaOption - sub criteria option mentioned in the custom metadata
   * @return {Decimal} - return the calculated score each field
   */
    public Decimal calculateScore(List<Personal_Credit_Score_Model__mdt> creditScoreModelList, String subCriteriaOption){
        Decimal score = 0;
        System.debug('SubCriteriaOption'+subCriteriaOption);
        System.debug('creditScoreModelList ==>'+creditScoreModelList);
        for(Personal_Credit_Score_Model__mdt creditScore :creditScoreModelList){
            System.debug(creditScore);
            if((creditScore.Sub_Criteria_Option__c != null && creditScore.Sub_Criteria_Option__c.equalsIgnoreCase(subCriteriaOption)) 
                || (creditScore.Sub_Criteria_Options__c != null && creditScore.Sub_Criteria_Options__c.equalsIgnoreCase(subCriteriaOption))){
                score = (isSalaried == true ? (creditScore.Salaried_Score_Number__c != null ? creditScore.Salaried_Score_Number__c : 0):creditScore.Self_Employed_Score_Number__c) * creditScore.Sub_Criteria_Weight_Numbr__c / 100;
            }
        }
        System.debug('Score ==>'+score);
        return score;
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