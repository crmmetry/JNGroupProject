/**
 * this file consolidates all the reusable functions used in different aura components
 */
/**
 * Ver  Ticket#      Date            Author                  Purpose
 * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  To calculate the annual fees for primary applicant
 **/

/**
 * calculates savings
 * @param {Object} data
 * @param {Number} totalMonthly_PI_LoanPayment
 * @return {Object}
 */
function calculateSavings(data, totalMonthly_PI_LoanPayment) {
  if (
    validNumbersWithObject(
      ["totalMonthly_PI_LoanPayment", "months", "years"],
      data
    )
  ) {
    let tenure = calculateMonths(data.years, data.months);
    let monthlySavings = basicMonthlyCompulsorySavingsCalculator(
      totalMonthly_PI_LoanPayment,
      data.percentage,
      data.amount
    );
    let monthlySavingsOverRepaymentPeriod = basicTotalMonthlyCompulsorySavingsCalculator(
      monthlySavings,
      tenure
    );
    return {
      totalCompulsorySavingsBalance: parseFloat(
        monthlySavingsOverRepaymentPeriod
      ),
      monthlyCompulsorySavings: parseFloat(monthlySavings)
    };
  } else if (validNumbersWithObject(["amount"], data)) {
    let totalCompulsorySavings = data.amount * tenure;
    return {
      monthlyCompulsorySavings: data.amount,
      totalCompulsorySavingsBalance: totalCompulsorySavings
    };
  } else {
    return {
      totalCompulsorySavingsBalance: 0,
      monthlyCompulsorySavings: 0
    };
  }
}
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
  let cmp = component.find(auraId);
  if (cmp !== null) {
    cmp.set("v.value", value);
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
    if (container.cardType == CREDIT_TYPE_GOLD) {
      calculatePrimaryFee = jnDefaults.goldCardFee + jnDefaults.gct / 100;
    } else if (container.cardType == CREDIT_TYPE_CLASSIC) {
      calculatePrimaryFee = jnDefaults.classicCardFee + jnDefaults.gct / 100;
    }

    if (container.numberOfSupplementaryCardHolders > 0) {
      let numberOfSupplementaryHolders =
        container.numberOfSupplementaryCardHolders;
      let annualFee = 0;
      for (let i = 0; i < numberOfSupplementaryHolders; i++) {
        annualFee += jnDefaults.supplementaryCardFee + jnDefaults.gct / 100;
      }
      //Fee for Supplementary Card Holder = annual fee for Primary applicant  + annual fee for n number of card holders
      calculateSupplemetaryFee = calculatePrimaryFee + annualFee;
    } else {
      calculateSupplemetaryFee = 0;
    }
  } else if (locFlag) {
    /**
     * if Product family is Line of Credit then calculate the annual fees for primary applicant only
     * Primary Applicant Fee = LOC credit Limit % * Approved starting limit + GCT%
     **/
    calculatePrimaryFee =
      (jnDefaults.locCreditLimitPercent / 100) *
        container.approvedStartingLimit +
      jnDefaults.gct / 100;
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
window.ASLCalculator = function (container, jnDefault, riskFactor) {
  if (
    !validNumber(container.TDSRBefore) ||
    !validNumber(jnDefault.policyLimit) ||
    !validNumber(container.TDSRBefore) ||
    !validNumber(riskFactor)
  ) {
    return 0;
  }
  if (roundedValue(container.TDSRBefore / 100) > jnDefault.policyLimit) {
    return 0;
  }
  // //Step 1:
  let annualGrossIncome = annualGrossIncomeCalculator(
    container.grossMonthlyIncome
  );
  // //Step 1.5:
  let maxCredilLimit = maximumCreditLimitCalculator(
    jnDefault.creditLimitMax,
    jnDefault.creditLimitMin,
    annualGrossIncome
  );
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
    maxCredilLimit
  );
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
    third = newObject[field] != oldObject[field];
    return first && second && third;
  });
};
