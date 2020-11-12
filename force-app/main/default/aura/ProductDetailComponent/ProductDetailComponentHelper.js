({
  updateProductSelection: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSingleProductFamilySelection");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
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
  },
  getJNConfigurations: function (component) {
    let action = component.get("c.GetJNConfigs");
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.jnDefaultConfigs", result);
      }
    });
    $A.enqueueAction(action);
  },

  getApplicants: function (component, oppId, tenure) {
    let action = component.get("c.getApplicantsRating");
    action.setParams({
      oppId: oppId,
      tenure: tenure
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.applicants", result);
        if (applicants.size() > 1) {
          component.set("v.multipleApplicantsFlag", true);
        }
        console.log(result);
        console.log(JSON.parse(JSON.stringify(component.get("v.applicants"))));
      }
    });
    $A.enqueueAction(action);
  }
});
