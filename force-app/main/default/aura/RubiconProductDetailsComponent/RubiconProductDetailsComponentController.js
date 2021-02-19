({
  doInit: function (component, event, helper) {
    helper.getIDMDataMap(component);
    helper.getCreditCardTypye(component);
    helper.getNumberOfSupplementaryHolders(component);
  }
});
