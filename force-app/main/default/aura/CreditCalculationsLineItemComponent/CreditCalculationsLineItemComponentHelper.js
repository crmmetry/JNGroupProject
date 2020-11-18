({
  /**
   * Calculates the monthly P&I Loan amount in the credit calculations table.
   */
  calculateMonthlyP_ILoanAmount: function (component) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      component.get("v.ParentContainer")
    );
    component.set("v.monthly_PI_LoanAmount", result);
    this.updateChildContainerWithValue(component, [
      { key: "monthly_PI_LoanAmount", value: parseFloat(result) }
    ]);
  },
  /**
   * Toggles the deduct repayment flag that controls the visibility of the 1st installment payable in the fees and charges.
   */
  setDeductRepaymentFlag: function (component) {
    let creditRepayment = component.get("v.ParentContainer");
    if (creditRepayment.deductRepayment == "Yes") {
      component.set("v.deductRepaymentFlag", true);
    } else {
      component.set("v.deductRepaymentFlag", false);
    }
  },
  /**
   * Calculates the Monthly compulsory savings and Total monthly compulsory savings in the credit calculations table.
   */
  calculateSavings: function (component) {
    let data = component.get("v.ParentContainer");
    let totalPI = component.get("v.totalMonthly_PI_LoanPayment");
    if (totalPI && data.months && data.years) {
      let tenure = calculateMonths(data.years, data.months);
      let monthlySavings = basicMonthlyCompulsorySavingsCalculator(
        totalPI,
        data.percentage,
        data.amount
      );
      let monthlySavingsOverRepaymentPeriod = basicTotalMonthlyCompulsorySavingsCalculator(
        monthlySavings,
        tenure
      );
      component.set("v.monthlyCompulsorySavings", monthlySavings);
      component.set(
        "v.totalCompulsorySavingsBalance",
        monthlySavingsOverRepaymentPeriod
      );
      this.updateChildContainerWithValue(component, [
        {
          key: "totalCompulsorySavingsBalance",
          value: parseFloat(monthlySavingsOverRepaymentPeriod)
        },
        { key: "monthlyCompulsorySavings", value: parseFloat(monthlySavings) }
      ]);
    } else {
      component.set("v.monthlyCompulsorySavings", 0);
      component.set("v.totalCompulsorySavingsBalance", 0);
      this.updateChildContainerWithValue(component, [
        { key: "monthlyCompulsorySavings", value: 0 },
        { key: "totalCompulsorySavingsBalance", value: 0 }
      ]);
    }
  },
  /**
   * Calculates the Processing fees including gct for Closing Cost and Credit Calculations table as well as Monthly PI Processing fee
   * for Credit Calculation table.
   */
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
      { key: "processingFeeClosingCost", value: processingFeeClosingCost },
      {
        key: "monthlyPrincipalInterestProcessingFee",
        value: monthlyProcessingFee
      },
      { key: "processingFeesGCT", value: processingFee }
    ]);
  },
  /**
   * Sets the 1st payment installment payable dependent on the deductRepayment is yes or no in the Closing Cost table.
   */
  updateFirstPaymentInstallable: function (component) {
    const parentObj = component.get("v.ParentContainer");
    if (
      parentObj.deductRepayment === "No" &&
      parentObj.totalMonthlyLoanPayment
    ) {
      component.set(
        "v.firstPaymentInstallable",
        parentObj.totalMonthlyLoanPayment
      );
      this.updateChildContainerWithValue(component, [
        {
          key: "firstPaymentInstallable",
          value: parentObj.totalMonthlyLoanPayment
        }
      ]);
    } else {
      component.set("v.firstPaymentInstallable", 0);
      this.updateChildContainerWithValue(component, [
        {
          key: "firstPaymentInstallable",
          value: 0
        }
      ]);
    }
  },
  /**
   * Creates a list of attribute keys to be include in the total calculations dependent on various conditions.
   */
  getFieldsToCalculate: function (parentObj) {
    let data = [];
    //creditor life
    if (parentObj.includeCreditorLifeInLoanAmount === "Yes") {
      data.push("jnLifeCreditorPremium");
    } else {
      data.push("jnCLPremiumFeesAndCharges");
    }
    //processing fee
    if (parentObj.includeInLoanAmountFlag) {
      data.push("processingFeesGCT");
    } else {
      data.push("processingFeeClosingCost");
    }
    console.log("data", data);
    return data;
  },
  /**
   * Calculates the total closing cost.
   */
  totalClosingCostCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    const jnDefault = component.get("v.jnDefaultConfigs");
    const data = Object.assign(parentObj, jnDefault);
    console.info(
      "TotalClosingCostCalculation",
      JSON.parse(JSON.stringify(data))
    );
    let properties = [];
    let total = 0;
    let fieldsTocalculate = this.getFieldsToCalculate(parentObj);

    if (
      component.get("v.estimatedStampDuty") != 0 &&
      component.get("v.assignmentFee") != 0
    ) {
      console.info("Branch 1");
      properties = [
        "stampDutyUns",
        "legalFee",
        "estimatedStampDutyAndAdminFee",
        "assignmentFee",
        "firstPaymentInstallable"
      ].concat(fieldsTocalculate);
    } else {
      console.info("Branch 2");
      properties = [
        "stampDutyUns",
        "legalFee",
        "firstPaymentInstallable"
      ].concat(fieldsTocalculate);
    }
    total = calculateTotalClosingCost(properties, data);
    console.info("TotalClosingCost = ", total);
    component.set("v.totalClosingCost", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalClosingCost", value: total }
    ]);
  },
  /**
   * Calculates the total closing cost financed by JN.
   */
  totalClosingCostFinancedJNCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalClosingCostFinancedJN(
      ["processingFeesGCT", "jnLifeCreditorPremium"],
      parentObj
    );
    component.set("v.totalFinancedByJN", total);
    console.info("TotalFinancedByJN = ", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalFinancedByJN", value: total }
    ]);
  },
  /**
   * Calculates the total closing cost payable by applicant.
   */
  totalClosingCostPaidByApplicantCalculation: function (component) {
    let total = 0;
    const parentObj = component.get("v.ParentContainer");
    console.log(parentObj.totalClosingCost, parentObj.totalFinancedByJN);
    if (parentObj.totalClosingCost >= 0 && parentObj.totalFinancedByJN >= 0) {
      total = calculateTotalClosingCostPayableByApplicant(
        parentObj.totalClosingCost,
        parentObj.totalFinancedByJN
      );
      console.log("ClosingCostPaidByApplicantCalculation = ", total);
      component.set("v.totalPayableByApplicant", total);
      this.updateChildContainerWithValue(component, [
        { key: "totalPayableByApplicant", value: total }
      ]);
    }
  },
  /**
   * Calculates the monthly loan payment in the credit calculations table.
   */
  totalMonthlyPaymentCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalLoanAmount(
      ["totalMonthly_PI_LoanPayment"],
      parentObj
    );
    component.set("v.totalMonthlyLoanPayment", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalMonthlyLoanPayment", value: total }
    ]);
  },
  /**
   * Calculates the total monthly loan payment in the credit calculations under totals.
   */
  totalLoanAmountCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");

    let total = calculateTotalLoanAmount(
      ["loanAmount", "jnLifeCreditorPremium", "processingFeesGCT"],
      parentObj
    );
    component.set("v.totalLoanAmount", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalLoanAmount", value: total }
    ]);
  },
  /**
   * Calculates the total monthly P&I payment in credit calculations table.
   */
  totalMonthlyPILoanPaymentCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalMonthlyPIPayment(
      [
        "monthly_PI_LoanAmount",
        "monthlyJnLifeCreditor_PI_Premium",
        "monthlyPrincipalInterestProcessingFee"
      ],
      parentObj
    );
    component.set("v.totalMonthly_PI_LoanPayment", total);
    console.log("Total Monthly PI: ", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalMonthly_PI_LoanPayment", value: total }
    ]);
  },
  /**
   * Calculates the sum of total monthly loan payment and monthly compulsory savings under totals in credit calculations table.
   */
  totalMonthlyLoanPaymentMonthlyCompulsorySavingsCalculation: function (
    component
  ) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalMonthlyLoanCompulsoryPayment(
      ["totalMonthlyLoanPayment", "monthlyCompulsorySavings"],
      parentObj
    );
    console.info("totalMonthlyLoanPaymentAndSavings", total);
    component.set("v.totalMonthlyLoanPaymentAndSavings", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalMonthlyLoanPaymentAndSavings", value: total }
    ]);
  },
  /**
   * Calculates the total interest payment.
   */
  totalInterestPaymentCalculation: function (component) {
    const totalMonthlyPIPayment = component.get(
      "v.totalMonthly_PI_LoanPayment"
    );
    const totalLoanAmount = component.get("v.totalLoanAmount");
    const years = component.get("v.ParentContainer.years");
    const months = component.get("v.ParentContainer.months");
    let total = calculateTotalInterestPayment(
      totalMonthlyPIPayment,
      totalLoanAmount,
      years,
      months
    );
    component.set("v.totalInterestPaymentBalance", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalInterestPaymentBalance", value: total }
    ]);
  },
  /**
   * Updates child container attributes and its values.
   */
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach((element) => {
      childContainer[element.key] = element.value;
      component.set(`v.${element.key}`, element.value);
    });
    component.set("v.ChildContainer", childContainer);
  },
  /**
   * Calculates creditor life premium.
   */
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
      this.updateChildContainerWithValue(component, [
        { key: "jnLifeCreditorPremium", value: monthlyCLPremium }
      ]);
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
      this.updateChildContainerWithValue(component, [
        { key: "monthlyJnLifeCreditor_PI_Premium", value: pmtCLResult }
      ]);
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
      this.updateChildContainerWithValue(component, [
        { key: "jnLifeCreditorPremium", value: 0 },
        { key: "monthlyJnLifeCreditor_PI_Premium", value: 0 },
        { key: "jnCLPremiumFeesAndCharges", value: monthlyCLPremium }
      ]);
    } else if (data.interestedInCreditorLife === "No") {
      component.set("v.jnCLPremiumFeesAndCharges", 0);
      component.set("v.includeCLPremiumFlag", false);
      component.set("v.jnLifeCreditorPremium", 0);
      component.set("v.monthlyJnLifeCreditor_PI_Premium", 0);
      this.updateChildContainerWithValue(component, [
        { key: "jnLifeCreditorPremium", value: 0 },
        { key: "monthlyJnLifeCreditor_PI_Premium", value: 0 },
        { key: "jnCLPremiumFeesAndCharges", value: 0 }
      ]);
    }
  },
  /**
   * Set the assignment fee when the policy provider is updated.
   */
  setAssignmentFees: function (component) {
    let data = component.get("v.ParentContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    if (data.policyProvider != null) {
      component.set("v.assignmentFee", jnDefaults.assignmentFee);
      this.updateChildContainerWithValue(component, [
        { key: "assignmentFee", value: jnDefaults.assignmentFee }
      ]);
    } else {
      component.set("v.assignmentFee", 0);
      this.updateChildContainerWithValue(component, [
        { key: "assignmentFee", value: 0 }
      ]);
    }
  },
  /**
   * Set the estimated stamp duty fees when the policy provider is updated.
   */
  setEstimatedStampDutyFees: function (component) {
    let data = component.get("v.ParentContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    if (data.policyProvider != null) {
      component.set(
        "v.estimatedStampDuty",
        jnDefaults.estimatedStampDutyAndAdminFee
      );
      this.updateChildContainerWithValue(component, [
        {
          key: "estimatedStampDuty",
          value: jnDefaults.estimatedStampDutyAndAdminFee
        }
      ]);
    } else {
      component.set("v.estimatedStampDuty", 0);
      this.updateChildContainerWithValue(component, [
        { key: "estimatedStampDuty", value: 0 }
      ]);
    }
  }
});
