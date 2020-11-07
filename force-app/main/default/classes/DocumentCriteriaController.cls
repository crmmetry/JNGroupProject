public class DocumentCriteriaController {
  public String PDFData { get; set; }
  public String CalType { get; set; }
  public Date todaydate { get; set; }
  public integer currentyear { get; set; }
  public integer previousyear { get; set; }
  public integer payslipyear { get; set; }
  public String officername { get; set; }
  public Boolean iscommision { get; set; }
  public string payslip { get; set; }

  public Boolean isSalary { get; set; }

  public Boolean isPension { get; set; }
  public Boolean isNetProfit { get; set; }
  public Boolean isCompanyDirector { get; set; }
  public Boolean isShareofProfitPartnership { get; set; }
  public Boolean isShareofProfitShareholder { get; set; }
  public Boolean isPropertyRental { get; set; }

  public Boolean isProofofIdentity { get; set; }
  public Boolean isProofofAge { get; set; }
  public Boolean isProofofAddress { get; set; }
  public Boolean isTRN { get; set; }
  public Boolean isFATCA { get; set; }

  public Boolean isEducation { get; set; }
  public Boolean isDebt { get; set; }
  public Boolean isMedical { get; set; }
  public Boolean isHomeImprovement { get; set; }
  public Boolean isAssetAcquisition { get; set; }
  public Boolean isAutoRepair { get; set; }
  public Boolean isOther { get; set; }
  public Boolean isunnote { get; set; }

  public string autolp { get; set; }
  public string autovc { get; set; }
  public string autoin { get; set; }
  public string credit { get; set; }
  public string loc { get; set; }
  public string isloc { get; set; }
  public string oemail { get; set; }
  public string ophone { get; set; }
  public string kycdone { get; set; }
  public string officerlocation { get; set; }
  public string isNone { get; set; }

  public string offEmail { get; set; }

  public DocumentCriteriaController() {
    officername = '';
    ophone = '';
    oemail = '';

    user u = [
      SELECT id, MobilePhone
      FROM user
      WHERE id = :UserInfo.getUserId()
      LIMIT 1
    ];
    officername = UserInfo.getName();
    oemail = UserInfo.getUserEmail();
    ophone = u.MobilePhone != null ? u.MobilePhone : '';
    system.debug('');
    system.debug('');
    system.debug('');

    todaydate = system.today();
    currentyear = todaydate.year();
    if (todaydate.month() < 4)
      currentyear = todaydate.year() - 1;
    previousyear = currentyear - 1;
    payslipyear = currentyear - 1;
    CalType = '0';
    PDFData = '';
    isPension = false;
    isSalary = false;

    isNetProfit = false;
    isCompanyDirector = false;
    isShareofProfitPartnership = false;
    isShareofProfitShareholder = false;
    isPropertyRental = false;
    isProofofIdentity = false;
    isProofofAge = false;
    isProofofAddress = false;
    isTRN = false;
    isFATCA = false;
    isunnote = false;
    iscommision = false;

    CalType = Apexpages.currentPage().getParameters().get('CalType');
    String INCOMECRITERIA = '';
    String kycdoc = '';
    String unsecured = '';
    String commision = '';
    autolp = '';
    autovc = '';
    autoin = '';
    credit = '';
    loc = '';
    isloc = '';
    payslip = '';
    kycdone = '';
    if (Apexpages.currentPage().getParameters().get('kycdone') != null)
      kycdone = Apexpages.currentPage().getParameters().get('kycdone');
    if (Apexpages.currentPage().getParameters().get('location') != null)
      officerlocation = Apexpages.currentPage().getParameters().get('location');
    if (Apexpages.currentPage().getParameters().get('commision') != null)
      commision = Apexpages.currentPage().getParameters().get('commision');
    if (Apexpages.currentPage().getParameters().get('payslip') != null)
      payslip = Apexpages.currentPage().getParameters().get('payslip');
    /* if(Apexpages.currentPage().getParameters().get('oemail')!=null)
oemail=Apexpages.currentPage().getParameters().get('oemail');
if(Apexpages.currentPage().getParameters().get('ophone')!=null)
ophone=Apexpages.currentPage().getParameters().get('ophone');*/
    if (Apexpages.currentPage().getParameters().get('isNone') != null) {
      isNone = Apexpages.currentPage().getParameters().get('isNone');
    }

    if (Apexpages.currentPage().getParameters().get('loc') != null)
      loc = Apexpages.currentPage().getParameters().get('loc');
    if (Apexpages.currentPage().getParameters().get('isloc') != null)
      isloc = Apexpages.currentPage().getParameters().get('isloc');
    if (Apexpages.currentPage().getParameters().get('credit') != null)
      credit = Apexpages.currentPage().getParameters().get('credit');
    if (Apexpages.currentPage().getParameters().get('autoin') != null)
      autoin = Apexpages.currentPage().getParameters().get('autoin');
    if (Apexpages.currentPage().getParameters().get('autovc') != null)
      autovc = Apexpages.currentPage().getParameters().get('autovc');
    if (Apexpages.currentPage().getParameters().get('autolp') != null)
      autolp = Apexpages.currentPage().getParameters().get('autolp');
    if (Apexpages.currentPage().getParameters().get('incr') != null)
      INCOMECRITERIA = Apexpages.currentPage().getParameters().get('incr');
    if (Apexpages.currentPage().getParameters().get('kyc') != null)
      kycdoc = Apexpages.currentPage().getParameters().get('kyc');
    if (Apexpages.currentPage().getParameters().get('uns') != null)
      unsecured = Apexpages.currentPage().getParameters().get('uns');
    if (
      Apexpages.currentPage().getParameters().get('uns') == null ||
      string.isblank(unsecured) ||
      !unsecured.contains(',')
    )
      isunnote = true;
    //?OfficerEmail=naresh%40gmail.com&name=Salaried%2CNetProfit%2CCompanyDirector%2CShareofProfitPartnership%2CShareofProfitShareholder%2CPension%2CPropertyRental&OfficerPhone=09966332211&Selectcombination=1&officername=Naresh&DateCreated=2019-09-20&officerloc=Branch+Network+-+Barbican
    system.debug('unsecured==========' + unsecured);
    if (commision.contains('Overtime')) {
      iscommision = true;
    }
    if (unsecured.contains('Education')) {
      isEducation = true;
    }
    if (unsecured.contains('Debt')) {
      isDebt = true;
    }
    if (unsecured.contains('Medical')) {
      isMedical = true;
    }
    if (unsecured.contains('HomeImprovement')) {
      isHomeImprovement = true;
    }
    if (unsecured.contains('AssetAcquisition')) {
      isAssetAcquisition = true;
    }
    if (unsecured.contains('AutoRepair')) {
      isAutoRepair = true;
    }
    if (unsecured.contains('Other')) {
      isOther = true;
    }

    //========================
    if (INCOMECRITERIA.contains('Salaried')) {
      isSalary = true;
    }
    if (INCOMECRITERIA.contains('Pension')) {
      isPension = true;
    }
    if (INCOMECRITERIA.contains('NetProfit')) {
      isNetProfit = true;
    }
    if (INCOMECRITERIA.contains('CompanyDirector')) {
      isCompanyDirector = true;
    }
    if (INCOMECRITERIA.contains('ShareofProfitPartnership')) {
      isShareofProfitPartnership = true;
    }
    if (INCOMECRITERIA.contains('ShareofProfitShareholder')) {
      isShareofProfitShareholder = true;
    }
    if (INCOMECRITERIA.contains('PropertyRental')) {
      isPropertyRental = true;
    }

    if (kycdoc.contains('ProofofIdentity')) {
      isProofofIdentity = true;
    }
    if (kycdoc.contains('ProofofAge')) {
      isProofofAge = true;
    }
    if (kycdoc.contains('ProofofAddress')) {
      isProofofAddress = true;
    }
    if (kycdoc.contains('TRN')) {
      isTRN = true;
    }
    if (kycdoc.contains('FATCA')) {
      isFATCA = true;
    }
  }

  public PageReference downloadPDF() {
    System.PageReference pageRef = new System.PageReference(
      '/apex/DocumentCriteriaDoc'
    );

    //ensure pdf downloads and is assigned with defined name
    pageRef.getHeaders()
      .put('content-disposition', 'attachment; filename=TestPDF.pdf');

    return pageRef;
  }
}
