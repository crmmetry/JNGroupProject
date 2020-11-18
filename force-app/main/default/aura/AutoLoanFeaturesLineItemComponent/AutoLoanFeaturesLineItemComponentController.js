({
  doinit: function (component, event, helper) {
    let data = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: "",
      percentage: null,
      amount: null,
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

  onChildContainerChange: function (component, event, helper) {
    console.log("CHild COntainer changed");
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    data['containerName'] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
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
  },

  onInterestedInJNGIChange: function (component, event, helper) {
    console.log("Interest");
    const selected = event.getSource().get("v.value");
    if (selected === "Yes") {
      console.log("Yes");
      component.set("v.interestedInPremiumFlag", false);
    } else if (selected === "No") {
      console.log("No");
      component.find("includePremium").set("v.value", null);
      let jngiPremium = component.get("v.ChildContainer");
      jngiPremium.jngiMonthlyPremium = 0;
      jngiPremium.jngiIncludeInLoan = null;
      component.set("v.ChildContainer", jngiPremium);
      component.set("v.interestedInPremiumFlag", true);
    }
    let jngiPremium = component.get("v.ChildContainer");
    jngiPremium.interested = selected;
    console.log(selected);
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
    console.log(selected);
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
    console.log(selected);
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
    creditRepaymentMap.waiveProcessingFeeFlag = selected === "Yes";
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onIncludeWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.includeInLoanAmountFlag = selected === "Yes";
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
  }
});