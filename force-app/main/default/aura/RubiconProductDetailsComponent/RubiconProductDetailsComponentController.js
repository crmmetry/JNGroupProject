({
  doInit: function (component, event, helper) {
    helper.getIDMDataMap(component);
    helper.getCreditCardType(component);
    helper.getNumberOfSupplementaryHolders(component);
    helper.getApplicantsMap(component);
    helper.getOpportunityDataMap(component);
    helper.setPickListValues(component);
  },

  onSubmitRubiconProductDetailsAction: function (component, event, helper) {
    helper.submitRubiconProductDetails(component);
  },

  onJointApplicationChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    if (selected == "Yes") {
      component.set("v.indicatePrimaryApplicantToggle", true);
    } else {
      component.set("v.indicatePrimaryApplicantToggle", false);
    }
  }
});
