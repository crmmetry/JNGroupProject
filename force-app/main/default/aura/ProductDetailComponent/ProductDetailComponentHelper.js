({
    updateProductSelection : function(component) {
        let oppId = component.get("v.recordId");
        console.log("oppId ", oppId)
        let productSelection = component.find("selectProduct");
        let action = component.get("c.getSingleProductFamilySelection");
        action.setParams({
            oppId: oppId
        });
        action.setCallback(this, function (response) {
            let state = response.getState(); //Checking response status
            let result = response.getReturnValue();
            console.log("Result ", result);
            if (state === "SUCCESS") {
                console.log("success");
                component.set("v.productSelection", result);
            }
        });

        $A.enqueueAction(action);
    }
})
