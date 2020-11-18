({
  init: function (component, event, helper) {
    console.table(
      "Site lead from modal ",
      JSON.parse(JSON.stringify(component.get("v.SiteLead")))
    );
    $A.enqueueAction(component.get("c.openModal"));
  },
  openModal: function (component, event, helper) {
    //find modal using aura id
    var modal = component.find("myModal");
    var modalBackdrop = component.find("myModal-Back");

    // Now add and remove class
    $A.util.addClass(modal, "slds-fade-in-open");
    $A.util.addClass(modalBackdrop, "slds-backdrop_open");
  },

  closeModal: function (component, event, helper) {
    //find modal using aura id
    var modal = component.find("myModal");
    var modalBackdrop = component.find("myModal-Back");

    // Now add and remove class
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
    //send  event
    helper.sendEvents(component, "JNDocumentUploadTab", "hideModal", {});
  }
});