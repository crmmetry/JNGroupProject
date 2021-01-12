({
  /**
   * Ver  Ticket#      Date            Author                  Purpose
   * 1.0  JN1-3969     4/12/2020      Ishwari G.(thinqloud)  get count of supplementary card holders
   **/
  /**
   * Initializes the component and retrieves all necessary data to be used by component upon intialisation.
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  doInit: function (component, event, helper) {
    component.set("v.ChildContainer", {
      monthly_PI_LoanAmount: 0,
      processingFeeClosingCost: 0,
      monthlyPrincipalInterestProcessingFee: 0,
      processingFeesGCT: 0,
      existingDebt: 0,
      TDSRBefore: null,
      TDSRAfter: null,
      minimumOfPurchaseMarketValue: 0,
      LTVValue: null,
      creditRiskScore: 0,
      creditRiskRating: "None",
      minimumPayment: 0,
      approvedStartingLimit: 0,
      cardType: "",
      primaryApplicantAnnualMembership: 0,
      supplementaryApplicantAnnualMembership: 0,
      numberOfSupplementaryCardHolders: 0,
      repaymentMethod: "",
      existingDebtAfter: 0
    });
    //utilized to display spinners
    let spinnerList = {
      productSelection: true,
      jnConfigs: true,
      assetsAndLiabilitiesForApplicants: true,
      riskRatings: true
    };
    component.set("v.spinnerList", spinnerList);
    component.set("v.productSelection", {
      productFamily: "No Product Selected"
    });
    helper.updateProductSelection(component);
  },
  /**
   * listens for child container changes
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onChildContainerChange: function (component, event, helper) {
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      const isLineOfCredit = checkProductFamily(component, "Line Of Credit");
      const isCreditCard = checkProductFamily(component, "Credit Card");
      const isAuto = checkProductFamily(component, "Auto");
      const isUnsecured = checkProductFamily(component, "Unsecured");
      let container = component.get("v.ChildContainer");
      noNotifyContainerChanges(component);
      //Async Functions
      helper.TDSRCalculationBefore(component);
      helper.TDSRCalculationAfter(component);
      if (isLineOfCredit || isCreditCard) {
        helper.revolvingLoanCalculations(component);
      } else if (isAuto || isUnsecured) {
        helper.nonRevolvingLoanCalculations(component, container);
      }
      notifyContainerChanges(component);
    }
  },
  /**
   * Sets scriptLoad attribute to true when all static resources are uplaoded successfully.
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  /**
   * Handles products detail event and manages all non specific calculations and bubbles the results to the approprite children.
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  handleProductDetailsEvent: function (component, event, helper) {
    //const updatedContainer = {};
    if (component.get("v.scriptsLoaded")) {
      const oldChildContainer = copyInto(
        null,
        component.get("v.ChildContainer")
      );
      console.info("Old Version", oldChildContainer);

      let container = copyInto(
        component.get("v.ChildContainer"),
        event.getParam("payload")
      );
      console.info("New Version", JSON.parse(JSON.stringify(container)));
      let attributesToUpdate = [];
      //Gets the applicant credit score
      const creditScoreChanged = changeDetectedInObjects(
        oldChildContainer,
        container,
        ["LTVValue", "TDSRBefore", "repaymentMethod", "collateralType"]
      );
      if (creditScoreChanged) {
        helper.getCreditScoreRatings(component);
      }
      // Calculate the monthly P&I Loan amount
      const monthlyPILoanAmount = monthlyPILoanAmountCalculation(container);
      attributesToUpdate.push({
        key: "monthly_PI_LoanAmount",
        value: monthlyPILoanAmount
      });
      //Calculate processing fees
      attributesToUpdate = attributesToUpdate.concat(
        helper.processingFeeCalculation(container, component)
      );
      const updatedContainer = updateChildContainerWithValue(
        component,
        attributesToUpdate,
        false
      );
      component.set("v.ChildContainer", updatedContainer);
    }
  },
  /**
   * click handler for save button
   * JN1-4210 : For validating child component containers
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onSaveProductDetails: function (component, event, helper) {
    let fieldsValidatedCorrectly = helper.validateFields(component);
    if (fieldsValidatedCorrectly) {
      helper.showSpinner(component);
      let container = copyInto(
        component.get("v.ChildContainer"),
        component.get("v.jnDefaultConfigs")
      );
      let productRecordTypes = [
        component.get("v.productSelection.productFamily")
      ]; //TODO: update in future to accomodate multiple products
      let {
        loanCalculationProductFields,
        loanCalculationFields
      } = helper.contructProductDetailsFields(component);
      loanCalculationFields = persistentFieldsValidator(
        container,
        loanCalculationFields
      );
      loanCalculationProductFields = persistentFieldsValidator(
        container,
        loanCalculationProductFields
      );
      return helper.saveProductDetailsInfo(
        component,
        productRecordTypes,
        loanCalculationFields,
        loanCalculationProductFields
      );
    }
    return showToast(
      "Product Details Error",
      "The application details cannot be saved until all the required fields are filled out.",
      "error"
    );
  }
});
