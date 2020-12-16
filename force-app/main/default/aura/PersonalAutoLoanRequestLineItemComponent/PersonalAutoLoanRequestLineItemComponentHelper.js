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
  setMinimumValue: function (data) {
    if (validNumbersWithObject(["purchasePrice", "marketValue"], data)) {
      let minimumOfPurchaseMarketValue = Math.min(
        parseFloat(data.purchasePrice),
        parseFloat(data.marketValue)
      );
      data.minimumOfPurchaseMarketValue = minimumOfPurchaseMarketValue;
    }
    return data;
  },
  /**
   * Calculates loan to value ration
   */
  calculateLTVAuto: function (data) {
    if (
      validNumbersWithObject(
        ["loanAmount", "minimumOfPurchaseMarketValue"],
        data
      )
    ) {
      data.LTVValue = LTVCalculatorAutoLoan(
        data.loanAmount,
        data.minimumOfPurchaseMarketValue
      );
    }
    return data;
  },
  /**
   * Updates child container attributes and its values.
   */
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach((element) => {
      //component.set(`v.${element.key}`, element.value);
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  },
  /**
   * Clear the deposit percentage from container when amount is toggeled
   */
  clearDepositPercentageWhenAmountIsSelected: function (component) {
    let childKeyValuePairs = [
      {
        key: "autoCollateralDepositPercentage",
        value: 0
      },
      {
        key: "computedAutoCollateralDepositFromPercentage",
        value: 0
      }
    ];
    this.updateChildContainerWithValue(component, childKeyValuePairs, false);
  },
  /**
   * Calculates deposit percentage amount
   */
  calculateDepositPercentageAmount: function (data) {
    if (
      validNumbersWithObject(
        ["autoCollateralDepositPercentage", "minimumOfPurchaseMarketValue"],
        data
      )
    ) {
      data.computedAutoCollateralDepositFromPercentage = autoCollateralDepositPercentageCalculator(
        data.autoCollateralDepositPercentage,
        data.minimumOfPurchaseMarketValue
      );
    }
    return data;
  },
  /**
   * Calculates deposit percentage amount
   */
  validateAutoCollateralDeposit: function (data, component) {
    if (
      !isZero(data.autoCollateralDeposit) &&
      !isZero(data.loanAmount) &&
      !isZero(data.minimumOfPurchaseMarketValue)
    ) {
      console.log("VALIDATION BEGIN");
      let minimumAndDepositDifference =
        data.autoCollateralDeposit - data.minimumOfPurchaseMarketValue;
      if (data.loanAmount !== minimumAndDepositDifference) {
        let depositField = component.find("auto-collateral-deposit");
        depositField.set("v.validity", { valid: false, badInput: true });
        depositField.showHelpMessageIfInvalid();
      }
    } else if (
      !isZero(data.computedAutoCollateralDepositFromPercentage) &&
      !isZero(data.loanAmount) &&
      !isZero(data.minimumOfPurchaseMarketValue)
    ) {
      let minimumAndDepositDifference =
        data.computedAutoCollateralDepositFromPercentage -
        data.minimumOfPurchaseMarketValue;
      if (data.loanAmount !== minimumAndDepositDifference) {
        let depositField = component.find("auto-collateral-computed-deposit");
        depositField.set("v.validity", { valid: false, badInput: true });
        depositField.showHelpMessageIfInvalid();
      }
    }
  }
});
