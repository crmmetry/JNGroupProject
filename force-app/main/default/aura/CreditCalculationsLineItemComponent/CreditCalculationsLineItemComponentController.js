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
  /**
   * JN1-4210 : For validating fields
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let fieldsToValidateArray = [
      "creditApplicantLoanPercentage",
      "creditApplicantMonthlyLoanPercentage"
    ];
    return validateFields(component, fieldsToValidateArray);
  }
});
