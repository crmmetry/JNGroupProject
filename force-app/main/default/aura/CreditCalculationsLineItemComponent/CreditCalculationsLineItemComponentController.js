({
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  doInit: function (component, event, helper) {
    // let data = {
    //   jngiMonthlyPremium: 0
    // };
    // component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  // onChildContainerChange: function (component, event, helper) {
  //   fireProductDetailsEvent(null, component.get("v.ChildContainer"));
  // },
  /**
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  onParenContainerChange: function (component, event, helper) {
    const containerName = component.get("v.ParentContainer.containerName");
    if (
      component.get("v.scriptsLoaded") &&
      containerName !== component.get("v.containerName")
    ) {
      console.info(
        "Parent",
        JSON.parse(JSON.stringify(component.get("v.ParentContainer")))
      );
      // on auto loan changes
      helper.calculateMonthlyP_ILoanAmount(component);
      helper.calculateSavings(component);
      // on credit repayment changes
      helper.setDeductRepaymentFlag(component);
      // on processing fee changes
      helper.calculateProcessingFee(component);
      //on JN creditor life changes
      helper.calculateCreditorLifePremium(component);
      helper.setAssignmentFees(component);
      helper.setEstimatedStampDutyFees(component);
      //calculate totals
      helper.totalLoanAmountCalculation(component);
      helper.totalMonthlyPILoanPaymentCalculation(component);
      helper.totalMonthlyPaymentCalculation(component);
      helper.totalInterestPaymentCalculation(component);
      helper.totalMonthlyLoanPaymentMonthlyCompulsorySavingsCalculation(
        component
      );
      //update 1st payment installment
      helper.updateFirstPaymentInstallable(component);
      //calculate total final costs
      helper.totalClosingCostCalculation(component);
      helper.totalClosingCostFinancedJNCalculation(component);
      helper.totalClosingCostPaidByApplicantCalculation(component);
    }
  }
});
