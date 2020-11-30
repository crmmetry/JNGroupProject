/**
 * @param ratePerPeriod       The interest rate for the loan.
 * @param numberOfPayments    The total number of payments for the loan in months.
 * @param presentValue         The present value, or the total amount that a series of future payments is worth now;
 *                              Also known as the principal.
 * @param futureValue          The future value, or a cash balance you want to attain after the last payment is made.
 *                              If fv is omitted, it is assumed to be 0 (zero), that is, the future value of a loan is 0.
 * @param type                  Optional, defaults to 0. The number 0 (zero) or 1 and indicates when payments are due.
 *                              0 = At the end of period
 *                              1 = At the beginning of the period
 * @returns {number}
 */

/**
 * USAGE
 * example for pmt calculation
 * var totalMonths = calculateMonths(2, 5);
 * var rate = calculateRatePerPeriod(20);
 * var presentValue = 5425.54;
 * var calculation = calculatePMT(rate, totalMonths, -presentValue, 0, 0);
 * var roundedCalculation = parseFloat(calculation).toFixed(2);
 */
window.calculatePMT = function (
  ratePerPeriod,
  numberOfPayments,
  presentValue,
  futureValue,
  type
) {
  //checks if future is specified
  futureValue = typeof futureValue !== "undefined" ? futureValue : 0;
  //checks the type
  type = typeof type !== "undefined" ? type : 0;
  // the interest rate cannot be zero
  if (ratePerPeriod != 0.0) {
    // Interest rate exists,
    var q = Math.pow(1 + ratePerPeriod, numberOfPayments);
    return (
      -(ratePerPeriod * (futureValue + q * presentValue)) /
      ((-1 + q) * (1 + ratePerPeriod * type))
    );
  } else if (numberOfPayments != 0.0) {
    // No interest rate, but number of payments exists
    return -(futureValue + presentValue) / numberOfPayments;
  }

  return 0;
};

/**
 * calculate total months
 * @param {Integer} years
 * @param {Integer} months
 */
window.calculateMonths = function (years, months) {
  if (isEmpty(years) || isEmpty(months)) return 0;
  return parseFloat(years) * 12 + parseFloat(months);
};
/**
 * checks if the tenure is valid and that the previous tensure is not the same
 * @param {Integer} years
 * @param {Integer} months
 * @param {Decimal} previousValue
 * @return {Boolean}
 */
window.validTenure = function (years, months, previousValue) {
  const tenure = calculateMonths(years, months);
  if (!tenure) return false;
  if (tenure === previousValue) return false;
  return true;
};
/**
 * calculate rate period
 * @param {rate}
 */
window.calculateRatePerPeriod = function (rate) {
  return parseFloat(rate) / 100 / 12;
};
/**
 * check if field is empty
 * @param {Any} field
 * @return {Boolean}
 */
window.isEmpty = function (field) {
  if (typeof field === "undefined" || field === "" || field === null) {
    return true;
  }
  return false;
};
/**
 * check if a number field is empty
 * @param {Any} field
 * @return {Boolean}
 */
window.isNumberNotEmpty = function (field) {
  if (isEmpty(field) == false && field != 0) {
    return true;
  }
  return false;
};
/**
 * populate an object given a set of properties and validates whether the parent object has any of the properties
 * @param {Array<String>} properties
 * @param {Object} parentObj
 * @return {Objec}
 */
window.enlistAndValidateFields = function (properties, parentObj) {
  if (!properties || !parentObj) return null;
  let fields = {};
  properties.forEach(function (property) {
    fields[property] = false;
  });
  Object.keys(fields).forEach((field) => {
    if (parentObj.hasOwnProperty(field)) {
      if (isEmpty(parentObj[field]) === false) {
        fields[field] = true;
      }
    }
  });
  return fields;
};
/**
 * populate an object given a set of properties and validates whether the parent object has any of the properties
 * @param {Array<String>} properties
 * @param {Object} parentObj
 * @return {Objec}
 */
window.enlistAndValidateNumberFields = function (properties, parentObj) {
  if (!properties || !parentObj) return null;
  let fields = {};
  properties.forEach(function (property) {
    fields[property] = false;
  });
  Object.keys(fields).forEach((field) => {
    if (parentObj.hasOwnProperty(field)) {
      if (isNumberNotEmpty(parentObj[field])) {
        fields[field] = true;
      }
    }
  });
  return fields;
};
/**
 * helper function used to calculate pmt
 * @param {Array<String>} properties - fields on the parent object
 * @param {Object} parentObj actual object with the fields to pull from
 *                 {market, amount, years, months}
 * @return {Number | Null}
 */
window.basicPMTCalculator = function (properties, parentObj) {
  let validatedFields = enlistAndValidateFields(properties, parentObj);
  console.info("validatedFields", validatedFields);
  if (!validatedFields) return 0;
  let rate;
  let totalMonths;
  let pmtResult;
  //calculate rate per period
  if (validatedFields.market) {
    rate = calculateRatePerPeriod(parentObj.market);
  }

  //calculate total months
  if (validatedFields.years && validatedFields.months) {
    totalMonths = calculateMonths(parentObj.years, parentObj.months);
  }

  //actual pmt calculation
  if (rate && totalMonths && parentObj.loanAmount) {
    pmtResult = calculatePMT(rate, totalMonths, -parentObj.loanAmount, 0, 0);
    return roundedValue(pmtResult);
  }
  return 0;
};
/**
 * checks if a given object as all the required properties
 * @param {Array<String>} properties - fields on the parent object
 * @param {Object} parentObj
 * @return {Boolean}
 */
window.asAllValidDependencies = function (properties, parentObj) {
  if (!parentObj || !properties) return false;
  properties.forEach((field) => {
    if (parentObj.hasOwnProperty(field)) {
      if (isEmpty(parentObj[field])) {
        return false;
      }
    } else {
      return false;
    }
  });
  return true;
};

/**
 * calculates base GCT percentage
 * @param {Number} gctPercentage
 * @return {Number}
 */
window.calculateGCT = function (gctPercentage) {
  return 1 + gctPercentage;
};
/**
 * calculates
 * @param {Array<String>} properties - fields on the parent object
 * @param {Object} parentObj
 * @deprecated {Array<String>} requiredDependencies - required fields
 * @param {Number} gct
 * @return {Boolean}
 */
window.basicProcessingFeesCalculator = function (
  properties,
  parentObj,
  requiredDependencies,
  gct
) {
  let defaultValue = 0;
  const shouldWaiveProcessingFee =
    parentObj.hasOwnProperty("waiveProcessingFeeFlag") === false ||
    parentObj.waiveProcessingFeeFlag === true;
  const shouldIncludeInLoanAmountFlag =
    parentObj.hasOwnProperty("includeInLoanAmountFlag") === true &&
    parentObj.includeInLoanAmountFlag === true;
  gct = calculateGCT(gct);
  if (shouldIncludeInLoanAmountFlag) {
    if (
      parentObj.processingFeePercentagePerAnum &&
      parentObj.processingFeePercentagePerAnum >= defaultValue
    ) {
      let newParentObj = Object.assign({}, parentObj);
      let loanAmount = parentObj.loanAmount;
      loanAmount =
        (parentObj.processingFeePercentagePerAnum / 100) * gct * loanAmount;
      newParentObj.loanAmount = loanAmount;
      return {
        processingFee: roundedValue(loanAmount),
        monthlyProcessingFee: basicPMTCalculator(properties, newParentObj),
        processingFeeClosingCost: defaultValue
      };
    } else {
      return {
        processingFee: defaultValue,
        monthlyProcessingFee: defaultValue,
        processingFeeClosingCost: defaultValue
      };
    }
  } else {
    let processingFeeClosingCost = defaultValue;
    if (!shouldWaiveProcessingFee) {
      processingFeeClosingCost =
        (parentObj.processingFeePercentagePerAnum / 100) *
        gct *
        parentObj.loanAmount;
    }
    return {
      processingFee: defaultValue,
      monthlyProcessingFee: defaultValue,
      processingFeeClosingCost: roundedValue(processingFeeClosingCost)
    };
  }
};

/**
 * calculates JN Life Creditor Life Premium
 * @param {Decimal} loanAmount - loan ampunt taken from opportunity product sales price.
 * @param {Decimal} creditRating - Credit rating applicable to applicant.
 * @return {Deciaml}
 */
window.basicJNLifePremiumCalculator = function (loanAmount, creditRating) {
  return roundedValue((loanAmount / 1000) * creditRating);
};
/**
 * calculates JN Life Creditor Life P & I Premium
 * @param {Decimal} loanAmount - loan ampunt taken from opportunity product sales price.
 * @param {Decimal} creditRating - Credit rating applicable to applicant.
 * @return {Deciaml}
 */
window.basicJNLifePIPremiumCalculator = function (properties, parentObj) {
  if (!properties || !parentObj) {
    return null;
  }
  return basicPMTCalculator(properties, parentObj);
};

/**
 * calculates monthly compulsory savings
 * @param {Decimal} totalPI - Total Monthly PI to be included in loan amount.
 * @param {Decimal} savings - Amount of savings in percentage to be made by applicant.
 * @param {Decimal} amount - Amount to be saved in dollars.
 * @return {Deciaml}
 */
window.basicMonthlyCompulsorySavingsCalculator = function (
  totalPI,
  savings,
  amount
) {
  if (savings) {
    return roundedValue(totalPI * (savings / 100));
  }
  return amount;
};
/**
 * calculates Total Compulsory Savings (over repayment period)
 * @param {Decimal} monthlyCompulsorySavings - loan amount taken from opportunity product sales price.
 * @param {Decimal} tenure - Loan term.
 * @return {Deciaml}
 */
window.basicTotalMonthlyCompulsorySavingsCalculator = function (
  monthlyCompulsorySavings,
  tenure
) {
  return roundedValue(monthlyCompulsorySavings * tenure);
};
/**
 * calculates Totals for a collection of values
 * @param {List} amountsToBeSummed - List of amounts that should be total'd.
 * @return {Deciaml}
 */
window.basicTotalCalculator = function (amountsToBeSummed) {
  return amountsToBeSummed.reduce((a, b) => a + b, 0);
};

/**
 * calculates Assignment FeeAssignment Fee to be paid by applicant when applying for JNLife Creditor.
 * @param {Decimal} assignmentFee - assignmentFee to be paid by applicant.
 * @param {Decimal} gct - JN GCT rate to be included in loan calculations.
 * @return {Deciaml}
 */
window.basicAssignmentFeeCalculator = function (assignmentFee, gct) {
  return roundedValue(assignmentFee + assignmentFee * gct);
};

/**
 * summates any given set of numbers
 * @param {Object} parentObj -
 * @param {Array<String>} properties - fields on the parent object
 * @return {Decimal}
 */
window.basicTotalsCalculator = function (properties, parentObj) {
  let validatedFields = enlistAndValidateNumberFields(properties, parentObj);
  if (!validatedFields) return 0;

  let values = [];
  properties.forEach((property) => {
    if (validatedFields[property]) {
      values.push(parentObj[property]);
    }
  });
  return roundedValue(
    values
      .filter((value) => !isNaN(value))
      .reduce((a, b) => parseFloat(a) + parseFloat(b), 0)
  );
};
/**
 * summates given totals to calculate total closing cost.
 * @param {Object} parentObj -
 * @param {Array<String>} properties - fields on the parent object
 * @return {Decimal}
 */
window.calculateTotalClosingCost = function (properties, parentObj) {
  return roundedValue(basicTotalsCalculator(properties, parentObj));
};
/**
 * summates given totals to calculate total closing cost financed by JN.
 * @param {Object} parentObj -
 * @param {Array<String>} properties - fields on the parent object
 * @return {Decimal}
 */
window.calculateTotalClosingCostFinancedJN = function (properties, parentObj) {
  return roundedValue(basicTotalsCalculator(properties, parentObj));
};

/**
 * summates given totals to calculate total closing cost payable by applicant.
 * @param {Object} parentObj -
 * @param {Array<String>} properties - fields on the parent object
 * @return {Decimal}
 */
window.calculateTotalClosingCostPayableByApplicant = function (
  totalClosingCost,
  totalFinancedByJn
) {
  return roundedValue(
    parseFloat(totalClosingCost) - parseFloat(totalFinancedByJn)
  );
};
/**
 * calculates total loan payment
 * @param {Array} properties
 * @param {Object} parentObj
 * @return {Number}
 */
window.calculateTotalLoanAmount = function (properties, parentObj) {
  return basicTotalsCalculator(properties, parentObj);
};
/**
 * calculates total monthly loan payment
 * @param {Array} properties
 * @param {Object} parentObj
 * @return {Number}
 */
window.calculateTotalMonthlyPIPayment = function (properties, parentObj) {
  return basicTotalsCalculator(properties, parentObj);
};
/**
 * calculates total monthly loan payment
 * @param {Array} properties
 * @param {Object} parentObj
 * @return {Number}
 */
window.calculateTotalMonthlyPayment = function (properties, parentObj) {
  return basicTotalsCalculator(properties, parentObj);
};
/**
 * calculates total monthly loan and compulsory payment
 * @param {Array} properties
 * @param {Object} parentObj
 * @return {Number}
 */
window.calculateTotalMonthlyLoanCompulsoryPayment = function (
  properties,
  parentObj
) {
  return basicTotalsCalculator(properties, parentObj);
};

/**
 * calculates the total interest payment value
 * @param {Number} totalMonthlyPIPayment
 * @param {Number} totalLoanAmount
 * @param {Number} years
 * @param {Number} months
 * @return {Number}
 */
window.calculateTotalInterestPayment = function (
  totalMonthlyPIPayment,
  totalLoanAmount,
  years,
  months
) {
  let tenure = null;
  if (years && months) {
    tenure = calculateMonths(years, months);
  }
  if (tenure === null) {
    return 0;
  }
  if (totalLoanAmount && totalMonthlyPIPayment) {
    return roundedValue(totalMonthlyPIPayment * tenure - totalLoanAmount);
  }
  return 0;
};
/**
 * rounds the value by 2 decimal places
 * @param {Number} value
 * @return {Number}
 */
window.roundedValue = function (value) {
  if (!value) {
    return 0;
  }
  return parseFloat(value).toFixed(2);
};

/**
 * checks whether the set of numbers are valid from an object
 * @param {Array} properties
 * @param {Object} parentObj
 * @return {Boolean}
 */
window.validNumbersWithObject = function (properties, parentObj) {
  if (!properties || !parentObj) return false;
  return properties.every((property) => {
    if (!isEmpty(parentObj[property])) {
      return (
        !isNaN(parentObj[property]) && parseFloat(parentObj[property]) >= 0
      );
    }
    return false;
  });
};
/**
 * checks whether the number is valid
 * @param {Number} value
 * @return {Boolean}
 */
window.validNumber = function (value) {
  if (!isEmpty(value)) {
    return !isNaN(value) && parseFloat(value) >= 0;
  }
  return false;
};
/**
 * checks whether the set of numbers are valid from an object
 * @param {Map} data
 * @param {Decimal} minimum
 * @return {Decimal}
 */
window.LTVCalculatorAutoLoan = function (loanAmount, minimum) {
  if (validNumber(loanAmount) === false || validNumber(minimum) === false) {
    return 0;
  }
  return roundedValue((parseFloat(loanAmount) / parseFloat(minimum)) * 100);
};

/**
 * checks whether the set of numbers are valid from an object
 * @param {Decimal} startingLimit
 * @param {Decimal} existingDebt
 * @param {Decimal} deposit
 * @return {Decimal}
 */
window.LTVCalculatorCash = function (startingLimit, existingDebt, deposit) {
  if (
    validNumber(startingLimit) === false ||
    validNumber(existingDebt) === false ||
    validNumber(deposit) === false
  ) {
    return 0;
  }
  return roundedValue(
    ((parseFloat(startingLimit) + parseFloat(existingDebt)) /
      parseFloat(deposit)) *
      100
  );
};

/**
 * Calculates TDSR Before
 * @param {Decimal} grossIncome
 * @param {Decimal} totalDebt
 * @return {Decimal}
 */
window.TDSRBeforeCalculator = function (grossIncome, totalDebt) {
  if (validNumber(grossIncome) === false || validNumber(totalDebt) === false) {
    return 0;
  }
  return roundedValue((parseFloat(totalDebt) / parseFloat(grossIncome)) * 100);
};

/**
 * Calculates TDSR After
 * @param {Decimal} grossIncome
 * @param {Decimal} totalDebt
 * @return {Decimal}
 */
window.TDSRAfterCalculator = function (grossIncome, totalDebt, minimumPayment) {
  if (
    validNumber(grossIncome) === false ||
    validNumber(totalDebt) === false ||
    validNumber(minimumPayment) === false
  ) {
    return 0;
  }
  return roundedValue(
    ((parseFloat(totalDebt) + parseFloat(minimumPayment)) /
      parseFloat(grossIncome)) *
      100
  );
};

/**
 * //TODO:dont use
 * @param {*} fields
 * @param {*} container
 */
function fieldValidator(fields, container) {
  if (!fields || !container) return false;
  return fields.every((field) => {
    if (!container.hasOwnProperty(field) || isEmpty(container[field]))
      return false;
    switch (typeof container[field]) {
      case "string": {
        return isEmpty(container[fiel]);
      }
      case "number": {
        return validNumber(container[field]);
      }
      default:
        return isEmpty(container[field]);
    }
  });
}
//TODO: Check that parameters are valid
//ASL Step Calculations
/**
 * ASL Calculation Step 1: Calculate Annual Gross Income
 * @param {Decimal} monthlyGrossIncome
 * @return {Decimal}
 */
window.annualGrossIncomeCalculator = function (monthlyGrossIncome) {
  if (validNumber(monthlyGrossIncome)) {
    return parseFloat(monthlyGrossIncome) * 12;
  }
  return 0;
};

/**
 * ASL Calculation Step 1.5: Calculate MaximumCreditCardLimit
 * @param {Decimal} creditLimitAllowable
 * @param {Decimal} annualGrossIncome
 * @return {Decimal}
 */
window.maximumCreditLimitCalculator = function (
  creditLimitAllowable,
  annualGrossIncome
) {
  return parseFloat(creditLimitAllowable) * parseFloat(annualGrossIncome);
};

/**
 * ASL Calculation Step 2: Calculate Maximum allowable for monthly debt payments
 * @param {Decimal} monthlyGrossIncome
 * @param {Decimal} policyLimit
 * @return {Decimal}
 */
window.maximumAllowableForMonthlyDebtPaymentsCalculator = function (
  monthlyGrossIncome,
  policyLimit
) {
  return parseFloat(monthlyGrossIncome) * parseFloat(policyLimit);
};

/**
 * ASL Calculation Step 3: Calculate Maximum allowable for minimum payment
 * @param {Decimal} maxDebtPayment
 * @param {Decimal} existingDebt
 * @return {Decimal}
 */
window.maximumAllowableForMinimumPaymentCalculator = function (
  maxDebtPayment,
  existingDebt
) {
  return parseFloat(maxDebtPayment) - parseFloat(existingDebt);
};

/**
 * ASL Calculation Step 4: Calculate credit limit which returns the computed minimum payment
 * @param {Decimal} maxMinimumPayment
 * @param {Decimal} creditCardInterestRate
 * @param {Decimal} monthlyPrincipalPayment
 * @return {Decimal}
 */
window.computedMinimumPaymentFromCreditLimitCalculator = function (
  //TODO: Modify to check product name on component to choose pricipal payment component metadata
  maxMinimumPayment,
  creditCardInterestRate,
  monthlyPrincipalPayment
) {
  return (
    parseFloat(maxMinimumPayment) /
    (parseFloat(creditCardInterestRate) / 12 +
      parseFloat(monthlyPrincipalPayment))
  );
};

/**
 * ASL Calculation Step 5: Calculate Lower Credit Limit
 * @param {Decimal} computedMinimumPayment
 * @param {Decimal} maxCreditCardLimit
 * @return {Decimal}
 */
window.lowerCreditLimitCalculator = function (
  computedMinimumPayment,
  maxCreditCardLimit
) {
  return Math.min(
    parseFloat(computedMinimumPayment),
    parseFloat(maxCreditCardLimit)
  );
};

/**
 * ASL Calculation Step 6: Calculate Credit Limit after risk rating
 * @param {Decimal} lowerCreditLimit
 * @param {Decimal} riskRatingFactor
 * @return {Decimal}
 */
window.creditLimitRiskCalculator = function (
  lowerCreditLimit,
  riskRatingFactor
) {
  return parseFloat(lowerCreditLimit) * parseFloat(riskRatingFactor);
};

/**
 * ASL Calculation Step 7: Calculate Credit Limit after risk rating
 * @param {Decimal} creditLimitAfterRisk
 * @param {Decimal} discountFactor
 * @return {Decimal}
 */
window.startingCreditLimtCalculator = function (
  creditLimitAfterRisk,
  discountFactor
) {
  return parseFloat(creditLimitAfterRisk) * parseFloat(discountFactor) * 2;
};

/**
 * ASL Calculation Step 8: Calculate approve starting limit
 * @param {Decimal} startingCreditLimt
 * @param {Decimal} requestedLimit
 * @return {Decimal}
 */
window.approvedStartingLimitCalculator = function (
  creditLimitAfterRisk,
  requestedLimit
) {
  return Math.min(parseFloat(creditLimitAfterRisk), parseFloat(requestedLimit));
};
