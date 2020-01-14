({
  getPickListValues: function(component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead",
      fieldApiNames: [
        "Country__c",
        "Address_Type__c",
        "Status_of_Address__c",
        "Preferred_Contact_Method__c"
      ]
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        component.set("v.addressTypes", mappedList["Address_Type__c"]);
        component.set("v.countries", mappedList["Country__c"]);
        component.set("v.addressStatuses", mappedList["Status_of_Address__c"]);
        component.set(
          "v.preferredContactMethods",
          mappedList["Preferred_Contact_Method__c"]
        );
      }
    });
    $A.enqueueAction(action);
  },
  updateApplicant: function(component) {
    const action = component.get("c.updateApplicantTextInfo");
    action.setParams({
      applicantDetails: component.get("v.SiteLead"),
      leadId: component.get("v.leadId")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function(response) {
      this.sendEvents(component, ["disableShowLoading"]);
      const state = response.getState();
      if (state === "SUCCESS") {
        this.sendEvents(component, ["navigateNext"], {});
      }
    });
    $A.enqueueAction(action);
  },
  sendEvents: function(component, events, data) {
    const eventToSend = component.getEvent("jnEvent");
    eventToSend.setParams({
      component: "JNApplicationForm",
      action: events,
      data: data
    });
    eventToSend.fire();
  }
});