/**
 * this file consolidates all the reusable functions used in different aura components
 */

/**
 * Updates child container attributes and its values.
 */
window.updateChildContainerWithValue = function (container, values) {
  values.forEach((element) => {
    container[element.key] = element.value;
    component.set(`v.${element.key}`, element.value);
  });
  return container;
};

/**
 * Toggles cash investment flag.
 */
window.toggleCashInvestmentFlag = function (data) {
  if (data.collateralType === "Cash/Investments") {
    return true;
  } else if (data.collateralType === "Unsecured (None)") {
    return false;
  }
};
