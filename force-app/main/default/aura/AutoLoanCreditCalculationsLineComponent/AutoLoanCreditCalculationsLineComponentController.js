({
  onPersonalAutoLoanChange: function (component, event, helper) {
    const result = basicPMTCalculator(['years', 'months', 'loanAmount', ',market'], component.get("v.PersonalAutoLoan"));
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", pmtResult);
    }
  }
});
