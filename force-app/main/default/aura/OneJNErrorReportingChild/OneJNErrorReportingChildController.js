({
  doInit: function (component, event, helper) {
    let key = component.get("v.key");
    let map = component.get("v.map");
    let jsonMap = map[key];
    let errorMessage = jsonMap[ERROR_MESSAGE];
    let errorCode = jsonMap[ERROR_CODE];
    let eventName = jsonMap[SOURCE_EVENT];
    let time = jsonMap[TIME];
    let date = jsonMap[DATE];
    let userName = jsonMap[LAST_MODIFIED_BY];
    component.set("v.errorMessage", errorMessage);
    component.set("v.errorCode", errorCode);
    component.set("v.eventName", eventName);
    component.set("v.time", time);
    component.set("v.date", date);
    component.set("v.userName", userName);
  }
});
