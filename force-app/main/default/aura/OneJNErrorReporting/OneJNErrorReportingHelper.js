({
  getEventRecords: function (component) {
    let action = component.get("c.getErrorLogs");
    let recordId = component.get("v.recordId");
    action.setParams({
      recordId: recordId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        let arrayMapKeys = [];
        component.set("v.eventLogs", result);
        for (let key in result) {
          arrayMapKeys.push(key);
        }
        component.set("v.keyList", arrayMapKeys);
      } else {
        console.info(JSON.stringify(response.getError()));
      }
    });
    $A.enqueueAction(action);
  }
});
