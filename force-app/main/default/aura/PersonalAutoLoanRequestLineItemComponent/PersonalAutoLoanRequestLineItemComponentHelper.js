({
  //TODO: SHOULD BE OPTIMIZED, query applicants once then query there rating on subsequent calls
  getApplicants: function (component) {
    console.log("getApplicants called");
    let oppId = component.get("v.oppId");
    let data = component.get("v.ChildContainer");
    console.log(oppId);
    console.log(JSON.stringify(data));
    if (data.years && data.months) {
      console.log("server side called");
      //TODO: REVIEW with travis
      let tenure = calculateMonths(data.years, data.months) / 12;
      console.log("tenure and oppId:", tenure, oppId);
      let action = component.get("c.getApplicantsRating");
      action.setParams({
        oppId: oppId,
        tenure: tenure
      });
      action.setCallback(this, function (response) {
        let state = response.getState(); //Checking response status
        let result = response.getReturnValue();
        if (state === "SUCCESS") {
          component.set("v.applicants", result);
          console.log(result);
          console.log(
            "applicants: ",
            JSON.parse(JSON.stringify(component.get("v.applicants")))
          );
        } else {
          console.log("rror", response.getError());
        }
      });
      $A.enqueueAction(action);
    }
  },
  /**
   * compares purchase price and market value and sets the minimun as the result.
   */
  setMinimumValue: function (component) {
    let data = component.get("v.ChildContainer");
    if (validNumbersWithObject(["purchasePrice", "marketValue"], data)) {
      let minimumOfPurchaseMarketValue = Math.min(
        parseFloat(data.purchasePrice),
        parseFloat(data.marketValue)
      );
      this.updateChildContainerWithValue(component, [{
        key: "minimumOfPurchaseMarketValue",
        value: minimumOfPurchaseMarketValue
      }]);
    }
  },
  /**
   * Calculates loan to value ration
   */
  calculateLTV: function (component) {
    let data = component.get("v.ChildContainer");
    if (validNumbersWithObject(["loanAmount", "minimumOfPurchaseMarketValue"], data)) {
      let LTV = LTVCalculatorAutoLoan(data.loanAmount, data.minimumOfPurchaseMarketValue);
      console.log("ltv: ", LTV);
      // this.updateChildContainerWithValue(component, [
      //   { key: "loanToValueRatio", value: LTV }
      // ]);
    }
  },
  /**
   * Updates child container attributes and its values.
   */
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach((element) => {
      component.set(`v.${element.key}`, element.value);
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
