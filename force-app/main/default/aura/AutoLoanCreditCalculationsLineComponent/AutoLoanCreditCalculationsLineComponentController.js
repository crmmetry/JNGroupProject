({
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  doInit: function (component, event, helper) {
    let data = {
      premium: 0
    };
    component.set("v.ChildContainer", data);
  },
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    console.info("onChildContainerChange 1");
    component.set("v.ParentContainer", data);
    console.info("onChildContainerChange 2");
  },
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onParenContainerChange: function (component, event, helper) {
    console.log("onParenContainerChange 1");
    // on auto loan changes
    helper.calculateMonthlyP_ILoanAmount(component);
    console.log("calculateMonthlyP_ILoanAmount 1");
    // on credit repayment changes
    helper.setDeductRepaymentFlag(component);
    helper.calculateProcessingFee(component);
    //on loan savings change
    helper.calculateSavings(component);
    //on jngi changes
    helper.calculateJNGIPMT(component);
    helper.onJNGIPremiumChange(component);
    //on JN creditor life changes
    helper.setAssignmentFees(component);
    helper.setEstimatedStampDutyFees(component);
    helper.calculateCreditorLifePremium(component);
  }
});
