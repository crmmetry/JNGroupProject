({
    getPickListValues: function(component) {
        const action = component.get("c.getPickListValuesList");
        action.setParams({
            objectApiName: "Lead",
            fieldApiNames: [
                "Lead_Title__c",
                "Gender__c",
                "Marital_Status__c",
                "Country__c",
                "Suffix__c",
                "Highest_Level_of_Education_Attained__c"
            ]
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const mappedList = response.getReturnValue();
                component.set("v.titles", mappedList["Lead_Title__c"]);
                component.set("v.genders", mappedList["Gender__c"]);
                component.set("v.maritalStatuses", mappedList["Marital_Status__c"]);
                const countries = mappedList["Country__c"].filter(function(country) {
                    return country !== "Jamaica";
                });
                component.set("v.countries", countries);
                component.set("v.suffixes", mappedList["Suffix__c"]);
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
        console.log("General Details", component.get("v.SiteLead"))
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
                console.info(response.getReturnValue());
                let siteLead = component.get("v.SiteLead");
                
                Object.assign(siteLead, response.getReturnValue());
                component.set("v.SiteLead", siteLead);
                this.sendEvents(
                    component,
                    [ "setLeadInfo", "navigateNext"],
                    {"Id": siteLead.Id}
                );
            } else {
                console.error(JSON.parse(JSON.stringify(response.getError())));
            }
        });
        $A.enqueueAction(action);
    }
});