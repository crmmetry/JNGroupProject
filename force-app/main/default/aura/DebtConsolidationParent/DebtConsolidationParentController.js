({
  remove: function (component, event, helper) {
    let indexPosition = event.target.name;
    let setEvent = component.getEvent("setAttribute");
    setEvent.setParams({ rowToDelete: indexPosition });
    setEvent.fire();
  }
});
