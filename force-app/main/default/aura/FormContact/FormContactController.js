({
  doInit: function (component, event) {},
  save: function (component, event) {
    var getCon = component.get("v.NewCon");

    var action = component.get("c.CreateNewContact");

    action.setParams({
      con: getCon
    });

    action.setCallback(this, function (a) {
      var state = a.getState();

      if (state === "SUCCESS") {
        var name = a.getReturnValue();
      }
    });

    $A.enqueueAction(action);
  }
});
