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
        console.log("financial map", JSON.parse(JSON.stringify(result)));
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
        console.log(
          "debts to be consolidated",
          JSON.parse(JSON.stringify(component.get("v.ConsolidatedDebts")))
        );
      }
    });
    $A.enqueueAction(action);
  },

  saveFinancialDetailsAndDebtsHelper: function (component) {
    let verifiedFinancialData = component.get("v.VerifiedDataMap");
    let debtConsolidated = component.get("v.VerifiedDebts");
    let oppId = component.get("v.recordId");
    console.log(
      "verified financial details",
      JSON.parse(JSON.stringify(verifiedFinancialData))
    );
    console.log(
      "verified debts list",
      JSON.parse(JSON.stringify(debtConsolidated))
    );
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
        console.log("SUCCESS");
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
        console.log("verified field", key);
        verifiedMap[key] = financialMap[key];
      } else {
        console.log("unverified field", key);
        unverifiedMap[key] = financialMap[key];
      }
    }
    component.set("v.VerifiedDataMap", verifiedMap);
    component.set("v.UnverifiedDataMap", unverifiedMap);
    console.log("verified map", JSON.parse(JSON.stringify(verifiedMap)));
    console.log("unverified map", JSON.parse(JSON.stringify(unverifiedMap)));
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
    console.log(
      "parsed verified debts",
      JSON.parse(JSON.stringify(verifiedDebts))
    );
    console.log(
      "parsed unverified debts",
      JSON.parse(JSON.stringify(unverifiedDebts))
    );
  }
});
