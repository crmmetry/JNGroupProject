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
        component.set("v.showComponentToggle", true);
        if (result.productName.includes("Classic")) {
          component.set("v.cardType", "Classic");
        } else {
          component.set("v.cardType", "Gold");
        }
        component.set("v.ProductSelectionMap", result);
      } else {
        component.set("v.showComponentToggle", false);
        this.showToast(
          "Oops! Something went wrong!",
          "Please check to ensure the correct product is selected for this opportunity.",
          "error"
        );
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
  },

  submitRubiconProductDetails: function (component) {
    let oppId = component.get("v.recordId");
    let fieldValueSets = {
      Product_Details_flag__c: true,
      Pre_Assessment_Submitted_flag__c: true
    };
    const action = component.get("c.updateFieldsOnOpportunity");
    action.setParams({
      oppId: oppId,
      fieldValueSets: fieldValueSets
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      const result = response.getReturnValue();
      if (state === "SUCCESS") {
        console.log("save successful");
        this.showToast(
          "Submission Successful",
          "Product Details was submitted successfully",
          "success"
        );
      } else {
        this.showToast(
          "Submission Failed",
          "Product Details was not submitted successfully",
          "error"
        );
      }
    });
    $A.enqueueAction(action);
  },

  /**
   * displays toast message
   * @param {String} title
   * @param {String} message
   * @param {String} type
   * @returns {Void}
   */
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
