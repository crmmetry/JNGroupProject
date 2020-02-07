({
  doInit: function(component, event, helper) {
    helper.getPickListValues(component);

    component.set("v.validate", function() {
      let userInput = component.find("picklistChoices");
      let value = userInput.get("v.value");
      if (userInput && value === "") {
        return {
          isValid: false,
          errorMessage: "Please fill all the required fields on the page."
        };
      } else {
        return { isValid: true };
      }
    });
  },
  setSelectedPicklist: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.crmmObjectSelected", selected);
  }
});