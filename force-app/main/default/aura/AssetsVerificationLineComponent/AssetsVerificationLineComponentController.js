({
  doinit: function (component, event) {
    let auraList = [
      "realEstateHoldings",
      "motorVehicles",
      "savingsAccount",
      "lifeInsurance",
      "pension",
      "otherAssets"
    ];
    component.set("v.auraIdList", auraList);
  },
  onToggleCheckAlChange: function (component, event, helper) {
    let checkBoxCmp = component.find("verificationToggle");
    checkBoxCmp.forEach((element) => {
      element.set("v.checked", component.get("v.toggleCheckAll"));
      if (component.get("v.toggleCheckAll")) {
        //set all verified fields to disabled
        let inputCmpIdList = component.get("v.auraIdList");
        inputCmpIdList.forEach((element) => {
          let inputCmp = component.find(element);
          inputCmp.set("v.disabled", true);
          let unverifiedCmp = component.find(element.concat("Unverified"));
          inputCmp.set("v.value", unverifiedCmp.get("v.value"));
        });
      } else {
        //set all verified fields to undisabled
        let inputCmpIdList = component.get("v.auraIdList");
        inputCmpIdList.forEach((element) => {
          let inputCmp = component.find(element);
          inputCmp.set("v.disabled", false);
          inputCmp.set("v.value", null);
        });
      }
    });
  },

  fireComponentEvent: function (cmp, event) {
    let cmpEvent = cmp.getEvent("AssetsEvent");
    let checkBoxCmpName = event.getSource().get("v.name");
    let checkBoxValue = event.getSource().get("v.checked");
    cmpEvent.setParams({
      componentName: checkBoxCmpName,
      checkedVar: checkBoxValue
    });
    cmpEvent.fire();
  },

  handleComponentEvent: function (component, event) {
    let componentName = event.getParam("componentName");
    let checkedValue = event.getParam("checkedVar");
    let inputCmp = component.find(componentName);
    let unverifiedInputCmp = component.find(componentName.concat("Unverified"));
    if (checkedValue) {
      inputCmp.set("v.disabled", true);
      //set value to the value of related unverified amount
      //add verified to component string as aura id
      //reference the aura id and reverence the attribute value
      //set the value of inputCmp  as that of the unverified amount
      inputCmp.set("v.value", unverifiedInputCmp.get("v.value"));
    } else {
      inputCmp.set("v.disabled", false);
      inputCmp.set("v.value", null);
    }
  },

  onChildVerifiedDataMapChange: function (component, event, helper) {
    component.set(
      "v.parentVerifiedDataMap",
      component.get("v.childVerifiedDataMap")
    );
  }
});
