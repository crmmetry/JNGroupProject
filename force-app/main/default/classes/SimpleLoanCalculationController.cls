/**
 * @description       :
 * @author            : Travis Allen
 * @group             :
 * @last modified on  : 04-09-2021
 * @last modified by  : Travis Allen
 * Modifications Log
 * Ver   Date         Author         Modification
 * 1.0   04-08-2021   Travis Allen   Initial Version
 **/
public class SimpleLoanCalculationController {
  private static final String TAG = 'SimpleLoanCalculationController';
  @AuraEnabled
  public static Object SaveLoanCalculation(
    String CalculationData,
    String radioGrpName,
    String leadId
  ) {
    String returnStr = '';
    List<SObject> recordsToUpsert = new List<SObject>();
    try {
      Map<String, String> rtMap = new Map<String, String>();
      rtMap.put(
        'AffordabilityCalculator',
        'Installment Affordability Calculator'
      );
      rtMap.put('InstallmentPayment', 'Installment Payment');
      rtMap.put(
        'RevolvingCreditLimitUnsecured',
        'Revolving Credit Limit Unsecured'
      );
      rtMap.put(
        'RevolvingCreditLimitSecured',
        'Revolving Credit Limit Secured'
      );

      Loan_Calculator__c LoanObj = (Loan_Calculator__c) JSON.deserialize(
        CalculationData,
        Loan_Calculator__c.class
      );
      if (LoanObj != null) {
        Id rtID = Schema.SObjectType.Loan_Calculator__c.getRecordTypeInfosByName()
          .get(rtMap.get(radioGrpName))
          .getRecordTypeId();
        LoanObj.recordTypeId = rtID;
        Lead updatedLead = updateNumberOfScenariosRunOnLead(leadId);
        recordsToUpsert.add(updatedLead);
        recordsToUpsert.add(LoanObj);
        upsert recordsToUpsert;

        return [SELECT Name FROM Loan_Calculator__c WHERE Id = :LoanObj.Id]
        .Name;
      }
    } catch (Exception ex) {
      System.debug(TAG + '' + ex.getMessage());
      return new AuraException(ex.getMessage());
    }
    return 'Saved';
  }
  /**
   * Calculates the amount of loan scenarios ran on a lead.
   * @{params} - leadId
   * @{return} - Lead
   */
  private static Lead updateNumberOfScenariosRunOnLead(String leadId) {
    List<Lead> leads = [
      SELECT Id, Number_of_Loans_Scenerios_Run__c
      FROM Lead
      WHERE Id = :leadId
      WITH SECURITY_ENFORCED
    ];
    Lead currentLead = leads[0];
    if (
      currentLead.Number_of_Loans_Scenerios_Run__c == null ||
      currentLead.Number_of_Loans_Scenerios_Run__c == 0
    ) {
      currentLead.Number_of_Loans_Scenerios_Run__c = 1;
    } else {
      currentLead.Number_of_Loans_Scenerios_Run__c += 1;
    }
    return currentLead;
  }
}
