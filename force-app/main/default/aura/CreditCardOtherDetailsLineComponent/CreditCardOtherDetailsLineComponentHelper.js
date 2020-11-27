({
  updateChildContainer: function (
    component,
    containerValues,
    shouldSetComponentValue
  ) {
    let data = updateChildContainerWithValue(
      component,
      containerValues,
      shouldSetComponentValue
    );
    component.set("v.ChildContainer", data);
  }
});
