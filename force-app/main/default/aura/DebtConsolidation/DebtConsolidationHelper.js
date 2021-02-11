({
  calculateDebtAmt: function (component, debtAmount) {
    let existingValue = component.get("v.totalDebtAmount");
    existingValue = parseFloat(existingValue) + parseFloat(debtAmount);
    existingValue = existingValue;
    component.set("v.totalDebtAmount", existingValue);
  },
  remove: function (component, rowToDelete) {
    let deletedDebtAmt;
    let string1 = rowToDelete.split("_");
    if (string1[1] == "Unsecured Loan") {
      let existingRecords = component.get("v.unsecuredLoanRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.unsecuredLoanRecords", existingRecords);
    } else if (string1[1] == "Motor Vehicle Loan") {
      let existingRecords = component.get("v.motorvehicalRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.motorvehicalRecords", existingRecords);
    } else if (string1[1] == "Mortgage/ Home Equity Loan") {
      let existingRecords = component.get("v.homeLoanRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.homeLoanRecords", existingRecords);
    } else if (string1[1] == "Credit Card") {
      let existingRecords = component.get("v.creditCardRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.creditCardRecords", existingRecords);
    } else if (string1[1] == "Student Loan") {
      let existingRecords = component.get("v.studentLoanRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.studentLoanRecords", existingRecords);
    } else if (string1[1] == "Hire Purchase") {
      let existingRecords = component.get("v.hirePurchaseRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.hirePurchaseRecords", existingRecords);
    } else if (string1[1] == "Other") {
      let existingRecords = component.get("v.otherRecords");
      deletedDebtAmt = existingRecords[string1[0]].DebtAmount;
      existingRecords.splice(string1[0], 1);
      component.set("v.otherRecords", existingRecords);
    }

    this.calculateDebtAmt(component, -deletedDebtAmt);
  }
});
