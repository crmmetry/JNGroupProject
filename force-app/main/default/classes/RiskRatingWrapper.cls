public  class RiskRatingWrapper {
   @AuraEnabled
   public Decimal score;
   @AuraEnabled
   public String rating;
   @AuraEnabled
   public String classification;
   @AuraEnabled
   public List<Credit_Rating__mdt> creditRatingList = new List<Credit_Rating__mdt>();

   public RiskRatingWrapper(Decimal score){
      this.score = score;
      this.creditRatingList = JNConfigurations.getCreditRatings();
      this.rating = getRating(this.creditRatingList);
   }
    

   private String getRating(List<Credit_Rating__mdt> creditRatingList){
      for(Credit_Rating__mdt rating:creditRatingList){
         if(rating.Credit_Score_Min__c >= this.score && rating.Credit_Score_Max__c <= this.score){
            this.rating = rating.Rating__c;
            this.classification =  rating.Classification__c;
         }
      }
   }
}
