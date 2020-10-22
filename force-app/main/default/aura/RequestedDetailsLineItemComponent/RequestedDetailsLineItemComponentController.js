({
  doInit: function (component, event, helper) {
    console.log("Requested: ", component.get("v.productPrice"));
    let requestedDetails = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.RequestedDetails", requestedDetails);
  },
  onRequestedDetailsChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.RequestedDetailsContainer"),
      component.get("v.RequestedDetails")
    );
    component.set("v.RequestedDetailsContainer", data);
  }
});
