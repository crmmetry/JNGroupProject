({
    calculateDebtAmt : function(component, debtAmount) {
        var existingValue = component.get("v.totalDebtAmount");
        console.log('existingValue::before',existingValue);
        console.log('debtAmount::before',debtAmount);
        existingValue = parseFloat(existingValue) + parseFloat(debtAmount);
        existingValue = existingValue ;
        console.log('existingValue::after',existingValue);
        component.set("v.totalDebtAmount", existingValue);
    },
    remove : function(component, rowToDelete) {
        debugger;
        var deletedDebtAmt;
        var string1 = rowToDelete.split("_");
        console.log('string1',string1);
        if(string1[1] == 'Unsecured Loan'){
            var existingRecords = component.get("v.unsecuredLoanRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.unsecuredLoanRecords", existingRecords);
        }else if(string1[1] == 'Motor Vehicle Loan'){
            var existingRecords = component.get("v.motorvehicalRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.motorvehicalRecords", existingRecords);
        }else if(string1[1] == 'Mortgage/ Home Equity Loan'){
            var existingRecords = component.get("v.homeLoanRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.homeLoanRecords", existingRecords);
        }else if(string1[1] == 'Credit Card'){
            var existingRecords = component.get("v.creditCardRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.creditCardRecords", existingRecords);
        }else if(string1[1] == 'Student Loan'){
            var existingRecords = component.get("v.studentLoanRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.studentLoanRecords", existingRecords);
        }else if(string1[1] == 'Hire Purchase'){
            var existingRecords = component.get("v.hirePurchaseRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.hirePurchaseRecords", existingRecords);
        }else if(string1[1] == 'Other'){
            var existingRecords = component.get("v.otherRecords");
            deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
            existingRecords.splice(string1[0], 1);
            component.set("v.otherRecords", existingRecords);
        }
        
        console.log('deletedDebtAmt'+deletedDebtAmt);
        this.calculateDebtAmt(component,-deletedDebtAmt);
    },
})