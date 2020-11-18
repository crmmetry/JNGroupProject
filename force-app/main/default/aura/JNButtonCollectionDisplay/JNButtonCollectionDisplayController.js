({
  doInit: function (component, event, helper) {
    helper.getAccounts(component);
    component.set("v.validate", function () {
      if (component.get("v.selectedId") !== "") {
        return { isValid: true };
      } else {
        return { isValid: false, errorMessage: "Please make a selection." };
      }
    });
  },
  setSelected: function (component, event, helper) {
    const selected = component.get("v.selectedId");
    if (selected == "") {
      component.set("v.selectedId", event.currentTarget.name);
    } else {
      component.set("v.selectedId", "");
    }
  }
});