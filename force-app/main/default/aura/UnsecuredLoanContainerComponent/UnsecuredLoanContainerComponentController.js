({
  doinit: function (component, event, helper) {},
  onRequestedDetailsContainerChange: function (component, event, helper) {
    console.warn(
      "RequestedDetailsContainer changing",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetailsContainer")))
    );
  }
});
