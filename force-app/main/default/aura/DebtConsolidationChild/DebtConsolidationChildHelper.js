({
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Application_Asset_Liability__c",
      fieldApiNames: ["Institution_Debt_List__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set(
          "v.debtInstitutions",
          mappedList["Institution_Debt_List__c"]
        );
      }
    });
    $A.enqueueAction(action);
  }
});
