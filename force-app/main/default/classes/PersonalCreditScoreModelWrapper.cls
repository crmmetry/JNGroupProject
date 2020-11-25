/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     24/11/2020      Ishwari G.(thinqloud)  Wrapper for PersonalCreditScoreModel Metadata  
**/
public class PersonalCreditScoreModelWrapper {
    
    @AuraEnabled
    public String subCriteriaOption;
    @AuraEnabled
    public Decimal salariedScore;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String subCriteriaOptions;
    @AuraEnabled
    public Decimal selfEmployedScore;
    @AuraEnabled
    public Decimal subCriteriaWeight;
    @AuraEnabled
    public String label;
    
    public PersonalCreditScoreModelWrapper(Personal_Credit_Score_Model__mdt personalCreditModel){
        this.label = personalCreditModel.MasterLabel;
        this.subCriteriaOption = personalCreditModel.Sub_Criteria_Option__c;
        this.salariedScore = personalCreditModel.Salaried_Score_Number__c;
        this.type = personalCreditModel.Type__c;
        this.subCriteriaOptions = personalCreditModel.Sub_Criteria_Options__c;
        this.selfEmployedScore = personalCreditModel.Self_Employed_Score_Number__c;
        this.subCriteriaWeight = personalCreditModel.Sub_Criteria_Weight_Numbr__c;
    }

}