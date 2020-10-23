({
  onPersonalAutoLoanChange: function (component, event, helper) {
    console.log(
      "Credit Calculations",
      JSON.parse(JSON.stringify(component.get("v.PersonalAutoLoan")))
    );
    helper.calculateMonthlyP_ILoanAmount(
      component,
      component.get("v.PersonalAutoLoan")
    );
  }
});
