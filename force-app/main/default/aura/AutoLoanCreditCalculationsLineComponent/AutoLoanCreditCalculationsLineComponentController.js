({
  /**
   * //TODO: refactor use only ChildContaier
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    component.set("v.ParentContainer", data);
    // on auto loan changes
    helper.calculateMonthlyP_ILoanAmount(component);
    // on credit repayment changes
    helper.setDeductRepaymentFlag(component);
    helper.calculateProcessingFee(component);
    //on loan savings change
    helper.calculateSavings(component);
    //on jngi changes
    helper.calculateJNGIPMT(component);
    helper.onJNGIPremiumChange(component);
  },
  onParenContainerChange: function (component, event, helper) {
    // on auto loan changes
    helper.calculateMonthlyP_ILoanAmount(component);
    // on credit repayment changes
    helper.setDeductRepaymentFlag(component);
    helper.calculateProcessingFee(component);
    //on loan savings change
    helper.calculateSavings(component);
    //on jngi changes
    helper.calculateJNGIPMT(component);
    helper.onJNGIPremiumChange(component);
  }
});
