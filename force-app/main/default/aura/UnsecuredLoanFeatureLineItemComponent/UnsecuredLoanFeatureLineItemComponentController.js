({
  doinit: function (component, helper, event) {
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: "",
      processingFeePercentagePerAnum: null
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
    const loanSavings = {
      percentage: null,
      amount: null,
      selection: null
    };
    component.set("v.LoanSavings", loanSavings);
  },
  onProcessingFeePercentagePerAnumChange: function (component, event, helper) {
    const value = component.get("v.processingFeePercentagePerAnum");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.processingFeePercentagePerAnum = value;
    component.set("v.CreditRepayment", creditRepaymentMap);
  },
  onCreditRepaymentChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.CreditRepaymentContainer"),
      component.get("v.CreditRepayment")
    );
    component.set("v.CreditRepaymentContainer", data);
    helper.toggleShowIndicateApplicableProcessingFees(
      component,
      component.get("v.CreditRepayment")
    );
    helper.toggleShowIncludeInLoanAmount(
      component,
      component.get("v.CreditRepayment")
    );
    helper.resetProcessingFieldsValues(data, component);
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

  onWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.waiveProcessingFeeFlag = selected === "Yes";
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onIncludeWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.includeInLoanAmountFlag = selected === "Yes";
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentMethod = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onMonthlyRepaymentDateChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentDate = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
  }
});
