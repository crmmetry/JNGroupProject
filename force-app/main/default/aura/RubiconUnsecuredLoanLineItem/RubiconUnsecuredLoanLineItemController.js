({
  doInit: function (component, event, helper) {
    let creditCardData = {
      loanAmount: 0,
      loanTerm: null,
      ageAtEndOfLoanTerm: null
    };

    component.set("v.CreditCardContainer", creditCardData);

    helper.setPickListValues(component);
  }
});
