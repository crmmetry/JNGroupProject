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

  onProcessingFeePercentagePerAnumChange: function (component, event, helper) {
    const value = component.get("v.processingFeePercentagePerAnum");
    let creditRepaymentMap = component.get("v.ChildContainer");
    creditRepaymentMap.processingFeePercentagePerAnum = value;
    component.set("v.ChildContainer", creditRepaymentMap);
  },

  onInterestedInCreditorLifeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
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
