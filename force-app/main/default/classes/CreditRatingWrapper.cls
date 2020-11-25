public with sharing class CreditRatingWrapper {
    @AuraEnabled
    public String classification;
    @AuraEnabled
    public Decimal creditScoreMax;
    @AuraEnabled
    public Decimal creditScoreMin;
    @AuraEnabled
    public String rating;
    @AuraEnabled
    public String label;
    
    public CreditRatingWrapper(Credit_Rating__mdt creditRating){
        this.label = creditRating.Label;
        this.classification = creditRating.Classification__c;
        this.creditScoreMax = creditRating.Credit_Score_Max__c;
        this.creditScoreMin = creditRating.Credit_Score_Min__c;
        this.rating = creditRating.Rating__c;
    }
}