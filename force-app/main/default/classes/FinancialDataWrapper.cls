public class FinancialDataWrapper {
  public Applicant__c applicant { get; set; }

  public StatementOfAffairsFormController getSoa() {
    system.debug('test');

    return new StatementOfAffairsFormController(applicant.Id);
  }
}
