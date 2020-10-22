({
  onRequestedDetailsChange: function (component, event, helper) {
    console.log(
      "Credit Calculations",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetails")))
    );
    helper.calculateMonthlyP_ILoanAmount(
      component,
      component.get("v.RequestedDetails")
    );
  }
});
