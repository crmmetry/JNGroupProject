({
  doInit: function (component, event, helper) {
    let data = {
      requestedCreditLimit: component.get("v.productPrice"),
      market: null
    };
    component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    const childContainer = component.get("v.ChildContainer");
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      fireProductDetailsEvent(null, childContainer, component);
    }
  },
  /**
   * JN1-4212 : For validating fields
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let fieldsToValidateArray = ["locInterestRate"];
    return validateFields(component, fieldsToValidateArray);
  }
});
