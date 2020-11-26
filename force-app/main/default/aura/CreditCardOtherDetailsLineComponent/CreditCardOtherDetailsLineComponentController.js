({
  doInit: function (component, event, helper) {
    let data = {
      collateralType: null,
      interestedInJNLifeInsurance: null,
      coverageType: null,
      repaymentMethod: null,
      desiredRepaymentDate: null,
      creditRiskScore: null,
      creditRiskRating: null,
      containerName: ""
    };
    component.set("v.ChildContainer", data);
    console.log("init called");
  },
  scriptsLoaded: function (component, event, helper) {
    console.log("scriptsloaded: ");
    component.set("v.scriptsLoaded", true);
    console.log("scriptsloaded: ", component.get("v.scriptsLoaded"));
  },

  onChildContainerChange: function (component, event, helper) {
    let container = component.get("v.ParentContainer");
    const childContainer = component.get("v.ChildContainer");
    let data = Object.assign(container, childContainer);
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      console.log("container changed but collateral: ", data.collateralType);
      fireProductDetailsEvent(null, data, component);
    }
  },

  onCollateralTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log("colatertal type changed: ", selected);
    console.log("scriptsloaded: ", component.get("v.scriptsLoaded"));
    let childKeyValuePairs = [
      {
        key: "collateralType",
        value: selected
      }
    ];
    console.log("chilkeyvalue pairs created ", childKeyValuePairs);
    helper.updateChildContainer(component, childKeyValuePairs, false);
    console.log("child container was updated with collateral type ");
    let flag = toggleCashInvestmentFlag(selected);
    component.set("v.cashInvestmentFlag", flag);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "repaymentMethod",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  }
});
