({
  doInit: function(component, event, helper) {
    const siteLead = {
        Emergency_Contact_Relationship__c : "",
        Emergency_Contact_First_Name__c:'',
        Emergency_Contact_Last_Name__c:'',
        Emergency_Contact_Middle_Initial__c:'',
        Emergency_Contact_Mobile__c:'',
        Emergency_Contact_Home_Phone__c:'',
        Emergency_Contact_Business_Phone__c:'',
        Emergency_Contact_Personal_Email__c:''
    };
    component.set("v.SiteLead", siteLead);
    helper.getPickListValues(component);
  },
  getApplicantRelationship: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Emergency_Contact_Relationship__c"] = selected;
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