({
  calculateMonthlyP_ILoanAmount: function (component) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.ParentContainer")
    );
    component.set("v.monthly_PI_LoanAmount", result);
    this.updateChildContainerWithValue(component, [{ "key": "monthly_PI_LoanAmount", value: parseFloat(result) }]);
  },
  setDeductRepaymentFlag: function (component) {
    let creditRepayment = component.get("v.ParentContainer");
    if (creditRepayment.deductRepayment == "Yes") {
      component.set("v.deductRepaymentFlag", true);
    } else {
      component.set("v.deductRepaymentFlag", false);
    }
  },

  calculateSavings: function (component) {
    //TODO: refactor into calculations resource
    let PIMonthlyPayment = component.get("v.monthly_PI_LoanAmount");
    let parentContainer = component.get("v.ParentContainer");
    if (PIMonthlyPayment > 0) {
      let tenure = calculateMonths(parentContainer.years, parentContainer.months);
      if (parentContainer.percentage > 0 && parentContainer.percentage) {
        let monthlyCompulsorySavings =
          PIMonthlyPayment * parentContainer.percentage;
        let totalCompulsorySavings = monthlyCompulsorySavings * tenure;
        component.set("v.monthlyCompulsorySavings", monthlyCompulsorySavings);
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
      } else if (parentContainer.amount > 0 && parentContainer.amount) {
        component.set("v.monthlyCompulsorySavings", parentContainer.amount);
        let totalCompulsorySavings = parentContainer.amount * tenure;
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
    let data = component.get("v.ParentContainer");
    const pmtData = {
      years: data.years,
      months: data.months,
      loanAmount: component.get("v.jngiMotorPremium"),
      market: data.market
    };
    if (data.interested == "Yes" && data.jngiIncludeInLoan == "Yes") {
      const result = basicPMTCalculator(
        ["years", "months", "loanAmount", "market"],
        pmtData
      );
      component.set("v.monthlyPIJNGIMotorPremium", result);
      this.updateChildContainerWithValue(component, [
        { "key": "monthlyPIJNGIMotorPremium", value: parseFloat(result) }]);

    } else {
      component.set("v.monthlyPIJNGIMotorPremium", 0);
      component.set("v.jngiMotorPremium", 0);
      this.updateChildContainerWithValue(component, [
        { "key": "monthlyPIJNGIMotorPremium", value: 0 },
        { "key": "jngiMotorPremium", value: 0 }]);
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

    this.updateChildContainerWithValue(component, [
      { "key": "processingFeeClosingCost", value: processingFeeClosingCost },
      { "key": "monthlyPrincipalInterestProcessingFee", value: monthlyProcessingFee },
      { "key": "processingFeesGCT", value: processingFee }]);
  },
  onJNGIPremiumChange: function (component) {
    let parentContainer = component.get("v.ParentContainer");
    if (parentContainer.jngiIncludeInLoan === "No") {
      component.set("v.showPremiumInFeesAndCharges", true);
      component.set("v.showPremiumInCreditCalculations", false);
    } else {
      component.set("v.showPremiumInCreditCalculations", true);
      component.set("v.showPremiumInFeesAndCharges", false);
    }
    let firstYearPremium = this.calcualateFirstYearPremium(
      parentContainer.jngiMonthlyPremium
    );
    component.set("v.jngiMotorPremium", firstYearPremium);
    this.updateChildContainerWithValue(component, [{ "key": "jngiMotorPremium", value: firstYearPremium }]);
  },
  totalMonthlyPaymentCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalLoanAmount(["totalMonthlyPIPayment", "jngiMonthlyPremium"], parentObj);
    component.set("v.totalMonthlyLoanPayment", total);
    this.updateChildContainerWithValue(component, [{ "key": "totalMonthlyLoanPayment", value: total }]);
  },
  totalLoanAmountCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    parentObj.jnLifeCreditorPremium = 1000;
    let total = calculateTotalLoanAmount(["loanAmount", "jnLifeCreditorPremium", "processingFeesGCT", "jngiMotorPremium"], parentObj);
    component.set("v.totalLoanAmount", total);
    this.updateChildContainerWithValue(component, [{ "key": "totalLoanAmount", value: total }]);
  },
  totalMonthlyPILoanPaymentCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalMonthlyPIPayment(
      ["monthly_PI_LoanAmount", "monthlyJnLifeCreditor_PI_Premium",
      "monthlyPrincipalInterestProcessingFee", "monthlyPIJNGIMotorPremium"],
      parentObj);
    component.set("v.totalMonthly_PI_LoanPayment", total);
    this.updateChildContainerWithValue(component, [{ "key": "totalMonthly_PI_LoanPayment", value: total }]);
  },
  totalMonthlyLoanPaymentMonthlyCompulsorySavingsCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalLoanAmount(["totalMonthlyLoanPayment", "monthlyCompulsorySavings"], parentObj);
    component.set("v.totalMonthlyLoanPaymentAndSavings", total);
    this.updateChildContainerWithValue(component, [{ "key": "totalMonthlyLoanPaymentAndSavings", value: total }]);
  },
  totalInterestPaymentCalculation: function (component) {
    const totalMonthlyPIPayment = component.get("v.totalMonthly_PI_LoanPayment");
    const totalLoanAmount = component.get("v.totalLoanAmount");
    const years = component.get("v.ParentContainer.years");
    const months = component.get("v.ParentContainer.months");
    let total = calculateTotalInterestPayment(totalMonthlyPIPayment, totalLoanAmount, years, months);
    component.set("v.totalInterestPaymentBalance", total);
    this.updateChildContainerWithValue(component, [{ "key": "totalInterestPaymentBalance", value: total }]);
  },
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach(element => {
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
