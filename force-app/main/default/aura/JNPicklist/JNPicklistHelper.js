({
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValues");
    const objName = component.get("v.crmmObjectname");
    const objField = component.get("v.crmmObjectField");

    const recordTypeName = component.get("v.recordTypeName");
    const recordTypeId = component.get("v.recordTypeId");
    action.setParams({
      objectApiName: objName,
      fieldApiName: objField,
      recordTypeName: recordTypeName,
      recordTypeId: recordTypeId
    });

    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component
          .find("picklistChoices")
          .set("v.value", component.get("v.crmmObjectSelected"));
        component.set("v.values", values);
      }
    });
    $A.enqueueAction(action);
  }
});