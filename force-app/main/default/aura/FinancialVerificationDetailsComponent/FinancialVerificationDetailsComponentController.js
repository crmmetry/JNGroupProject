({
  doinit: function (component, event) {
    // let verifiedMap = {
    //   //Assets
    //   realEstateHoldingAssets: null,
    //   motorVehicleAssets: null,
    //   savingsAccountInvestmentAssets: null,
    //   lifeInsuranceAssets: null,
    //   pensionAssets: null,
    //   otherAssets: null,
    //   //Liabilities
    //   mortgageBalance: null,
    //   outstandingBalanceOnLoans: null,
    //   averageCreditBalance: null,
    //   averageLineOfCreditBalance: null,
    //   otherDebts: null,
    //   //Monthly Income
    //   primarySourceOfIncome: null,
    //   grossSalaryAllowances: null,
    //   otherIncome: null,
    //   netBusinessIncomeSoleTrader: null,
    //   netBusinessIncomePartnership: null,
    //   netBusinessIncomeCompanyShareholding: null,
    //   directorEmoluments: null,
    //   pensionIncome: null,
    //   propertyRental: null,
    //   totalOtherIncome: null,
    //   totalMonthlyIncome: null,
    //   //Monthly Expenses
    //   totalMonthlyLoanPayments: null,
    //   mortgagePayment: null,
    //   utilitiesAndHouseholdExpenses: null,
    //   personalAndFamilyExpenses: null,
    //   transportationExpenses: null,
    //   otherExpenses: null,
    //   totalStatutoryDeductions: null,
    //   totalMonthlyExpenses: null,
    //   //NetWorth
    //   totalAssets: null,
    //   totalLiabilities: null,
    //   netWorth: null
    // }
    // component.set("v.VerifiedDataMap", verifiedMap);
    // helper.getDebtsConsolidated
    // helper.getUnverifiedFinancialInfo
  },

  toggleCheckBoxes: function (component, event, helper) {
    let checkBoxVar = component.get("v.toggleCheckAll");
    let buttonCmp = event.getSource();
    if (checkBoxVar) {
      component.set("v.toggleCheckAll", false);
      console.log("check all toggled to false");
    } else if (!checkBoxVar) {
      component.set("v.toggleCheckAll", true);
      console.log("check all toggled to true");
    }
    if (buttonCmp.get("v.label") === "Check All") {
      buttonCmp.set("v.label", "Uncheck All");
      console.log("button label change");
    } else {
      buttonCmp.set("v.label", "Check All");
      console.log("button label change");
    }
  },

  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onVerifiedDataMapChange: function (component, event) {
    console.log(JSON.parse(JSON.stringify(component.get("v.VerifiedDataMap"))));
  }
});
