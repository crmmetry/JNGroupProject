({
  doInit: function (component, event, helper) {
    const sitelead = {
      First_Name__c: "",
      Last_Name__c: "",
      Middle_Name__c: "",
      Afilliate_Type__c: "Credit Card Extension",
      Relationship__c: "",
      Title__c: "",
      TRN__c: ""
    };
    component.set("v.SiteLead", sitelead);
    helper.getPickListValues(component);
  },

  getRelationship: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Relationship__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getTitle: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Title__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },

  removeExtension: function (component, event, helper) {
    const affiliateEvent = component.getEvent("jnEvent");
    const data = new Map();
    data.set("layoutId", component.get("v.layoutId"));
    affiliateEvent.setParams({
      component: "JNExtensionsTab",
      action: "removeExtension",
      data
    });
    affiliateEvent.fire();
  },
  validateTabFields: function (component, event, helper) {
    return component.find("validation").reduce(function (validSoFar, inputCmp) {
      // Displays error messages for invalid fields
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get("v.validity").valid;
    }, true);
  }
});