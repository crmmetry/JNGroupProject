({
    /**
   * //TODO: refactor use only ChildContaier
   * @param {*} component 
   * @param {*} event 
   * @param {*} helper 
   */
  onRequestedDetailsChange: function (component, event, helper) {
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
    console.log("calculating onCreditRepaymentChange")
    helper.setDeductRepaymentFlag(component);
    helper.calculateProcessingFee(component);
  }
});
