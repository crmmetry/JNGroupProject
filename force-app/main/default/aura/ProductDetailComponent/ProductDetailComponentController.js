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
      TDSRBefore: 0,
      TDSRAfter: 0,
      minimumOfPurchaseMarketValue: 0,
      LTVValue: 0,
      riskRating: {}, //for multi applicants
      creditRiskScore: 0,
      creditRiskRating: "",
      startingLimit: 20000
    });
    helper.updateProductSelection(component);
    helper.getJNConfigurations(component);
    helper.getAssetsAndLiabilitiesForApplicant(component);
    helper.getSupplementaryCardHolders(component); //JN1-3969
    //helper.getApplicants(component);
  },
  // onLoanPurposeChange: function (component, event, helper) {
  //   const selected = event.getSource().get("v.value");
  //   console.log(selected);
  // },

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
    if (component.get("v.scriptsLoaded")) {
      let container = Object.assign(
        component.get("v.ChildContainer"),
        event.getParam("payload")
      );
      let attributesToUpdate = [];
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
      attributesToUpdate = attributesToUpdate.concat(
        helper.processingFeeCalculation(container, component)
      );
      //JN1-3969
      attributesToUpdate = attributesToUpdate.concat(
        helper.annualFeesCalcualtions(container, component)
      );
      const updatedContainer = updateChildContainerWithValue(
        component,
        attributesToUpdate,
        false
      );
      // if (
      //   helper.detectObjectChanges(
      //     component.get("v.ChildContainer"),
      //     container,
      //     ["LTVValue", "repaymentMethod", "TDSRAfter", "TDSRBefore"]
      //   )
      // ) {

      // }
      helper.getCreditScoreRatings(component);
      component.set("v.ChildContainer", updatedContainer);
      console.info(
        "Parenthical Child",
        JSON.parse(JSON.stringify(component.get("v.ChildContainer")))
      );
    }
  }
});
