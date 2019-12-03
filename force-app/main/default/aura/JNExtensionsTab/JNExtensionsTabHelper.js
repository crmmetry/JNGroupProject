({
    createExtensions: function(component) {
        let extensionList = component.get("v.extensionList");
        let items = {};
        extensionList.forEach(function(element, index) {
            items[index + ""] = element;
        });
        
        const action = component.get("c.createPersonExtensions");
        action.setParams({
            values: items,
            leadId: component.get("v.leadId")
        });
        this.sendEvents(component, ["showLoading"]);
        action.setCallback(this, function(response) {
            this.sendEvents(component, ["disableShowLoading"]);
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.extensionList", []);               
                this.sendEvents(
                    component,
                    ["navigateNext"],
                    response.getReturnValue()
                );
            } else {
                const err = response.getError();
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
    }
});