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
      const data = Object.assign(
        component.get("v.ParentContainer"),
        component.get("v.ChildContainer")
      );
      helper.onProposedSavingsChange(component);
      helper.toggleShowIndicateApplicableProcessingFees(component, data);
      helper.toggleShowIncludeInLoanAmount(component, data);
      helper.resetProcessingFieldsValues(data, component);
      fireProductDetailsEvent(null, data, component);
    }
  },
  onInterestedInJNGIChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [];
    if (selected === "Yes") {
      component.set("v.interestedInPremiumFlag", false);
    } else if (selected === "No") {
      component.find("includePremium").set("v.value", null);
      childKeyValuePairs = childKeyValuePairs.concat([
        {
          key: "jngiMonthlyPremium",
          value: 0
        },
        {
          key: "jngiIncludeInLoan",
          value: ""
        }
      ]);
      component.set("v.interestedInPremiumFlag", true);
    }
    childKeyValuePairs = childKeyValuePairs.concat([
      {
        key: "interestedInJNGIPremium",
        value: selected
      }
    ]);
    helper.updateChildContainer(component, childKeyValuePairs, false);
  },
  onProcessingFeePercentagePerAnumChange: function (component, event, helper) {
    const value = component.get("v.processingFeePercentagePerAnum");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.processingFeePercentagePerAnum = value;
    component.set("v.ChildContainer", creditRepaymentMap);
  },
  onIncludePremiumChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    const childKeyValuePairs = [
      {
        key: "jngiIncludeInLoan",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
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
      "includePremium",
      "interestedCreditorLife",
      "Reason",
      "PolicyProvider",
      "otherPolicyProvider",
      "otherReason",
      "includeInLoanAmountId",
      "indicateRepaymentMethod",
      "dedicatedMonthlyRepaymentDate",
      "proposedSavings",
      "saving",
      "amount",
      "creditRiskScore",
      "monthlyPremium",
      "coverageType",
      "indicateApplicableProcessingFees"
    ];
    return validateFields(component, cmpFields);
  }
});
