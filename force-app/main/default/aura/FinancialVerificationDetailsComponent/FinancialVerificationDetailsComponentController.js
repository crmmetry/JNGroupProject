({
  doinit: function (component, event, helper) {
    helper.getUnverifiedFinancialInfo(component);
    helper.getDebtsTobeConsolidated(component);
  },

  toggleCheckBoxes: function (component, event, helper) {
    let checkBoxVar = component.get("v.toggleCheckAll");
    let buttonCmp = event.getSource();
    if (checkBoxVar) {
      component.set("v.toggleCheckAll", false);
      console.log("check all toggled to false");
    } else if (!checkBoxVar) {
      component.set("v.toggleCheckAll", true);
      console.log("check all toggled to true");
    }
    if (buttonCmp.get("v.label") === "Check All") {
      buttonCmp.set("v.label", "Uncheck All");
      console.log("button label change");
    } else {
      buttonCmp.set("v.label", "Check All");
      console.log("button label change");
    }
  },

  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onVerifiedDataMapChange: function (component, event) {
    console.log(JSON.parse(JSON.stringify(component.get("v.VerifiedDataMap"))));
  }

  // saveFinancialDetails: function (component, event) {
  //   helper.saveFinancialDetailsAndDebtsHelper(component);
  // }
});
