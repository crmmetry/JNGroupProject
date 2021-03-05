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
    //TODO: refactor into calculations resource
    let totalPI = component.get("v.totalMonthly_PI_LoanPayment");
    let data = component.get("v.ParentContainer");
    if (totalPI >= 0 && data.months && data.years) {
      let tenure = calculateMonths(data.years, data.months);
      if (
        data.proposedSavingsPercentage > 0 &&
        data.proposedSavingsPercentage
      ) {
        let monthlySavings = basicMonthlyCompulsorySavingsCalculator(
          totalPI,
          data.proposedSavingsPercentage,
          data.proposedSavingsAmount
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
      } else if (data.proposedSavingsAmount > 0 && data.proposedSavingsAmount) {
        component.set("v.monthlyCompulsorySavings", data.proposedSavingsAmount);
        let totalCompulsorySavings = data.proposedSavingsAmount * tenure;
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
        this.updateChildContainerWithValue(component, [
          {
            key: "monthlyCompulsorySavings",
            value: data.proposedSavingsAmount
          },
          {
            key: "totalCompulsorySavingsBalance",
            value: totalCompulsorySavings
          }
        ]);
      } else {
        component.set("v.monthlyCompulsorySavings", 0);
        component.set("v.totalCompulsorySavingsBalance", 0);
        this.updateChildContainerWithValue(component, [
          { key: "monthlyCompulsorySavings", value: 0 },
          { key: "totalCompulsorySavingsBalance", value: 0 }
        ]);
      }
    }
  },
  /**
   * Calculates JNGI first year premium.
   */
  calcualateFirstYearPremium: function (premium) {
    if (premium) {
      return premium * 12;
    }
    return 0;
  },
  /**
   * Calculates JNGI PI monthly payment.
   */
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
        { key: "monthlyPIJNGIMotorPremium", value: parseFloat(result) }
      ]);
    } else {
      component.set("v.monthlyPIJNGIMotorPremium", 0);
      component.set("v.jngiMotorPremium", 0);
      this.updateChildContainerWithValue(component, [
        { key: "monthlyPIJNGIMotorPremium", value: 0 },
        { key: "jngiMotorPremium", value: 0 }
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

      component.set("v.includeCLPremiumFlag", true);
      component.set("v.jnCLPremiumFeesAndCharges", monthlyCLPremium);
      component.set("v.jnLifeCreditorPremium", 0);
      component.set("v.monthlyJnLifeCreditor_PI_Premium", 0);

      this.updateChildContainerWithValue(component, [
        { key: "jnLifeCreditorPremium", value: 0 },
        { key: "monthlyJnLifeCreditor_PI_Premium", value: 0 },
        { key: "jnCLPremiumFeesAndCharges", value: monthlyCLPremium }
      ]);
    } else if (data.interestedInCreditorLife === "No") {
      component.set("v.includeCLPremiumFlag", false);
      component.set("v.jnCLPremiumFeesAndCharges", 0);
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
   * Calculates JNGI Premium for Credit Calculations and Fees and Charges.
   */
  onJNGIPremiumChange: function (component) {
    let parentContainer = component.get("v.ParentContainer");
    if (parentContainer.jngiIncludeInLoan == "No") {
      component.set("v.showPremiumInCreditCalculations", false);
      component.set("v.showPremiumInFeesAndCharges", true);
      let firstYearPremium = this.calcualateFirstYearPremium(
        parentContainer.jngiMonthlyPremium
      );
      component.set("v.jngiMotorPremiumFeesAndCharges", firstYearPremium);
      component.set("v.jngiMotorPremium", 0);
      this.updateChildContainerWithValue(component, [
        { key: "jngiMotorPremiumFeesAndCharges", value: firstYearPremium },
        { key: "jngiMotorPremium", value: 0 }
      ]);
    } else if (parentContainer.jngiIncludeInLoan === "Yes") {
      component.set("v.showPremiumInCreditCalculations", true);
      component.set("v.showPremiumInFeesAndCharges", false);
      let firstYearPremium = this.calcualateFirstYearPremium(
        parentContainer.jngiMonthlyPremium
      );
      component.set("v.jngiMotorPremium", firstYearPremium);
      component.set("v.jngiMotorPremiumFeesAndCharges", 0);
      this.updateChildContainerWithValue(component, [
        { key: "jngiMotorPremium", value: firstYearPremium },
        { key: "jngiMotorPremiumFeesAndCharges", value: 0 }
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
    //jngi motor
    if (parentObj.jngiIncludeInLoan === "Yes") {
      data.push("jngiMotorPremium");
    } else {
      data.push("jngiMotorPremiumFeesAndCharges");
    }
    //processing fee
    if (parentObj.includeInLoanAmountFlag === YES) {
      data.push("processingFeesGCT");
    } else {
      data.push("processingFeeClosingCost");
    }
    return data;
  },
  /**
   * Calculates the total closing cost.
   */
  totalClosingCostCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    const jnDefault = component.get("v.jnDefaultConfigs");
    const data = Object.assign(parentObj, jnDefault);
    let properties = [];
    let total = 0;
    let fieldsTocalculate = this.getFieldsToCalculate(parentObj);

    if (
      component.get("v.estimatedStampDuty") != 0 &&
      component.get("v.assignmentFee") != 0
    ) {
      properties = [
        "stampDutyAuto",
        "legalFee",
        "nsipp",
        "estimatedStampDutyAndAdminFee",
        "assignmentFee"
      ].concat(fieldsTocalculate);
    } else {
      properties = ["stampDutyAuto", "legalFee", "nsipp"].concat(
        fieldsTocalculate
      );
    }
    total = calculateTotalClosingCost(properties, data);
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
      ["processingFeesGCT", "jnLifeCreditorPremium", "jngiMotorPremium"],
      parentObj
    );
    component.set("v.totalFinancedByJN", total);
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
    if (parentObj.totalClosingCost >= 0 && parentObj.totalFinancedByJN >= 0) {
      total = calculateTotalClosingCostPayableByApplicant(
        parentObj.totalClosingCost,
        parentObj.totalFinancedByJN
      );
      component.set("v.totalPayableByApplicant", total);
      this.updateChildContainerWithValue(component, [
        { key: "totalPayableByApplicant", value: total }
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
      updateChildContainerNoNotification(component, [
        { key: "assignmentFee", value: jnDefaults.assignmentFee }
      ]);
    } else {
      component.set("v.assignmentFee", 0);
      updateChildContainerNoNotification(component, [
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
      updateChildContainerNoNotification(component, [
        {
          key: "estimatedStampDuty",
          value: jnDefaults.estimatedStampDutyAndAdminFee
        }
      ]);
    } else {
      component.set("v.estimatedStampDuty", 0);
      updateChildContainerNoNotification(component, [
        { key: "estimatedStampDuty", value: 0 }
      ]);
    }
  },
  /**
   * Calculates the total closing cost.
   */
  totalClosingCost: function (component) {
    const parentObj = component.get("v.ParentContainer");
    const jnDefault = component.get("v.jnDefaultConfigs");
    const data = Object.assign(parentObj, jnDefault);
    let total = calculateTotalClosingCost(
      [
        "stampDutyUns",
        "legalFee",
        "processingFeeClosingCost",
        "nsipp",
        "jnCLPremiumFeesAndCharges"
      ],
      data
    );
    component.set("v.totalClosingCost", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalClosingCost", value: total }
    ]);
  },
  totalMonthlyPaymentCalculation: function (component) {
    const parentObj = component.get("v.ParentContainer");
    let total = calculateTotalLoanAmount(
      ["totalMonthly_PI_LoanPayment", "jngiMonthlyPremium"],
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
      [
        "loanAmount",
        "jnLifeCreditorPremium",
        "processingFeesGCT",
        "jngiMotorPremium"
      ],
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
        "monthlyPrincipalInterestProcessingFee",
        "monthlyPIJNGIMotorPremium"
      ],
      parentObj
    );
    component.set("v.totalMonthly_PI_LoanPayment", total);
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
      component.set(`v.${element.key}`, element.value);
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
