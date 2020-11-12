({
  toggleShowIncludeInLoanAmount: function (component, parentObj) {
    if (parentObj.hasOwnProperty("waiveProcessingFeeFlag")) {
      if (parentObj.waiveProcessingFeeFlag) {
        component.set(`v.showIncludeInLoanAmount`, true);
      } else {
        component.set(`v.showIncludeInLoanAmount`, false);
      }
    }
  },
  toggleShowIndicateApplicableProcessingFees: function (component, parentObj) {
    if (
      parentObj.hasOwnProperty("waiveProcessingFeeFlag") &&
      parentObj.waiveProcessingFeeFlag === false
    ) {
      component.set("v.showIndicateApplicableProcessingFees", false);
    } else {
      component.set("v.showIndicateApplicableProcessingFees", true);
    }
  },
  resetProcessingFieldsValues: function (data, component) {
    if (typeof data["waiveProcessingFeeFlag"] !== "undefined") {
      if (data["waiveProcessingFeeFlag"] === true) {
        component.set("v.processingFeePercentagePerAnum", null);
        component.find("includeInLoanAmountId").set("v.value", "select one...");
      }
    }
  },
  onProposedSavingsChange: function (component) {
    const selected = component.get("v.value");
    let childContainer = component.get("v.ChildContainer");
    if (selected === "percent") {
      childContainer.amount = null;
      childContainer.selection = selected;
    } else if (selected === "amount") {
      childContainer.percentage = null;
      childContainer.selection = selected;
    }
  },

  showReasonWhenCLIsNotTaken: function (component) {
    component.set("v.interestedInCreditorLifeFlag", false);
    component.set("v.showReasonFlag", true);
    console.log("Interested in CreditorLife is false");
  },

  showReasonWhenCLIsTaken: function (component) {
    component.set("v.interestedInCreditorLifeFlag", true);
    component.set("v.showReasonFlag", false);
    component.set("v.showOtherForPolicyProviderFlag", false);
    component.set("v.showOtherForReasonFlag", false);
    component.set("v.showPolicyProviderFlag", false);
  },

  toggleReasonAction: function (component, selected) {
    if (selected === "exisiting life insurance policy to be assigned") {
      component.set("v.showPolicyProviderFlag", true);
      component.set("v.showOtherForReasonFlag", false);
    } else if (selected === "Other") {
      component.set("v.showOtherForReasonFlag", true);
      component.set("v.showPolicyProviderFlag", false);
    } else {
      component.set("v.showOtherForReasonFlag", false);
      component.set("v.showPolicyProviderFlag", false);
    }
  },

  togglePolicyProviderAction: function (component, selected) {
    if (selected === "Other") {
      component.set("v.showOtherForPolicyProviderFlag", true);
      let data = component.get("v.ChildContainer");
      data.policyProvider = selected;
      component.set("v.ChildContainer", data);
    } else if (selected === "Sagicor") {
      component.set("v.showOtherForPolicyProviderFlag", false);
      this.clearPolicyProviderOtherText(component);
      let data = component.get("v.ChildContainer");
      data.policyProvider = selected;
      component.set("v.ChildContainer", data);
    } else if (selected === "Gaurdian") {
      component.set("v.showOtherForPolicyProviderFlag", false);
      this.clearPolicyProviderOtherText(component);
      let data = component.get("v.ChildContainer");
      data.policyProvider = selected;
      component.set("v.ChildContainer", data);
    }
  },

  clearReasonData: function (component) {
    component.find("Reason").set("v.value", null);
  },

  clearPolicyProviderData: function (component) {
    component.find("PolicyProvider").set("v.value", null);
    let data = component.get("v.ChildContainer");
    data.policyProvider = null;
    component.set("v.ChildContainer", data);
  },

  clearPolicyProviderOtherText: function (component) {
    component.set("v.otherPolicyProvider", null);
  },

  clearReasonOtherText: function (component) {
    component.set("v.otherReason", null);
  }
});
