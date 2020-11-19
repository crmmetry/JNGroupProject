/**
 * this file consolidates all the reusable functions used in different aura components
 */

/**
 * Updates child container attributes and its values.
 */
window.updateChildContainerWithValue = function (
  component,
  values,
  shouldSetComponentValue
) {
  console.log("Function reached");
  let container = component.get("v.ChildContainer");
  values.forEach((element) => {
    container[element.key] = element.value;
    if (shouldSetComponentValue)
      component.set(`v.${element.key}`, element.value);
  });
  return container;
};

/**
 * Toggles cash investment flag.
 */
window.toggleCashInvestmentFlag = function (value) {
  console.log("cash investment flag toggled");
  if (value === "Cash/Investments") return true;
  return false;
};

/**
 * Toggles disability of account type.
 */
window.toggleAccountTypeDisability = function (value) {
  console.log("Function reached");
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
  if (selected === "JN Bank Ltd.") return fundManagerAccountTypeOptions;
  if (selected === "JN Fund Managers Ltd.") return jnBankAccountTypeOptions;
};

/**
 * Clears components with an identified aura id.
 */
window.clearSelectLists = function (auraId, component) {
  component.find(auraId).set("v.value", null);
};

/**
 * Sets any numerical field with a particular aura id to 0.
 */
window.clearNumericalInput = function (auraId, component) {
  component.find(auraId).set("v.value", 0);
};

/**
 * Sets any text field with a particular aura id to 0.
 */
window.clearNumericalInput = function (auraId, component) {
  component.find(auraId).set("v.value", "");
};
/**
 * Toggle account number fields layout
 */
window.toggleAccountNumberComponent = function (selected, component) {
  console.log("toggle account number");
  if (selected === "JN Bank Ltd.") {
    component.set("v.bankSelectedFlag", true);
    component.set("v.fundManagerSelectedFlag", false);
    console.log("toggle jn bank");
  }
  if (selected === "JN Fund Managers Ltd.") {
    component.set("v.fundManagerSelectedFlag", true);
    component.set("v.bankSelectedFlag", false);
    console.log("jn fund toggled");
  }
};
/**
 * Toggle visibility of existing balance field
 */
window.toggleHypothecatedLoanFlag = function (selected, component) {
  console.log("toggle hypothecated loan");
  if (selected === "Yes") {
    component.set("v.hypothecatedLoanFlag", true);
  }
  if (selected === "No") {
    component.set("v.hypothecatedLoanFlag", false);
  }
};
