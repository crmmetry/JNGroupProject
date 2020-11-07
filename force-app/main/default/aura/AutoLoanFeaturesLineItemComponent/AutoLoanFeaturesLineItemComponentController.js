({
  doinit: function (component, event, helper) {
    const JNGIPremiumMap = {
      interested: "",
      includeInLoan: "",
      premium: null
    };
    component.set("v.JNGIPremium", JNGIPremiumMap);
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
      helper.toggleShowIndicateApplicableProcessingFees(component, component.get("v.CreditRepayment"));
      helper.toggleShowIncludeInLoanAmount(component, component.get("v.CreditRepayment"));
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
    creditRepaymentMap.waiveProcessingFeeFlag = (selected === 'Yes');
    component.set("v.CreditRepayment", creditRepaymentMap);
  },

  onIncludeWaiveProcessingFeeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.includeInLoanAmountFlag = (selected === 'Yes');
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
