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
        component.set("v.UnverifiedDebts", result);
        // result.forEach(element => {
        //   indexList.push(1);
        // });
        // component.set("v.listOfDebtIndices", indexList);
        console.log(
          "debts to be consolidated",
          JSON.parse(JSON.stringify(result))
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
  }
});
