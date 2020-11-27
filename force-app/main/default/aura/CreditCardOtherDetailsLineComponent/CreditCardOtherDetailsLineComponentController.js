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
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onChildContainerChange: function (component, event, helper) {
    let container = component.get("v.ParentContainer");
    const childContainer = component.get("v.ChildContainer");
    let data = Object.assign(container, childContainer);
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      fireProductDetailsEvent(null, data, component);
    }
  },

  onCollateralTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "collateralType",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      childKeyValuePairs,
      false
    );
    component.set("v.ChildContainer", data);
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
