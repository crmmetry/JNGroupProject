({
  doinit: function (component, event, helper) {
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

  onInterestedInJNGIChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
    const JNGIPremiumMap = {
      interested: "",
      includeInLoan: "",
      premium: null
    };
    component.set("v.JNGIPremium", JNGIPremiumMap);
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: "",
      processingFeePercentagePerAnum: null
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onJNGIPremiumChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.JNGIPremiumContainer"),
      component.get("v.JNGIPremium")
    );
    component.set("v.JNGIPremiumContainer", data);
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
      let jngiPremium = component.get("v.JNGIPremium");
      jngiPremium.premium = null;
      jngiPremium.includeInLoan = null;
      component.set("v.JNGIPremium", jngiPremium);
      component.set("v.interestedInPremiumFlag", true);
    }
    let jngiPremium = component.get("v.JNGIPremium");
    jngiPremium.interested = selected;
    console.log(selected);
    component.set("v.JNGIPremium", jngiPremium);
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

  onIncludePremiumChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let jngiPremium = component.get("v.JNGIPremium");
    jngiPremium.includeInLoan = selected;
    component.set("v.JNGIPremium", jngiPremium);
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
    //component.set('v.CreditRepayment.repaymentMethod', selected);
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentMethod = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onMonthlyRepaymentDateChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.repaymentDate = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    console.log(selected);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
  }
});
