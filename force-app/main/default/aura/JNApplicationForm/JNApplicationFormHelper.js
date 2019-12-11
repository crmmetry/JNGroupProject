({
  getTabName: function(tabId) {
    return tabId.replace("_Tab", "");
  },
  navigateNext: function(component) {
    const allTabs = component.get("v.allTabs");
    const index = allTabs.indexOf(component.get("v.tabId"));

    //can go next
    if (index + 1 <= allTabs.length - 1) {
      const tab = allTabs[index + 1];
      component.set("v.tabId", tab);
    }
  },
  setSiteLeadInfo: function(component, currentCmp) {
    let siteLead = component.get("v.SiteLead");
    Object.assign(siteLead, currentCmp.get("v.SiteLead"));
    component.set("v.SiteLead", siteLead);
  },
  showModal: function(component) {
    let childCmp = component.find("JNModal");
    let header = "Application Form Submission";
    let body = "Are you sure you want to submit this form?";
    childCmp.showModal(header, body);
  },
  closeModal: function(component) {
    let childCmp = component.find("JNModal");
    childCmp.hideModal();
  },
  updateLeadInfo: function(component) {
    const action = component.get("c.updateLeadInformation");
    action.setParams({
      currentLead: component.get("v.SiteLead")
    });
    component.set("v.showLoading", true);
    action.setCallback(this, function(response) {
      component.set("v.showLoading", false);
      const state = response.getState();
      if (state === "SUCCESS") {
        //display successful toast
        alert("successfuly submitted");
      }
    });
    $A.enqueueAction(action);
  },
  showErrorToast: function(component, data) {
    const siteLead = component.get("v.SiteLead");
    if (!siteLead.hasOwnProperty("Id")) {
      //user must complete step 2 and 3 first
      const severity = data.severity; //"error"; //it could be 'confirm' or null
      const title = data.title; //"An error has occurred";
      const message = data.message; //"You must first complete step 2 and 3 before";
      const toastContainer = component.find("toastContainer");
      toastContainer.displayMessage(severity, title, message);
      return;
    }
  },
  showSuccessToast: function(component, data) {
    const siteLead = component.get("v.SiteLead");

    //user must complete step 2 and 3 first
    const severity = data.severity;
    const title = data.title;
    const message = data.message;
    const toastContainer = component.find("toastContainer");
    toastContainer.displayMessage(severity, title, message);
  },
  sendEvents: function(component, cmpName, events, data) {
    const eventToSend = component.getEvent("jnEvent");
    eventToSend.setParams({
      component: cmpName,
      action: events,
      data: data
    });
    eventToSend.fire();
  }
});