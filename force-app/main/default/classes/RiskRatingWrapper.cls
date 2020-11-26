/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Wrapper class of Credit_Rating__mdt
 **/
public class RiskRatingWrapper {
  @AuraEnabled
  public Decimal score;
  @AuraEnabled
  public String rating;
  @AuraEnabled
  public String classification;
  @AuraEnabled
  public List<CreditRatingWrapper> creditRatingList = new List<CreditRatingWrapper>();

  /*
   * Represents CreditRatingWrapper
   * @constructor
   * @param {Decimal} score
   */
  public RiskRatingWrapper(Decimal score) {
    this.score = score;
    this.creditRatingList = JNConfigurations.getCreditRatings();
    getRating(this.creditRatingList);
  }

  /*
   * Assigns the rating and classification data
   * @param {List<CreditRatingWrapper>} creditRatingList
   * @return {void}
   */
  private void getRating(List<CreditRatingWrapper> creditRatingList) {
    for (CreditRatingWrapper rating : creditRatingList) {
      if (
        rating.creditScoreMin <= this.score &&
        rating.creditScoreMax >= this.score
      ) {
        this.rating = rating.rating;
        this.classification = rating.classification;
        break;
      }
    }
  }
}
