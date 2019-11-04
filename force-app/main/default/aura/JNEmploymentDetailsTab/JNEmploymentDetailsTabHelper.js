({
    getPickListValues: function(component) {
        const action = component.get("c.getPickListValues");
        action.setParams({
            objectApiName: "Lead",
            fieldApiName: "Primary_Employment_Type__c"
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const values = response.getReturnValue();
                component.set("v.employmentTypes", values);
            } else {
            }
        });
        $A.enqueueAction(action);
    }
});