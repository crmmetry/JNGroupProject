({
    updateProductSelection : function(component) {
        let oppId = component.get("v.recordId");
        console.log("oppId ", oppId)
        let productList = component.get("v.products");
        let productSelection = component.find("selectProduct");
        let action = component.get("c.opportunityProductSelector");
        action.setParams({
            oppId: oppId,
            productSelections: productList
        });
        action.setCallback(this, function (response) {
            let state = response.getState(); //Checking response status
            let result = response.getReturnValue();
            console.log("Result ", result);
            if (state == "SUCCESS") {
                console.log("success");
                productSelection.set("v.value", result);
            }
        });

        $A.enqueueAction(action);
    }
})
