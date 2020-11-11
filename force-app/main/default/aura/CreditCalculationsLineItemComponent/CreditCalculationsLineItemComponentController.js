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
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
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
    component.set("v.ParentContainer", data);
  },
  /**
 * @param {*} component
 * @param {*} event
 * @param {*} helper
 */
  onParenContainerChange: function (component, event, helper) {
    console.log("scriptsLoaded", component.get("v.scriptsLoaded"));
    if (component.get("v.scriptsLoaded")) {
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
    }
  }
});
