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
   * @return {void}
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
  }
});
