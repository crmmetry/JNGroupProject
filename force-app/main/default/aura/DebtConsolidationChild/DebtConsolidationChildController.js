({
  onChange: function (component, event, helper) {
    let inputfieldValue = component.find("DebtAmount").get("v.value");
    let setEvent = component.getEvent("setAttribute");
    setEvent.setParams({ attributeValue: inputfieldValue });
    setEvent.fire();
  }
});
