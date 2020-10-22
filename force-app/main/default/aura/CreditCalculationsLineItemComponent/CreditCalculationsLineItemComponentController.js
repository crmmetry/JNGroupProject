({
  onRequestedDetailsChange: function (component, event, helper) {
    console.log("Requested Details: ", component.get("v.RequestedDetails"));
    helper.calculateMonthlyP_ILoanAmount(
      component,
      component.get("v.RequestedDetails")
    );
  }
});
