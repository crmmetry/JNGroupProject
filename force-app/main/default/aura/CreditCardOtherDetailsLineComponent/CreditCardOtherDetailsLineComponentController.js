({
  doInit: function (component, event, helper) {
    let data = {
      collateralType: null,
      interestedInJNLifeInsurance: null,
      coverageType: null,
      repaymentMethod: component.get("v.repaymentMethod"), //JN1-3928 :: Added by default value
      desiredRepaymentDate: null,
      containerName: "",
      noCreditorLifeReason: "", //JN1-4053 Creditor Life
      monthlyRepaymentDate: null
    };
    component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onChildContainerChange: function (component, event, helper) {
    const childContainer = component.get("v.ChildContainer");
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      fireProductDetailsEvent(null, childContainer, component);
    }
  },

  onCollateralTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let flag = toggleCashInvestmentFlag(selected);
    component.set("v.cashInvestmentFlag", flag);
    let childKeyValuePairs = [
      {
        key: "collateralType",
        value: selected
      },
      {
        key: "cashInvestmentFlag",
        value: flag
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      childKeyValuePairs,
      false
    );
    component.set("v.ChildContainer", data);
  },

  oninterestedInCreditorLifeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.toggleProductFlags(component);
    helper.toggleCreditorLifeFlags(component, selected);
    let attributesToUpdate = [
      {
        key: "interestedInCreditorLifeNonRevolving",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      attributesToUpdate,
      false
    );
    component.set("v.ChildContainer", data);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let attributesToUpdate = [
      {
        key: "coverageType",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      attributesToUpdate,
      false
    );
    component.set("v.ChildContainer", data);
  },

  onLifeInsuranceCoverageChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let attributesToUpdate = [
      {
        key: "lifeInsuranceCoverage",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      attributesToUpdate,
      false
    );
    component.set("v.ChildContainer", data);
  },

  onReasonChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.toggleReasonFlags(component, selected);
    let attributesToUpdate = [
      {
        key: "noCreditorLifeReason",
        value: selected
      }
    ];
    let data = updateChildContainerWithValue(
      component,
      attributesToUpdate,
      false
    );
    component.set("v.ChildContainer", data);
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
  },
  //JN1-3928 :: Added a method to bind selected monthly date change
  onMonthlyRepaymentDateChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let container = component.get("v.ChildContainer");
    container.monthlyRepaymentDate = selected;
    component.set("v.ChildContainer", container);
  }
});
