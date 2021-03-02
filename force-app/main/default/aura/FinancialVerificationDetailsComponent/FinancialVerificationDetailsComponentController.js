({
  doinit: function (component, event, helper) {
    helper.getFinancialInfo(component);
    helper.getDebtsTobeConsolidated(component);
  },

  toggleCheckBoxes: function (component, event, helper) {
    let checkBoxVar = component.get("v.toggleCheckAll");
    let buttonCmp = event.getSource();
    if (checkBoxVar) {
      component.set("v.toggleCheckAll", false);
    } else if (!checkBoxVar) {
      component.set("v.toggleCheckAll", true);
    }
    if (buttonCmp.get("v.label") === "Check All") {
      buttonCmp.set("v.label", "Uncheck All");
    } else {
      buttonCmp.set("v.label", "Check All");
    }
  },

  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onVerifiedDataMapChange: function (component, event) {},

  onVerifiedDebtsChange: function (component) {},

  submitButtonAction: function (component, event, helper) {
    helper.updateOpportunity(
      component,
      "Final_Assessment_Submitted_flag__c",
      true,
      "Submit"
    );
    if (component.get("v.isSubmitted")) {
      this.showToast(
        "Submission Successful",
        "Fianancial Details was submitted successfully",
        "success"
      );
    }
  },

  verifyButtonAction: function (component, event, helper) {
    helper.updateOpportunity(
      component,
      "Documents_Financial_Info_Verified_flag__c",
      true,
      "Verify"
    );
    if (component.get("v.isVerified")) {
      this.showToast(
        "Verification Successful",
        "Fianancial Details was verified successfully",
        "success"
      );
    }
  },

  handleDebtInfoEvent: function (component, event) {
    const debtData = event.getParam("data");
    const index = event.getParam("index");
    const consolidatedDebts = component.get("v.ConsolidatedDebts");
    consolidatedDebts[index] = debtData;
  },

  saveFinancialDetails: function (component, event, helper) {
    helper.saveFinancialDetailsAndDebtsHelper(component);
  }
});
