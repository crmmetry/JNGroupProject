/**
 * this file consolidates all the reusable functions used in different aura components
 */
/**
 * Ver  Ticket#      Date            Author                  Purpose
 * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  To calculate the annual fees for primary applicant
 * 2.0  JN1-4210     18/12/2020     Ishwari G.(thinqloud)   To validate the the array of result
 **/

/**
 * calculates savings
 * @param {Object} data
 * @return {Object}
 */
window.calculateSavings = function (component, data) {
  let totalCompulsorySavingsBalance = 0;
  let monthlyCompulsorySavings = 0;
  let {
    totalMonthly_PI_LoanPayment,
    proposedSavingsPercentage,
    proposedSavingsAmount,
    years,
    months
  } = data;
  if (
    validNumbersWithObject(
      ["totalMonthly_PI_LoanPayment", "months", "years"],
      data
    )
  ) {
    let tenure = calculateMonths(years, months);
    let monthlySavings = basicMonthlyCompulsorySavingsCalculator(
      totalMonthly_PI_LoanPayment,
      proposedSavingsPercentage,
      proposedSavingsAmount
    );
    let monthlySavingsOverRepaymentPeriod = basicTotalMonthlyCompulsorySavingsCalculator(
      monthlySavings,
      tenure
    );

    totalCompulsorySavingsBalance = parseFloat(
      monthlySavingsOverRepaymentPeriod
    );
    monthlyCompulsorySavings = parseFloat(monthlySavings);
  } else if (validNumbersWithObject(["proposedSavingsAmount"], data)) {
    let totalCompulsorySavings = proposedSavingsAmount * tenure;

    monthlyCompulsorySavings = proposedSavingsAmount;
    totalCompulsorySavingsBalance = totalCompulsorySavings;
  } else {
    totalCompulsorySavingsBalance = ZERO;
    monthlyCompulsorySavings = ZERO;
  }
  let values = [
    {
      key: "totalCompulsorySavingsBalance",
      value: totalCompulsorySavingsBalance
    },
    {
      key: "monthlyCompulsorySavings",
      value: monthlyCompulsorySavings
    }
  ];
  let result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates the total monthly loan payment in the credit calculations under totals.
 */
window.totalLoanAmountCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  const isAuto = checkProductFamily(component, "Auto");
  const isUnsecured = checkProductFamily(component, "Unsecured");
  let total = 0;
  if (isAuto) {
    total = calculateTotalLoanAmount(
      [
        "loanAmount",
        "jnLifeCreditorPremium",
        "processingFeesGCT",
        "jngiMotorPremium"
      ],
      parentObj
    );
  } else if (isUnsecured) {
    total = calculateTotalLoanAmount(
      ["loanAmount", "jnLifeCreditorPremium", "processingFeesGCT"],
      parentObj
    );
  }
  let values = [{ key: "totalLoanAmount", value: total }];
  const data = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", data);
  return data;
};

/**
 * Calculates the total monthly P&I payment in credit calculations table.
 */
(window.totalMonthlyPILoanPaymentCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  const isAuto = checkProductFamily(component, "Auto");
  const isUnsecured = checkProductFamily(component, "Unsecured");
  let total = 0;
  if (isAuto) {
    total = calculateTotalMonthlyPIPayment(
      [
        "monthly_PI_LoanAmount",
        "monthlyJnLifeCreditor_PI_Premium",
        "monthlyPrincipalInterestProcessingFee",
        "monthlyPIJNGIMotorPremium"
      ],
      parentObj
    );
  } else if (isUnsecured) {
    total = calculateTotalMonthlyPIPayment(
      [
        "monthly_PI_LoanAmount",
        "monthlyJnLifeCreditor_PI_Premium",
        "monthlyPrincipalInterestProcessingFee"
      ],
      parentObj
    );
  }
  let values = [{ key: "totalMonthly_PI_LoanPayment", value: total }];
  const data = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", data);
  return data;
}),
  /**
   * Calculates the sum of total monthly loan payment and monthly compulsory savings under totals in credit calculations table.
   */
  (window.totalMonthlyLoanPaymentMonthlyCompulsorySavingsCalculation = function (
    component
  ) {
    const parentObj = component.get("v.ChildContainer");
    let total = calculateTotalMonthlyLoanCompulsoryPayment(
      ["totalMonthlyLoanPayment", "monthlyCompulsorySavings"],
      parentObj
    );
    let values = [{ key: "totalMonthlyLoanPaymentAndSavings", value: total }];
    const data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    return data;
  });
/**
 * Calculates the total interest payment.
 */
window.totalInterestPaymentCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  let totalMonthlyPIPayment = parentObj.totalMonthly_PI_LoanPayment;
  const totalLoanAmount = parentObj.totalLoanAmount;
  const years = parentObj.years;
  const months = parentObj.months;
  let total = calculateTotalInterestPayment(
    totalMonthlyPIPayment,
    totalLoanAmount,
    years,
    months
  );
  let values = [{ key: "totalInterestPaymentBalance", value: total }];
  const data = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", data);
  return data;
};
/**
 * calculates total monthly payment
 * @param {*} component
 */
window.totalMonthlyPaymentCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  const isAuto = checkProductFamily(component, "Auto");
  const isUnsecured = checkProductFamily(component, "Unsecured");
  let total = 0;
  if (isAuto) {
    total = calculateTotalLoanAmount(
      ["totalMonthly_PI_LoanPayment", "jngiMonthlyPremium"],
      parentObj
    );
  } else if (isUnsecured) {
    total = calculateTotalLoanAmount(
      ["totalMonthly_PI_LoanPayment"],
      parentObj
    );
  }
  let values = [{ key: "totalMonthlyLoanPayment", value: total }];
  const data = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", data);
  return data;
};
window.getFieldsToCalculate = function (parentObj) {
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
};
/**
 * Calculates the total closing cost.
 */
window.totalClosingCostCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  const jnDefault = component.get("v.jnDefaultConfigs");
  const isAuto = checkProductFamily(component, "Auto");
  const isUnsecured = checkProductFamily(component, "Unsecured");
  const data = copyInto(parentObj, jnDefault);
  let properties = [];
  let total = 0;
  let fieldsTocalculate = getFieldsToCalculate(parentObj);
  if (isAuto) {
    if (data.estimatedStampDuty != 0 && data.assignmentFee != 0) {
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
  } else if (isUnsecured) {
    if (data.estimatedStampDuty != 0 && data.assignmentFee != 0) {
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
  }
  let values = [{ key: "totalClosingCost", value: total }];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates the total closing cost financed by JN.
 */
window.totalClosingCostFinancedJNCalculation = function (component) {
  const parentObj = component.get("v.ChildContainer");
  const isAuto = checkProductFamily(component, "Auto");
  const isUnsecured = checkProductFamily(component, "Unsecured");
  let total = 0;
  if (isAuto) {
    total = calculateTotalClosingCostFinancedJN(
      ["processingFeesGCT", "jnLifeCreditorPremium", "jngiMotorPremium"],
      parentObj
    );
  } else if (isUnsecured) {
    total = calculateTotalClosingCostFinancedJN(
      ["processingFeesGCT", "jnLifeCreditorPremium"],
      parentObj
    );
  }
  let values = [{ key: "totalFinancedByJN", value: total }];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates the total closing cost payable by applicant.
 */
window.totalClosingCostPaidByApplicantCalculation = function (component) {
  let total = 0;
  const parentObj = component.get("v.ChildContainer");
  if (parentObj.totalClosingCost >= 0 && parentObj.totalFinancedByJN >= 0) {
    total = calculateTotalClosingCostPayableByApplicant(
      parentObj.totalClosingCost,
      parentObj.totalFinancedByJN
    );
  }
  let values = [{ key: "totalPayableByApplicant", value: total }];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Sets the 1st payment installment payable dependent on the deductRepayment is yes or no in the Closing Cost table.
 */
window.updateFirstPaymentInstallable = function (component) {
  const parentObj = component.get("v.ChildContainer");
  let firstPaymentInstallable = 0;
  if (parentObj.deductRepayment === NO && parentObj.totalMonthlyLoanPayment) {
    firstPaymentInstallable = parentObj.totalMonthlyLoanPayment;
  }
  let values = [
    { key: "firstPaymentInstallable", value: firstPaymentInstallable }
  ];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates creditor life premium.
 */
window.calculateCreditorLifePremium = function (component) {
  let data = component.get("v.ChildContainer");
  let jnLifeCreditorPremium = 0;
  let monthlyJnLifeCreditor_PI_Premium = 0;
  let jnCLPremiumFeesAndCharges = 0;
  if (
    data.interestedInCreditorLife === YES &&
    data.includeCreditorLifeInLoanAmount === YES
  ) {
    let monthlyCLPremium = basicJNLifePremiumCalculator(
      data.loanAmount,
      data.rating
    );
    jnLifeCreditorPremium = monthlyCLPremium;
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
    monthlyJnLifeCreditor_PI_Premium = pmtCLResult;
    component.set("v.includeCLPremiumFlag", false);
  } else if (
    data.interestedInCreditorLife === YES &&
    data.includeCreditorLifeInLoanAmount === NO
  ) {
    let monthlyCLPremium = basicJNLifePremiumCalculator(
      data.loanAmount,
      data.rating
    );
    component.set("v.includeCLPremiumFlag", true);
    jnLifeCreditorPremium = 0;
    monthlyJnLifeCreditor_PI_Premium = 0;
    jnCLPremiumFeesAndCharges = monthlyCLPremium;
  } else if (data.interestedInCreditorLife === NO) {
    jnCLPremiumFeesAndCharges = 0;
    jnLifeCreditorPremium = 0;
    monthlyJnLifeCreditor_PI_Premium = 0;
    component.set("v.includeCLPremiumFlag", false);
  }

  let values = [
    { key: "jnLifeCreditorPremium", value: jnLifeCreditorPremium },
    {
      key: "monthlyJnLifeCreditor_PI_Premium",
      value: monthlyJnLifeCreditor_PI_Premium
    },
    { key: "jnCLPremiumFeesAndCharges", value: jnCLPremiumFeesAndCharges }
  ];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates JNGI first year premium.
 */
window.calcualateFirstYearPremium = function (premium) {
  if (validNumber(premium)) {
    return premium * 12;
  }
  return ZERO;
};
/**
 * Calculates JNGI Premium for Credit Calculations and Fees and Charges.
 */
window.onJNGIPremiumChange = function (component) {
  let parentContainer = component.get("v.ChildContainer");
  let jngiMotorPremiumFeesAndCharges = 0;
  let jngiMotorPremium = 0;
  if (parentContainer.jngiIncludeInLoan == NO) {
    component.set("v.showPremiumInCreditCalculations", false);
    component.set("v.showPremiumInFeesAndCharges", true);
    let firstYearPremium = calcualateFirstYearPremium(
      parentContainer.jngiMonthlyPremium
    );
    jngiMotorPremium = 0;
    jngiMotorPremiumFeesAndCharges = firstYearPremium;
  } else if (parentContainer.jngiIncludeInLoan === "Yes") {
    component.set("v.showPremiumInCreditCalculations", true);
    component.set("v.showPremiumInFeesAndCharges", false);
    let firstYearPremium = calcualateFirstYearPremium(
      parentContainer.jngiMonthlyPremium
    );
    jngiMotorPremium = firstYearPremium;
    jngiMotorPremiumFeesAndCharges = 0;
  }
  let values = [
    {
      key: "jngiMotorPremiumFeesAndCharges",
      value: jngiMotorPremiumFeesAndCharges
    },
    {
      key: "jngiMotorPremium",
      value: jngiMotorPremium
    }
  ];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/**
 * Calculates JNGI PI monthly payment.
 */
window.calculateJNGIPMT = function (component) {
  let data = component.get("v.ChildContainer");
  let monthlyPIJNGIMotorPremium = 0;
  let jngiMotorPremium = 0;
  const pmtData = {
    years: data.years,
    months: data.months,
    loanAmount: data.jngiMotorPremium,
    market: data.market
  };
  if (data.interested == YES && data.jngiIncludeInLoan == YES) {
    const result = basicPMTCalculator(
      ["years", "months", "loanAmount", "market"],
      pmtData
    );
    monthlyPIJNGIMotorPremium = result;
    jngiMotorPremium = data.jngiMotorPremium;
  } else {
    monthlyPIJNGIMotorPremium = 0;
    jngiMotorPremium = 0;
  }
  let values = [
    { key: "monthlyPIJNGIMotorPremium", value: monthlyPIJNGIMotorPremium },
    {
      key: "jngiMotorPremium",
      value: jngiMotorPremium
    }
  ];
  const result = updateChildContainerWithValue(component, values, false);
  component.set("v.ChildContainer", result);
  return result;
};
/*
 * Updates child container attributes and its values.
 */
window.updateChildContainerWithValue = function (
  component,
  values,
  shouldSetComponentValue
) {
  let container = component.get("v.ChildContainer");
  values.forEach((element) => {
    container[element.key] = element.value;
    if (shouldSetComponentValue)
      component.set(`v.${element.key}`, element.value);
  });
  return container;
};
/*
 * Updates child container attributes and its values with notification
 */
window.updateChildContainerWithNotification = function (component, values) {
  let container = component.get("v.ChildContainer");
  values.forEach((element) => {
    container[element.key] = element.value;
  });
  notifyContainerChanges(component);
  component.set("v.ChildContainer", container);
};
/*
 * Updates child container attributes and its values. then toggles when it should be notified
 */
window.updateChildContainerNoNotification = function (component, values) {
  let container = component.get("v.ChildContainer");
  values.forEach((element) => {
    container[element.key] = element.value;
  });
  component.set("v.notifyContainerChange", false);
  component.set("v.ChildContainer", container);
  return container;
};

/**
 * Toggles cash investment flag.
 */
window.toggleCashInvestmentFlag = function (value) {
  if (value === "Cash/Investments") return true;
  return false;
};

/**
 * Toggles disability of account type.
 */
window.toggleAccountTypeDisability = function (value) {
  if (value !== null) return false;
  return true;
};

/**
 * Toggle option list values depending on institution selected
 */
window.updateAccountTypeOptionList = function (
  fundManagerAccountTypeOptions,
  jnBankAccountTypeOptions,
  selected
) {
  if (selected === "JN Bank Ltd.") return jnBankAccountTypeOptions;
  if (selected === "JN Fund Managers Ltd.")
    return fundManagerAccountTypeOptions;
};

/**
 * Toggle account number fields layout
 */
window.toggleAccountNumberComponent = function (selected, component) {
  if (selected === "JN Bank Ltd.") {
    component.set("v.bankSelectedFlag", true);
    component.set("v.fundManagerSelectedFlag", false);
  }
  if (selected === "JN Fund Managers Ltd.") {
    component.set("v.fundManagerSelectedFlag", true);
    component.set("v.bankSelectedFlag", false);
  }
};
/**
 * Toggle visibility of existing balance field
 */
window.toggleHypothecatedLoanFlag = function (selected, component) {
  if (selected === "Yes") {
    component.set("v.hypothecatedLoanFlag", true);
  }
  if (selected === "No") {
    component.set("v.hypothecatedLoanFlag", false);
  }
};

/**
 * Clears components with an identified aura id.
 */
window.resetComponentValue = function (auraId, component, value) {
  let components = component.find(auraId);
  if (isEmpty(components) === false && !Array.isArray(components)) {
    components = [components];
  }
  if (components) {
    components.forEach((componentElement) => {
      componentElement.set("v.value", value);
    });
  }
};

/**
 * Calculates the monthly P&I Loan amount in the credit calculations table.
 */
window.monthlyPILoanAmountCalculation = function (container) {
  return basicPMTCalculator(
    ["years", "months", "loanAmount", "market"],
    container
  );
};
/**
 * contructs and fire the product details application event
 * @param {String} type - specifies the intent of the event
 * @param {Object} payload
 * @return {Void}
 */
window.fireProductDetailsEvent = function (type, payload, component) {
  let productDetailsEvent = $A.get("e.c:ProductDetailsEvent");
  productDetailsEvent.setParams({
    type: !type ? "calculation" : type,
    payload: payload
  });
  productDetailsEvent.fire();
  //indicate that the component wants notifications
  notifyContainerChanges(component);
};

/**
 * Re-enables child container notification updates
 */
window.notifyContainerChanges = function (component) {
  //indicate that the component wants notifications
  if (component) {
    component.set("v.notifyContainerChange", true);
  }
};
/**
 * Disables child container notification updates
 */
window.noNotifyContainerChanges = function (component) {
  //indicate that the component does'nt wants notifications
  if (component) {
    component.set("v.notifyContainerChange", false);
  }
};
/**
 * calculates the requested credit limit
 * @param {*} requestedCreditLimit
 * @param {*} capLimit
 */
window.calculatRequestedCreditBalanceLimit = function (requestedCreditLimit) {
  return requestedCreditLimit * REQUESTED_CREDIT_LIMIT_PERCENTAGE;
};

/**
 * ************JN1-3969 ***********
 * calculates the annual fees for primary applicant and supplementary Card Holders
 * @param {*} jnDefaults
 * @param {*} creditFlag
 * @param {*} locFlag
 * @param {*} container
 * @param {Decimal, Decimal}
 */
window.annualFeesCalculator = function (
  jnDefaults,
  creditFlag,
  locFlag,
  container
) {
  let calculatePrimaryFee = 0;
  let calculateSupplemetaryFee = 0;
  /**
   * If Product family is Credit card then calculate the annual fees for
   * primary applicant as well as supplementary card holder is done
   * card type = Gold then, Primary Applicant Fee = Gold card Fee + GCT%
   * card type = Classic then, Primary Applicant Fee = Classic card Fee + GCT%
   **/
  if (creditFlag) {
    calculatePrimaryFee = creditCardAnnualFeesCalculation(
      container,
      calculatePrimaryFee,
      jnDefaults
    );
    //calculates the primary applicant , supplementary card holder's fee
    calculateSupplemetaryFee = supplementaryCardHoldersFeeCalculation(
      container,
      jnDefaults,
      calculateSupplemetaryFee
    );
  } else if (locFlag) {
    /**
     * if Product family is Line of Credit then calculate the annual fees for primary applicant only
     * Primary Applicant Fee = LOC credit Limit % * Approved starting limit + GCT%
     **/
    calculatePrimaryFee = lineOfCreditAnnualFeesCalculation(
      calculatePrimaryFee,
      jnDefaults,
      container
    );
  }
  return {
    primaryAnnualFee: roundedValue(calculatePrimaryFee),
    supplementaryAnnualFee: roundedValue(calculateSupplemetaryFee)
  };
};
/* Calculate ASL
 * @param {*} container
 * @param {*} jnDefaults
 * @return {Decimal}
 */
window.ASLCalculator = function (container, jnDefault, riskFactor = 0) {
  let maxCreditLimit = 0;
  if (
    !validNumber(container.TDSRBefore) ||
    !validNumber(jnDefault.policyLimit) ||
    !validNumber(container.TDSRAfter)
  ) {
    return ZERO;
  }
  if (roundedValue(container.TDSRBefore / 100) > jnDefault.policyLimit) {
    return ZERO;
  }
  console.log("ASL Calculations have begun");
  // //Step 1:
  let annualGrossIncome = annualGrossIncomeCalculator(
    container.grossMonthlyIncome
  );
  // //Step 1.5:
  if (container.cashInvestmentFlag === false) {
    maxCreditLimit = maximumCreditLimitCalculator(
      jnDefault.creditLimitMax,
      jnDefault.creditLimitMin,
      annualGrossIncome,
      jnDefault.creditLimitThreshold
    );
  } else {
    maxCreditLimit = maximumCreditLimitCalculatorWithCashCollateral(
      container.depositBalance,
      jnDefault.LTVCeiling,
      container.existingBalance
    );
  }
  //Step 2:
  let maxDebtPayment = maximumAllowableForMonthlyDebtPaymentsCalculator(
    jnDefault.policyLimit,
    container.grossMonthlyIncome
  );
  //Step 3:
  let maxMinimumPayment = maximumAllowableForMinimumPaymentCalculator(
    maxDebtPayment,
    container.existingDebt
  );
  //Step 4:
  let computedMinimumPayment = computedMinimumPaymentFromCreditLimitCalculator(
    container,
    jnDefault,
    maxMinimumPayment
  );
  //Step 5:
  let lowerCreditLimit = lowerCreditLimitCalculator(
    computedMinimumPayment,
    maxCreditLimit
  );
  if (container.cashInvestmentFlag === false) {
    //Step 6:
    let creditLimitAfterRisk = creditLimitRiskCalculator(
      lowerCreditLimit,
      riskFactor
    );
    //Step 7:
    let startingLimit = startingCreditLimtCalculator(
      creditLimitAfterRisk,
      jnDefault.discountFactor
    );
    //Step 8
    return approvedStartingLimitCalculator(
      startingLimit,
      container.requestedCreditLimit
    );
  } else {
    //Step 6 with cash collateral:
    let startingLimit = startingCreditLimtCalculatorWithCollateral(
      jnDefault.minimumCreditLimitAllowable,
      lowerCreditLimit
    );
    //Step 7 with cash collateral
    return approvedStartingLimitCalculator(
      startingLimit,
      container.requestedCreditLimit
    );
  }
};
/**
 * copies all the src properties into target
 * @param {Object} target
 * @param {Object} src
 * @return {Object} target
 */
window.copyInto = function (target, src) {
  if (!src) return null;
  target = target || {};
  this.Object.keys(src).forEach((prop) => {
    if (src.hasOwnProperty(prop)) {
      target[prop] = src[prop];
    }
  });
  return target;
};
/**
 * checks if object
 * @param {Object} obj
 * @return {Boolean}
 */
window.isObject = function (obj) {
  let type = typeof obj;
  return type === "object" && !!obj;
};
/**
 * checks if a string is empty
 * @param {String} value
 * @returns {Boolean}
 */
window.isEmptyString = function (value) {
  if (typeof value === "undefined" || value === null) {
    return true;
  }
  return false;
};
/**
 * Compares old state vs new state for fields
 * @param {Object} oldObject
 * @param {Object} newObject
 * @param {Array<String>} fields
 * @return {Boolean} change detected
 */
window.changeDetectedInObjects = function (oldObject, newObject, fields) {
  if (!oldObject || !newObject || !fields) return false;
  let first, second, third;
  return fields.some((field) => {
    //both have same fields and values are different
    first =
      isEmptyString(newObject[field]) === false ||
      validNumber(newObject[field]);
    second =
      isEmptyString(oldObject[field]) === false ||
      validNumber(oldObject[field]);
    third = newObject[field] !== oldObject[field];
    return first && second && third;
  });
};
/**
 * Calculates Creditor Life Rates for LOC/CC
 * @param {Map} jnDefaults
 * @param {Map} container
 * @return {Decimal}
 */
window.nonRevolvingCreditorLifeCalculator = function (jnDefaults, container) {
  let lifeProtectionAndCIRate =
    jnDefaults.creditCardLifeProtectionAndCriticalIllnessRate;
  let lifeProtectionRate = jnDefaults.creditCardLifeProtectionRate;
  let lineOfCreditCreditorLifeRate = jnDefaults.lineOfCreditLifeProtectionRate;
  let coverageType = container.coverageType;
  let ASL = container.approvedStartingLimit;
  let product = container.productFamily;
  if (product === CREDIT_CARD) {
    return creditCardCreditorLifeCalculator(
      lifeProtectionRate,
      lifeProtectionAndCIRate,
      coverageType,
      ASL
    );
  } else if (product === LINE_OF_CREDIT) {
    return lineOfCreditCreditorLifeCalculator(
      ASL,
      lineOfCreditCreditorLifeRate
    );
  }
  return 0;
};
/** simple debounce method for debouncing function call
 * @param {*} component
 * @param {Number} timerId
 * @param {Function} function to invoke
 * @param {Array<*>} arguments for the function to invoke
 */
window.debouncer = function (component, timerId, funcToCall, funcArguments) {
  let delay = 500;
  clearTimeout(timer);
  timerId = setTimeout(
    $A.getCallback(function () {
      if (funcToCall) {
        funcToCall.apply(this, funcArguments);
      }
    }),
    delay
  );
  component.set("v.timerId", timerId);
  return timerId;
};
/**
 * calculates the supplementary card holders fee
 * @param {Object} container
 * @param {Object} jnDefaults
 * @param {Number} calculateSupplemetaryFee
 * @returns {Number} supplementary CardHolder's Fee
 */
window.supplementaryCardHoldersFeeCalculation = function (
  container,
  jnDefaults,
  calculateSupplemetaryFee
) {
  if (
    validNumber(jnDefaults.supplementaryCardFee) &&
    validNumber(container.numberOfSupplementaryCardHolders)
  ) {
    if (container.numberOfSupplementaryCardHolders > 0) {
      return (
        container.numberOfSupplementaryCardHolders *
        jnDefaults.supplementaryCardFee *
        calculateGCT(jnDefaults.gct)
      );
    }
    return calculateSupplemetaryFee;
  }
  return ZERO;
};
/**
 * calculates line of credit annual fees
 * @param {Number} calculatePrimaryFee
 * @param {Object} jnDefaults
 * @param {Object} container
 * @returns {Number}
 */
window.lineOfCreditAnnualFeesCalculation = function (
  calculatePrimaryFee,
  jnDefaults,
  container
) {
  if (
    validNumber(container.approvedStartingLimit) &&
    validNumber(jnDefaults.locCreditLimitPercent)
  ) {
    calculatePrimaryFee =
      (jnDefaults.locCreditLimitPercent / 100) *
      container.approvedStartingLimit *
      calculateGCT(jnDefaults.gct);
    return calculatePrimaryFee;
  }
  return ZERO;
};
/**
 * calculates credit credit annual fees
 * @param {Object} container
 * @param {Number} calculatePrimaryFee
 * @param {Object} jnDefaults
 * @returns {Number}
 */
window.creditCardAnnualFeesCalculation = function (
  container,
  calculatePrimaryFee,
  jnDefaults
) {
  if (
    validNumber(jnDefaults.goldCardFee) &&
    validNumber(jnDefaults.classicCardFee)
  ) {
    if (container.cardType == CREDIT_TYPE_GOLD) {
      calculatePrimaryFee =
        jnDefaults.goldCardFee * calculateGCT(jnDefaults.gct);
    } else if (container.cardType == CREDIT_TYPE_CLASSIC) {
      calculatePrimaryFee =
        jnDefaults.classicCardFee * calculateGCT(jnDefaults.gct);
    }
    return calculatePrimaryFee;
  }
  return ZERO;
};

/**
 * Checks if a number is ZERO
 * @param {Number} number
 * @returns {Number}
 */
window.isZero = function (number) {
  if (validNumber(number) && parseFloat(number) === ZERO) {
    return true;
  }
  return false;
};
/** *
 * validates whether the supplied fields are valid, meaning not null, undefined etc
 * @param {Object} childContainer
 * @param {Object<Array>} values
 * @returns {Object}
 */
window.persistentFieldsValidator = function (childContainer, values) {
  const container = {};
  if (values && childContainer) {
    values.forEach((value) => {
      if (childContainer.hasOwnProperty(value.localName)) {
        if (
          validNumber(childContainer[value.localName]) ||
          !isEmpty(childContainer[value.localName])
        ) {
          if (value.hasOwnProperty("mappedName")) {
            container[value.mappedName] = childContainer[value.localName];
          } else {
            container[value.localName] = childContainer[value.localName];
          }
        }
      }
    });
    return container;
  }
  return null;
};
/**
 * displays toast message
 * @param {String} title
 * @param {String} message
 * @param {String} type
 * @returns {Void}
 */
window.showToast = function (title, message, type) {
  let toastEvent = $A.get("e.force:showToast");
  toastEvent.setParams({
    title: title,
    message: message,
    type: type
  });
  toastEvent.fire();
};
/**
 * Validates fields
 * @param {*} component
 * @param {Array<String>} validationArray
 */
window.validateFields = function (component, validationArray) {
  let components = [];
  validationArray.forEach((element) => {
    const cmp = component.find(element);
    if (cmp) {
      if (Array.isArray(cmp)) {
        components.concat(cmp);
      } else {
        components.push(cmp);
      }
    }
  });
  return components.reduce(function (validSoFar, inputCmp) {
    console.log(
      "Id = ",
      inputCmp.getLocalId(),
      inputCmp.get("v.validity").valid
    );
    inputCmp.showHelpMessageIfInvalid();
    return validSoFar && inputCmp.get("v.validity").valid;
  }, true);
};

/** JN1-4210
 * Validates Component
 * @param {Array<Boolean>} resultsFromChild
 */
window.isValidComponent = function (resultsFromChild) {
  return resultsFromChild.every(function (result) {
    if (result) {
      return true;
    }
    return false;
  });
};

/**
 * checks if the passed family is the selected product
 * @param {*} component
 * @param {String} family
 * @return {Boolean}
 */
window.checkProductFamily = function (component, family) {
  let selectedFlag = component.get("v.productSelection.productFamily");
  if (selectedFlag && family) {
    return selectedFlag.includes(family);
  }
  return false;
};

/**
 * Set the assignment fee when the policy provider is updated.
 */
(window.setAssignmentFees = function (component) {
  let data = component.get("v.ChildContainer");
  let jnDefaults = component.get("v.jnDefaultConfigs");
  console.log("jn defaults", JSON.parse(JSON.stringify(jnDefaults)));
  if (data.policyProvider !== null) {
    console.log("assignment fee ", jnDefaults.assignmentFee);
    let values = [{ key: "assignmentFee", value: jnDefaults.assignmentFee }];
    const result = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", result);
  } else {
    let values = [{ key: "assignmentFee", value: 0 }];
    const result = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", result);
  }
}),
  /**
   * Set the estimated stamp duty fees when the policy provider is updated.
   */
  (window.setEstimatedStampDutyFees = function (component) {
    let data = component.get("v.ChildContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    if (data.policyProvider !== null) {
      console.log(
        "estimate stamp duty fee ",
        jnDefaults.estimatedStampDutyAndAdminFee
      );
      let values = [
        {
          key: "estimatedStampDutyAndAdminFee",
          value: jnDefaults.estimatedStampDutyAndAdminFee
        }
      ];
      const result = updateChildContainerWithValue(component, values, false);
      component.set("v.ChildContainer", result);
    } else {
      let values = [{ key: "estimatedStampDutyAndAdminFee", value: 0 }];
      const result = updateChildContainerWithValue(component, values, false);
      component.set("v.ChildContainer", result);
    }
  });
