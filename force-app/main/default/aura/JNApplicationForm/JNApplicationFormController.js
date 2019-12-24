({
  doInit: function(component, event, helper) {
       
    const creditCardTabs = [
      "Getting_Started_Tab",
      "Application_Information_Tab",
      "General_Details_Tab",
      "Identification_Details_Tab",
      "Contact_Details_Tab",
      "Emergency_Contact_Tab",
      "Employment_Details_Tab",
      "Affiliations_Tab",
      "Extensions_Tab",
      "Document_Upload_Tab"
    ];
    const unsecuredLoanTabs = [
      "Getting_Started_Tab",
      "Application_Information_Tab",
      "General_Details_Tab",
      "Identification_Details_Tab",
      "Contact_Details_Tab",
      "Emergency_Contact_Tab",
      "Employment_Details_Tab",
      "Affiliations_Tab",
      "Document_Upload_Tab"
    ];
    const loanType = component.get("v.loan_type");
    component.set("v.SiteLead", {});
    component.set("v.allTabs", loanType == 'credit_card' ? creditCardTabs : unsecuredLoanTabs);
    component.set("v.tabId", "Getting_Started_Tab");
  },

  openModal: function(component, event, helper) {
    var childCmp = component.find("JNModal");
    var header = "Here is the header I assign";
    var body = "Here is content for the body";
    childCmp.showModal(header, body);
  },
  navigateBack: function(component, event, helper) {
    const navEvent = component.getEvent("jnEvent");
    navEvent.setParam("action", "showHomePage");
    navEvent.setParam("component", "JNHomePage");
    navEvent.fire();
  },
  handleTabChange: function(component, event, helper) {
    const tabName = helper.getTabName(component.get("v.tabId"));
    if (tabName === "Document_Upload") {
      component.set("v.formBtnText", "Finish");
    } else {
      component.set("v.formBtnText", "Next");
    }
  },
  tabNext: function(component, event, helper) {
    const siteLead = component.get("v.SiteLead");
    const allTabs = component.get("v.allTabs");
    const index = allTabs.indexOf(component.get("v.tabId"));
    const tabName = helper.getTabName(component.get("v.tabId"));
    // this logic needs to be at the component level
    /*if (!siteLead.hasOwnProperty("Id") && index >= 3) {
      helper.showErrorToast(component, {
        severity: "error",
        message: "You must first complete step 2 and 3 first",
        title: "An error has occurred"
      });
      return;
    }*/

    const currentCmp = component.find(tabName);
    if (component.get("v.formBtnText") === "Finish") {
      helper.showModal(component);
    } else {
      if (typeof currentCmp.validateTabFields === "function") {
        if (currentCmp.validateTabFields() === true) {
          switch (tabName) {
            case "Application_Information": {
              helper.setSiteLeadInfo(component, currentCmp);
              helper.navigateNext(component);
              break;
            }
            case "Contact_Details": {
              if (!currentCmp.get("v.shouldShow")) {
                currentCmp.setMailingAddress();
              }
              currentCmp.createDetails();
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
        helper.navigateNext(component);
      }
    }
  },
  tabPrevious: function(component, event, helper) {
    const allTabs = component.get("v.allTabs");
    const index = allTabs.indexOf(component.get("v.tabId"));
    //can go next
    if (index - 1 >= 0) {
      const tab = allTabs[index - 1];
      component.set("v.tabId", tab);
    }
  },
  handleEvent: function(component, event, helper) {
    const eventAction = event.getParam("action");
    const eventComponent = event.getParam("component");
    const eventData = event.getParam("data");
    if (eventComponent === "JNApplicationForm") {
      if (Array.isArray(eventAction)) {
        eventAction.forEach(function(action) {
          switch (action) {
            case "showLoading": {
              component.set("v.showLoading", true);
              break;
            }
            case "disableShowLoading": {
              component.set("v.showLoading", false);
              break;
            }
            case "navigateNext": {
              helper.navigateNext(component);
              break;
            }
            case "setLeadInfo": {
              let siteLead = component.get("v.SiteLead");
              Object.assign(siteLead, eventData);
              component.set("v.SiteLead", siteLead);
            }
          }
        });
      }
    }
  },
  postiveBtnClick: function(component, event, helper) {
    helper.closeModal(component);
    const siteLead = component.get("v.SiteLead");
    if (!siteLead.hasOwnProperty("Id")) {
      //user must complete step 2 and 3 first
      helper.showErrorToast(component, {
        severity: "error",
        message: "You must first complete step 2 and 3 before",
        title: "An error has occurred"
      });
      return;
    } else {
      // display successful toast
      helper.showSuccessToast(component, {
        severity: "confirm",
        message:
          "Thanks for taking your time to complete this form, please look out for a follow up email.",
        title: "Applicant Form Completion"
      });
      setTimeout(function() {
          window.location.reload();
        //helper.sendEvents(component, "JNHomePage", ["showHomePage"], {});
      }, 5500);
    }
  }
});