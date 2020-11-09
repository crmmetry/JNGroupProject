({
  /**
   * //TODO: refactor use only ChildContaier
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onRequestedDetailsChange: function (component, event, helper) {
    console.log(
      "Credit Calculations",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetails")))
    );
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.RequestedDetails")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", result);
      helper.calculateSavings(component);
    }
  },

  onLoanSavingsChange: function (component, event, helper) {
    console.log("SavingsLoan Change");
    helper.calculateSavings(component);
    helper.calculateMonthlyP_ILoanAmount(component);
    helper.calculateProcessingFee(component);
    console.log("Saving Calculations done?");
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
