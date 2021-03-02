({
  doInit: function (component, event, helper) {
    let creditCardData = {
      requestedLimit: 0,
      currencyOfCreditCard: null,
      coverageType: null,
      jnBankPromotion: null,
      hasSupplementaryCardholder: null
    };

    component.set("v.CreditCardContainer", creditCardData);

    helper.setPickListValues(component);
  },

  onCreditLimitCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditCardData = component.get("v.CreditCardContainer");
    creditCardData.currencyOfCreditCard = selected;
    component.set("v.CreditCardContainer", creditCardData);
  },

  onCoverageTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let creditCardData = component.get("v.CreditCardContainer");
    creditCardData.coverageType = selected;
    component.set("v.CreditCardContainer", creditCardData);
  }
});
