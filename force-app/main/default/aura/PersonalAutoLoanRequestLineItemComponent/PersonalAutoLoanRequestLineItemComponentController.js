({
  doInit: function (component, event, helper) {
    let personalAutoLoan = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null,
      purchasePrice: 0,
      marketValue: 0,
      loanToValueRatio: 0,
      minimumOfPurchaseMarketValue: 0,
      autoCollateralDeposit: 0,
      autoCollateralDepositPercentage: 0,
      computedAutoCollateralDepositFromPercentage: 0,
      makeAndModelOfVehicle: "",
      yearOfVehicle: 0
    };
    component.set("v.ChildContainer", personalAutoLoan);
    component.set("v.loanPurposeOptions", AUTO_LOAN_PURPOSE);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      let container = component.get("v.ChildContainer");
      //sets the minimum of purchase price vs market value
      container = helper.setMinimumValue(container);
      //calculate ltv value
      container = helper.calculateLTVAuto(container);
      helper.getApplicants(component); //TODO: REFACTOR CANNOT BE CALLED LIKE THIS
      //Calculate Deposit Percentage
      container = helper.calculateDepositPercentageAmount(container);
      //Validate Auto Collateral Deposit
      helper.validateAutoCollateralDeposit(container, component);
      fireProductDetailsEvent(null, container, component);
    }
  },
  onApplicantsChange: function (component, event, helper) {
    let applicant = component.get("v.applicants");
    const applicantsMap = {
      id: applicant[0].Id,
      rating: applicant[0].rating,
      age: applicant[0].age
    };
    const data = Object.assign(
      component.get("v.ParentContainer"),
      applicantsMap
    );
    component.set("v.ParentContainer", data);
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "loanPurpose",
        value: selected
      }
    ];
    helper.updateChildContainerWithValue(component, childKeyValuePairs, false);
  },

  onMotorVehicleDepositFormatChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.clearDepositPercentageAndDepositAmountWhenToggled(
      component,
      selected
    );
  },

  onPurchasePriceCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onMarketCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onDepositCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  onVehicleClassificationChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "vehicleClassification",
        value: selected
      }
    ];
    helper.updateChildContainerWithValue(component, childKeyValuePairs, false);
  },
  /** Validates child cmp fields - JN1-4201
   * @param {*} component
   * @return - Boolean
   */
  validateFields: function (component) {
    let cmpFields = [
      "market",
      "autoCollateralComputedDeposit",
      "vehiclePrice",
      "vehicleMarketValue",
      "vehicleYear",
      "makeModel",
      "amount",
      "years",
      "months",
      "autoCollateralDeposit",
      "motorVehicleDeposit",
      "loanPurpose",
      "vehicleClassification",
      "motorVehicleDepositRadioGroup"
    ];
    return validateFields(component, cmpFields);
  }
});
