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
  return parseFloat(years) * 12 + parseFloat(months);
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
 * helper function used to calculate pmt
 * @param {Array<String>} properties - fields on the parent object
 * @param {Object} parentObj actual object with the fields to pull from
 *                 {market, amount, years, months}
 * @return {Number | Null}
 */
window.basicPMTCalculator = function (properties, parentObj) {
  let validatedFields = enlistAndValidateFields(properties, parentObj);
  if (!validatedFields) return null;
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
    return parseFloat(pmtResult).toFixed(2);
  }
  return null;
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
 * @param {Array<String>} requiredDependencies - required fields
 * @param {Number} gct
 * @return {Boolean}
 */
window.basicProcessingFeesCalculator = function (
  properties,
  parentObj,
  requiredDependencies,
  gct
) {
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
      parentObj.processingFeePercentagePerAnum >= 0
    ) {
      let newParentObj = Object.assign({}, parentObj);
      let loanAmount = parentObj.loanAmount;
      loanAmount =
        (parentObj.processingFeePercentagePerAnum / 100) *
        gct *
        loanAmount;
      newParentObj.loanAmount = loanAmount;
      return {
        processingFee:  loanAmount,
        monthlyProcessingFee: basicPMTCalculator(properties, newParentObj),
        processingFeeClosingCost: 0
      };
    } else {
      return {
        processingFee: 0,
        monthlyProcessingFee: 0,
        processingFeeClosingCost: 0
      };
    }
  } else {
    let processingFeeClosingCost = 0;
    if (!shouldWaiveProcessingFee) {
      processingFeeClosingCost =
        (parentObj.processingFeePercentagePerAnum / 100) *
        gct *
        parentObj.loanAmount;
    }
    return {
      processingFee: 0,
      monthlyProcessingFee: 0,
      processingFeeClosingCost: processingFeeClosingCost
    };
  }
};


/**
 * summates any given set of numbers
 * @param {Object} parentObj - 
 * @param {Array<String>} properties - fields on the parent object
 * @return {Decimal}
 */
window.basicTotalsCalculator = function (properties, parentObj) {
  let validatedFields = enlistAndValidateFields(properties, parentObj);
  if (!validatedFields) return null;
  let allValid = true;
  Object.keys(validatedFields).forEach((key) => {
    if (validatedFields[key] === false) {
      allValid = false;
    }
  });
  if (allValid === false) return 0;
  let values = [];
  properties.forEach((property) => {
    if (validatedFields.property) {
      values.push(parentObj[property]);
    }
  });
  return values.reduce((a, b) => a + b, 0);
};

window.calculateTotalLoanAmount = function (properties, parentObj) {
  //const properties = ["loanAmount","jnLifeCreditorPremium","processingFeesGCT","jngiMotorPremium"];
  return basicTotalsCalculator(properties, parentObj);
}
window.calculateTotalMonthlyPIPayment = function (properties, parentObj) {
  //const properties = ["monthly_PI_LoanAmount","monthlyJnLifeCreditor_PI_Premium","monthlyPrincipalInterestProcessingFee","monthlyPIJNGIMotorPremium"];
  return basicTotalsCalculator(properties, parentObj);
}
window.calculateTotalMonthlyPayment = function (properties, parentObj) {
  //const properties = ["totalMonthlyPIPayment", "premium"]
  return basicTotalsCalculator(properties, parentObj);
}
window.calculateTotalMonthlyLoanCompulsoryPayment = function (properties, parentObj) {
  //const properties = ["totalMonthlyPayment", "monthlyCompulsorySavings"]
  return basicTotalsCalculator(properties, parentObj);
}
window.calculateTotalInterestPayment = function (totalMonthlyPIPayment, totalLoanAmount, years, months) {
  let tenure = null;
  if (years && months) {
    tenure = calculateMonths(years, months);
  }
  if (tenure === null) {
    return 0;
  }
  if (totalLoanAmount && totalMonthlyPIPayment) {
    return totalMonthlyPIPayment * tenure - totalLoanAmount;
  }
}