({
  /** Validates cmp fields - JN1-4201
   * @return - Boolean
   */
  validateFields: function (component) {
    let personalCreditcardRequestLineCmp = component.find(
      "personalCreditcardRequestLineCmp"
    );
    let creditCardOtherDetailsLineComponent = component.find(
      "creditCardOtherDetailsLineCmp"
    );
    let resultsFromChild = [
      personalCreditcardRequestLineCmp.validateFields(component),
      creditCardOtherDetailsLineComponent.validateCmpFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
