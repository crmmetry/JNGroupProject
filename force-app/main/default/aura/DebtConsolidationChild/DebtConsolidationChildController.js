({
    onChange : function(component, event, helper) {
        var inputfieldValue = component.find("DebtAmount").get("v.value");
        var setEvent = component.getEvent("setAttribute");
        setEvent.setParams({"attributeValue":inputfieldValue});
        setEvent.fire();
    }
})