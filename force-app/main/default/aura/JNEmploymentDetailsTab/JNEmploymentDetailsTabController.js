({
    doInit: function(component, event, helper) {
        const siteLead = {
            Primary_Employment_Type__c: ""
        };
        component.set("v.SiteLead", siteLead);
        component.set("v.SiteLeadUnemployed", siteLead);
        component.set("v.SiteLeadSelfEmployed", siteLead);
        helper.getPickListValues(component);
    },
    getEmploymentType: function(component, event, helper) {        
        const selected = event.getSource().get("v.value");
        component.set("v.SiteLead.Primary_Employment_Type__c", selected);
        component.set("v.SiteLeadUnemployed.Primary_Employment_Type__c", selected);
        component.set("v.SiteLeadSelfEmployed.Primary_Employment_Type__c", selected);
    },
    validateTabFields: function(component, event, helper) {
        let fields = component.find("validation");
        if (!Array.isArray(fields)) {
            fields = [fields];
        }
        return fields.reduce(function(validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
    },
    createDetails: function(component, event, helper) {
        helper.updateApplicantInfo(component);
    },
    getAddressStatus: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Address_Status_PK__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getUnemployedAddressStatus: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadUnemployed");
        siteLead["Unemployed_Address_Status_PK__c"] = selected;
        component.set("v.SiteLeadUnemployed", siteLead);
    },
    getSelfEmployedAddressStatus: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadSelfEmployed");
        siteLead["Self_Employed_Address_Status_PK__c"] = selected;
        component.set("v.SiteLeadSelfEmployed", siteLead);
    },
    getIndustryEmployment: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Industry"] = selected;
        component.set("v.SiteLead", siteLead);
    },
      getSelfEmployedIndustry: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadSelfEmployed");
        siteLead["Industry"] = selected;
        component.set("v.SiteLeadSelfEmployed", siteLead);
    },
          getBusinessNature: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadSelfEmployed");
        siteLead["Nature_of_Engagement__c"] = selected;
        component.set("v.SiteLeadSelfEmployed", siteLead);
    },
    getEmploymentStatus: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Employment_Status__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getCountry: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Employer_Country__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
        getSelfEmployedCountry: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadSelfEmployed");
        siteLead["Self_Employed_Country__c"] = selected;
        component.set("v.SiteLeadSelfEmployed", siteLead);
    },
    getUnemployedCountry: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadUnemployed");
        siteLead["Unemployed_Country__c"] = selected;
        component.set("v.SiteLeadUnemployed", siteLead);
    },
    getIndustryBusiness: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadUnemployed");
        siteLead["Industry"] = selected;
        component.set("v.SiteLeadUnemployed", siteLead);
    },
    getBusinessType: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLeadSelfEmployed");
        siteLead["Type_of_Business__c"] = selected;
        component.set("v.SiteLeadSelfEmployed", siteLead);
    }
});