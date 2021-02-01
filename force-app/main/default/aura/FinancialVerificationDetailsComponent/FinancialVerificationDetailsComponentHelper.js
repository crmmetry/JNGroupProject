({
  /**
   * Retrieves All financial Details belonging to an applicant on the opportunity.
   * @param {*} container
   */
  getUnverifiedFinancialInfo: function (component) {
    let action = component.get("c.getApplicantFinancialDetails");
    let oppId = component.get("v.recordId");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState(); //Checking response status
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        component.set("v.UnverifiedDataMap", result);
        console.log(JSON.parse(JSON.stringify(result)));
      }
    });
    $A.enqueueAction(action);
  }
});
