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
      if (!isZero(data.purchasePrice) && isZero(data.marketValue)) {
        let minimumOfPurchaseMarketValue = data.purchasePrice;
        data.minimumOfPurchaseMarketValue = minimumOfPurchaseMarketValue;
        return data;
      } else if (isZero(data.purchasePrice) && !isZero(data.marketValue)) {
        let minimumOfPurchaseMarketValue = data.marketValue;
        data.minimumOfPurchaseMarketValue = minimumOfPurchaseMarketValue;
        return data;
      }
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
  clearDepositPercentageAndDepositAmountWhenToggled: function (
    component,
    selected
  ) {
    if (selected === "amount") {
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
    } else if (selected === "percent") {
      let childKeyValuePairs = [
        {
          key: "autoCollateralDeposit",
          value: 0
        }
      ];
      this.updateChildContainerWithValue(component, childKeyValuePairs, false);
    }
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
    const depositAutoCollateralField = component.find(
      "auto-collateral-deposit"
    );
    const depositComputedAutoCollateralField = component.find(
      "aautoCollateralComputedDeposit"
    );
    if (
      !isZero(data.autoCollateralDeposit) &&
      validNumber(data.autoCollateralDeposit) &&
      !isZero(data.loanAmount) &&
      validNumber(data.loanAmount) &&
      !isZero(data.minimumOfPurchaseMarketValue) &&
      validNumber(data.minimumOfPurchaseMarketValue) &&
      !isEmpty(depositAutoCollateralField)
    ) {
      let minimumAndDepositDifference =
        data.minimumOfPurchaseMarketValue - data.autoCollateralDeposit;
      if (data.loanAmount !== minimumAndDepositDifference) {
        depositAutoCollateralField.setCustomValidity(
          "Loan amount must be equal to the difference between the deposit and the minimum"
        );
        depositAutoCollateralField.reportValidity();
      } else {
        depositAutoCollateralField.setCustomValidity("");
        depositAutoCollateralField.reportValidity();
      }
    } else if (
      !isZero(data.computedAutoCollateralDepositFromPercentage) &&
      validNumber(data.computedAutoCollateralDepositFromPercentage) &&
      !isZero(data.loanAmount) &&
      validNumber(data.loanAmount) &&
      !isZero(data.minimumOfPurchaseMarketValue) &&
      validNumber(data.minimumOfPurchaseMarketValue) &&
      !isEmpty(depositComputedAutoCollateralField)
    ) {
      let minimumAndDepositDifference =
        data.minimumOfPurchaseMarketValue -
        data.computedAutoCollateralDepositFromPercentage;
      if (data.loanAmount !== minimumAndDepositDifference) {
        depositComputedAutoCollateralField.setCustomValidity(
          "Loan amount must be equal to the difference between the deposit and the minimum"
        );
        depositComputedAutoCollateralField.reportValidity();
      } else {
        depositComputedAutoCollateralField.setCustomValidity("");
        depositComputedAutoCollateralField.reportValidity();
      }
    }
  }
});
