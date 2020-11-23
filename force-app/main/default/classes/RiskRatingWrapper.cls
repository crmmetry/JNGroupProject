/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper class of Credit_Rating__mdt  
**/
public  class RiskRatingWrapper {
   @AuraEnabled
   public Decimal score;
   @AuraEnabled
   public String rating;
   @AuraEnabled
   public String classification;
   @AuraEnabled
   public List<Credit_Rating__mdt> creditRatingList = new List<Credit_Rating__mdt>();

   /*
     * Represents Credit_Rating__mdt 
     * @constructor
     * @param {Decimal} score   
    */
   public RiskRatingWrapper(Decimal score){
      this.score = score;
      this.creditRatingList = JNConfigurations.getCreditRatings();
      getRating(this.creditRatingList);
   }
    
   /*
     * Assigns the rating and classification data  
     * @param {List<Credit_Rating__mdt>} creditRatingList  
     * @return {void}  
    */
   private void getRating(List<Credit_Rating__mdt> creditRatingList){
      for(Credit_Rating__mdt rating:creditRatingList){
         if(rating.Credit_Score_Min__c >= this.score && rating.Credit_Score_Max__c <= this.score){
            this.rating = rating.Rating__c;
            this.classification =  rating.Classification__c;
         }
      }
   }
}