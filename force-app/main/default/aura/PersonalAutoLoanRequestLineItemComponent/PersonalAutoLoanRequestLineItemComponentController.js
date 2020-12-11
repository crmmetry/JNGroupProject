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
      minimumOfPurchaseMarketValue: 0
    };
    component.set("v.ChildContainer", personalAutoLoan);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    if (component.get("v.scriptsLoaded")) {
      let container = component.get("v.ChildContainer");
      //sets the minimum of purchase price vs market value
      container = helper.setMinimumValue(container);
      //calculate ltv value
      container = helper.calculateLTVAuto(container);
      helper.getApplicants(component); //TODO: REFACTOR CANNOT BE CALLED LIKE THIS
      fireProductDetailsEvent(null, container);
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
    console.log(selected);
  },

  onPurchasePriceCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onMarketCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onDepositCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onVehicleClassificationChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
