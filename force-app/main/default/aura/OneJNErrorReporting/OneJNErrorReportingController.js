({
  doInit: function (component, event, helper) {
    const empApi = component.find("empApi");
    const channel = "/topic/OneJNErrorOuputEventLog";
    empApi.setDebugFlag(true);
    let handleError = function (error) {
      console.log("empApi error", error);
    };
    empApi.onError(handleError);

    empApi.subscribe(
      channel,
      -1,
      $A.getCallback((eventReceived) => {
        helper.getEventRecords(component);
      })
    );
  },
  onRecordIdChange: function (component, event, helper) {
    helper.getEventRecords(component);
  }
});
