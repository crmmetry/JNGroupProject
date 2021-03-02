({
    add: function (component, event, helper) {
        let newRow = { DebtInstitution: "", DebtAmount: "",Id: ""};
        let debtTypeSelected = component.find("debtType").get("v.value");
        let existingRows;
        if (debtTypeSelected == "Unsecured Loan") {
            existingRows = component.get("v.unsecuredLoanRecords");
            existingRows.push(newRow);
            component.set("v.unsecuredLoanRecords", existingRows);
        } else if (debtTypeSelected == "Motor Vehicle Loan") {
            existingRows = component.get("v.motorvehicalRecords");
            existingRows.push(newRow);
            component.set("v.motorvehicalRecords", existingRows);
        } else if (debtTypeSelected == "Mortgage/ Home Equity Loan") {
            existingRows = component.get("v.homeLoanRecords");
            existingRows.push(newRow);
            component.set("v.homeLoanRecords", existingRows);
        } else if (debtTypeSelected == "Credit Card") {
            existingRows = component.get("v.creditCardRecords");
            existingRows.push(newRow);
            component.set("v.creditCardRecords", existingRows);
        } else if (debtTypeSelected == "Student Loan") {
            existingRows = component.get("v.studentLoanRecords");
            existingRows.push(newRow);
            component.set("v.studentLoanRecords", existingRows);
        } else if (debtTypeSelected == "Hire Purchase") {
            existingRows = component.get("v.hirePurchaseRecords");
            existingRows.push(newRow);
            component.set("v.hirePurchaseRecords", existingRows);
        } else if (debtTypeSelected == "Other") {
            existingRows = component.get("v.otherRecords");
            existingRows.push(newRow);
            component.set("v.otherRecords", existingRows);
        }
    },
    ChangeInDebtAmount: function (component, event, helper) {
        let eventValue = event.getParam("attributeValue");
        let rowToDelete = event.getParam("rowToDelete");
        let totalDebtMap = component.get("v.totalDebtAmtMap");
        if (eventValue != undefined) {
            let string1 = eventValue.split(":");
            totalDebtMap[string1[0]] = string1[1];
            component.set("v.totalDebtAmtMap", totalDebtMap);
            helper.calculateDebtAmt(component, totalDebtMap);
        } else if (rowToDelete != undefined) {
            helper.remove(component, rowToDelete);
        }
    },
    saveRecords: function(component, event, helper){
        let listOfRecordsToInsert = component.get("v.appAssetLiabilityList");
        let applicantId = component.get("v.applicantId");
        let accountId = component.get("v.accountId");
        let unsecuredLoanRecords = component.get("v.unsecuredLoanRecords");
        let objunsecuredLoanRecords = JSON.parse(JSON.stringify(unsecuredLoanRecords));
        for (let ulElement of objunsecuredLoanRecords)
        {
            
            let record = {};
            record.Debt_Type_List__c = "Unsecured Loan";
            record.Institution_Debt_List__c = ulElement['DebtInstitution'];
            record.Debt_Amount_Number__c = ulElement['DebtAmount'];
            if(ulElement['Id'] != undefined && ulElement['Id'] !=null && ulElement['Id'] !=''){
              record.Id = ulElement['Id'];
            }
            listOfRecordsToInsert.push(record);
        }
        let homeLoanRecords = component.get("v.homeLoanRecords");
        let objhomeLoanRecords = JSON.parse(JSON.stringify(homeLoanRecords));
        for (let hlElement of objhomeLoanRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Mortgage/ Home Equity Loan";
            record.Institution_Debt_List__c = hlElement['DebtInstitution'];
            record.Debt_Amount_Number__c = hlElement['DebtAmount'];
            if(hlElement['Id'] != undefined && hlElement['Id'] !=null && hlElement['Id'] !=''){
              record.Id = hlElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let motorvehicleRecords = component.get("v.motorvehicalRecords");
        let objmotorvehicleRecords = JSON.parse(JSON.stringify(motorvehicleRecords));
        for (let mvElement of objmotorvehicleRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Motor Vehicle Loan";
            record.Institution_Debt_List__c = mvElement['DebtInstitution'];
            record.Debt_Amount_Number__c = mvElement['DebtAmount'];
            if(mvElement['Id'] != undefined && mvElement['Id'] !=null && mvElement['Id'] !=''){
              record.Id = mvElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let creditCardRecords = component.get("v.creditCardRecords");
        let objcreditCardRecords = JSON.parse(JSON.stringify(creditCardRecords));
        for (let ccrElement of objcreditCardRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Credit Card";
            record.Institution_Debt_List__c = ccrElement['DebtInstitution'];
            record.Debt_Amount_Number__c = ccrElement['DebtAmount'];
            if(ccrElement['Id'] != undefined && ccrElement['Id'] !=null && ccrElement['Id'] !=''){
              record.Id = ccrElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let studentLoanRecords = component.get("v.studentLoanRecords");
        let objstudentLoanRecords = JSON.parse(JSON.stringify(studentLoanRecords));
        for (let slElement of objstudentLoanRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Student Loan";
            record.Institution_Debt_List__c = slElement['DebtInstitution'];
            record.Debt_Amount_Number__c = slElement['DebtAmount'];
            if(slElement['Id'] != undefined && slElement['Id'] !=null && slElement['Id'] !=''){
              record.Id = slElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let hirePurchaseRecords = component.get("v.hirePurchaseRecords");
        let objhirePurchaseRecords = JSON.parse(JSON.stringify(hirePurchaseRecords));
        for (let hpElement of objhirePurchaseRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Hire Purchase";
            record.Institution_Debt_List__c = hpElement['DebtInstitution'];
            record.Debt_Amount_Number__c = hpElement['DebtAmount'];
            if(hpElement['Id'] != undefined && hpElement['Id'] !=null && hpElement['Id'] !=''){
              record.Id = hpElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let otherRecords = component.get("v.otherRecords");
        let objotherRecords = JSON.parse(JSON.stringify(otherRecords));
        for (let otherElement of objotherRecords)
        {
            let record = {};
            record.Debt_Type_List__c = "Other";
            record.Institution_Debt_List__c = otherElement['DebtInstitution'];
            record.Debt_Amount_Number__c = otherElement['DebtAmount'];
            if(otherElement['Id'] != undefined && otherElement['Id'] !=null && otherElement['Id'] !=''){
              record.Id = otherElement['Id'];  
            }
            listOfRecordsToInsert.push(record);
        }
        let action = component.get("c.saveAssetLiablityRecords");
        let totalConsolidatedAmount = component.get("v.totalDebtAmount");
        let totalMonthlyAmount = component.get("v.totalMonthlyPayment");
        action.setParams({
            recordList : listOfRecordsToInsert,
            applId : applicantId,
            accId : accountId,
            totalMonthly : totalMonthlyAmount,
            totalConsolidated : totalConsolidatedAmount
            
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
            }
        });
        $A.enqueueAction(action);
        
        var navigate = component.get("v.navigateFlow");
        navigate(event.getParam("action"));
    },
    doInit: function(component, event, helper){
        let applicantId = component.get("v.applicantId");
        let action = component.get("c.getAssetLiabilityRecords");
        action.setParams({
            Id : applicantId
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let controllerResponse = response.getReturnValue();
                let totalDebtMap = component.get("v.totalDebtAmtMap");
                for(let allRecords of controllerResponse){
                    let newRow = { DebtInstitution: allRecords.Institution_Debt_List__c, DebtAmount: allRecords.Debt_Amount_Number__c, Id: allRecords.Id};
                    let debtTypeSelected = allRecords.Debt_Type_List__c;
                    let totalConsolidatedAmount = allRecords.Application__r.Total_Amount_Consolidated__c;
                    let totalMonthlyAmount = allRecords.Application__r.Total_Monthly_Payment__c;
                    let existingRows;
                    if (debtTypeSelected == "Unsecured Loan") {
                        existingRows = component.get("v.unsecuredLoanRecords");
                        existingRows.push(newRow);
                        component.set("v.unsecuredLoanRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Unsecured Loan'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Motor Vehicle Loan") {
                        existingRows = component.get("v.motorvehicalRecords");
                        existingRows.push(newRow);
                        component.set("v.motorvehicalRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Motor Vehicle Loan'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Mortgage/ Home Equity Loan") {
                        existingRows = component.get("v.homeLoanRecords");
                        existingRows.push(newRow);
                        component.set("v.homeLoanRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Mortgage/ Home Equity Loan'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Credit Card") {
                        existingRows = component.get("v.creditCardRecords");
                        existingRows.push(newRow);
                        component.set("v.creditCardRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Credit Card'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Student Loan") {
                        existingRows = component.get("v.studentLoanRecords");
                        existingRows.push(newRow);
                        component.set("v.studentLoanRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Student Loan'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Hire Purchase") {
                        existingRows = component.get("v.hirePurchaseRecords");
                        existingRows.push(newRow);
                        component.set("v.hirePurchaseRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Hire Purchase'] = allRecords.Debt_Amount_Number__c;
                        
                    } else if (debtTypeSelected == "Other") {
                        existingRows = component.get("v.otherRecords");
                        existingRows.push(newRow);
                        component.set("v.otherRecords", existingRows);
                        
                        let length = existingRows.length-1;
                    	totalDebtMap[length+'_Other'] = allRecords.Debt_Amount_Number__c;
                        
                    }
                    component.set("v.totalMonthlyPayment", totalMonthlyAmount);
                    component.set("v.totalDebtAmount", totalConsolidatedAmount);
                }
                component.set("v.totalDebtAmtMap", totalDebtMap);
                helper.calculateDebtAmt(component, totalDebtMap);
            }
        });
        $A.enqueueAction(action);
    }
});