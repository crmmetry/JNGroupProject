({
  onDocumentClick: function (component, event, helper) {
    let url = window.location.origin;
    let target = event.currentTarget;
    let newURL = target.name;
    let urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      url: url + newURL
    });
    urlEvent.fire();
  }
});
