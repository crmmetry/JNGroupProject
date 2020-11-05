({
  calculateMonthlyP_ILoanAmount: function (component) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.PersonalAutoLoan")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", result);
    }
  },
  setDeductRepaymentFlag: function (component) {
    console.log("Repayment deducted");
    let creditRepayment = component.get("v.CreditRepayment");
    if (creditRepayment.deductRepayment == "Yes") {
      component.set("v.deductRepaymentFlag", true);
    } else {
      component.set("v.deductRepaymentFlag", false);
    }
  },
  calculateProcessingFee: function (component) {
    const requiredDependencies = ["years", "months", "loanAmount", "market", "includeInLoanAmountFlag"];
    //TODO: CHANGE LATER TO CHILDCONTAINER, call in the personal auto loan change
    const combinedFields = Object.assign({}, component.get("v.CreditRepayment"), component.get("v.PersonalAutoLoan"));
    const allValid = asAllValidDependencies(requiredDependencies, combinedFields);
    console.info("combinedFields", combinedFields, "allValid", allValid);
    if (allValid) {
      let pmtResult = 0;
      if (combinedFields.includeInLoanAmountFlag && combinedFields.processingFeePercentagePerAnum) {
        const gct = calculateGCT(component.get("v.jnDefaultConfigs.gct"));
        combinedFields.loanAmount = (((combinedFields.processingFeePercentagePerAnum / 100) + gct) * combinedFields.loanAmount);
        pmtResult = basicPMTCalculator(["years", "months", "loanAmount", "market"], combinedFields);
      } else {
        pmtResult = basicPMTCalculator(["years", "months", "loanAmount", "market"], combinedFields);
      }
      component.set("v.processingFeesGCT", combinedFields.loanAmount);
      component.set("v.monthlyPrincipalInterestProcessingFee", pmtResult);
    } else {
      component.set("v.processingFeesGCT", 0);
      component.set("v.monthlyPrincipalInterestProcessingFee", 0);
    }
  }
})
