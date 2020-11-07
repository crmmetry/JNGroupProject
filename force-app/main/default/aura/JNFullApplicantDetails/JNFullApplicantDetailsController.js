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
  }
});
