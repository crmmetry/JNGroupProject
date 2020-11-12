({
  getAccounts: function (component) {
    let action = component.get("c.getContactsAccount");
    action.setParams({
      ids: component.get("v.accountIds")
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const accounts = response.getReturnValue();
        const names = accounts.map(function (account) {
          return account.Name;
        });
        console.log(accounts);
        component.set("v.accountNames", JSON.stringify(names));
        const navigate = component.get("v.navigateFlow");
        console.info(component.get("v.accountNames"));
        //navigate("NEXT");
      }
    });
    $A.enqueueAction(action);
  }
});