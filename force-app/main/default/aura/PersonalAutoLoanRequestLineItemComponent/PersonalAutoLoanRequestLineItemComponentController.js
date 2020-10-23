({
  doInit: function (component, event, helper) {
    console.log("Product Price: ", component.get("v.productPrice"));
    let personalAutoLoan = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.PersonalAutoLoan", personalAutoLoan);
  },

  onPersonalAutoLoanChange: function (component, event, help) {
    const data = Object.assign(
      component.get("v.PersonalAutoLoanContainer"),
      component.get("v.PersonalAutoLoan")
    );
    component.set("v.PersonalAutoLoanContainer", data);
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
