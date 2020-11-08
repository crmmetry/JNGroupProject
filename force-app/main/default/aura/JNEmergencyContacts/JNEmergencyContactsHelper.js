({
  getAccounts: function (component) {
    let action = component.get("c.getContactsAccount");
    action.setParams({
      ids: component.get("v.contactIds")
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.contacts", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);
  }
});
