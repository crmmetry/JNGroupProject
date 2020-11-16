({
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
      let tenure = calculateMonths(
        parentContainer.years,
        parentContainer.months
      );
      if (parentContainer.percentage > 0 && parentContainer.percentage) {
        let monthlyCompulsorySavings =
          PIMonthlyPayment * parentContainer.percentage;
        let totalCompulsorySavings = monthlyCompulsorySavings * tenure;
        component.set("v.monthlyCompulsorySavings", monthlyCompulsorySavings);
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
        this.updateChildContainerWithValue(component, [
          { key: "monthlyCompulsorySavings", value: monthlyCompulsorySavings },
          {
            key: "totalCompulsorySavingsBalance",
            value: totalCompulsorySavings
          }
        ]);
      } else if (parentContainer.amount > 0 && parentContainer.amount) {
        component.set("v.monthlyCompulsorySavings", parentContainer.amount);
        let totalCompulsorySavings = parentContainer.amount * tenure;
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
        this.updateChildContainerWithValue(component, [
          { key: "monthlyCompulsorySavings", value: parentContainer.amount },
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

  totalClosingCost: function (component) {
    const parentObj = component.get("v.ParentContainer");
    const jnDefault = component.get("v.jnDefaultConfigs");
    let total = 0;
    const data = Object.assign(parentObj, jnDefault);
    console.log("Total Closing Cost", JSON.parse(JSON.stringify(data)));
    if (
      component.get("v.estimatedStampDuty") != 0 &&
      component.get("v.assignmentFee") != 0
    ) {
      total = calculateTotalClosingCost(
        [
          "stampDutyAuto",
          "legalFee",
          "nsipp",
          "processingFeeClosingCost",
          "jnCLPremiumFeesAndCharges",
          "estimatedStampDutyAndAdminFee",
          "jngiMotorPremiumFeesAndCharges",
          "assignmentFee"
        ],
        data
      );
    } else {
      total = calculateTotalClosingCost(
        [
          "stampDutyAuto",
          "legalFee",
          "nsipp",
          "processingFeeClosingCost",
          "jnCLPremiumFeesAndCharges",
          "jngiMotorPremiumFeesAndCharges"
        ],
        data
      );
    }
    console.log("Total Closing Cost: ", total);
    console.log("JNGI: ", parentObj.jngiMotorPremiumFeesAndCharges);
    component.set("v.totalClosingCost", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalClosingCost", value: total }
    ]);
  },

  totalClosingCostFinancedJN: function (component) {
    const parentObj = component.get("v.ParentContainer");
    console.log(JSON.parse(JSON.stringify(parentObj)));
    let total = calculateTotalClosingCostFinancedJN(
      [
        "processingFeeClosingCost",
        "jnCLPremiumFeesAndCharges",
        "jngiMotorPremiumFeesAndCharges"
      ],
      parentObj
    );
    console.log("Total Closing Cost Financed By JN: ", total);
    component.set("v.totalFinancedByJN", total);
    this.updateChildContainerWithValue(component, [
      { key: "totalFinancedByJN", value: total }
    ]);
  },

  totalClosingCostPaidByApplicant: function (component) {
    const parentObj = component.get("v.ParentContainer");
    console.log(JSON.parse(JSON.stringify(parentObj)));
    if (parentObj.totalClosingCost && parentObj.totalFinancedByJN) {
      let total = calculateTotalClosingCostPayableByApplicant(
        parentObj.totalClosingCost,
        parentObj.totalFinancedByJN
      );
      console.log("Total Closing Cost Payable By Applicant: ", total);
      component.set("v.totalPayableByApplicant", total);
      this.updateChildContainerWithValue(component, [
        { key: "totalPayableByApplicant", value: total }
      ]);
    }
  },

  setAssignmentFees: function (component) {
    let data = component.get("v.ParentContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    if (data.policyProvider != null) {
      let assignmentFee = basicAssignmentFeeCalculator(
        jnDefaults.assignmentFee,
        jnDefaults.gct
      );
      console.log(assignmentFee);
      component.set("v.assignmentFee", assignmentFee);
      this.updateChildContainerWithValue(component, [
        { key: "assignmentFee", value: assignmentFee }
      ]);
    } else {
      component.set("v.assignmentFee", 0);
      this.updateChildContainerWithValue(component, [
        { key: "assignmentFee", value: 0 }
      ]);
    }
  },

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
  },
  totalClosingCost: function (component) {
    const parentObj = component.get("v.ParentContainer");
    const jnDefault = component.get("v.jnDefaultConfigs");
    const data = Object.assign(parentObj, jnDefault);
    console.log(JSON.parse(JSON.stringify(data)));
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
    console.log("Total Closing Cost: ", total);
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
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach((element) => {
      if (typeof component.get(`v.${element.key}`) !== "undefined") {
        component.set(`v.${element.key}`, element.value);
      }
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
