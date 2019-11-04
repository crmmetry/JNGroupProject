({
    getPickListValues: function(component) {
      const action = component.get("c.getPickListValues");
      const objName = component.get("v.crmmObjectname");
      const objField = component.get("v.crmmObjectField");
      const crmmLabel = component.get("v.crmmLabel");
      const selected = component.get("v.crmmObjectSelected");
     
      action.setParams({
        'objectApiName': objName,
        'fieldApiName': objField
      });
      action.setCallback(this, function(response) {
        const state = response.getState();
        if (state === "SUCCESS") {
            if(crmmLabel!=null){
                component.find("picklistChoices").set("v.label",crmmLabel);
             }
            if(selected!=null){
                component.find("picklistChoices").set("v.value", selected);
            }

          const values = response.getReturnValue();
           
          component.set("v.values", values);

        } else {
        }
      });
      $A.enqueueAction(action);
    },
      createLead: function(component) {
          
      }
  });