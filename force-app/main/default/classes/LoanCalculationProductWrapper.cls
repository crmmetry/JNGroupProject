/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public inherited sharing class LoanCalculationProductWrapper {
  @AuraEnabled
  public Decimal market;
  @AuraEnabled
  public Decimal startingLimit;
  @AuraEnabled
  public Decimal minimumPayment;
  //monthly interest rate

  public LoanCalculationProductWrapper(Loan_Calculation_Product__c record) {
    this.market = record.Loan_Amount_Market_Percentage_Number__c;
    this.startingLimit = record.Approved_Starting_Limit_Number__c;
    this.minimumPayment = record.Minimum_Payment_per_Credit_Limit_Number__c;
    //monthly interest rate
  }
}
