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
    console.log("toggle gets called");
    if (!isEmptyString(selected)) {
      if (selected == YES) {
        console.log("Flags toggled when yes");
        component.set("v.yesCreditorLifeFlag", true);
        component.set("v.noCreditorLifeFlag", false);
        component.set("v.disableLifeInsuranceCoverageFlag", false);
        component.set("v.disableCoverageTypeFlag", false);
        //clear fields that are not necessary when creditor life is not selected
        resetComponentValue("creditor-life-selected", component, null);
        console.log("Flags toggled when yes");
      } else if (selected == NO) {
        console.log("Flags toggled when no");
        component.set("v.yesCreditorLifeFlag", false);
        component.set("v.noCreditorLifeFlag", true);
        component.set("v.otherCreditorLifeReasonFlag", false);
        //clear fields that are not necessary when creditor life is selected
        resetComponentValue("creditor-life-not-selected", component, null);
        resetComponentValue("other-reason", component, "");
        console.log("Flags toggled when no");
      }
    }
  },

  /**
   * Toggles flags dependent on whether or not user selects creditor life for non-revolving loans
   * @param {Object} component
   * @return {void}
   */
  toggleReasonFlags: function (component, selected) {
    console.log("toggle gets called");
    if (!isEmptyString(selected)) {
      if (selected == OTHER) {
        component.set("v.otherCreditorLifeReasonFlag", true);
      } else {
        component.set("v.otherCreditorLifeReasonFlag", false);
        resetComponentValue("other-reason", component, "");
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
    }
    if (product === LINE_OF_CREDIT) {
      component.set("v.lineOfCreditFlag", true);
    }
  }
});
