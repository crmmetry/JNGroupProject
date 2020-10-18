({
  doInit: function (component, event, helper) {
    let siteLead = {
      Primary_Employment_Type__c: ""
    };
    component.set("v.employedIndustries", [
      "Manufacturing",
      "Tourism",
      "Other",
      "Financial Services",
      "Government",
      "ICT",
      "None"
    ]);
    component.set("v.unEmployedIndustries", [
      "Manufacturing",
      "Tourism",
      "Other",
      "Financial Services",
      "Government",
      "ICT",
      "None"
    ]);
    component.set("v.selfEmployedIndustries", [
      "Manufacturing",
      "Tourism",
      "Agriculture",
      "Transportation",
      "Construction",
      "Retail Trade",
      "Other",
      "None"
    ]);
    component.set("v.employmentStatuses", ["Permanent", "Contractual"]);
    component.set("v.unEmploymentStatuses", ["Unemployed"]);
    helper.getPickListValues(component);
    siteLead = helper.mapSiteLeadFields(siteLead, component.get("v.SiteLead"));
    component.set("v.SiteLead", siteLead);
  },
  getEmploymentType: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.SiteLead.Primary_Employment_Type__c", selected);
  },
  validateTabFields: function (component, event, helper) {
    let fields = component.find("validation");
    if (!Array.isArray(fields)) {
      fields = [fields];
    }
    return fields.reduce(function (validSoFar, inputCmp) {
      // Displays error messages for invalid fields
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get("v.validity").valid;
    }, true);
  },
  // createDetails: function(component, event, helper) {
  //   //helper.updateApplicantInfo(component);
  //   helper.createLead(component);
  // },
  getAddressStatus: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Address_Status_PK__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getUnemployedAddressStatus: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Unemployed_Address_Status_PK__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getSelfEmployedAddressStatus: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Self_Employed_Address_Status_PK__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getIndustryEmployment: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Industry"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getSelfEmployedIndustry: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Industry"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getBusinessNature: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Nature_of_Engagement__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getEmploymentStatus: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Employment_Status__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getCountry: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Employer_Country__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getSelfEmployedCountry: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Employer_Country__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getUnemployedCountry: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Employer_Country__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getIndustryBusiness: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Industry"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  getBusinessType: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let siteLead = component.get("v.SiteLead");
    siteLead["Type_of_Business__c"] = selected;
    component.set("v.SiteLead", siteLead);
  },
  checkDateValidity: function (component, event, helper) {
    let cmp = event.getSource();
    let currentDateValue = cmp.get("v.value");
    if (new Date(currentDateValue).getTime() > new Date().getTime()) {
      cmp.setCustomValidity("Date cannot greater than today");
    } else {
      cmp.setCustomValidity("");
    }
    cmp.reportValidity();
  }
});
