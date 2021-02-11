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
          if (result === NO_APPLICANTS_FOUND) {
            showToast("Applcant Not Found!", NO_APPLICANTS_FOUND, "error");
          } else {
            component.set("v.applicants", result);
          }
        }
      });
      $A.enqueueAction(action);
    }
  }
});
