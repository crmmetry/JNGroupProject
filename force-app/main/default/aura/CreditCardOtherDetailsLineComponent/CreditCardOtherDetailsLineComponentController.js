({
  onCollateralTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    if (selected == "") {
      component.set("v.cashInvestmentFlag", true);
    }
    console.log(selected);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
