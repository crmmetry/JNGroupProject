({
    doInit: function(component, event, helper) {
        const siteLead = {
            Primary_Employment_Type__c: ""
        };
        component.set("v.SiteLead", siteLead);
        helper.getPickListValues(component);
    },
    getEmploymentType: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Primary_Employment_Type__c"] = selected;
        component.set("v.SiteLead", siteLead);
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
        helper.updateApplicant(component);
    }
});