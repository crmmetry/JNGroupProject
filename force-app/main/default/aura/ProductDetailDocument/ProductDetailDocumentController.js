({
  onDocumentClick: function (component, event, helper) {},
  gotoURL: function (component, event, helper) {
    let url;
    let urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      url: url
    });
    urlEvent.fire();
  }
});
