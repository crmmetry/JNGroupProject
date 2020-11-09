({
  doInit: function (component, event, helper) {
    let personalAutoLoan = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.ChildContainer", personalAutoLoan);
  },

  onChildContainerChange: function (component, event, help) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
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
