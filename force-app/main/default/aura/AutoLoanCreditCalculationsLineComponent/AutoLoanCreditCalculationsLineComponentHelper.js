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
    if (premium) {
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

  calculateCreditorLifePremium: function (component) {
    let data = component.get("v.ParentContainer");
    if (
      data.interestedInCreditorLife === "Yes" &&
      data.includeCreditorLifeInLoanAmount === "Yes"
    ) {
      let monthlyCLPremium = basicJNLifePremiumCalculator(
        data.loanAmount,
        data.rating
      );
      component.set("v.jnLifeCreditorPremium", monthlyCLPremium);
      const piProperties = {
        years: data.years,
        months: data.months,
        loanAmount: monthlyCLPremium,
        market: data.market
      };
      let pmtCLResult = basicPMTCalculator(
        ["years", "months", "loanAmount", "market"],
        piProperties
      );
      component.set("v.monthlyJnLifeCreditor_PI_Premium", pmtCLResult);
      console.log(monthlyCLPremium, pmtCLResult);
      component.set("v.includeCLPremiumFlag", false);
    } else if (
      data.interestedInCreditorLife === "Yes" &&
      data.includeCreditorLifeInLoanAmount === "No"
    ) {
      let monthlyCLPremium = basicJNLifePremiumCalculator(
        data.loanAmount,
        data.rating
      );
      component.set("v.jnCLPremiumFeesAndCharges", monthlyCLPremium);
      component.set("v.includeCLPremiumFlag", true);
      component.set("v.jnLifeCreditorPremium", 0);
      component.set("v.monthlyJnLifeCreditor_PI_Premium", 0);
    }
  },

  onJNGIPremiumChange: function (component) {
    let jngiPremium = component.get("v.ParentContainer");
    let childContainer = component.get("v.ChildContainer");
    if (jngiPremium.includeInLoan === "No") {
      component.set("v.showPremiumInFeesAndCharges", true);
      component.set("v.showPremiumInCreditCalculations", false);
    } else {
      component.set("v.showPremiumInCreditCalculations", true);
      component.set("v.showPremiumInFeesAndCharges", false);
    }
    let firstYearPremium = this.calcualateFirstYearPremium(
      childContainer.premium
    );
    component.set("v.jngiMotorPremium", firstYearPremium);
  },

  setAssignmentFees: function (component) {
    let data = component.get("v.ParentContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    console.log(JSON.stringify(data));
    console.log(JSON.stringify(jnDefaults));
    if (data.policyProvider != null) {
      let assignmentFee = basicAssignmentFeeCalculator(
        jnDefaults.gct,
        jnDefaults.assignmentFee
      );
      console.log(assignmentFee);
      component.set("v.assignmentFee", assignmentFee);
    } else {
      component.set("v.assignmentFee", 0);
    }
  },

  setEstimatedStampDutyFees: function (component) {
    let data = component.get("v.ParentContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    console.log(JSON.stringify(data));
    console.log(JSON.stringify(jnDefaults));
    if (data.policyProvider != null) {
      console.log(jnDefaults.estimatedStampDutyAndAdminFee);
      component.set(
        "v.estimatedStampDuty",
        jnDefaults.estimatedStampDutyAndAdminFee
      );
    } else {
      component.set("v.estimatedStampDuty", 0);
    }
  }
});
