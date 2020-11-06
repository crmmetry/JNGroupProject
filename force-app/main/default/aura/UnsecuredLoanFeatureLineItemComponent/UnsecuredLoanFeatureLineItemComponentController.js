({
  doinit: function (component, helper, event) {
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: ""
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
    const loanSavings = {
      percentage: null,
      amount: null,
      selection: null
    };
    component.set("v.LoanSavings", loanSavings);
  },

  onCreditRepaymentChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.CreditRepaymentContainer"),
      component.get("v.CreditRepayment")
    );
    component.set("v.CreditRepaymentContainer", data);
  },

  onProposedSavingsChange: function (component, event, helper) {
    const selected = component.get("v.value");
    console.log(selected);
    let loanSavings = component.get("v.LoanSavings");
    if (selected === "percent") {
      loanSavings.amount = null;
      loanSavings.selection = selected;
    } else if (selected === "amount") {
      loanSavings.percentage = null;
      loanSavings.selection = selected;
    }
    //component.set("v.LoanSavingsContainer", loanSavings);
    const data = Object.assign(
      component.get("v.LoanSavingsContainer"),
      component.get("v.LoanSavings")
    );
    component.set("v.LoanSavingsContainer", data);
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
