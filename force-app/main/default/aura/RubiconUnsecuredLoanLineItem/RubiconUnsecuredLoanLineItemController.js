({
  doInit: function (component, event, helper) {
    let unsecuredLoanData = {
      loanAmount: 0,
      loanTerm: null,
      ageAtEndOfLoanTerm: null,
      repaymentMethod: null,
      methodFeePayment: null,
      currencyOfRequestedLoan: null,
      includeCreditorLifeInLoanAmount: null
    };

    component.set("v.UnsecuredLoanContainer", unsecuredLoanData);

    helper.setPickListValues(component);
  },

  onRequestedLoanCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let unsecuredLoanData = component.get("v.UnsecuredLoanContainer");
    unsecuredLoanData.currencyOfCreditCard = selected;
    component.set("v.UnsecuredLoanContainer", unsecuredLoanData);
  },

  onRepaymentMethodChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let unsecuredLoanData = component.get("v.UnsecuredLoanContainer");
    unsecuredLoanData.repaymentMethod = selected;
    component.set("v.UnsecuredLoanContainer", unsecuredLoanData);
  },

  onIncludeCreditorLifeInLoanAmountChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let unsecuredLoanData = component.get("v.UnsecuredLoanContainer");
    unsecuredLoanData.includeCreditorLifeInLoanAmount = selected;
    component.set("v.UnsecuredLoanContainer", unsecuredLoanData);
  },

  onMethodFeePaymentChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let unsecuredLoanData = component.get("v.UnsecuredLoanContainer");
    unsecuredLoanData.methodFeePayment = selected;
    component.set("v.UnsecuredLoanContainer", unsecuredLoanData);
    if (selected === "Deduct from JN Account") {
      component.set("v.deductFromJNFlag", true);
    } else {
      component.set("v.deductFromJNFlag", false);
    }
  },

  onLoanTermChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    helper.calculateAge(component, selected);
  }
});
