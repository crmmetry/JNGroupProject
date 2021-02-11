({
  /**
   * Retrieves All financial Details belonging to an applicant on the opportunity.
   * @param {*} container
   */
  getFinancialInfo: function (component) {
    let action = component.get("c.getApplicantFinancialDetails");
    let oppId = component.get("v.recordId");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.FinancialDataMap", result);
        this.parseFinancialDataIntoVerifiedAndUnverifiedData(component);
      }
    });
    $A.enqueueAction(action);
  },

  /**
   * Retrieves All financial Details belonging to an applicant on the opportunity.
   * @param {*} container
   */
  getDebtsTobeConsolidated: function (component) {
    let action = component.get("c.getApplicantConsolidatedDebts");
    let oppId = component.get("v.recordId");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      //let indexList = [];
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.ConsolidatedDebts", result);
      }
    });
    $A.enqueueAction(action);
  },

  saveFinancialDetailsAndDebtsHelper: function (component) {
    let verifiedFinancialData = component.get("v.VerifiedDataMap");
    let debtConsolidated = component.get("v.ConsolidatedDebts");
    let oppId = component.get("v.recordId");
    let action = component.get("c.saveFinancialDetailsAndConsolidatedDebts");
    //let oppId = component.get("v.recordId");
    action.setParams({
      financialDetailsMap: verifiedFinancialData,
      oppId: oppId,
      consolidatedDebts: debtConsolidated
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        this.showToast(
          "Successful Save",
          "Your information has been successfully saved!",
          "success"
        );
      } else {
        //call showtoast
        let errors = response.getError();
        let message = "Unknown error"; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        this.showToast("Custom Permission Error", message, "error");
      }
    });
    $A.enqueueAction(action);
  },

  parseFinancialDataIntoVerifiedAndUnverifiedData: function (component) {
    let financialMap = component.get("v.FinancialDataMap");
    let verifiedMap = new Map();
    let unverifiedMap = new Map();
    for (let key in financialMap) {
      if (key.includes("Verified")) {
        verifiedMap[key] = financialMap[key];
      } else {
        unverifiedMap[key] = financialMap[key];
      }
    }
    component.set("v.VerifiedDataMap", verifiedMap);
    component.set("v.UnverifiedDataMap", unverifiedMap);
  },

  parseDebtConsolidatedData: function (component) {
    let consolidatedDebtsList = component.get("v.ConsolidatedDebts");
    let verifiedDebts = [];
    let unverifiedDebts = [];
    //const test = `${Verified}Verified`;
    consolidatedDebtsList.forEach((consolidatedDebt) => {
      let verifiedDebt = new Map();
      let unverifiedDebt = new Map();
      let consolidatedDebtKeys = Object.keys(consolidatedDebt);
      consolidatedDebtKeys.forEach((consolidatedDebtKey) => {
        if (consolidatedDebtKey.includes("Verified")) {
          verifiedDebt[consolidatedDebtKey] =
            consolidatedDebt[consolidatedDebtKey];
        } else {
          unverifiedDebt[consolidatedDebtKey] =
            consolidatedDebt[consolidatedDebtKey];
        }
      });
      verifiedDebts.push(verifiedDebt);
      unverifiedDebts.push(unverifiedDebt);
    });
    component.set("v.VerifiedDebts", verifiedDebts);
    component.set("v.UnverifiedDebts", unverifiedDebts);
  },

  showToast: function (title, message, type) {
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: title,
      message: message,
      type: type
    });
    toastEvent.fire();
  }
});
