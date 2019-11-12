({
  doInit: function(component, event, helper) {
    const sitelead = {
      Identification_Type_Country_of_issue__c: "Jamaica",
      Identification_Type__c: "",
      Identification_Number__c: "",
      Identification_Type_Expiration__c: new Date()
    };
	let current_datetime = new Date();
      let formatted_date = current_datetime.getFullYear() + "-" + (current_datetime.getMonth() + 1) + "-" + current_datetime.getDate();
    component.set("v.mindate", formatted_date);
    console.log(component.get("v.mindate"));
    component.set("v.SiteLead", sitelead);
    helper.getPickListValues(component);
  },
  getIdentificationType: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Identification_Type__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getCountryofIssue: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Identification_Type_Country_of_issue__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  validateTabFields: function(component, event, helper) {
    return component.find("validation").reduce(function(validSoFar, inputCmp) {
      // Displays error messages for invalid fields
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get("v.validity").valid;
    }, true);
  },
         createDetails: function(component, event, helper) {
         helper.updateApplicant(component);
     }
});