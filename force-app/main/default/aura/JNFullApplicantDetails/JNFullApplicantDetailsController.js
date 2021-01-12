/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     2/12/2020      Ishwari G.(thinqloud)  bases on source of income showing fields
 **/
({
  doInit: function (component, event, helper) {
    //helper.getPickListValues(component);
    helper.getApplicant(component);
    component.set("v.validate", function () {
      helper.updateApplicant(component);
    });
  },
  /* JN1-4030 : START */
  handleSourceOfIncomeChange: function (component, event, helper) {
    let source = component.find("sourceOfIncome").get("v.value");
    let sourceOfIncome = [];
    if (source.includes(";")) {
      sourceOfIncome = source.split(";");
    } else {
      sourceOfIncome.push(source);
    }
    component.set("v.sourceOfIncome", sourceOfIncome);
  },
  /* JN1-4030 : END */
  //JN1-4047  :: Added a method to set changed selected expense detail
  handleExpenseDetailChange: function (component, event, helper) {
    let expenseDetail = component.find("monthlyExpensesDetails").get("v.value");
    component.set("v.selectedExpenseDetail", expenseDetail);
  }
});
