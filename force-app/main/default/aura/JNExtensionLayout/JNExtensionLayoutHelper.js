({
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead_Related_Person__c",
      fieldApiNames: ["Relationship__c", "Title__c"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set("v.relationships", mappedList["Relationship__c"]);
        component.set("v.titles", mappedList["Title__c"]);
      } else {
      }
    });
    $A.enqueueAction(action);
  }
});