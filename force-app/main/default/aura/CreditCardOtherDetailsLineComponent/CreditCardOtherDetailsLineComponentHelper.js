({
  updateChildContainer: function (component, key, value) {
    let data = updateChildContainerWithValue(component.get("ChildContainer"), [
      {
        key: key,
        value: value
      }
    ]);
    component.set("v.ChildContainer", data);
    console.log("child updated");
  },

  toggleCashInvestment: function (component) {
    let data = component.get("v.ChildContainer");
    component.set("v.cashInvestmentFlag", toggleCashInvestmentFlag(data));
    console.log("cash investments toggled");
  }
});
