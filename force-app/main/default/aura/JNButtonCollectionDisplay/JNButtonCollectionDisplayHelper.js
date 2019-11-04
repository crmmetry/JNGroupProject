({
    getAccounts: function(component){
        let action = component.get("c.getAccounts");
        action.setParams({
            ids: component.get("v.Ids")
        });
        action.setCallback(this, function(response){
            const state = response.getState();
            if (state === "SUCCESS") {
                console.info(response.getReturnValue())
                component.set("v.contacts", response.getReturnValue());
            }
        });
	 $A.enqueueAction(action);
    }
})