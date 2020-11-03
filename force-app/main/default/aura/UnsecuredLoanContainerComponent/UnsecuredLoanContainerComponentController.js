({
  doinit: function (component, event, helper) {},
  onRequestedDetailsContainerChange: function (component, event, helper) {
    console.warn(
      "RequestedDetailsContainer changing",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetailsContainer")))
    );
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: ""
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
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

  onWaveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onIncludeWaveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    //component.set('v.CreditRepayment.repaymentMethod', selected);
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentMethod = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    console.log(component.get("v.CreditRepayment.repaymentMethod"));
  },

  onMonthlyRepaymentDateCHange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentDate = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    console.log(component.get("v.CreditRepayment.repaymentDate"));
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    console.log(component.get("v.CreditRepayment.deductRepayment"));
  }
});
