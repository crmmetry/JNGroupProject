({
  updateChildContainer: function (
    component,
    containerValues,
    shouldSetComponentValue
  ) {
    let data = updateChildContainerWithValue(
      component,
      containerValues,
      shouldSetComponentValue
    );
    component.set("v.ChildContainer", data);
  },

  /**
   * Toggles flags dependent on whether or not user selects creditor life for non-revolving loans
   * @param {Object} component
   * @return {Boolean}
   */
  toggleCreditorLifeFlags: function (component, selected) {
    if (!isEmptyString(selected)) {
      if (selected == YES) {
        component.set("v.yesCreditorLifeFlag", true);
        component.set("v.noCreditorLifeFlag", false);
        component.set("v.disableLifeInsuranceCoverageFlag", false);
        component.set("v.disableCoverageTypeFlag", false);
        //clear fields that are not necessary when creditor life is not selected
        resetComponentValue("creditorLifeSelected", component, null);
        //reset attributes on child container
        let childKeyValuePairsToBeReset = [
          {
            key: "noCreditorLifeReason",
            value: ""
          }
        ];
        let data = updateChildContainerWithValue(
          component,
          childKeyValuePairsToBeReset,
          false
        );
        component.set("v.ChildContainer", data);
      } else if (selected == NO) {
        component.set("v.yesCreditorLifeFlag", false);
        component.set("v.noCreditorLifeFlag", true);
        component.set("v.otherCreditorLifeReasonFlag", false);
        //clear fields that are not necessary when creditor life is selected
        resetComponentValue("creditorLifeNotSelected", component, null);
        resetComponentValue("otherReason", component, "");
        //reset attributes on child container
        let childKeyValuePairsToBeReset = [
          {
            key: "coverageType",
            value: ""
          },
          {
            key: "lifeInsuranceCoverage",
            value: ""
          }
        ];
        let data = updateChildContainerWithValue(
          component,
          childKeyValuePairsToBeReset,
          false
        );
        component.set("v.ChildContainer", data);
      }
    }
  },

  /**
   * Toggles flags dependent on whether or not user selects creditor life for non-revolving loans
   * @param {Object} component
   * @return {void}
   */
  toggleReasonFlags: function (component, selected) {
    if (!isEmptyString(selected)) {
      if (selected == OTHER) {
        component.set("v.otherCreditorLifeReasonFlag", true);
      } else {
        component.set("v.otherCreditorLifeReasonFlag", false);
        resetComponentValue("otherReason", component, "");
      }
    }
  },

  /**
   * Toggles layout between Credit Card and Line of credit for Life Insurance field set
   * @param {Object} component
   * @return {void}
   */
  toggleProductFlags: function (component) {
    let container = component.get("v.ParentContainer");
    let product = container.productFamily;
    if (product === CREDIT_CARD) {
      component.set("v.creditCardFlag", true);
      component.set("v.creditorLifeCoverage", CREDIT_CARD_APPLICANT_COVERAGE);
    }
    if (product === LINE_OF_CREDIT) {
      component.set("v.lineOfCreditFlag", true);
      component.set(
        "v.creditorLifeCoverage",
        LINE_OF_CREDIT_APPLICANT_COVERAGE
      );
    }
  }
});
