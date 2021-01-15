({
  sendEvents: function (component, componentName, events, data) {
    const eventToSend = component.getEvent("jnEvent");
    eventToSend.setParams({
      component: componentName,
      action: events,
      data: data
    });
    eventToSend.fire();
  }
});
