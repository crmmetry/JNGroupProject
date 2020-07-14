({
    getPickListValues: function(component) {
        const action = component.get("c.getPickListValuesList");
        action.setParams({
            objectApiName: "Lead",
            fieldApiNames: [
                "Salutation",
                "Gender__c",
                "Marital_Status__c",
                "Country__c",
                "Highest_Level_of_Education_Attained__c"
            ]
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const mappedList = response.getReturnValue();
                component.set("v.titles", mappedList["Salutation"]);
                component.set("v.genders", mappedList["Gender__c"]);
                component.set("v.maritalStatuses", mappedList["Marital_Status__c"]);
                const countries = mappedList["Country__c"].filter(function(country) {
                    return country !== "Jamaica";
                });
                component.set("v.countries", countries);
                component.set(
                    "v.educationLevels",
                    mappedList["Highest_Level_of_Education_Attained__c"]
                );
            } 
        });
        $A.enqueueAction(action);
    },
    sendEvents: function(component, events, data) {
        const eventToSend = component.getEvent("jnEvent");
        eventToSend.setParams({
            component: "JNApplicationForm",
            action: events,
            data: data
        });
        eventToSend.fire();
    },
    createLead: function(component) {
        let serviceofInterest;
        if (component.get("v.loan_type") == "credit_card") {
            serviceofInterest = "JN Bank Credit Card";
        } else {
            serviceofInterest = "JN Bank Unsecured Loan";
        }
        component.set("v.SiteLead.Service_of_Interest__c", serviceofInterest);
        const action = component.get("c.createLeadReferral");
        action.setParams({
            "applicantDetails": component.get("v.SiteLead")
        });
        this.sendEvents(component, ["showLoading"]);
        action.setCallback(this, function(response) {
            this.sendEvents(component, ["disableShowLoading"]);
            const state = response.getState();
            if (state === "SUCCESS") {
                let siteLead = component.get("v.SiteLead");               
                Object.assign(siteLead, response.getReturnValue());
                component.set("v.SiteLead", siteLead);
                this.sendEvents(
                    component,
                    [ "setLeadInfo", "navigateNext"],
                    {"Id": siteLead.Id}
                );
            } else {
                const commonError = "You're creating a duplicate record with an existing First and Last name.";
                this.showToast(component, {
                    severity: "error",
                    message: commonError
                });
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(component, data) {
        const siteLead = component.get("v.SiteLead");
        
        //user must complete step 2 and 3 first
        const severity = data.severity; 
        const title = data.title; 
        const message = data.message; 
        const toastContainer = component.find("toastContainer");
        toastContainer.displayMessage(severity, title, message);
        
    },
});