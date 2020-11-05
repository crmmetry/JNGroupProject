({
  onPersonalAutoLoanChange: function (component, event, helper) {
    console.log(
      "Credit Calculations",
      JSON.parse(JSON.stringify(component.get("v.PersonalAutoLoan")))
    );
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.PersonalAutoLoan")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", result);
    }
    helper.calculateJNGIPMT(component);
  },

  onJNGIPremiumChange: function (component, event, helper) {
    let jngiPremium = component.get("v.JNGIPremium");
    if (jngiPremium.includeInLoan === "No") {
      component.set("v.showPremiumInFeesAndCharges", true);
      component.set("v.showPremiumInCreditCalculations", false);
    } else {
      component.set("v.showPremiumInCreditCalculations", true);
      component.set("v.showPremiumInFeesAndCharges", false);
    }
    let firstYearPremium = helper.calcualateFirstYearPremium(
      jngiPremium.premium
    );
    component.set("v.jngiMotorPremium", firstYearPremium);
    helper.calculateJNGIPMT(component);
  }
});
