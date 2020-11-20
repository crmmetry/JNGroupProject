({
  updateChildContainer: function (component, key, value) {
    let data = updateChildContainerWithValue(
      component.get("v.ChildContainer"),
      [
        {
          key: "numberOfSupplementaryCardHolders",
          value: selected
        }
      ]
    );
    component.set("v.ChildContainer", data);
  }
});
