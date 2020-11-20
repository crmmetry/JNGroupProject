public class CreditScoreModelWrapper {
    public List<SubCriteriaOptionWrapper> subCriteriaOptionWrapperList;
    
    public CreditScoreModelWrapper(List<SubCriteriaOptionWrapper> subCriteriaOptionWrapperList) {
        this.subCriteriaOptionWrapperList =  subCriteriaOptionWrapperList;
    }
    
    public RiskRatingWrapper getRiskRating() {
        decimal score = calculateCreditScore();
        RiskRatingWrapper riskRating = new RiskRatingWrapper(score);
        return riskRating;
    }

    public decimal calculateCreditScore() {
        decimal total = 0.0;
        for(SubCriteriaOptionWrapper option :subCriteriaOptionWrapperList) {
            total += calculateRiskScore( option.riskscore, option.weight);
        }
        
        return total;
    }
    
    public decimal calculateRiskScore(decimal riskscore, decimal weight) {
        return (riskscore * weight)/100;
    }
    
}