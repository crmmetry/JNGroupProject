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
  }
});
