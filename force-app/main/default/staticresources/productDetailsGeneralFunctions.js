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
 * Updates child container attributes and its values. then toggles when it should be notified
 */
window.updateChildContainerNoNotification = function (component, values) {
  let container = component.get("v.ChildContainer");
  values.forEach((element) => {
    container[element.key] = element.value;
  });
  component.set("v.notifyContainerChange", false);
  component.set("v.ChildContainer", container);
  console.log("After updatinf child");
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
  if (component) {
    component.get("v.notifyContainerChange", true);
  }
};
/**
 * calculates the requested credit limit
 * @param {*} requestedCreditLimit
 * @param {*} capLimit
 */
window.calculatRequestedCreditBalanceLimit = function (requestedCreditLimit) {
  console.log("requested card limit: ", requestedCreditLimit);
  //console.log("requested card limit: ", REQUESTED_CREDIT_LIMIT_PERCENTAGE);
  return requestedCreditLimit * REQUESTED_CREDIT_LIMIT_PERCENTAGE;
};

/**
 * ************JN1-3969 ***********
 * calculates the annual fees for primary applicant
 * @param {*} jnDefaults
 * @param {*} creditFlag
 * @param {*} locFlag
 * @param {*} container
 */
window.annualFeesCalculator = function (
  jnDefaults,
  creditFlag,
  locFlag,
  container
) {
  debugger;
  let calculatePrimaryFee = 0;
  let calculateSupplemetaryFee = 0;
  if (creditFlag) {
    if (container.cardType == GOLD) {
      calculatePrimaryFee = (jnDefaults.goldCardFee + jnDefaults.gct) / 100;
    } else if (container.cardType == CLASSIC) {
      calculatePrimaryFee = (jnDefaults.classicCardFee + jnDefaults.gct) / 100;
    }

    if (container.numberOfSupplementaryCardHolders > 0) {
      let numberOfSupplementaryHolders =
        container.numberOfSupplementaryCardHolders;
      let annualFee = 0;
      for (let i = 0; i < numberOfSupplementaryHolders; i++) {
        annualFee += (jnDefaults.supplementaryCardFee + jnDefaults.gct) / 100;
      }
      calculateSupplemetaryFee = calculatePrimaryFee + annualFee;
    } else {
      calculateSupplemetaryFee = 0;
    }
  } else if (locFlag) {
    calculatePrimaryFee =
      (jnDefaults.locCreditLimitPercent / 100) * container.startingLimit +
      jnDefaults.gct / 100;
  }
  return {
    primaryAnnualFee: calculatePrimaryFee,
    supplementaryAnnualFee: calculateSupplemetaryFee
  };
};
