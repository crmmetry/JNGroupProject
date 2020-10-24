({
  doinit: function (component, event, helper) {},
  onRequestedDetailsContainerChange: function (component, event, helper) {
    console.warn(
      "RequestedDetailsContainer changing",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetailsContainer")))
    );
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
