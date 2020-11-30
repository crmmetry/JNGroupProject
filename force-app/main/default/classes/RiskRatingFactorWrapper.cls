public with sharing class RiskRatingFactorWrapper {
  @AuraEnabled
  public String riskRating;
  @AuraEnabled
  public Decimal score;

  public RiskRatingFactorWrapper(Risk_Rating_Factor__mdt record) {
    this.riskRating = record.Risk_Rating_List__c;
    this.score = record.Score_Range_Number__c;
  }
}
