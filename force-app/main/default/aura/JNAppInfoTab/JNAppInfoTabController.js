({
  doInit: function (component, event, helper) {
    let siteLead = {
      Estimated_Amount__c: null,
      Preferred_Date_of_Contact__c: "",
      Preferred_Time_of_Contact__c: "",
      Preferred_Location__c: "",
      Loan_Purpose_UL__c: "",
      Gross_Monthly_Income__c: null,
      Gross_Monthly_Expenses__c: null
    };
    let current_datetime = new Date();
    let formatted_date =
      current_datetime.getFullYear() +
      "-" +
      (current_datetime.getMonth() + 1) +
      "-" +
      current_datetime.getDate();
    component.set("v.mindate", formatted_date);
    siteLead = helper.mapSiteLeadFields(siteLead, component.get("v.SiteLead"));
    component.set("v.SiteLead", siteLead);
    console.log("Info", JSON.parse(JSON.stringify(siteLead)));
    helper.getPickListValues(component);
  },
  getPreferredLocation: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Preferred_Location__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getLoanPurpose: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Loan_Purpose_UL__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  validateTabFields: function (component, event, helper) {
    return component.find("validation").reduce(function (validSoFar, inputCmp) {
      // Displays error messages for invalid fields
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get("v.validity").valid;
    }, true);
  }
});
