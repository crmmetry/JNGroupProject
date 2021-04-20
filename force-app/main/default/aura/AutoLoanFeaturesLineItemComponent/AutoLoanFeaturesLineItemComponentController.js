({
  doinit: function (component, event, helper) {
    let data = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: "",
      proposedSavingsPercentage: null,
      proposedSavingsAmount: null,
      selection: null,
      processingFeePercentagePerAnum: null,
      interested: "",
      includeInLoan: "",
      premium: null,
      policyProvider: null,
      interestedInCreditorLife: null,
      includeCreditorLifeInLoanAmount: null,
      jngiIncludeInLoan: "",
      jngiMonthlyPremium: 0
    };
    component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      let data = copyInto(null, component.get("v.ParentContainer"));
      data = copyInto(data, component.get("v.ChildContainer"));
      helper.onProposedSavingsChange(component);
      helper.toggleShowIndicateApplicableProcessingFees(component, data);
      helper.toggleShowIncludeInLoanAmount(component, data);
      helper.resetProcessingFieldsValues(data, component);
      fireProductDetailsEvent(null, data, component);
    }
  },
  onInterestedInJNGIChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    if (selected === "Yes") {
      component.set("v.interestedInPremiumFlag", false);
    } else if (selected === "No") {
      component.find("includePremium").set("v.value", null);
      let jngiPremium = component.get("v.ChildContainer");
      jngiPremium.jngiMonthlyPremium = 0;
      jngiPremium.jngiIncludeInLoan = null;
      component.set("v.ChildContainer", jngiPremium);
      component.set("v.interestedInPremiumFlag", true);
    }
    let jngiPremium = component.get("v.ChildContainer");
    jngiPremium.interested = selected;
    component.set("v.ChildContainer", jngiPremium);
  },
  onProcessingFeePercentagePerAnumChange: function (component, event, helper) {
    const value = component.get("v.processingFeePercentagePerAnum");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.processingFeePercentagePerAnum = value;
    component.set("v.ChildContainer", creditRepaymentMap);
  },
  onIncludePremiumChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let jngiPremium = component.get("v.ChildContainer");
    jngiPremium.jngiIncludeInLoan = selected;
    component.set("v.ChildContainer", jngiPremium);
  },

  onInterestedInCreditorLifeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    if (selected === "Yes") {
      helper.showReasonWhenCLIsTaken(component);
      component.set("v.disableTogglerForJNLifeCLFields", false);
    } else if (selected === "No") {
      helper.showReasonWhenCLIsNotTaken(component);
    }
    let data = component.get("v.ChildContainer");
    data.interestedInCreditorLife = selected;
    component.set("v.ChildContainer", data);
  },

  onReasonChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.toggleReasonAction(component, selected);
  },

  onPolicyProviderChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.togglePolicyProviderAction(component, selected);
  },

  onShowReasonFlagChange: function (component, event, helper) {
    const selected = component.get("v.showReasonFlag");
    if (!selected) {
      helper.clearReasonData(component);
    }
  },

  onShowPolicyProviderFlagChange: function (component, event, helper) {
    const selected = component.get("v.showPolicyProviderFlag");
    if (!selected) {
      helper.clearPolicyProviderData(component);
    }
  },
  onshowOtherForPolicyProviderFlagChange: function (component, event, helper) {
    const selected = component.get("v.showPolicyProviderFlag");
    if (!selected) {
      helper.clearPolicyProviderOtherText(component);
    }
  },

  onshowOtherForReasonFlagChange: function (component, event, helper) {
    const selected = component.get("v.showPolicyProviderFlag");
    if (!selected) {
      helper.clearReasonOtherText(component);
    }
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let attributesToUpdate = [
      {
        key: "coverageType",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      attributesToUpdate,
      false
    );
    component.set("v.ChildContainer", data);
  },

  onIncludeCoverageChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let data = component.get("v.ChildContainer");
    data.includeCreditorLifeInLoanAmount = selected;
    component.set("v.ChildContainer", data);
  },

  onWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.waiveProcessingFeeFlag = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onIncludeWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.includeInLoanAmountFlag = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.repaymentMethod = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onMonthlyRepaymentDateChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.repaymentDate = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },
  /** Validates cmp fields - JN1-4201
   * @param {*} component
   * @return - Boolean
   */
  validateFields: function (component) {
    let cmpFields = [
      "credit-risk-rating",
      "interestedProgramme",
      "interestedCreditorLife",
      "Reason",
      "PolicyProvider",
      "otherPolicyProvider",
      "otherReason",
      "indicateRepaymentMethod",
      "dedicatedMonthlyRepaymentDate",
      "creditRiskScore",
      "monthlyPremium",
      "coverageType"
    ];
    let interestedInPremiumFlag = true;
    if (!component.get("v.interestedInPremiumFlag")) {
      let autoLoanFeatureComponentFields2 = ["includePremium"];
      interestedInPremiumFlag = validateFields(
        component,
        autoLoanFeatureComponentFields2
      );
    } else {
      let inputCmp = component.find("includePremium");
      $A.util.removeClass(inputCmp, "slds-has-error"); // remove red border
      $A.util.addClass(inputCmp, "hide-error-message"); // hide error message
    }

    let showIncludeInLoanAmount = true;
    if (!component.get("v.showIncludeInLoanAmount")) {
      let autoLoanFeatureComponentFields = ["includeInLoanAmountId"];
      showIncludeInLoanAmount = validateFields(
        component,
        autoLoanFeatureComponentFields
      );
    } else {
      let inputCmp = component.find("includeInLoanAmountId");
      $A.util.removeClass(inputCmp, "slds-has-error"); // remove red border
      $A.util.addClass(inputCmp, "hide-error-message"); // hide error message
    }

    let showIndicateApplicableProcessingFees = true;
    if (!component.get("v.showIndicateApplicableProcessingFees")) {
      let autoLoanFeatureComponentFields1 = [
        "indicateApplicableProcessingFees"
      ];
      showIndicateApplicableProcessingFees = validateFields(
        component,
        autoLoanFeatureComponentFields1
      );
    } else {
      let inputCmp = component.find("indicateApplicableProcessingFees");
      $A.util.removeClass(inputCmp, "slds-has-error"); // remove red border
      $A.util.addClass(inputCmp, "hide-error-message"); // hide error message
    }

    let resultsFromChild = [
      showIncludeInLoanAmount,
      showIndicateApplicableProcessingFees,
      interestedInPremiumFlag,
      validateFields(component, cmpFields)
    ];
    return isValidComponent(resultsFromChild);
  }
});
