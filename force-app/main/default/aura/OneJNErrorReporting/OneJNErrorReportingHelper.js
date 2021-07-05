({
  getEventRecords: function (component) {
    let action = component.get("c.getErrorLogs");
    let recordId = component.get("v.recordId");
    console.log("recordId" + recordId);
    action.setParams({
      recordId: recordId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        var arrayMapKeys = [];
        debugger;
        component.set("v.eventLogs", result);
        console.log("result ::", result);
        for (var key in result) {
          console.log("result[key] :: ", result[key]);
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
