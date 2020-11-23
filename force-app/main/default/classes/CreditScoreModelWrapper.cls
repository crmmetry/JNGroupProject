/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     23/11/2020      Ishwari G.(thinqloud)  Calculates the Risk rating score  
**/
public class CreditScoreModelWrapper {
    public List<SubCriteriaOptionWrapper> subCriteriaOptionWrapperList;
    /*
     * Represents creditScoreModelWrapper of personal credit score model.
     * @constructor
     * @param {List<SubCriteriaOptionWrapper>} subCriteriaOptionWrapperList 
    */
    public creditScoreModelWrapper(List<SubCriteriaOptionWrapper> subCriteriaOptionWrapperList) {
        this.subCriteriaOptionWrapperList =  subCriteriaOptionWrapperList;
    }
    /*
     * Creates the RiskRatingWrapper and calculates the risk rating score 
     * @param {List<SubCriteriaOptionWrapper>} subCriteriaOptionWrapperList 
     * @return {riskRating} 
    */
    public RiskRatingWrapper getRiskRating() {
        decimal score = calculateCreditScore();
        RiskRatingWrapper riskRating = new RiskRatingWrapper(score);
        return riskRating;
    }
    /*
     * Calculates the credit score  
     * @return {decimal} total
    */
    public decimal calculateCreditScore() {
        decimal total = 0.0;
        for(SubCriteriaOptionWrapper option :subCriteriaOptionWrapperList) {
            total += calculateRiskScore( option.riskScore, option.weight);
        }  
        return total;
    }
    /*
     * Calculates the risk score
     * @param {decimal} riskScore 
     * @param {decimal} weight 
     * @return {decimal} riskScore
    */
    public decimal calculateRiskScore(decimal riskScore, decimal weight) {
        return (riskScore * weight)/100;
    }
    
}