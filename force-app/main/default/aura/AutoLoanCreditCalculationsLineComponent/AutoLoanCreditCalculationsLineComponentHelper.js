({
  calculateMonthlyP_ILoanAmount: function (component) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.ParentContainer")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
    } else {
      component.set("v.monthly_PI_LoanAmount", result);
    }
  },
  setDeductRepaymentFlag: function (component) {
    console.log("Repayment deducted");
    let creditRepayment = component.get("v.ParentContainer");
    if (creditRepayment.deductRepayment == "Yes") {
      component.set("v.deductRepaymentFlag", true);
    } else {
      component.set("v.deductRepaymentFlag", false);
    }
  },

  calculateSavings: function (component) {
    //TODO: refactor into calculations resource
    var PIMonthlyPayment = component.get("v.monthly_PI_LoanAmount");
    var personalAutoLoan = component.get("v.ParentContainer");
    var loanSavings = component.get("v.ParentContainer");
    console.log("Calcualte Savings Heloper");
    if (PIMonthlyPayment > 0) {
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
      } else {
        component.set("v.monthlyCompulsorySavings", 0);
        component.set("v.totalCompulsorySavingsBalance", 0);
      }
    }
  },
  calcualateFirstYearPremium: function (premium) {
    if (premium != null) {
      return premium * 12;
    }
  },

  calculateJNGIPMT: function (component) {
    let jngiPremium = component.get("v.ParentContainer");
    let personalAutoLoan = component.get("v.ParentContainer");
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
    const combinedFields = component.get("v.ParentContainer");
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
  onJNGIPremiumChange: function (component) {
    let jngiPremium = component.get("v.ParentContainer");
    if (jngiPremium.includeInLoan === "No") {
      component.set("v.showPremiumInFeesAndCharges", true);
      component.set("v.showPremiumInCreditCalculations", false);
    } else {
      component.set("v.showPremiumInCreditCalculations", true);
      component.set("v.showPremiumInFeesAndCharges", false);
    }
    let firstYearPremium = this.calcualateFirstYearPremium(
      jngiPremium.premium
    );
    component.set("v.jngiMotorPremium", firstYearPremium);

  }
});
