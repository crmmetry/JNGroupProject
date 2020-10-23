({
  updateProductSelection: function (component) {
    let oppId = component.get("v.recordId");
    console.log("oppId ", oppId);
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
        console.log("Price: ", result.productPrice);
        component.set("v.productSelection", result);
        this.updateProductSelectedFlag(component);
      }
    });

    $A.enqueueAction(action);
  },

  updateProductSelectedFlag: function (component) {
    let selectedFlag = component.get("v.productSelection.productFamily");
    const families = [
      { name: "Auto", variable: "autoFlag" },
      { name: "Unsecured", variable: "unsecuredFlag" },
      { name: "Credit Card", variable: "creditCardFlag" },
      { name: "Line Of Credit", variable: "lineOfCreditFlag" }
    ];
    const family = families.find((family) => {
      return selectedFlag.includes(family.name);
    });
    if (family) {
      component.set(`v.${family.variable}`, true);
    }
  }
});
