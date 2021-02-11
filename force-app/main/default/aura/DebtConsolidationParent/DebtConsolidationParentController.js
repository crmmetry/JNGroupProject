({
  remove: function (component, event, helper) {
    var indexPosition = event.target.name;
    var setEvent = component.getEvent("setAttribute");
    setEvent.setParams({ rowToDelete: indexPosition });
    setEvent.fire();
  }
});
