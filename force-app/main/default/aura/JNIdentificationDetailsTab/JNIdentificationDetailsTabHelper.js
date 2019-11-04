({
  getPickListValues: function(component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead",
      fieldApiNames: [
        "Country__c",
        "Identification_Type__c",       
      ]
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set("v.identificationTypes", mappedList["Identification_Type__c"]);
        const countries = mappedList["Country__c"].filter(function (country) {
          return country !== 'Jamaica';
        })
        component.set("v.countries", countries);
      } else {
      }
    });
    $A.enqueueAction(action);
  }
});