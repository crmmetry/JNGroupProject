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
  },

  setPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Application_Asset_Liability__c",
      fieldApiNames: [
        "Debt_Type_VERIFIED_List__c",
        "Institution_Debt_is_with_VERIFIED_list__c"
      ]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set("v.debtTypeList", values["Debt_Type_VERIFIED_List__c"]);
        component.set(
          "v.institutionDebtList",
          values["Institution_Debt_is_with_VERIFIED_list__c"]
        );
      } else {
        console.error(JSON.parse(JSON.stringify(reponse.getError())));
      }
    });
    $A.enqueueAction(action);
  }
});
