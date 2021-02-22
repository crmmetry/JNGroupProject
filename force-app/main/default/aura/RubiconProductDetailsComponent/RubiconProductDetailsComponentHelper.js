({
  getIDMDataMap: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getIDMProductDetails");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        component.set("v.IDMDataMap", result);
        console.log("IDM Map: ", JSON.parse(JSON.stringify(result)));
      }
    });
    $A.enqueueAction(action);
  },
  getCreditCardType: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSingleProductFamilySelection");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS" && typeof result !== "string") {
        if (result.productName.includes("Classic")) {
          component.set("v.cardType", "Classic");
        } else {
          component.set("v.cardType", "Gold");
        }
        console.log(
          "Product Family data: ",
          JSON.parse(JSON.stringify(result))
        );
      }
    });
    $A.enqueueAction(action);
  },
  getNumberOfSupplementaryHolders: function (component) {
    let oppId = component.get("v.recordId");
    let action = component.get("c.getSupplementaryCardHolders");
    action.setParams({
      oppId: oppId
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      let result = response.getReturnValue();
      if (state === "SUCCESS") {
        if (result.length > 0) {
          component.set("v.hasSupplementaryCardHolders", "Yes");
        } else {
          component.set("v.hasSupplementaryCardHolders", "No");
        }
        console.log(
          "Supplementary Cardholder info: ",
          JSON.parse(JSON.stringify(result))
        );
      }
    });
    $A.enqueueAction(action);
  }
});
