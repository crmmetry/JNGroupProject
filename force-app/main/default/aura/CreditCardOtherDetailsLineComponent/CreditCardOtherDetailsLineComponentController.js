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
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    data["containerName"] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
  },

  onCollateralTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "collateralType",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
    let flag = toggleCashInvestmentFlag(selected);
    component.set("v.cashInvestmentFlag", flag);
    //helper.clearDetailsWhenUnsecuredLoanSelected(selected);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onDeductFirstMonthRepaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  }
});
