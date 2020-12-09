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
      creditRiskRating: "None",
      minimumPayment: 0,
      approvedStartingLimit: 0,
      cardType: "", //JN-4049 :: Added a field to track max the credit type,
      primaryApplicantAnnualMembership: 0,
      supplementaryApplicantAnnualMembership: 0,
      numberOfSupplementaryCardHolders: 0,
      repaymentMethod: ""
    });
    helper.updateProductSelection(component);
    helper.getJNConfigurations(component);
    helper.getAssetsAndLiabilitiesForApplicant(component);
    helper.getRiskRatingFactorsMap(component);
    //helper.getApplicants(component);
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
      noNotifyContainerChanges(component);
      //Async Functions
      helper.supplementaryCardHolderInit(component);
      helper.TDSRCalculationBefore(component);
      helper.ASLCalculations(component);
      helper.calculateCreditorLife(component);
      helper.minimumPaymentCalculations(component);
      helper.TDSRCalculationAfter(component);
      helper.setCardType(component); //JN1-4049 :: Kirti R :: Calculate the credit type
      helper.annualFeesCalcualtions(component);
      console.log("===Testing End===");
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
        console.log("Risk changing");
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
  }
});
