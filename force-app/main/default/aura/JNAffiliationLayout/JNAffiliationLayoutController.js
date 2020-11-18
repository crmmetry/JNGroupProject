({
  doInit: function (component, event, helper) {
    const sitelead = {
      First_Name__c: "",
      Last_Name__c: "",
      Afilliate_Type__c: "",
      JN_Location__c: "",
      Relationship__c: "",
      Role__c: "",
      Mobile_Number__c: "",
      Lead_and_Referral__c: component.get("v.leadId")
    };
    component.set("v.SiteLead", sitelead);
    helper.getPickListValues(component);
  },
  getLocation: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["JN_Location__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getRelationship: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Relationship__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getAffiliateType: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Afilliate_Type__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  removeAffiliate: function (component, event, helper) {
    const affiliateEvent = component.getEvent("jnEvent");
    const data = new Map();
    data.set("layoutId", component.get("v.layoutId"));
    affiliateEvent.setParams({
      component: "JNAffiliationsTab",
      action: "removeAffiliate",
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