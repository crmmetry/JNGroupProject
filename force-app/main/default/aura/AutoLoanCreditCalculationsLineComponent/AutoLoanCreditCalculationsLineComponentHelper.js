({
  calculateMonthlyP_ILoanAmount: function (component) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.ParentContainer")
    );
    if (!result) {
      component.set("v.monthly_PI_LoanAmount", 0);
      this.updateChildContainerWithValue(component, [{ "key": "monthly_PI_LoanAmount", value: 0 }]);

    } else {
      component.set("v.monthly_PI_LoanAmount", result);
      this.updateChildContainerWithValue(component, [{ "key": "monthly_PI_LoanAmount", value: parseFloat(result) }]);
    }
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
    if (data.interested == "Yes" && data.includeInLoan == "Yes") {
      const result = basicPMTCalculator(
        ["years", "months", "loanAmount", "market"],
        pmtData
      );
      if (!result) {
        component.set("v.monthlyPIJNGIMotorPremium", 0);
        this.updateChildContainerWithValue(component, [
          { "key": "monthlyPIJNGIMotorPremium", value: 0 }]);
      } else {
        component.set("v.monthlyPIJNGIMotorPremium", result);
        this.updateChildContainerWithValue(component, [
          { "key": "monthlyPIJNGIMotorPremium", value: parseFloat(result) }]);
      }
    } else if (data.interested === "No") {
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
    let childContainer = component.get("v.ChildContainer");
    if (parentContainer.includeInLoan === "No") {
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
  calculateTotalLoanPayment: function (component) {

  },
  totalLoanAmountCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    parentObj.jnLifeCreditorPremium = 1000;
    let totalLoanAmount = calculateTotalLoanAmount(["loanAmount", "jnLifeCreditorPremium", "processingFeesGCT", "jngiMotorPremium"], parentObj);
    component.set("v.totalLoanAmount", totalLoanAmount);
    this.updateChildContainerWithValue(component, [{ "key": "totalLoanAmount", value: totalLoanAmount }]);
  },
  calculateTotalMonthlyPILoanPayment: function (component) {

  },
  calculateTotalMonthlyLoanPaymentMonthlyCompulsorySavings: function (component) {

  },
  calculateTotalInterestPayment: function (component) {

  },
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach(element => {
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
