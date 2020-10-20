({
  getTabName: function (tabId) {
    return tabId.replace("_Tab", "");
  },
  formatTabName: function (tabId) {
    return tabId.replace("_Tab", "").replace("_", " ");
  },
  navigateNext: function (component) {
    let allTabs = component.get("v.allTabs");
    let index = allTabs.indexOf(component.get("v.tabId"));

    //can go next
    if (index + 1 <= allTabs.length - 1) {
      let tab = allTabs[index + 1];
      component.set("v.tabId", tab);
    }
  },
  getTabPrevious: function (component) {
    let allTabs = component.get("v.allTabs");
    let index = allTabs.indexOf(component.get("v.tabId"));
    //can go previous
    if (index - 1 >= 0) {
      return index - 1;
    }
    return index;
  },
  setSiteLeadInfo: function (component, currentCmp) {
    let siteLead = component.get("v.SiteLead");
    siteLead = Object.assign(siteLead, currentCmp.get("v.SiteLead"));
    component.set("v.SiteLead", siteLead);
    console.table(JSON.parse(JSON.stringify(siteLead)));
  },
  showModal: function (component) {
    let childCmp = component.find("JNModal");
    let header = "Application Form Submission";
    let body = "Are you sure you want to submit this form?";
    childCmp.showModal(header, body);
  },
  closeModal: function (component) {
    let childCmp = component.find("JNModal");
    childCmp.hideModal();
  },
  updateLeadInfo: function (component, applicant, leadId) {
    let action = component.get("c.updateApplicantTextInfo");
    action.setParams({
      applicantDetails: applicant,
      leadId: leadId
    });
    component.set("v.showLoading", true);
    action.setCallback(this, function (response) {
      component.set("v.showLoading", false);
      let state = response.getState();
      if (state === "SUCCESS") {
        // display successful toast
        this.showSuccessToast(component, {
          severity: "confirm",
          message:
            "Thanks for taking your time to complete this form, please look out for a follow up email.",
          title: "Applicant Form Completion"
        });
        setTimeout(function () {
          window.location.reload();
        }, 5500);
      }
    });
    $A.enqueueAction(action);
  },
  showErrorToast: function (component, data) {
    let severity = data.severity; //"error"; //it could be 'confirm' or null
    let title = data.title; //"An error has occurred";
    let message = data.message; //"You must first complete step 2 and 3 before";
    let toastContainer = component.find("toastContainer");
    toastContainer.displayMessage(severity, title, message);
  },
  showSuccessToast: function (component, data) {
    let siteLead = component.get("v.SiteLead");
    let severity = data.severity;
    let title = data.title;
    let message = data.message;
    let toastContainer = component.find("toastContainer");
    toastContainer.displayMessage(severity, title, message);
  },
  sendEvents: function (component, cmpName, events, data) {
    let eventToSend = component.getEvent("jnEvent");
    eventToSend.setParams({
      component: cmpName,
      action: events,
      data: data
    });
    eventToSend.fire();
  },
  validateMandatoryTabs: function (component) {
    let validatedTabs = component.get("v.validatedTabs");
    let missingSteps = [];
    let error = false;
    for (let key in validatedTabs) {
      if (validatedTabs.hasOwnProperty(key)) {
        if (validatedTabs[key] == false) {
          missingSteps.push(this.formatTabName(key));
          error = true;
        }
      }
    }
    let message = `The following mandatory tab(s) must be completed in full first ${missingSteps.join(
      ", "
    )}`;
    return { error, message };
  },
  createLead: function (component) {
    let action = component.get("c.createLeadReferral");
    action.setParams({
      applicantDetails: component.get("v.SiteLead")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function (response) {
      this.sendEvents(component, ["disableShowLoading"]);
      let state = response.getState();
      if (state === "SUCCESS") {
        console.log("Server call successful");
        let siteLead = component.get("v.SiteLead");
        Object.assign(siteLead, response.getReturnValue());
        component.set("v.SiteLead", siteLead);
        this.sendEvents(component, ["setLeadInfo", "navigateNext"], {
          Id: siteLead.Id
        });
      } else {
        let errors = response.getError();
        let message = "Unknown error"; // Default error message
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
  showToast: function (component, data) {
    //user must complete step 2 and 3 first
    let severity = data.severity;
    let title = data.title;
    let message = data.message;
    let toastContainer = component.find("toastContainer");
    toastContainer.displayMessage(severity, title, message);
  },
  enableCreateAppBtn: function (component) {
    let siteLead = component.get("v.SiteLead");
    let currentTab = this.getTabName(component.get("v.tabId"));
    if (!siteLead.hasOwnProperty("Id") && currentTab === "Document_Upload") {
      component.set("v.showCreateAppBtn", true);
    } else if (currentTab !== "Document_Upload") {
      component.set("v.showCreateAppBtn", false);
    }
  },
  handleAutoTab: function (component, currentTab, prevTab) {
    let mandatoryTabs = component.get("v.mandatoryTabs");
    let included = mandatoryTabs.some((tab) => tab === prevTab);
    if (included) {
      setTimeout(
        $A.getCallback(() => {
          let tabName = this.getTabName(prevTab);
          console.info("Current Tab", tabName, prevTab);
          let currentCmp = component.find(tabName);
          console.warn("currentCmp", currentCmp);
          if (
            currentCmp &&
            typeof currentCmp.validateTabFields === "function"
          ) {
            if (currentCmp.validateTabFields() === true) {
              let validatedTabs = component.get("v.validatedTabs");
              validatedTabs[prevTab] = true;
              component.set("v.validatedTabs", validatedTabs);
            }
          }
        }),
        1500
      );
    }
  },
  handleTab: function (component) {
    let tabName = this.getTabName(component.get("v.tabId"));
    let validatedTabs = component.get("v.validatedTabs");
    let currentCmp = component.find(tabName);
    if (component.get("v.formBtnText") === "Finish") {
      //this.showModal(component);
      this.createLead(component);
    } else {
      if (typeof currentCmp.validateTabFields === "function") {
        if (currentCmp.validateTabFields() === true) {
          let tab = component.get("v.tabId");
          if (validatedTabs.hasOwnProperty(tab)) {
            validatedTabs[tab] = true;
            component.set("v.validatedTabs", validatedTabs);
          }
          switch (tabName) {
            case "Application_Information": {
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              console.log("navigate success");
              break;
            }
            case "General_Details": {
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              break;
            }
            case "Identification_Details": {
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              break;
            }
            case "Emergency_Contact": {
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              break;
            }
            case "Contact_Details": {
              if (!currentCmp.get("v.shouldShow")) {
                currentCmp.setMailingAddress();
              }
              //currentCmp.createDetails();
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              break;
            }
            case "Employment_Details": {
              this.setSiteLeadInfo(component, currentCmp);
              this.navigateNext(component);
              break;
            }

            default: {
              if (typeof currentCmp.createDetails === "function") {
                currentCmp.createDetails();
              }
            }
          }
        }
      } else {
        this.navigateNext(component);
      }
    }
  }
});
