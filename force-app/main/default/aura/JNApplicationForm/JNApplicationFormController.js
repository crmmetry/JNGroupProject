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

    component.set("v.unsecuredLoanTabs", unsecuredLoanTabs);
    component.set("v.creditCardTabs", creditCardTabs);
    component.set("v.SiteLead", {});
    component.set("v.tabId", "Getting_Started_Tab");
  },
  handleLoanTypeChange: function(component, event, helper) {
    const old = event.getParam("oldValue");
    const current = event.getParam("value");
    if (old != current) {
      const unsecuredLoanTabs = component.get("v.unsecuredLoanTabs");
      const creditCardTabs = component.get("v.creditCardTabs");
      component.set("v.loan_type", current);
      component.set(
        "v.allTabs",
        current === "credit_card" ? creditCardTabs : unsecuredLoanTabs
      );
      const currentTabs = component.get("v.allTabs");
      let validatedTabs = {};
      const tabs = currentTabs
        .filter(function(tab) {
          return tab != "Getting_Started_Tab" && tab != "Document_Upload_Tab" && tab != 'Extensions_Tab';
        })
        .map(function(value, index) {
          return { [value]: false };
        });

      tabs.forEach(function(body) {
        Object.assign(validatedTabs, body);
      });
      component.set("v.validatedTabs", validatedTabs);
    }
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
    const tabName = helper.getTabName(component.get("v.tabId"));
    const validatedTabs = component.get("v.validatedTabs");
    const currentCmp = component.find(tabName);
    if (component.get("v.formBtnText") === "Finish") {
      helper.showModal(component);
    } else {
      if (typeof currentCmp.validateTabFields === "function") {
        if (currentCmp.validateTabFields() === true) {
          const tab = component.get("v.tabId");
          if (validatedTabs.hasOwnProperty(tab)) {
              validatedTabs[tab] = true;
              component.set("v.validatedTabs", validatedTabs);
          }
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
    const {error, message} = helper.createCompoundErrorMessage(component)
     
    helper.closeModal(component);
    const siteLead = component.get("v.SiteLead");
    if (error) {
        console.info(error)
        console.warn('Message ', message)
      //user must complete all required steps first
      helper.showErrorToast(component, {
        severity: "error",
        message: message,
        title: "An error has occurred"
      });
      return;
    } else {
        console.warn('whats going on')
      const applicant = { JN_Site_Form_Completed_Flag__c: true };
      helper.updateLeadInfo(component, applicant, siteLead["Id"]);
    }
  }
});