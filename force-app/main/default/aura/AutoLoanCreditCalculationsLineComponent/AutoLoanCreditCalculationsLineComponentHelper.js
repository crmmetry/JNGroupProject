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

  calculateSavings: function (component) {
    var PIMonthlyPayment = component.get("v.monthly_PI_LoanAmount");
    var personalAutoLoan = component.get("v.PersonalAutoLoan");
    var loanSavings = component.get("v.LoanSavings");
    console.log("Calcualte Savings Heloper");
    if (PIMonthlyPayment != 0) {
      console.log("Calculate Savings begin");
      var tenure =
        Number(personalAutoLoan.years) * 12 + Number(personalAutoLoan.months);
      console.log(tenure);
      console.log(loanSavings.percentage);
      if (loanSavings.percentage > 0 && loanSavings.percentage) {
        console.log("Percentage>0");
        var monthlyCompulsorySavings =
          PIMonthlyPayment * loanSavings.percentage;
        var totalCompulsorySavings = monthlyCompulsorySavings * tenure;
        console.log(monthlyCompulsorySavings);
        console.log(totalCompulsorySavings);
        component.set("v.monthlyCompulsorySavings", monthlyCompulsorySavings);
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
      } else if (loanSavings.amount > 0 && loanSavings.amount) {
        component.set("v.monthlyCompulsorySavings", loanSavings.amount);
        var totalCompulsorySavings = loanSavings.amount * tenure;
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
      }
    }
  },
  calcualateFirstYearPremium: function (premium) {
    if (premium != null) {
      return premium * 12;
    }
  },

  calculateJNGIPMT: function (component) {
    let jngiPremium = component.get("v.JNGIPremium");
    let personalAutoLoan = component.get("v.PersonalAutoLoan");
    const pmtData = {
      years: personalAutoLoan.years,
      months: personalAutoLoan.months,
      loanAmount: component.get("v.jngiMotorPremium"),
      market: personalAutoLoan.market
    };
    console.table("PMT DATA: ", JSON.stringify(pmtData));
    console.table("JNGI DATA: ", JSON.stringify(jngiPremium));
    if (jngiPremium.interested == "Yes" && jngiPremium.includeInLoan == "Yes") {
      console.log("SUCCESS");
      const result = basicPMTCalculator(
        ["years", "months", "loanAmount", "market"],
        pmtData
      );
      if (!result) {
        component.set("v.monthlyPIJNGIMotorPremium", 0);
      } else {
        component.set("v.monthlyPIJNGIMotorPremium", result);
      }
    } else if (jngiPremium.interested === "No") {
      component.set("v.monthlyPIJNGIMotorPremium", 0);
      component.set("v.jngiMotorPremium", 0);
    }
  },
  calculateProcessingFee: function (component) {
    console.log(
      "Credit Repayment",
      JSON.parse(JSON.stringify(component.get("v.CreditRepayment"))),
      "Auto Loan",
      JSON.parse(JSON.stringify(component.get("v.PersonalAutoLoan")))
    );
    //TODO: CHANGE LATER TO CHILDCONTAINER, call in the personal auto loan change
    const combinedFields = Object.assign(
      {},
      component.get("v.CreditRepayment"),
      component.get("v.PersonalAutoLoan")
    );
    const {
      processingFee,
      monthlyProcessingFee,
      processingFeeClosingCost
    } = basicProcessingFeesCalculator(
      ["years", "months", "loanAmount", "market"],
      combinedFields,
      ["years", "months", "loanAmount", "market", "includeInLoanAmountFlag"],
      component.get("v.jnDefaultConfigs.gct")
    );

    component.set("v.processingFeesGCT", processingFee);
    component.set(
      "v.monthlyPrincipalInterestProcessingFee",
      monthlyProcessingFee
    );
    component.set("v.processingFeeClosingCost", processingFeeClosingCost);
  },

  resetCompulsorySavings: function (component) {
    component.set("v.monthlyCompulsorySavings", 0);
    component.set("v.totalCompulsorySavingsBalance", 0);
  }
});
