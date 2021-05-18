({
  doinit: function (component, event, helper) {
    let calculationsMap = {
      totalAssets: [
        "realEstateHoldingsAssetsVerified",
        "motorVehicleAssetsVerified",
        "savingsAccountInvestmentAssetsVerified",
        "lifeInsuranceAssetsVerified",
        "pensionAssetsVerified",
        "otherAssetsVerified"
      ],
      totalLiabilities: [
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
        "otherExpensesVerified",
        "totalStatutoryDeductionsVerified",
        "totalMonthlyExpensesVerified"
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
    console.log(component.get("v.scriptsLoaded"));
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

  handleDebtInfoEvent: function (component, event) {
    const debtData = event.getParam("data");
    const index = event.getParam("index");
    const consolidatedDebts = component.get("v.ConsolidatedDebts");
    consolidatedDebts[index] = debtData;
  },

  onParentVerifiedDataMapChange: function (component, event, helper) {
    if (component.get("v.scriptsLoaded")) {
      let newVerifiedDataMap = component.get("v.ParentVerifiedDataMap");
      let debtsToBeCalculated = component.get("v.ConsolidatedDebts");
      let calculationMap = component.get("v.calculationsMap");
      Object.keys(calculationMap).forEach((key) => {
        newVerifiedDataMap = financialVerificationComponentTotalsController(
          key,
          newVerifiedDataMap,
          calculationMap,
          debtsToBeCalculated
        );
        console.log(JSON.parse(JSON.stringify(newVerifiedDataMap)));
      });
      component.set("v.VerifiedDataMapWithUpdatedTotals", newVerifiedDataMap);
      component.set("v.VerifiedDataMap", newVerifiedDataMap);
    }
  },

  saveFinancialDetails: function (component, event, helper) {
    helper.saveFinancialDetailsAndDebtsHelper(component);
  }
});
