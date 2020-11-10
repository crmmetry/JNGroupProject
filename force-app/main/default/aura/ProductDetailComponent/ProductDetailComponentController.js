({
  doinit: function (component, event, helper) {
    helper.updateProductSelection(component);
    helper.getJNConfigurations(component);
    helper.getApplicants(component);
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
