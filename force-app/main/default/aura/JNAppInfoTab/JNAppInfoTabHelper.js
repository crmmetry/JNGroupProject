({
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead",
      fieldApiNames: ["Preferred_Location__c", "Loan_Purpose_UL__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set("v.loanPurposes", mappedList["Loan_Purpose_UL__c"]);
        component.set(
          "v.preferredLocations",
          mappedList["Preferred_Location__c"]
        );
      }
    });
    $A.enqueueAction(action);
  },
  mapSiteLeadFields: function (componentSiteLead, siteLead) {
    console.log("Current", JSON.parse(JSON.stringify(componentSiteLead)));
    console.log("Main", JSON.parse(JSON.stringify(siteLead)));
    return Object.assign(componentSiteLead, siteLead);
  }
});