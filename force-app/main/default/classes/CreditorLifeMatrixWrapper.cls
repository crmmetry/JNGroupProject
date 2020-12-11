public class CreditorLifeMatrixWrapper {
  @AuraEnabled
  public Decimal loanTerm;
  @AuraEnabled
  public String label;
  @AuraEnabled
  public Integer ageLowerBound;
  @AuraEnabled
  public Integer ageUpperBound;
  @AuraEnabled
  public Creditor_Life_Matrix__mdt record;

  public CreditorLifeMatrixWrapper(Creditor_Life_Matrix__mdt record) {
    this.calculateAgeBoundaries(record.Label);
    this.label = record.Label;
    this.record = record;
  }
  /**
   * Splits age range into an upper and a lower boundary.
   * @param {String} ageRange - Age Range of matrx record.
   * @return {void}
   */
  private void calculateAgeBoundaries(String ageRange) {
    List<String> ranges = ageRange.split('-');
    this.ageLowerBound = Integer.valueOf(ranges[0]);
    this.ageUpperBound = Integer.valueOf(ranges[1]);
  }

  public Boolean isAgeWithinBound(Integer age) {
    return age >= this.ageLowerBound && age <= this.ageUpperBound;
  }
  /**
   * retrieves credit rating related to an applicants age and loan tenure.
   * @param {Decimal} tenure - Loan Term for product being applied for.
   * @param {Integer} age - Age og applicant.
   * @return {Decimal}
   */
  public Decimal getCreditRating(Integer age, Decimal tenure) {
    if (this.isAgeWithinBound(age)) {
      //implement logic to get the rating based on loan term
      return (Decimal) this.record.get(this.getRatingBasedOnTenure(tenure));
    }
    return null;
  }

  /**
   * retrieves a valid tenure that is applicable to credit matrix.
   * @param {Decimal} tenure - Loan Term for product being applied for.
   * @return {String}
   */
  private String getRatingBasedOnTenure(Decimal tenure) {
    Decimal ratingTenure;
    String template;
    Decimal increment = 0.5;
    if (tenure > 10) {
      throw new AuraException(Constants.INVALID_TENURE);
    }
    for (Decimal x = 0; x <= 10; x += increment) {
      if (tenure == x) {
        ratingTenure = x;
        break;
      } else if (tenure > x && tenure < x + increment) {
        ratingTenure = x + increment;
        break;
      }
    }
    Integer ratingTenureWholeNumber = Integer.valueOf(ratingTenure * 10);
    if (Math.mod(ratingTenureWholeNumber, 10) == 0) {
      template = 'X' + (Integer) ratingTenure + '__c';
    } else {
      String ratingTenureStr = String.valueOf(ratingTenure);
      String[] values = ratingTenureStr.split('\\.');
      template = 'X' + values[0] + '_' + values[1] + '__c';
    }
    return template;
  }
}
