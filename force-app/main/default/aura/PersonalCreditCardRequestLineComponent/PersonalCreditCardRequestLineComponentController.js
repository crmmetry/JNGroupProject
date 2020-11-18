({
  doInit: function (component, event, helper) {
    let data = {
      requestedCreditLimit: component.get("v.productPrice"),
      interestRate: null,
      numberOfSupplementaryCardHolders: null
    };
    component.set("v.ChildContainer", data);
  },

  onChildContainerChange: function (component, event, helper) {
    console.log("child container changed");
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    data["containerName"] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
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
