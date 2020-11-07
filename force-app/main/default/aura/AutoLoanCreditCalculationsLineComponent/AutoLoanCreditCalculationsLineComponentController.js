({
  /**
   * //TODO: refactor use only ChildContaier
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onPersonalAutoLoanChange: function (component, event, helper) {
    helper.calculateJNGIPMT(component);
    helper.calculateMonthlyP_ILoanAmount(component);
    helper.calculateProcessingFee(component);
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
    helper.calculateMonthlyP_ILoanAmount(component);
    helper.calculateProcessingFee(component);
  },
  /**
   * //TODO: refactor use only ChildContaier
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onCreditRepaymentChange: function (component, event, helper) {
    console.log("calculating onCreditRepaymentChange");
    helper.setDeductRepaymentFlag(component);
    helper.calculateProcessingFee(component);
  }
});
