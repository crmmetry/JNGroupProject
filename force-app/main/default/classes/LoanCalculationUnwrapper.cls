/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-26-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public class LoanCalculationUnwrapper {
  private static final String TAG = 'LoanCalculationUnwrapper';
  @AuraEnabled
  public Loan_Calculator__c record;
  public LoanCalculationUnwrapper(ProductDetailsSerializer serializer) {
    this.record = new Loan_Calculator__c();
    record.Loan_Amount__c = serializer.loanAmount;
    record.Interested_in_programme__c = serializer.interestedInPremiumFlag;
    record.Monthly_Premium__c = serializer.jngiMonthlyPremium;
    //record.Coverage_Type__c = serializer.coverageType;
    record.Type_of_Card__c = serializer.cardType;
    record.JNGI_Motor_Premium_1st_Year__c = serializer.jngiMotorPremium;
    record.Estimated_Stamp_Duty_AdminCharges_Number__c = serializer.stampDutyAndAdminCharges;
    //record.Stamp_Duty__c = serializer.stampDuty;
    record.Creditor_Life_Denial_Reason_Text__c = serializer.noCreditorLifeReason;
    record.Name_of_Insurance_Provider__c = serializer.policyProvider;
    record.Type_of_Card__c = serializer.cardType;
    record.Financial_Institution__c = serializer.financialInstitution;
    //record.Deposit_Account_Number_Text__c = serializer.depositAccountNumber;
    record.Account_Holders__c = serializer.accountHolder;
    record.Annual_Interest_Rate_on_Deposit_Account__c = serializer.annualInterestRate;
    record.Hypothecated_Loan_Flag__c = serializer.hypothecatedLoan;
    record.Deposit_Account_Balance_Number__c = serializer.depositBalance;
    record.Life_Insurance_Coverage__c = serializer.lifeInsuranceCoverage;
  }
  /**
   * save loan calculations oject
   * @param {Id} opportunityId
   * @return {Id}
   */
  public Id save(Id opportunityId) {
    try {
      Map<String, Id> recordTypeIds = Util.getRecordTypeids(
        'Loan_Calculator__c'
      );
      this.record.RecordTypeId = recordTypeIds.get('Product_Details');
      this.record.Opportunity__c = opportunityId;
      insert this.record;
      return this.record.Id;
    } catch (Exception e) {
      System.debug(TAG + ' ' + e.getMessage());
      throw new StringException(e.getMessage());
    }
  }
}
