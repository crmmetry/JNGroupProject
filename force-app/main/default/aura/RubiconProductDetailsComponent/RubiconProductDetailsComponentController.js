({
  doInit: function (component, event, helper) {
    helper.getIDMDataMap(component);
    helper.getCreditCardType(component);
    helper.getNumberOfSupplementaryHolders(component);
  }
});
