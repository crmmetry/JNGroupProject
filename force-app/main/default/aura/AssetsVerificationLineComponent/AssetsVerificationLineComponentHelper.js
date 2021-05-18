({
  parentNotifierToggler: function (component, shouldNotifyFlag) {
    if (shouldNotifyFlag) {
      component.set("v.shouldNotifyParent", false);
    } else {
      component.set("v.shouldNotifyParent", true);
    }
  }
});
