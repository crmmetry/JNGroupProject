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
  }
});
