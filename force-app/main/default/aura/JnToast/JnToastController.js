({
  displayMessage: function (component, event, helper) {
    let params = event.getParam("arguments");
    if (!params) {
      return;
    }
    let severity = params.severity;
    let title = params.title;
    let message = params.message;

    let toastClass =
      severity === "confirm"
        ? "slds-notify slds-notify--toast slds-theme_success"
        : severity === "error"
        ? "slds-notify slds-notify--toast slds-theme_error"
        : "slds-notify slds-notify--toast";

    component.set("v.severity", severity);
    component.set("v.title", title);
    component.set("v.message", message);
    component.set("v.toastClass", toastClass);
    helper.showMessage(component, event);
    const autoHide = component.get("v.autoHide");
    if (autoHide === true) {
      setTimeout(function () {
        helper.hideMessage(component, event);
      }, 5000);
    }
  },
  hideMessage: function (component, event, helper) {
    helper.hideMessage(component, event);
  }
});