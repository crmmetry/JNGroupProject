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
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.ConsolidatedDebts", result);
      }
    });
    $A.enqueueAction(action);
  },

  saveFinancialDetailsAndDebtsHelper: function (component) {
    let verifiedFinancialData = component.get(
      "v.VerifiedDataMapWithUpdatedTotals"
    );
    let debtConsolidated = component.get("v.ConsolidatedDebts");
    let oppId = component.get("v.recordId");
    let action = component.get("c.saveFinancialDetailsAndConsolidatedDebts");
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
      if (key) {
        if (key.includes("Verified")) {
          verifiedMap[key] = financialMap[key];
        } else {
          unverifiedMap[key] = financialMap[key];
        }
      }
    }
    component.set("v.VerifiedDataMap", verifiedMap);
    component.set("v.UnverifiedDataMap", unverifiedMap);
    this.parseTotalFields(component);
  },

  parseTotalFields: function (component) {
    let verifiedMap = component.get("v.VerifiedDataMap");
    let totalFields = Object.keys(component.get("v.calculationsMap"));
    let totalsMap = new Map();
    for (let key in verifiedMap) {
      if (totalFields && totalFields.includes(key)) {
        totalsMap[key] = verifiedMap[key];
      }
    }
    component.set("v.VerifiedTotalsMap", totalsMap);
  },

  parseDebtConsolidatedData: function (component) {
    let consolidatedDebtsList = component.get("v.ConsolidatedDebts");
    let verifiedDebts = [];
    let unverifiedDebts = [];
    consolidatedDebtsList.forEach((consolidatedDebt) => {
      let verifiedDebt = new Map();
      let unverifiedDebt = new Map();
      let consolidatedDebtKeys = Object.keys(consolidatedDebt);
      consolidatedDebtKeys.forEach((consolidatedDebtKey) => {
        if (consolidatedDebtKey) {
          if (
            consolidatedDebtKey.includes("Verified") &&
            consolidatedDebtKeys
          ) {
            verifiedDebt[consolidatedDebtKey] =
              consolidatedDebt[consolidatedDebtKey];
          } else {
            unverifiedDebt[consolidatedDebtKey] =
              consolidatedDebt[consolidatedDebtKey];
          }
        }
      });
      verifiedDebts.push(verifiedDebt);
      unverifiedDebts.push(unverifiedDebt);
    });
    component.set("v.VerifiedDebts", verifiedDebts);
    component.set("v.UnverifiedDebts", unverifiedDebts);
  },

  /**
   * Gets the correlated income value for the selected primary source of Income.
   * @param {*} component
   * @return {Integer}
   */

  getSelectedPrimarySourceOfIncomeValue: function (component) {
    let primarySourceofIncomeMap = component.get("v.PrimarySourceOfIncomeMap");
    let primarySourceOfincomeField;
    let dataMap = component.get("v.ParentVerifiedDataMap");
    let primarySourceOfIncome = dataMap.primarySourceOfIncomeVerified;
    for (let key in primarySourceofIncomeMap) {
      if (primarySourceOfIncome) {
        if (primarySourceOfIncome.includes(key)) {
          primarySourceOfincomeField = primarySourceofIncomeMap[key];
          break;
        }
      }
    }
    return dataMap[primarySourceOfincomeField];
  },

  updateOpportunity: function (component, fieldName, value, btnLabel) {
    let action = component.get("c.updateFieldOnOpportunity");
    let oppId = component.get("v.recordId");
    action.setParams({
      oppId: oppId,
      fieldAPIName: fieldName,
      value: value
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        if (btnLabel == "Submit") {
          component.set("v.isSubmitted", value);
        } else if (btnLabel == "Verify") {
          component.set("v.isVerified", value);
        }
      }
    });
    $A.enqueueAction(action);
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
