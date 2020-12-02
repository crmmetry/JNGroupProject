({
  doInit: function (component, event, helper) {
    //helper.getPickListValues(component);
    helper.getApplicant(component);
    component.set("v.validate", function () {
      helper.updateApplicant(component);
      /*if (helper.validateFields(component)) {

        return { isValid: true };
      } else {
        return {
          isValid: false,
          errorMessage: "Please complete the form to continue."
        };
      }*/
    });
  },
  //JN1-4047  :: Added a method to set changed selected expense detail
  handleExpenseDetailChange: function (component, event, helper) {
    debugger;
    var expenseDetail = component.find("monthlyExpensesDetails").get("v.value");
    console.log("expenseDetail", expenseDetail);
    component.set("v.selectedExpenseDetail", expenseDetail);
  }
});
