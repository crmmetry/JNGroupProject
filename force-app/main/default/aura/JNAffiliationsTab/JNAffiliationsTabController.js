({
  doInit: function (component, event, helper) {},
  addAffiliate: function (component, event, helper) {
    let addRowInList = component.get("v.affiliateList");
    let obj = new Map();
    addRowInList.push(obj);
    component.set("v.affiliateList", addRowInList);
  },
  removeAffiliate: function (component, event, helper) {
    const eventAction = event.getParam("action");
    if (eventAction == "removeAffiliate") {
      const eventComponent = event.getParam("component");
      const data = event.getParam("data");
      const id = data.get("layoutId");
      let affiliateList = component.get("v.affiliateList");

      if (eventComponent == "JNAffiliationsTab") {
        affiliateList.splice(id, 1);
        component.set("v.affiliateList", affiliateList);
      }
    }
  },
  createDetails: function (component, event, helper) {
    let siteLead;
    let affiliateList = component.get("v.affiliateList");
    let components = component.find("layout");
    if (components) {
      if (!Array.isArray(components)) {
        components = [components];
      }
      components.forEach(function (cmp, index) {
        siteLead = cmp.get("v.SiteLead");
        affiliateList[index] = siteLead;
      });
      component.set("v.affiliateList", affiliateList);
      helper.createAffiliates(component);
    } else {
      helper.sendEvents(component, ["navigateNext"]);
    }
  },
  validateTabFields: function (component, event, helper) {
    let components = component.find("layout");
    if (components) {
      if (!Array.isArray(components)) {
        components = [components];
      }
      return components.reduce(function (validSoFar, inputCmp) {
        // Displays error messages for invalid layouts
        return validSoFar && inputCmp.validateTabFields();
      }, true);
    }
    return true;
  }
});