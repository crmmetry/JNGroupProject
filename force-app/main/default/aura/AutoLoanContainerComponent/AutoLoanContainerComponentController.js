({
  doinit: function (component, event, helper) {},
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
      personalAutoLoanRequestLineItemCmp.validateFields(component),
      autoLoanFeaturesLineItemCmp.validateFields(component),
      autoLoanCreditCalculationsLineCmp.validateFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
