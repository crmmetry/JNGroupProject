({
  updateChildContainer: function (
    component,
    containerValues,
    shouldSetComponentValue
  ) {
    console.log("helper for update child container was reached ");
    let data = updateChildContainerWithValue(
      component,
      containerValues,
      shouldSetComponentValue
    );
    component.set("v.ChildContainer", data);
    console.log("childcontainer set");
  }
});
