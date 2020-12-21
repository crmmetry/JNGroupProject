({
  /** Validates cmp fields - JN1-4201
   * @return - Boolean
   */
  validateFields: function (component) {
    console.log("Credit");
    let personalCreditcardRequestLineCmp = component.find(
      "personalCreditcardRequestLineCmp"
    );
    console.info(
      "personalCreditcardRequestLineCmp",
      personalCreditcardRequestLineCmp.validateFields(component)
    );
    let creditCardOtherDetailsLineComponent = component.find(
      "creditCardOtherDetailsLineCmp"
    );
    console.info(
      "creditCardOtherDetailsLineComponent",
      creditCardOtherDetailsLineComponent.validateFields(component)
    );
    let resultsFromChild = [
      personalCreditcardRequestLineCmp.validateFields(component),
      creditCardOtherDetailsLineComponent.validateFields(component)
    ];
    return isValidComponent(resultsFromChild);
  }
});
