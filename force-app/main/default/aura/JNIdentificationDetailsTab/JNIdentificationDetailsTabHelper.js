({
    getPickListValues: function(component) {
        const action = component.get("c.getPickListValuesList");
        action.setParams({
            objectApiName: "Lead",
            fieldApiNames: [
                "Country__c",
                "Identification_Type__c",       
            ]
                });
                action.setCallback(this, function(response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                const mappedList = response.getReturnValue();
                component.set("v.identificationTypes", mappedList["Identification_Type__c"]);
            const countries = mappedList["Country__c"].filter(function (country) {
            return country !== 'Jamaica';
        })
        component.set("v.countries", countries);
    } else {
}
 });
		$A.enqueueAction(action);
},
    updateApplicant: function(component) {
        const action = component.get("c.updateApplicantTextInfo");
        action.setParams({
            "applicantDetails":component.get("v.SiteLead"),
            "leadId": component.get("v.leadId")
        });
        this.sendEvents(component, ["showLoading"]);
        action.setCallback(this, function(response) {
            this.sendEvents(component, ["disableShowLoading"]);
            const state = response.getState();
            if (state === "SUCCESS") {
                this.sendEvents(
                    component,
                    ["navigateNext"],
                    {}
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
});