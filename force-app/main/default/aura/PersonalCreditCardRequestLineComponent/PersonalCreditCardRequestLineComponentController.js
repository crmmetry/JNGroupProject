({
  doInit: function (component, event, helper) {
    let data = {
      requestedCreditLimit: component.get("v.productPrice"),
      interestRate: null,
      numberOfSupplementaryCardHolders: null
    };
    component.set("v.ChildContainer", data);
  },

  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onChildContainerChange: function (component, event, helper) {
    let container = component.get("v.ParentContainer");
    const childContainer = component.get("v.ChildContainer");
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      console.log("interestRate: ", childContainer.interestRate);
      fireProductDetailsEvent(null, childContainer, component);
    }
  },

  onNumberOfSupplementaryCardHoldersChange: function (
    component,
    event,
    helper
  ) {
    const selected = event.getSource().get("v.value");
    helper.updateChildContainer(
      component,
      "numberOfSupplementaryCardHolders",
      selected
    );
    console.log(selected);
  }
});
