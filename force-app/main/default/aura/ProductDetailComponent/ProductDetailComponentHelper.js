({
  /**
   * Ver  Ticket#      Date            Author                  Purpose
   * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  To calculate the annual fees for primary applicant
   **/
  /**
   * Retrieves product selection wrapper from apex.
   * @param {*} container
   */
  updateProductSelection: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSingleProductFamilySelection");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.productSelection", result);
        this.updateProductSelectedFlag(component);
      }
    });

    $A.enqueueAction(action);
  },
  /**
   * Toggles the flags responsible for showing the different layouts depending on selected products.
   * @param {*} container
   */
  updateProductSelectedFlag: function (component) {
    let selectedFlag = component.get("v.productSelection.productFamily");
    const families = [
      { name: "Auto", variable: "autoFlag" },
      { name: "Unsecured", variable: "unsecuredFlag" },
      { name: "Credit Card", variable: "creditCardFlag" },
      { name: "Line Of Credit", variable: "lineOfCreditFlag" }
    ];
    const family = families.find((family) => {
      return selectedFlag.includes(family.name);
    });
    if (family) {
      component.set(`v.${family.variable}`, true);
    }
  },
  /**
   * Retrieves JNConfigurations from apex.
   * @param {*} container
   */
  getJNConfigurations: function (component) {
    let action = component.get("c.GetJNConfigs");
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.jnDefaultConfigs", result);
        console.log(JSON.parse(JSON.stringify(result)));
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * Retrieves All applicants belonging to a particular opportunity.
   * @param {*} container
   */
  getApplicants: function (component, oppId, tenure) {
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
        if (applicants.size() > 1) {
          component.set("v.multipleApplicantsFlag", true);
        }
        console.log(result);
        console.log(JSON.parse(JSON.stringify(component.get("v.applicants"))));
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * confirms whether current values are the same in the child even after recomputation
   * @param {*} container
   */
  redundancyRemover: function (component, container) {
    let childContainer = component.get("v.ChildContainer");
    container.forEach((element, index) => {
      if (childContainer.hasOwnProperty(element.key)) {
        if (element.value == childContainer[element.key]) {
          //remove element to update
          container.splice(index, 1);
        }
      }
    });
    return container;
  },
  /**
   * calculates processing fees
   */
  processingFeeCalculation: function (container, component) {
    const {
      processingFee,
      monthlyProcessingFee,
      processingFeeClosingCost
    } = basicProcessingFeesCalculator(
      ["years", "months", "loanAmount", "market"],
      container,
      ["years", "months", "loanAmount", "market", "includeInLoanAmountFlag"],
      component.get("v.jnDefaultConfigs.gct")
    );
    return [
      { key: "processingFeeClosingCost", value: processingFeeClosingCost },
      {
        key: "monthlyPrincipalInterestProcessingFee",
        value: monthlyProcessingFee
      },
      { key: "processingFeesGCT", value: processingFee }
    ];
  },

  /**
   * Gets Applicants Existing Debts.
   */
  getAssetsAndLiabilitiesForApplicant: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getApplicantsAssetsAndLiabilities");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        this.mergeWithChildContainer(component, result);
        this.existingDebtCalculation(component, result);
        this.TDSRCalculations(component, component.get("v.ChildContainer"));
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * Meges a list of object with child container
   * @param {*} component
   * @param {*} containerValues
   */
  mergeWithChildContainer: function (component, objectList) {
    const fieldsToMerge = { grossMonthlyIncome: true };
    let data = component.get("v.ChildContainer");
    objectList.forEach((element) => {
      Object.keys(element).forEach((key) => {
        if (fieldsToMerge.hasOwnProperty(key)) {
          data[key] = element[key];
        }
      });
    });
    component.set("v.ChildContainer", data);
  },
  /**
   * Calculate existing debt.
   */
  existingDebtCalculation: function (component, containerValues) {
    const fields = [
      "motorVehicleMonthlyRepayment",
      "otherAssetMonthlyPayment",
      "otherLoanMonthlyPayment",
      "personalMonthlyExpensesPriorLoan",
      "realEstateMonthlyPayment",
      "rentStrataMaintenance",
      "salutaryDeductions",
      "savingsPensionInsurance",
      "minimumPayment"
    ];
    let total = 0;
    const fieldsMap = {};
    fields.forEach((element) => (fieldsMap[element] = true));
    containerValues.forEach((element) => {
      Object.keys(element).forEach((key) => {
        console.log("key: ", key);
        if (fieldsMap.hasOwnProperty(key)) {
          total += element[key];
        }
      });
    });
    let values = [
      {
        key: "existingDebt",
        value: total
      }
    ];
    let data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
  },
  /**
   * calculates both TDSR before and TDSR after
   * @param {*} component
   * @param {Object} data
   * @return {Void}
   */
  TDSRCalculations: function (component, data) {
    let tdsrBefore = TDSRBeforeCalculator(
      data.grossMonthlyIncome,
      data.existingDebt
    );
    //TODO:Minimum Payment For Credit Facility should be calculated on a separate ticket outside sprint3 zero will be used as a place holder for now.
    let tdsrAfter = TDSRAfterCalculator(
      data.grossMonthlyIncome,
      data.existingDebt,
      0
    );
    let values = [
      {
        key: "TDSRBefore",
        value: tdsrBefore
      },
      {
        key: "TDSRAfter",
        value: tdsrAfter
      }
    ];
    let childValues = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", childValues);
  },

  /**
   * Passes LTV, TDSR After and Before as well as repayment method to the serverside
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  getCreditScoreRatings: function (component) {
    let container = component.get("v.ChildContainer");
    const { LTVValue, repaymentMethod, TDSRBefore, collateralType } = container;
    let action = component.get("c.getCreditRiskRating");
    if (
      !isEmpty(collateralType) &&
      validNumber(LTVValue) &&
      validNumber(TDSRBefore) &&
      !isEmpty(repaymentMethod)
    ) {
      console.info("Call getCreditScoreRatings", roundedValue(LTVValue));
      action.setParams({
        oppId: component.get("v.recordId"),
        ltv: this.LTVApplicableValue(component, container),
        repaymentMethod: repaymentMethod,
        tdsrBefore: roundedValue(TDSRBefore),
        collateral: collateralType
      });
      action.setCallback(this, function (response) {
        let state = response.getState();
        let result = response.getReturnValue();
        if (state === "SUCCESS") {
          console.info("Risk", result);
          container.riskRating = result;
          container.creditRiskScore = result.score;
          container.creditRiskRating = result.rating;
          component.set("v.ChildContainer", container);
        } else {
          console.info(JSON.stringify(response.getError()));
        }
      });
      $A.enqueueAction(action);
    }
  },
  /**
   * Compares old state vs new state of child container
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  detectObjectChanges: function (oldObject, newObject, fields) {
    if (!oldObject || !newObject || !fields) return false;
    return fields.every((field) => {
      //both have same fields and values are different
      if (newObject.hasOwnProperty(field) && oldObject.hasOwnProperty(field)) {
        //check if both are valid numbers
        const valid =
          validNumber(newObject[field]) && validNumber(oldObject[field]);
        return valid && newObject[field] !== oldObject[field];
      }
      return false;
    });
  },
  /**
   * checks whether current product family is auto or line of credit
   * @param {*} component
   * @param {Objec} container
   * @return {Number} ltv
   */
  LTVApplicableValue: function (component, container) {
    let selectedFlag = component.get("v.productSelection.productFamily");
    const families = [{ name: "Auto" }, { name: "Line Of Credit" }];
    const family = families.find((family) => {
      return selectedFlag.includes(family.name);
    });
    if (family) {
      return roundedValue(container.LTVValue);
    }
    return 0;
  },

  /**
   * JN1-3969
   * Gets the supplementary card holders wrapper and sets the number of supplementary card holder in child container
   * @param {*} component
   */
  getSupplementaryCardHolders: function (component) {
    let container = component.get("v.ChildContainer");
    let numberOfSupplementaryCardHolders = 0;
    let action = component.get("c.getSupplementaryCardHolders");

    action.setParams({
      oppId: component.get("v.recordId")
    });
    action.setCallback(this, function (response) {
      debugger;
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        console.info("new result", result.length);
        if (result != undefined && result.length > 0) {
          numberOfSupplementaryCardHolders = result.length;
        } else {
          numberOfSupplementaryCardHolders = 0;
        }
        let values = [
          {
            key: "numberOfSupplementaryCardHolders",
            value: numberOfSupplementaryCardHolders
          },
          {
            key: "cardType",
            value: "Gold"
          }
        ];
        let childValues = updateChildContainerWithValue(
          component,
          values,
          false
        );
        component.set("v.ChildContainer", childValues);
      } else {
        console.info(JSON.stringify(response.getError()));
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * JN1-3969
   * Calculate the annual fees for the primary applicant
   * @param {*} container
   * @param {*} component
   */
  annualFeesCalcualtions: function (container, component) {
    debugger;
    const JNDefaults = component.get("v.jnDefaultConfigs");
    const creditFlag = component.get("v.creditCardFlag");
    const locFlag = component.get("v.lineOfCreditFlag");
    const { primaryAnnualFee, supplementaryAnnualFee } = annualFeesCalculator(
      JNDefaults,
      creditFlag,
      locFlag,
      container
    );
    console.log(primaryAnnualFee, supplementaryAnnualFee);
    return [
      { key: "primaryApplicantAnnualMembership", value: primaryAnnualFee },
      {
        key: "supplementaryApplicantAnnualMembership",
        value: supplementaryAnnualFee
      }
    ];
  }
});
