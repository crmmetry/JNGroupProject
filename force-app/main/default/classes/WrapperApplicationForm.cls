/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 04-21-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   04-21-2021   Remario Richards   Initial Version
 **/
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
      this.howLongMonth = '';
      string aa = string.valueOf(
        ApplicantPersonAccount1.Years_at_Residence__pc
      );
      String afterDecimal = aa.substringAfter('.');
      Integer b = Integer.valueOf(afterDecimal);
      if (b > 0)
        this.howLongMonth = afterDecimal;
      else
        this.howLongMonth = '0';
    }
  }
}
