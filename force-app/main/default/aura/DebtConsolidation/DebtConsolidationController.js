({
  add: function (component, event, helper) {
    let newRow = { DebtInstitution: "", DebtAmount: "" };
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
  }
});
