({
  doinit: function (component, event, helper) {
    let calculationsMap = {
      totalAssetsVerified: [
        "realEstateHoldingsAssetsVerified",
        "motorVehicleAssetsVerified",
        "savingsAccountInvestmentAssetsVerified",
        "lifeInsuranceAssetsVerified",
        "pensionAssetsVerified",
        "otherAssetsVerified"
      ],
      totalLiabilitiesVerified: [
        "mortgageBalanceVerified",
        "outstandingBalanceOnLoansVerified",
        "outstandingBalanceOnLoansVerified",
        "averageLineOfCreditBalanceVerified",
        "otherDebtsVerified"
      ],
      netWorthVerified: ["totalAssetsVerified", "totalLiabilitiesVerified"],

      totalMonthlyExpensesVerified: [
        "totalMonthlyLoanPaymentsVerified",
        "mortgagePaymentVerified",
        "utilitiesAndHouseholdExpensesVerified",
        "personalAndFamilyExpensesVerified",
        "transportationExpensesVerified",
        "otherExpensesVerified"
      ],
      totalDebtConsolidatedVerified: ["debtAmountVerified"]
    };
    component.set("v.calculationsMap", calculationsMap);
    component.set("v.OldVerifiedDataMap", component.get("v.VerifiedDataMap"));
  },

  toggleCheckBoxes: function (component, event, helper) {
    let checkBoxVar = component.get("v.toggleCheckAll");
    let buttonCmp = event.getSource();
    if (checkBoxVar) {
      component.set("v.toggleCheckAll", false);
    } else if (!checkBoxVar) {
      component.set("v.toggleCheckAll", true);
    }
    if (buttonCmp.get("v.label") === "Check All") {
      buttonCmp.set("v.label", "Uncheck All");
    } else {
      buttonCmp.set("v.label", "Check All");
    }
  },

  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
    helper.getFinancialInfo(component);
    helper.getDebtsTobeConsolidated(component);
  },

  onVerifiedDebtsChange: function (component) {},

  submitButtonAction: function (component, event, helper) {
    helper.updateOpportunity(
      component,
      "Final_Assessment_Submitted_flag__c",
      true,
      "Submit"
    );
    if (component.get("v.isSubmitted")) {
      this.showToast(
        "Submission Successful",
        "Fianancial Details was submitted successfully",
        "success"
      );
    }
  },

  verifyButtonAction: function (component, event, helper) {
    helper.updateOpportunity(
      component,
      "Documents_Financial_Info_Verified_flag__c",
      true,
      "Verify"
    );
    if (component.get("v.isVerified")) {
      this.showToast(
        "Verification Successful",
        "Fianancial Details was verified successfully",
        "success"
      );
    }
  },

  onParentVerifiedDataMapChange: function (component, event, helper) {
    if (component.get("v.scriptsLoaded")) {
      const debtData = event.getParam("data");
      const index = event.getParam("index");
      const consolidatedDebts = component.get("v.ConsolidatedDebts");
      consolidatedDebts[index] = debtData;
      let newVerifiedDataMap = component.get("v.ParentVerifiedDataMap");
      let totalsMap = component.get("v.VerifiedTotalsMap");
      let calculationMap = component.get("v.calculationsMap");
      Object.keys(calculationMap).forEach((key) => {
        totalsMap = financialVerificationComponentTotalsController(
          key,
          newVerifiedDataMap,
          calculationMap,
          consolidatedDebts,
          totalsMap
        );
      });
      let newMapWithUpdatedTotals = Object.assign(
        newVerifiedDataMap,
        totalsMap
      );
      component.set(
        "v.VerifiedDataMapWithUpdatedTotals",
        newMapWithUpdatedTotals
      );
      component.set("v.VerifiedTotalsMap", totalsMap);
    }
  },

  saveFinancialDetails: function (component, event, helper) {
    helper.saveFinancialDetailsAndDebtsHelper(component);
  }
});
