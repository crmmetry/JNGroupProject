({
  //TODO: SHOULD BE OPTIMIZED, query applicants once then query there rating on subsequent calls
  getApplicants: function (component) {
    console.log("getApplicants called");
    let oppId = component.get("v.oppId");
    let data = component.get("v.ChildContainer");
    console.log(oppId);
    console.log(JSON.stringify(data));
    if (data.years && data.months) {
      console.log("server side called");
      //TODO: REVIEW with travis
      let tenure = calculateMonths(data.years, data.months) / 12;
      console.log("tenure and oppId:", tenure, oppId);
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
          console.log(result);
          console.log(
            "applicants: ",
            JSON.parse(JSON.stringify(component.get("v.applicants")))
          );
        } else {
          console.log("rror", response.getError())
        }
      });
      $A.enqueueAction(action);
    }
  }
});
