({
  getIDMDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getIDMProductDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        component.set("v.IDMDataMap", result);
      }
    });
    $A.enqueueAction(action);
  },
  getIDMDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getIDMProductDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        component.set("v.IDMDataMap", result);
      }
    });
    $A.enqueueAction(action);
  },
  getIDMDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getIDMProductDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        component.set("v.IDMDataMap", result);
      }
    });
    $A.enqueueAction(action);
  }
});
