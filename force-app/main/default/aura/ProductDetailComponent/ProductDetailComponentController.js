({
  doInit: function (component, event, helper) {
    component.set("v.ChildContainer", {
      monthly_PI_LoanAmount: 0,
      processingFeeClosingCost: 0,
      monthlyPrincipalInterestProcessingFee: 0,
      processingFeesGCT: 0,
      existingDebt: 0
    });
    helper.updateProductSelection(component);
    helper.getJNConfigurations(component);
    helper.getAssetsAndLiabilitiesForApplicant(component);
    //helper.getApplicants(component);
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  handleProductDetailsEvent: function (component, event, helper) {
    if (component.get("v.scriptsLoaded")) {
      let container = Object.assign(
        component.get("v.ChildContainer"),
        event.getParam("payload")
      );
      let attributesToUpdate = [];
      // Calculate the monthly P&I Loan amount
      const monthlyPILoanAmount = monthlyPILoanAmountCalculation(container);
      attributesToUpdate.push({
        key: "monthly_PI_LoanAmount",
        value: monthlyPILoanAmount
      });
      //Calculate processing fees
      attributesToUpdate = attributesToUpdate.concat(
        helper.processingFeeCalculation(container, component)
      );
      const updatedContainer = updateChildContainerWithValue(
        component,
        attributesToUpdate,
        false
      );
      component.set("v.ChildContainer", updatedContainer);
      console.info(
        "Current Child",
        JSON.parse(JSON.stringify(component.get("v.ChildContainer")))
      );
    }
  }
});
