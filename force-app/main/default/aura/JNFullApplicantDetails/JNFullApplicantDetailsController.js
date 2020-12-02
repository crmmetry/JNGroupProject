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
  /* JN1-4030 : START */
  handleSourceOfIncomeChange: function (component, event, helper) {
    var source = component.find("sourceOfIncome").get("v.value");
    var sourceOfIncome = [];
    if (source.includes(";")) {
      sourceOfIncome = source.split(";");
    } else {
      sourceOfIncome.push(source);
    }
    component.set("v.sourceOfIncome", sourceOfIncome);
  }
  /* JN1-4030 : END */
});
