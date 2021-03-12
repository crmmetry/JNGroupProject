({
  setPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Loan_Calculation_Product__c",
      fieldApiNames: ["Life_Insurance_Coverage_List__c", "CurrencyIsoCode"]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set("v.creditLimitCurrency", values["CurrencyIsoCode"]);
        component.set(
          "v.coverageTypes",
          values["Life_Insurance_Coverage_List__c"]
        );
      } else {
        console.error(JSON.parse(JSON.stringify(reponse.getError())));
      }
    });
    $A.enqueueAction(action);
  },
  updateApplicantInfo: function (component) {
    const action = component.get("c.updateApplicantTextInfo");
    action.setParams({
      applicantDetails: this.getEmploymentDetails(component),
      leadId: component.get("v.leadId")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function (response) {
      this.sendEvents(component, ["disableShowLoading"]);
      const state = response.getState();
      if (state === "SUCCESS") {
        this.sendEvents(component, ["navigateNext"], {});
      } else {
        console.error(JSON.parse(JSON.stringify(reponse.getError())));
      }
    });
    $A.enqueueAction(action);
  }
});
