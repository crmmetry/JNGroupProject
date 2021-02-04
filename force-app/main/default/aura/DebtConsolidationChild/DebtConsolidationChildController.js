({
  onChange: function (component, event, helper) {
    let indexPosition = component.find("DebtAmount").get("v.name");
    let inputfieldValue = component.find("DebtAmount").get("v.value");
    let setEvent = component.getEvent("setAttribute");
    setEvent.setParams({
      attributeValue: indexPosition + ":" + inputfieldValue
    });
    setEvent.fire();
  }
});
