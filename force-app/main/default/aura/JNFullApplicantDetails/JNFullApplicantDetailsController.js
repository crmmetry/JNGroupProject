({
  doInit: function (component, event, helper) {
    //helper.getPickListValues(component);
    helper.getApplicant(component);
    component.set("v.validate", function () {
      helper.updateApplicant(component);
    });
  },
  //JN1-4047  :: Added a method to set changed selected expense detail
  handleExpenseDetailChange: function (component, event, helper) {
    var expenseDetail = component.find("monthlyExpensesDetails").get("v.value");
    component.set("v.selectedExpenseDetail", expenseDetail);
  }
});
