({
  onPersonalAutoLoanChange: function (component, event, helper) {
    helper.calculateMonthlyP_ILoanAmount(component);
  },

  onCreditRepaymentChange: function (component, event, helper) {
    helper.setDeductRepaymentFlag(component);
  }
});
