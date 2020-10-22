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
  if (
    typeof field === "undefined" ||
    field === "" ||
    field === null ||
    isNaN(field)
  ) {
    return true;
  }
  return false;
};
