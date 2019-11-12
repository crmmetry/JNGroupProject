({
  getPickListValues: function(component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Lead",
      fieldApiNames: [
        "Primary_Employment_Type__c",
        "Address_Status_PK__c",
        "Employer_Industry__c",
        "Employment_Status__c",
        "Employer_Country__c",
        "Type_of_Business__c",
        "Nature_of_Engagement__c",
          
      ],
    });
    action.setCallback(this, function(response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set(
          "v.employmentTypes",
          values["Primary_Employment_Type__c"]
        );
        component.set("v.countries", values["Employer_Country__c"]);
        component.set("v.employmentIndustries", values["Employer_Industry__c"]);
        component.set("v.employmentStatuses", values["Employment_Status__c"]);
        component.set("v.addressStatuses", values["Address_Status_PK__c"]);
        component.set("v.businessTypes", values["Type_of_Business__c"]);
        component.set("v.businessNatures", values["Nature_of_Engagement__c"]);
      } else {
        console.info(JSON.parse(JSON.stringify(response.getError())));
      }
    });
    $A.enqueueAction(action);
  },
  updateApplicantInfo: function(component) {
    const action = component.get("c.updateApplicantTextInfo");
    console.log(JSON.parse(JSON.stringify(this.getEmploymentDetails(component))));
    action.setParams({
      applicantDetails: this.getEmploymentDetails(component),
      leadId: component.get("v.leadId")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function(response) {
      this.sendEvents(component, ["disableShowLoading"]);
      const state = response.getState();
      if (state === "SUCCESS") {
        console.info(JSON.parse(JSON.stringify(response.getReturnValue())));

        this.sendEvents(component, ["navigateNext"], {});
      } else {
        console.log(JSON.parse(JSON.stringify(reponse.getError())));
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
  },
  getEmploymentDetails: function(component) {
    const et = component.get("v.SiteLead.Primary_Employment_Type__c");
    switch (et) {
      case "Employed": {
        return component.get("v.SiteLead");
      }
      case "Self-Employed": {
        return component.get("v.SiteLeadSelfEmployed");
      }
      case "Unemployed": {
        return component.get("v.SiteLeadUnemployed");
      }
    }
  }
});