({
  deduplicateVerifiedChildDebtInfo: function (component, debtInfo) {
    const parentContainerDebts = component.get("v.listOfVerifiedDebts");
    const index = parentContainerDebts.findIndex(function (element) {
      return element.debtType == debtInfo.debtType;
    });
    if (index != -1) {
      parentContainerDebts[index] = debtInfo;
    } else {
      parentContainerDebts.push(debtInfo);
    }
    component.set("v.listOfVerifiedDebts", parentContainerDebts);
  },

  parseDebtInfo: function (component) {
    let debt = component.get("v.debtInfo");
    let verfiedDebtList = [];
    let verifiedDebtData = new Map();
    for (let key in debt) {
      if (key.includes("Verified")) {
        verifiedDebtData[key] = debt[key];
      }
    }
    verfiedDebtList.push(verifiedDebtData);
    component.set("v.verifiedDebtInfo", verifiedDebtData);
    component.set("v.listOfVerifiedDebts", verfiedDebtList);
  }
});
