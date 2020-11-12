({
  doInit: function (component, event, helper) {
    let data = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.ChildContainer", data);
  },
  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    component.set("v.ParentContainer", data);
    console.info(JSON.stringify(component.get("v.ChildContainer")));
  }
});
