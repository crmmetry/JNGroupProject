/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 03-19-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-19-2021   Remario Richards   Initial Version
 **/
//Sample Opportunities Id 006f000000PhctcAAB  006f000000PhpadAAB
//Sample Applicant Ids are a15f0000002F8z5AAC 	a15f0000002F9sIAAS
//Sample Account Id 001f000001dJOzdAAG	001f000001dXjJ9AAK
public class PromissoryNoteController {
  //Date of Application
  public date dateOfApplication { get; set; }
  public String dateString { get; set; }

  //Application ID
  public String applicationIdString { get; set; }
  public Id OpportId { get; set; }

  public Account personAccount { get; set; }
  public Opportunity oppObject { get; set; }
  public Loan_Calculation_Product__c loanCalculProductObj { get; set; }

  public String loan_Amount_In_Words { get; set; }
  public String intrest_Rate_In_Words { get; set; }

  public PromissoryNoteController() {
    //Get opportunity id from URL
    OpportId = ApexPages.currentPage().getParameters().get('Id');

    if (OpportId != null) {
      //Form the date of application value to display in vf page
      dateOfApplication = date.today();
      dateString = dateOfApplication.format();

      //Get Opportunity by using the id from URL
      oppObject = getOpportunityObj(OpportId);

      //Get account objects
      personAccount = getAccount(oppObject.AccountId);

      //Get Loan_Calculation_Product__c
      loanCalculProductObj = getLoanCalculationProduct(OpportId);
      if (loanCalculProductObj != null) {
        if (loanCalculProductObj.Loan_Amount_Number__c != null) {
          long loanAmt = (long) loanCalculProductObj.Loan_Amount_Number__c;
          loan_Amount_In_Words = NumberToWordsConverterClass.Number_To_Words(
            loanAmt
          );
        }

        if (loanCalculProductObj.Interest_Rate_Number__c != null) {
          long interestRate = (long) loanCalculProductObj.Interest_Rate_Number__c;
          intrest_Rate_In_Words = NumberToWordsConverterClass.Number_To_Words(
            interestRate
          );
        }
      }
    }
    Apexpages.currentPage()
      .getHeaders()
      .put('content-disposition', 'attachment; filename= PromissoryNote.pdf');
  }

  private Opportunity getOpportunityObj(Id OppId) {
    Opportunity oppObjectInstance;
    oppObjectInstance = [
      SELECT Id, Product_Details__c, AccountId
      FROM Opportunity
      WHERE Id = :oppId
    ];

    if (oppObjectInstance != null) {
      return oppObjectInstance;
    } else {
      return null;
    }
  }

  private Account getAccount(Id accountId) {
    Account accountObj = [
      SELECT
        Name,
        Street_1__pc,
        Street_2__pc,
        Street_3__pc,
        City_Town__pc,
        Residential_Area_District__pc,
        Province_Parish_State__pc,
        Post_Office_Zip_Code__pc,
        Country__c
      FROM Account
      WHERE Id = :accountId
    ];
    if (accountObj != null) {
      return accountObj;
    } else {
      return null;
    }
  }

  private Loan_Calculation_Product__c getLoanCalculationProduct(Id oppId) {
    list<Loan_Calculation_Product__c> loanCalPrdct;
    Loan_Calculation_Product__c loanCalculationProductObj;

    if (oppObject != null) {
      loanCalPrdct = [
        SELECT Loan_Amount_Number__c, Interest_Rate_Number__c, CurrencyIsoCode
        FROM Loan_Calculation_Product__c
        WHERE Loan_Calculation_Id__c = :oppObject.Product_Details__c
      ];

      if (loanCalPrdct != null) {
        if (loanCalPrdct.size() > 0) {
          loanCalculationProductObj = loanCalPrdct.get(0);
          return loanCalculationProductObj;
        }
      }
      return null;
    }
    return null;
  }
}
