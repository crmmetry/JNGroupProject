({
  doInit: function(component, event, helper) {},
  addExtension: function(component, event, helper) {
    let addRowInList = component.get("v.extensionList");
    let obj = new Map();
    addRowInList.push(obj);
    component.set("v.extensionList", addRowInList);
  },
  removeExtension: function(component, event, helper) {
    const eventAction = event.getParam("action");
    if (eventAction == "removeExtension") {
      const eventComponent = event.getParam("component");
      const data = event.getParam("data");
      const id = data.get("id");
      let extensionList = component.get("v.extensionList");

      if (eventComponent == "JNExtensionsTab") {
        extensionList.splice(id, 1);
        component.set("v.extensionList", extensionList);
      }
    }
  },
  validateTabFields: function(component, event, helper) {
    let components = component.find("layout");
    if (components) {
      if (!Array.isArray(components)) {
        components = [components];
      }
      return components.reduce(function(validSoFar, inputCmp) {
        // Displays error messages for invalid layouts
        return validSoFar && inputCmp.validateTabFields();
      }, true);
    }
    return true;
  },
  createExtensions: function(component, event, helper) {
    let siteLead;
    let extensionList = component.get("v.extensionList");
    let components = component.find("layout");
    if (components) {
      if (!Array.isArray(components)) {
        components = [components];
      }
      components.forEach(function(cmp, index) {
        siteLead = cmp.get("v.SiteLead");
        extensionList[index] = siteLead;
      });
      component.set("v.extensionList", extensionList);
      helper.createExtensions(component);
    } else {
      helper.sendEvents(component, ["navigateNext"]);
    }
  }
});