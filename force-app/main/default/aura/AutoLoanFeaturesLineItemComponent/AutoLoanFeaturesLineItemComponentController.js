({
  doinit: function (component, event, helper) {
    const creditRepaymentMap = {
      repaymentMethod: "",
      repaymentDate: "",
      deductRepayment: ""
    };
    component.set("v.CreditRepayment", creditRepaymentMap);
    const loanSavings = {
      percentage: 0,
      amount: 0
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
      loanSavings.amount = 0;
    } else if (selected === "amount") {
      loanSavings.percentage = 0;
    }
    component.set("v.LoanSavingsContainer", loanSavings);
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
    // console.log("JNGI PREMIUM: ", JSON.stringify(jngiPremium));
    component.set("v.JNGIPremium", jngiPremium);
    // //disable fields based on whether applicant is interested in JNGI Programme or not
    // if(jngiPremium.interested === 'Yes'){
    //     console.log("DISABLE LOGIC REACHED");
    //     component.set("v.interestedInPremiumFlag", false);
    // } else {
    //     console.log('ELSE BLOCK');
    //     component.set("v.interestedInPremiumFlag", true);
    //     component.find("includePremium").set("v.value", ' ');
    //     let jngiPremium = component.get("v.JNGIPremium");
    //     jngiPremium.premium = 0;
    //     jngiPremium.includeInLoan = null;
    //     component.set("v.JNGIPremium", jngiPremium);
    // }
    // console.log(selected);
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
    console.log(selected);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditRepaymentMap = component.get("v.CreditRepayment");
    creditRepaymentMap.deductRepayment = selected;
    component.set("v.CreditRepayment", creditRepaymentMap);
    // component.set("v.CreditRepaymentContainer", creditRepaymentMap);
    // console.log(component.get("v.CreditRepayment.deductRepayment"));
    console.log(selected);
  }
});
