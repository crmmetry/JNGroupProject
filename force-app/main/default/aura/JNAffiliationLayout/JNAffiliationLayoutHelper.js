({
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead_Related_Person__c",
      fieldApiNames: ["Relationship__c", "JN_Location__c", "Afilliate_Type__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set("v.relationships", mappedList["Relationship__c"]);
        component.set("v.locations", mappedList["JN_Location__c"]);

        const affTypes = mappedList["Afilliate_Type__c"].filter(function (aff) {
          return aff !== "Credit Card Extension";
        });
        component.set("v.affiliateTypes", affTypes);
      }
    });
    $A.enqueueAction(action);
  }
});
