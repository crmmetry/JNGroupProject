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
    // console.log("child container changed");
    // const data = Object.assign(
    //   component.get("v.ParentContainer"),
    //   component.get("v.ChildContainer")
    // );
    // data["containerName"] = component.get("v.containerName");
    // component.set("v.ParentContainer", data);
    // fireProductDetailsEvent(null, data, component);
    let container = component.get("v.ParentContainer");
    const childContainer = component.get("v.ChildContainer");
    let data = Object.assign(container, childContainer);
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      console.log("interestRate: ", childContainer.interestRate);
      fireProductDetailsEvent(null, data, component);
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
