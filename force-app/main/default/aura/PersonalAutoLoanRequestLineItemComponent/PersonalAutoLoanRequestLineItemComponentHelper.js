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
    let data = component.get("v.ParentContainer");
    if (validNumbersWithObject(["purchasePrice", "marketValue"], data)) {
      let minimum = Math.min(
        parseFloat(data.purchasePrice),
        parseFloat(data.marketValue)
      );
      component.set("v.minimum", minimum);
      console.log(minimum);
    }
  },
  /**
   * Calculates loan to value ration
   */
  calculateLTV: function (component) {
    let minimum = component.get("v.minimum");
    let data = component.get("v.ParentContainer");
    console.log("minimum data:", JSON.parse(JSON.stringify(data)));
    data.minimum = minimum;
    if (validNumbersWithObject(["loanAmount", "minimum"], data)) {
      let LTV = LTVCalculatorAutoLoan(data.loanAmount, minimum);
      console.log("ltv: ", LTV);
      console.log("minimum", minimum);
      this.updateChildContainerWithValue(component, [
        { key: "loanToValueRatio", value: LTV }
      ]);
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
