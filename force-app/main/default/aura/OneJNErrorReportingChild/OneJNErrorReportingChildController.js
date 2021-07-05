({
  doInit: function (component, event, helper) {
    alert("here");
    debugger;
    let key = component.get("v.key");
    let map = component.get("v.map");
    let jsonMap = map[key];
    let errorMessage = jsonMap["ErrorMessage"];
    let errorCode = jsonMap["ErrorCode"];
    let eventName = jsonMap["SourceEvent"];
    component.set("v.errorMessage", errorMessage);
    component.set("v.errorCode", errorCode);
    component.set("v.eventName", eventName);
  }
});
