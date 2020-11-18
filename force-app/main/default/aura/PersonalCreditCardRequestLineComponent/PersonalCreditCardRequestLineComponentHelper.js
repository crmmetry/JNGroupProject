({
  updateChildContainer: function (component, key, value) {
    let data = updateChildContainerWithValue(component.get("ChildContainer"), [
      {
        key: "numberOfSupplementaryCardHolders",
        value: selected
      }
    ]);
    component.set("v.ChildContainer", data);
  }
});
