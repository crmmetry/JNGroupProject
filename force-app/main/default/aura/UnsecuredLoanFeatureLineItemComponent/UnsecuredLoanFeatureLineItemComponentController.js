({
  doinit: function (component, helper, event) {
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: ""
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onCreditRepaymentChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.CreditRepaymentContainer"),
      component.get("v.CreditRepayment")
    );
    component.set("v.CreditRepaymentContainer", data);
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
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentMethod = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    // component.set("v.CreditRepaymentContainer", creditRepaymentMap);
    // console.log(component.get("v.CreditRepayment.repaymentMethod"));
  },

  onMonthlyRepaymentDateChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentDate = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    // component.set("v.CreditRepaymentContainer", creditRepaymentMap);
    // console.log(component.get("v.CreditRepayment.repaymentDate"));
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    // component.set("v.CreditRepaymentContainer", creditRepaymentMap);
    // console.log(component.get("v.CreditRepayment.deductRepayment"));
  }
});
