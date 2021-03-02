public class WrapperApplicationForm {
  public Integer Appcount { get; set; }
  public Account ApplicantPersonAccount { get; set; }
  public string howLongMonth { get; set; }
  public List<FinServ__ContactContactRelation__c> ApplicantPAEmergencyContact {
    get;
    set;
  }
  public List<FinServ__Employment__c> EmploymentDetails { get; set; }
  public List<FinServ__ContactContactRelation__c> PoliticalExposure {
    get;
    set;
  }
  public List<FinServ__ContactContactRelation__c> BankAffiliation { get; set; }
  public Applicant__c applicant { get; set; }
  public WrapperApplicationForm(
    Integer Appcount,
    Account ApplicantPersonAccount1,
    Applicant__c applicant,
    List<FinServ__ContactContactRelation__c> ApplicantPAEmergencyContact1,
    List<FinServ__Employment__c> EmploymentDetails1,
    List<FinServ__ContactContactRelation__c> PoliticalExposure1,
    List<FinServ__ContactContactRelation__c> BankAffiliation1
  ) {
    this.Appcount = Appcount;
    this.ApplicantPersonAccount = ApplicantPersonAccount1;
    this.applicant = applicant;
    this.ApplicantPAEmergencyContact = ApplicantPAEmergencyContact1;
    this.EmploymentDetails = EmploymentDetails1;
    this.PoliticalExposure = PoliticalExposure1;
    this.BankAffiliation = BankAffiliation1;
    if (ApplicantPersonAccount1.Years_at_Residence__pc != null) {
      system.debug(
        '===============' + ApplicantPersonAccount1.Years_at_Residence__pc
      );
      this.howLongMonth = '';
      string aa = string.valueOf(
        ApplicantPersonAccount1.Years_at_Residence__pc
      );
      String afterDecimal = aa.substringAfter('.');
      system.debug('arrayOfProducts===============' + afterDecimal);
      Integer b = Integer.valueOf(afterDecimal);
      if (b > 0)
        this.howLongMonth = afterDecimal;
      else
        this.howLongMonth = '0';
    }
  }
}
