({
  onRequestedDetailsChange: function (component, event, helper) {
    console.log(
      "Credit Calculations",
      JSON.parse(JSON.stringify(component.get("v.RequestedDetails")))
    );
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.RequestedDetails")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", result);
    }
  },

  onCreditRepaymentChange: function (component, event, helper) {
    console.log("Repayment deducted");
    let creditRepayment = component.get("v.CreditRepayment");
    if (creditRepayment.deductRepayment == "Yes") {
      console.log("flag set to true");
      component.set("v.deductRepaymentFlag", true);
    } else {
      component.set("v.deductRepaymentFlag", false);
    }
  }
});
