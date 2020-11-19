({
  updateChildContainer: function (
    component,
    containerValues,
    shouldSetComponentValue
  ) {
    console.log("child updated");
    let data = updateChildContainerWithValue(
      component,
      containerValues,
      shouldSetComponentValue
    );
    console.log("child updated");
    component.set("v.ChildContainer", data);
    console.log("child updated");
  }
});
