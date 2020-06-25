public class SimpleLoanCalculationController {
    private static final String TAG = 'SimpleLoanCalculationController';
    @AuraEnabled
    Public static Object SaveLoanCalculation(String CalculationData,String radioGrpName){
        String returnStr='';
        try{
            Map<String,String> rtMap = new Map<String,String>();
            rtMap.put('AffordabilityCalculator', 'Installment Affordability Calculator');
            rtMap.put('InstallmentPayment', 'Installment Payment');
            rtMap.put('RevolvingCreditLimitUnsecured', 'Revolving Credit Limit Unsecured');   
            rtMap.put('RevolvingCreditLimitSecured', 'Revolving Credit Limit Secured');
            //rtMap.put('MultiProductCalculator', value);
            
            Loan_Calculator__c LoanObj = (Loan_Calculator__c) JSON.deserialize(CalculationData, Loan_Calculator__c.class);
            if(LoanObj != null){
                Id rtID = Schema.SObjectType.Loan_Calculator__c.getRecordTypeInfosByName().get(rtMap.get(radioGrpName)).getRecordTypeId();
                LoanObj.recordTypeId =rtID; 
                insert LoanObj;
                return LoanObj.Id;
            }
        }
        catch(Exception ex){
            System.debug(TAG + '' +ex.getMessage());
            return new AuraException(ex.getMessage());
        }
    }

}