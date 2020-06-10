({
  createAffiliates: function(component) {
    let affiliateList = component.get("v.affiliateList");
    let items = {};
    affiliateList.forEach(function(element, index) {
      items[index + ""] = element;
    });

    const action = component.get("c.createPersonAffiliates");
    action.setParams({
      values: items,
      leadId: component.get("v.leadId")
    });
    this.sendEvents(component, ["showLoading"]);
    action.setCallback(this, function(response) {
      this.sendEvents(component, ["disableShowLoading"]);
      const state = response.getState();
      if (state === "SUCCESS") {
			//reset  list	
        component.set("v.affiliateList", []);		
        this.sendEvents(
          component,
          ["navigateNext"],
          response.getReturnValue()
        );
      } else {
        const err = response.getError();
        console.log(JSON.parse(JSON.stringify(err)));
      }
    });
    $A.enqueueAction(action);
  },
  sendEvents: function(component, events, data) {
    const eventToSend = component.getEvent("jnEvent");
    eventToSend.setParams({
      component: "JNApplicationForm",
      action: events,
      data: data
    });
    eventToSend.fire();
  }
});