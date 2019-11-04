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
  updateApplicationInformation: function(component) {
    const action = component.get("c.updateApplicantDetails");
    action.setParams({
      applicant: component.get("v.SiteLead")
    });
    component.set("v.showLoading", true);
    action.setCallBack(this, function(response) {
      component.set("v.showLoading", false);
      const state = response.getState();
      if (state === "SUCCESS") {
        //display successful toast
      } else {
        console.log(JSON.parse(JSON.stringify(response.getError())));
      }
    });
    $A.enqueueAction(action);
  }
});