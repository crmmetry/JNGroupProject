({
  getApplicants: function (component) {
    let oppId = component.get("v.oppId");
    let data = component.get("v.ChildContainer");
    if (data.years && data.months) {
      let tenure = calculateMonths(data.years, data.months) / 12;
      let action = component.get("c.getApplicantsRating");
      action.setParams({
        oppId: oppId,
        tenure: tenure
      });
      action.setCallback(this, function (response) {
        let state = response.getState(); //Checking response status
        let result = response.getReturnValue();
        if (state === "SUCCESS") {
          component.set("v.applicants", result);
        }
      });
      $A.enqueueAction(action);
    }
  },

  /**
   * Updates child container attributes and its values.
   */
  updateChildContainerWithValue: function (component, values) {
    let childContainer = component.get("v.ChildContainer");
    values.forEach((element) => {
      //component.set(`v.${element.key}`, element.value);
      childContainer[element.key] = element.value;
    });
    component.set("v.ChildContainer", childContainer);
  }
});
