({
  /**
   * Retrieves picklist values from Web Service call out.
   * @param {*} component
   * @return
   */
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

  /**
   * Loops through picklist values and formats character references to special characters.
   * @param {*} values
   * @return {*} transformedValues
   */
  transformSpecialCharactersinPicklist: function (values) {
    let transformedValues = new Array();
    values.forEach((element) => {
      let newString = element
        .replace(/&amp;/g, "&")
        .replace(/&#39;/g, "'")
        .replace(/&lt;/g, "<")
        .replace(/&quot;/g, '"');
      transformedValues.push(newString);
    });
    return transformedValues;
  }
});
