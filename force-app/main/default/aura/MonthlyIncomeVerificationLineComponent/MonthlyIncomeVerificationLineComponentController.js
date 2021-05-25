({
  doinit: function (component, event, helper) {
    helper.setPickListValues(component);
    let auraList = [
      "primaryIncomeSource",
      "grossSalaryAllowances",
      "otherIncome",
      "netBusinessIncomeSoleTrader",
      "directorEmoluments",
      "netBusinessIncomePartnership",
      "netBusinessIncomeCompanyShareholding",
      "pension",
      "propertyRental",
      "totalOtherIncome",
      "totalMonthlyIncome"
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
          if (
            element == "totalOtherIncome" ||
            element == "totalMonthlyIncome"
          ) {
            let unverifiedCmp = component.find(element.concat("Unverified"));
            inputCmp.set("v.value", unverifiedCmp.get("v.value"));
          } else {
            inputCmp.set("v.disabled", true);
            let unverifiedCmp = component.find(element.concat("Unverified"));
            inputCmp.set("v.value", unverifiedCmp.get("v.value"));
          }
        });
      } else {
        //set all verified fields to undisabled
        let inputCmpIdList = component.get("v.auraIdList");
        inputCmpIdList.forEach((element) => {
          let inputCmp = component.find(element);
          if (
            element == "totalOtherIncome" ||
            element == "totalMonthlyIncome"
          ) {
            inputCmp.set("v.value", null);
          } else {
            inputCmp.set("v.disabled", false);
            inputCmp.set("v.value", null);
          }
        });
      }
    });
  },
  fireComponentEvent: function (cmp, event) {
    let cmpEvent = cmp.getEvent("MonthlyIncomeEvent");
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
    let calculatedFields = component.get("v.calculatedFieldIds");
    let checkedValue = event.getParam("checkedVar");
    let inputCmp = component.find(componentName);
    let unverifiedInputCmp = component.find(componentName.concat("Unverified"));
    if (checkedValue) {
      if (calculatedFields.includes(componentName)) {
        inputCmp.set("v.value", unverifiedInputCmp.get("v.value"));
      } else {
        inputCmp.set("v.value", unverifiedInputCmp.get("v.value"));
        inputCmp.set("v.disabled", true);
      }
    } else {
      if (calculatedFields.includes(componentName)) {
        inputCmp.set("v.value", null);
      } else {
        inputCmp.set("v.value", null);
        inputCmp.set("v.disabled", false);
      }
    }
  },

  onChildVerifiedDataMapChange: function (component, event, helper) {
    console.log("verified map data changed");
    component.set(
      "v.parentVerifiedDataMap",
      component.get("v.childVerifiedDataMap")
    );
  }
});
