({
  getPickListValues: function(component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead",
      fieldApiNames: [
        "Country__c",
       	"Address_Type__c",
        "Status_of_Address__c"
      ]
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
          console.log(mappedList)
        component.set("v.addressTypes", mappedList["Address_Type__c"]);
        component.set("v.countries", mappedList["Country__c"]);
        component.set("v.addressStatuses", mappedList["Status_of_Address__c"]);
      } else {
      }
    });
    $A.enqueueAction(action);
  },
  
});