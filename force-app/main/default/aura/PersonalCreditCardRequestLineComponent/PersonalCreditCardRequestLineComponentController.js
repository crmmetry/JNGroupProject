({
  doInit: function (component, event, helper) {
    let data = {
      requestedCreditLimit: component.get("v.productPrice"),
      interestRate: null
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
  }
});
