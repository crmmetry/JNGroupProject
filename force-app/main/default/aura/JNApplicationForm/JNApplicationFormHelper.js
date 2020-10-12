({
  getTabName: function(tabId) {
    return tabId.replace("_Tab", "");
  },
  formatTabName: function(tabId) {
    return tabId.replace("_Tab", "").replace("_"," ");
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
  getTabPrevious: function(component) {
    const allTabs = component.get("v.allTabs");
    const index = allTabs.indexOf(component.get("v.tabId"));
    //can go previous
    if (index - 1 >= 0) {
      return index - 1;
    }
    return index;
  },
  setSiteLeadInfo: function(component, currentCmp) {
    let siteLead = component.get("v.SiteLead");
    Object.assign(siteLead, currentCmp.get("v.SiteLead"));
    component.set("v.SiteLead", siteLead);
    console.table(JSON.parse(JSON.stringify(siteLead)));
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
  updateLeadInfo: function(component, applicant, leadId) {
    const action = component.get("c.updateApplicantTextInfo");
    action.setParams({
      applicantDetails: applicant,
      leadId: leadId
    });
    component.set("v.showLoading", true);
    action.setCallback(this, function(response) {
      component.set("v.showLoading", false);
      const state = response.getState();
      if (state === "SUCCESS") {
        // display successful toast
        this.showSuccessToast(component, {
          severity: "confirm",
          message:
            "Thanks for taking your time to complete this form, please look out for a follow up email.",
          title: "Applicant Form Completion"
        });
        setTimeout(function() {
          window.location.reload();
        }, 5500);
      }
    });
    $A.enqueueAction(action);
  },
  showErrorToast: function(component, data) {
      const severity = data.severity; //"error"; //it could be 'confirm' or null
      const title = data.title; //"An error has occurred";
      const message = data.message; //"You must first complete step 2 and 3 before";
      const toastContainer = component.find("toastContainer");
      toastContainer.displayMessage(severity, title, message);
    
  },
  showSuccessToast: function(component, data) {
    const siteLead = component.get("v.SiteLead");
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
  },
  createCompoundErrorMessage: function(component) {
    const validatedTabs = component.get("v.validatedTabs");
      let missingSteps = [];
      let error = false;
      for (const key in validatedTabs) {
          if (validatedTabs.hasOwnProperty(key)) {
              if(validatedTabs[key] == false){
                  missingSteps.push(this.formatTabName(key));
                  error = true;
              }
          }
	 }
      let message = `Please complete the following tab(s) first ${missingSteps.join(',')}`;
      return {error, message};
  },
  createLead: function(component) {
    const action = component.get("c.createLeadReferral");
    action.setParams({
        "applicantDetails": component.get("v.SiteLead")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function(response) {
        this.sendEvents(component, ["disableShowLoading"]);
        const state = response.getState();
        if (state === "SUCCESS") {
            console.log("Server call successful");
            let siteLead = component.get("v.SiteLead");               
            Object.assign(siteLead, response.getReturnValue());
            component.set("v.SiteLead", siteLead);
            this.sendEvents(
                component,
                [ "setLeadInfo", "navigateNext"],
                {"Id": siteLead.Id}
            );
        } else {
          let errors = response.getError();
          let message = 'Unknown error'; // Default error message
          // Retrieve the error message sent by the server
          if (errors && Array.isArray(errors) && errors.length > 0) {
              message = errors[0].message;
          }    
            this.showToast(component, {
                severity: "error",
                message: message
            });
        }
    });
    $A.enqueueAction(action);
},
showToast: function(component, data) {  
  //user must complete step 2 and 3 first
  const severity = data.severity; 
  const title = data.title; 
  const message = data.message; 
  const toastContainer = component.find("toastContainer");
  toastContainer.displayMessage(severity, title, message);
  
},
});