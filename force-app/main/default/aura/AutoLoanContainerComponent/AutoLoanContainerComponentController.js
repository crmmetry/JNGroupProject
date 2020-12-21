({
  doinit: function (component, event, helper) {
    console.log(
      "Auto Loan Container: ",
      component.get("v.CreditRepaymentContainer")
    );
  },
  /** Validates cmp fields - JN1-4201
   * @param {*} component
   * @return - Boolean
   */
  validateFields: function (component) {
    let personalAutoLoanRequestLineItemCmp = component.find(
      "personalAutoLoanRequestLineItemCmp"
    );
    let autoLoanFeaturesLineItemCmp = component.find(
      "autoLoanFeaturesLineItemCmp"
    );
    let autoLoanCreditCalculationsLineCmp = component.find(
      "autoLoanCreditCalculationsLineCmp"
    );
    let resultsFromChild = [
      personalAutoLoanRequestLineItemCmp.validateCmpFields(component),
      autoLoanFeaturesLineItemCmp.validateCmpFields(component),
      autoLoanCreditCalculationsLineCmp.validateCmpFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
