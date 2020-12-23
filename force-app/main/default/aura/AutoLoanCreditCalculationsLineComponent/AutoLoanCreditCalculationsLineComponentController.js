({
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  doInit: function (component, event, helper) {},
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onChildContainerChange: function (component, event, helper) {
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      fireProductDetailsEvent(
        null,
        component.get("v.ChildContainer"),
        component
      );
    }
  },
  /**
   * NOTE: do not mutate the ChildContainer in this function nor in any method invocations
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onParenContainerChange: function (component, event, helper) {
    // on credit repayment changes
    helper.setDeductRepaymentFlag(component);
    //assignment fees
    helper.setAssignmentFees(component);
    //stamp duty
    helper.setEstimatedStampDutyFees(component);
  },
  /** Validates cmp fields - JN1-4201
   * @param {*} component
   * @return - Boolean
   */
  validateFields: function (component) {
    let cmpFields = ["monthlyPayment", "loanAmount"];
    return validateFields(component, cmpFields);
  }
});
