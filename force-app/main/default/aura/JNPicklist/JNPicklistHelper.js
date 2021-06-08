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
        let newValues = this.transformSpecialCharactersinPicklist(values);
        component
          .find("picklistChoices")
          .set("v.value", component.get("v.crmmObjectSelected"));
        component.set("v.values", newValues);
      }
    });
    $A.enqueueAction(action);
  },

  transformSpecialCharactersinPicklist: function (values) {
    let transformedValues = new Array();
    values.forEach((element) => {
      if (element.includes("&amp;")) {
        let newString = element.replace(/&amp;/g, "&");
        transformedValues.push(newString);
      } else if (element.includes("&#39;")) {
        let newString = element.replace(/&#39;/g, "'");
        transformedValues.push(newString);
      } else {
        transformedValues.push(element);
      }
    });
    return transformedValues;
  }
});
