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
        let data = copyInto(component.get("v.ChildContainer"), result);
        component.set("v.ChildContainer", data);
        this.updateProductSelectedFlag(component);
        const creditFlag = component.get("v.creditCardFlag");
        const supplementaryCountSet = component.get(
          "v.isSupplementaryCountSet"
        );
        if (creditFlag && !supplementaryCountSet) {
          this.getSupplementaryCardHolders(component); //JN1-3969
        }
      }
    });

    $A.enqueueAction(action);
  },
  /**
   * Toggles the flags responsible for showing the different layouts depending on selected products.
   * @param {*} container
   */
  updateProductSelectedFlag: function (component) {
    console.log(
      "updateProductSelectedFlag",
      JSON.parse(JSON.stringify(component.get("v.productSelection")))
    );
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
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * Retrieves risk rating map from apex
   * @param {*} container
   */
  getRiskRatingFactorsMap: function (component) {
    let action = component.get("c.getRiskRatingMap");
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.RiskRatings", result);
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
        if (applicants.length > 1) {
          component.set("v.multipleApplicantsFlag", true);
        }
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
    console.log("existingDebtCalculation");
    fields.forEach((element) => (fieldsMap[element] = true));
    containerValues.forEach((element) => {
      Object.keys(element).forEach((key) => {
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
    //component.set("v.ChildContainer", data);
  },
  /**
   * calculates  TDSR before
   * @param {*} component
   * @param {Object} data
   * @return {Void}
   */
  TDSRCalculationBefore: function (component) {
    let container = component.get("v.ChildContainer");
    let tdsrBefore = TDSRBeforeCalculator(
      container.grossMonthlyIncome,
      container.existingDebt
    );
    let values = [
      {
        key: "TDSRBefore",
        value: tdsrBefore
      }
    ];
    let data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    return values;
  },
  /**
   * calculates  TDSR before
   * @param {*} component
   * @param {Object} data
   * @return {Void}
   */
  TDSRCalculationAfter: function (component) {
    let container = component.get("v.ChildContainer");
    let tdsrAfter = TDSRAfterCalculator(
      container.grossMonthlyIncome,
      container.existingDebt,
      container.minimumPayment
    );
    let values = [
      {
        key: "TDSRAfter",
        value: tdsrAfter
      }
    ];
    let data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    return values;
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
          let values = [
            { key: "creditRiskScore", value: result.score },
            { key: "creditRiskRating", value: result.rating }
          ];
          console.log("Updating Risk Score");
          updateChildContainerWithNotification(component, values);
          console.log("After Updating Risk Score");
        } else {
          console.info(JSON.stringify(response.getError()));
        }
      });
      $A.enqueueAction(action);
    } else {
      console.log("===Nothing===");
    }
  },
  /**
   * Compares old state vs new state of child container
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  changeDetectedInObjects: function (oldObject, newObject, fields) {
    if (!oldObject || !newObject || !fields) return false;
    return fields.every((field) => {
      //both have same fields and values are different
      let val =
        isEmpty(newObject[field]) === false ||
        (validNumber(newObject[field]) &&
          isEmpty(oldObject[field]) === false) ||
        (validNumber(oldObject[field]) &&
          newObject[field] !== oldObject[field]);
      console.info("Did change", val, "Field ", field);
      return val;
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
   * checks if the passed family is the selected product
   * @param {*} component
   * @param {String} family
   * @return {Boolean}
   */
  checkProductFamily: function (component, family) {
    let selectedFlag = component.get("v.productSelection.productFamily");
    return family === selectedFlag;
  },
  /**
   * //TODO: only call this function for credit card type. also beware its dependencies are async
   * JN1-3969
   * Gets the supplementary card holders wrapper and sets the number of supplementary card holder in child container
   * @param {*} component
   */

  getSupplementaryCardHolders: function (component) {
    let numberOfSupplementaryCardHolders = 0;
    let action = component.get("c.getSupplementaryCardHolders");
    action.setParams({
      oppId: component.get("v.recordId")
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        if (result != undefined && result.length > 0) {
          numberOfSupplementaryCardHolders = result.length;
        } else {
          numberOfSupplementaryCardHolders = 0;
        }
        let values = [
          {
            key: "numberOfSupplementaryCardHolders",
            value: numberOfSupplementaryCardHolders
          }
        ];
        let childValues = updateChildContainerWithValue(
          component,
          values,
          false
        );
        component.set("v.ChildContainer", childValues);
        component.set("v.isSupplementaryCountSet,true");
      } else {
        console.info(JSON.stringify(response.getError()));
      }
    });
    $A.enqueueAction(action);
  },
  /**
   * JN1-3969
   * Calculate the annual fees for the primary applicant and Supplementary card holders
   * @param {*} component
   */
  annualFeesCalcualtions: function (component) {
    const container = component.get("v.ChildContainer");
    const JNDefaults = component.get("v.jnDefaultConfigs");
    const creditFlag = component.get("v.creditCardFlag");
    const locFlag = component.get("v.lineOfCreditFlag");
    const { primaryAnnualFee, supplementaryAnnualFee } = annualFeesCalculator(
      JNDefaults,
      creditFlag,
      locFlag,
      container
    );
    let values = [
      { key: "primaryApplicantAnnualMembership", value: primaryAnnualFee },
      {
        key: "supplementaryApplicantAnnualMembership",
        value: supplementaryAnnualFee
      }
    ];
    const data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    return values;
  },
  /**
   * Selects appropriate risk rating factor
   * @param {*} component
   * @return {Number} risk factor
   */

  getRiskRatingFactor: function (component, riskRating) {
    let riskRatingMap = component.get("v.RiskRatings");
    if (riskRatingMap) {
      return riskRatingMap[riskRating];
    }
    return null;
  },
  /**
   * Calculate Approved Starting Limit
   * @param {*} component
   * @return {Number} asl
   */

  ASLCalculations: function (component) {
    let container = component.get("v.ChildContainer");
    let jnDefaults = component.get("v.jnDefaultConfigs");
    let riskFactor = this.getRiskRatingFactor(
      component,
      container.creditRiskRating
    );
    if (isEmpty(riskFactor) === false) {
      let values = [
        {
          key: "approvedStartingLimit",
          value: ASLCalculator(container, jnDefaults, riskFactor)
        }
      ];
      let data = updateChildContainerWithValue(component, values, false);
      component.set("v.ChildContainer", data);
      return values;
    }
    let values = [{ key: "approvedStartingLimit", value: 0 }];
    let data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    return values;
  },
  /**
   * Calculate minimum payment
   * @param {*} component
   * @return {Number} asl
   */
  minimumPaymentCalculations: function (component) {
    let container = component.get("v.ChildContainer");
    let defaults = component.get("v.jnDefaultConfigs");
    console.log("minimumPaymentCalculations");
    let minimumPayment = minimumPaymentCalculatorWithASL(
      container,
      defaults,
      container.approvedStartingLimit
    );
    console.log("minimumPaymentCalculations 2");
    let values = [{ key: "minimumPayment", value: minimumPayment }];
    let data = updateChildContainerWithValue(component, values, false);
    component.set("v.ChildContainer", data);
    console.log("minimumPaymentCalculations 3");
    return values;
  },
  /**
   * checks the credit type
   * @param {*} component
   * @param {Objec} container
   * @return {Number} credit type
   */
  setCardType: function (component) {
    //JN-4049 :: Kirti R. ::Added a method to set credit type
    let container = component.get("v.ChildContainer");
    let approvedStartingLimit = container.approvedStartingLimit;
    if (
      approvedStartingLimit >
      component.get("v.jnDefaultConfigs.creditLimitValue")
    ) {
      container.cardType = CREDIT_TYPE_GOLD;
    } else {
      container.cardType = CREDIT_TYPE_CLASSIC;
    }
    let values = [{ key: "cardType", value: container.cardType }];
    updateChildContainerWithValue(component, values);
    return values;
  }
});
