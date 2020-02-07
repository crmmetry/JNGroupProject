public class SimpleLoanCalculationController {
    
    @AuraEnabled
    Public static string SaveLoanCalculation(string CalculationData,string radioGrpName){
        system.debug('SaveLoanCalculation called============'+CalculationData +'...radioGrpName==>'+radioGrpName);
        string returnStr='';
        try{
            Map<string,string> rtMap = new Map<string,string>();
            rtMap.put('AffordabilityCalculator', 'Installment Affordability Calculator');
            rtMap.put('InstallmentPayment', 'Installment Payment');
            rtMap.put('RevolvingCreditLimitUnsecured', 'Revolving Credit Limit Unsecured');   
            rtMap.put('RevolvingCreditLimitSecured', 'Revolving Credit Limit Secured');
            //rtMap.put('MultiProductCalculator', value);
            
            Loan_Calculator__c LoanObj = (Loan_Calculator__c) Json.deserialize(CalculationData, Loan_Calculator__c.class);
            if(LoanObj != null){
                Id rtID = Schema.SObjectType.Loan_Calculator__c.getRecordTypeInfosByName().get(rtMap.get(radioGrpName)).getRecordTypeId();
                LoanObj.recordTypeId =rtID; 
                insert LoanObj;
                returnStr='Save';
            }
        }
        catch(Exception ex){
            returnStr=ex.getMessage();
            system.debug('Exception =>'+ex.getMessage() +'  Line Number => '+ex.getLineNumber());
        }
        return returnStr;
    }

}