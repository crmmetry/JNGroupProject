({
  doinit: function (component, event, helper) {
    helper.getFinancialInfo(component);
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
  },

  onVerifiedDebtsChange: function (component) {
    console.log(
      "verified debts change!!!!!!!!: ",
      JSON.parse(JSON.stringify(component.get("v.ConsolidatedDebts")))
    );
  },

  handleDebtInfoEvent: function (component, event) {
    const debtData = event.getParam("data");
    const index = event.getParam("index");
    const consolidatedDebts = component.get("v.ConsolidatedDebts");
    consolidatedDebts[index] = debtData;
    //component.set("v.ConsolidatedDebts", consolidatedDebts );
    console.log("debtInfo", JSON.parse(JSON.stringify(debtData)));
    console.log(
      "Consolidated Debts",
      JSON.parse(JSON.stringify(component.get("v.ConsolidatedDebts")))
    );
  },

  saveFinancialDetails: function (component, event, helper) {
    helper.saveFinancialDetailsAndDebtsHelper(component);
  }
});
