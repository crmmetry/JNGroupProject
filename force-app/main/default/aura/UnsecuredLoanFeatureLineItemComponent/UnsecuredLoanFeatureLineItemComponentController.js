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
      helper.toggleShowIndicateApplicableProcessingFees(
        component,
        component.get("v.ChildContainer")
      );
      helper.toggleShowIncludeInLoanAmount(
        component,
        component.get("v.ChildContainer")
      );
      helper.resetProcessingFieldsValues(data, component);
      fireProductDetailsEvent(
        null,
        component.get("v.ChildContainer"),
        component
      );
    }
  },
  onProcessingFeePercentagePerAnumChange: function (component, event, helper) {
    const value = component.get("v.processingFeePercentagePerAnum");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.processingFeePercentagePerAnum = value;
    component.set("v.ChildContainer", creditRepaymentMap);
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
    console.log(selected);
  },
  onReasonChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log("Reason changed");
    helper.toggleReasonAction(component, selected);
  },

  onPolicyProviderChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log("Policy Provider changed");
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
    console.log(selected);
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
    console.log(selected);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.ChildContainer", creditRepaymentMap);
  },
  /**
   * JN1-4210 : For validating fields
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let fieldsToValidateArray = [
      "unsecuredInterestedInCreditorLife",
      "unsecuredCoverageType",
      "unsecuredIncludeCoverage",
      "Reason",
      "PolicyProvider",
      "unsecuredOtherPolicyProvider",
      "unsecuredOtherReason",
      "unsecuredWaveProcessingFee",
      "includeInLoanAmountId",
      "unsecuredProcessingFeePercentPerAnum",
      "unsecuredRepaymentMethod",
      "unsecuredMonthlyRepaymentDate",
      "unsecuredDeductFirstMonthRepayment",
      "unsecuredProposedSavings",
      "unsecuredPercentage",
      "unsecuredAmount"
    ];
    return validateFields(component, fieldsToValidateArray);
  }
});
