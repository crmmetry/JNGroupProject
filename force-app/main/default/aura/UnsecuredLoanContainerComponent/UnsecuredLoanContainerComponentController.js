({
  doInit: function (component, event, helper) {
    component.set("v.loanPurposeOptions", UNSECURED_LOAN_PURPOSE);
  },
  /**
   * JN1-4210 : For validating fields
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let fieldsToValidateArray = ["unsecuredOnLoanPurposeChange"];
    let requestedDetailsLineItemComponent = component.find(
      "requestedDetailsLineItemComponent"
    );
    let unsecuredLoanFeatureLineItemComponent = component.find(
      "unsecuredLoanFeatureLineItemComponent"
    );
    let creditCalculationsLineItemComponent = component.find(
      "creditCalculationsLineItemComponent"
    );
    let resultsFromChild = [
      validateFields(component, fieldsToValidateArray),
      requestedDetailsLineItemComponent.validateFields(component),
      unsecuredLoanFeatureLineItemComponent.validateFields(component),
      creditCalculationsLineItemComponent.validateFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
