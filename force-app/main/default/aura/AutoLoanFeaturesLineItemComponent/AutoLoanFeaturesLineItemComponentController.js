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
      premium: null
    };
    component.set("v.ChildContainer", data);
  },

  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
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
      jngiPremium.premium = null;
      jngiPremium.includeInLoan = null;
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
    jngiPremium.includeInLoan = selected;
    component.set("v.ChildContainer", jngiPremium);
    console.log(selected);
  },

  onInterestedInCreditorLifeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    if (selected == "Yes") {
      component.set("v.interestedInCreditorLifeFlag", true);
      component.set("v.showReasonFlag", false);
      console.log("Interested in CreditorLife is true");
    } else if (selected == "No") {
      component.set("v.interestedInCreditorLifeFlag", false);
      component.set("v.showReasonFlag", true);
      console.log("Interested in CreditorLife is false");
    }
    console.log(selected);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onIncludeCoverageChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
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
