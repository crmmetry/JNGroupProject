({
  /** JN1-4212
   * Validate the inpute fields on the component
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let personalCreditCardRequestLineComponent = component.find(
      "personalCreditCardRequestLineComponent"
    );
    let creditCardOtherDetailsLineComponent = component.find(
      "creditCardOtherDetailsLineComponent"
    );
    let resultsFromChild = [
      personalCreditCardRequestLineComponent.validateFields(component),
      creditCardOtherDetailsLineComponent.validateFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
