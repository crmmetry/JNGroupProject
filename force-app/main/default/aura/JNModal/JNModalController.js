({
  init: function(component, event, helper) {},
  hideModal: function(component, event, helper) {
    helper.closeModal(component);
  },
  showModal: function(component, event, helper) {
    const args = event.getParam("arguments");
    component.set("v.header", args.header);
    component.set("v.body", args.body);
    helper.showModal(component);
  }
});