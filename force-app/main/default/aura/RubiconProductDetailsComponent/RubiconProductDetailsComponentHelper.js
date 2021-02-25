({
  getIDMDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getIDMProductDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        component.set("v.IDMDataMap", result);
      }
    });
    $A.enqueueAction(action);
  },
  getCreditCardType: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSingleProductFamilySelection");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        if (result.productName.includes("Classic")) {
          component.set("v.cardType", "Classic");
        } else {
          component.set("v.cardType", "Gold");
        }
        component.set("v.ProductSelectionMap", result);
      }
    });
    $A.enqueueAction(action);
  },
  getNumberOfSupplementaryHolders: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSupplementaryCardHolders");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        if (result.length > 0) {
          component.set("v.hasSupplementaryCardHolders", "Yes");
        } else {
          component.set("v.hasSupplementaryCardHolders", "No");
        }
      }
    });
    $A.enqueueAction(action);
  },

  getApplicantsMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getApplicantsDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && result != "None") {
        component.set("v.applicantAge", result[0].age);
        component.set("v.ApplicantDetails", result[0]);
      }
    });
    $A.enqueueAction(action);
  },

  getOpportunityDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getOpportunityDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && result != "None") {
        component.set("v.OpportunityDataMap", result);
      }
    });
    $A.enqueueAction(action);
  },

  setPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Loan_Calculation_Product__c",
      fieldApiNames: ["Loan_Purpose_List__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set("v.loanPurpose", values["Loan_Purpose_List__c"]);
      }
    });
    $A.enqueueAction(action);
  }
});
