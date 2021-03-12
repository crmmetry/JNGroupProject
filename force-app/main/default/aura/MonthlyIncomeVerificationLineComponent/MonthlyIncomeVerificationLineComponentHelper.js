({
  setPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Applicant__c",
      fieldApiNames: ["Primary_Source_of_Income_VERIFIED_list__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set(
          "v.primarySourceOfIncome",
          values["Primary_Source_of_Income_VERIFIED_list__c"]
        );
      } else {
        console.log("error returned");
        console.error(JSON.parse(JSON.stringify(reponse.getError())));
      }
    });
    $A.enqueueAction(action);
  }
});
