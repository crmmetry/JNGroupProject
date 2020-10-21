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
                this.updateProductSelectedFlag(component);
            }
        });

        $A.enqueueAction(action);
    },

    updateProductSelectedFlag : function(component) {
        let selectedFlag = component.get("v.productSelection.productFamily");
        if (selectedFlag.includes('Auto')){
            component.set("v.autoFlag", true);
            console.log("autoflag set ")
        }
        if (selectedFlag.includes('Unsecured')){
            component.set("v.unsecuredFlag", true);
            console.log("unsecuredflag set ")
        }
        if (selectedFlag.includes('Credit Card')){
            component.set("v.creditCardFlag", true);
            console.log("autoflag set ")
        }
        if (selectedFlag.includes('Line Of Credit')){
            component.set("v.locFlag", true);
            console.log("autoflag set ")
        }
    }
})
