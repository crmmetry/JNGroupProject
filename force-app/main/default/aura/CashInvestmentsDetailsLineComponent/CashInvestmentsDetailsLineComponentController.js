({
  doInit: function (component, event, helper) {
    let data = {
      financialInstitution: null,
      accountType: null,
      jnBankAccountNumberPrefix: "",
      jnBankAccountNumber: null,
      depositAccountNumber: "",
      accountHolder: "",
      annualInterestRate: 0,
      depositBalance: 0,
      existingBalance: 0
    };
    component.set("v.ChildContainer", data);
  },

  onChildContainerChange: function (component, event, helper) {
    console.log("child container changed");
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    console.log("CashInvest data: ", JSON.parse(JSON.stringify(data)));
    data["containerName"] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
  },

  onParenContainerChange: function (component, event, helper) {
    const containerName = component.get("v.ParentContainer.containerName");
    if (
      component.get("v.scriptsLoaded") &&
      containerName !== component.get("v.containerName")
    ) {
      console.info(
        "Parent",
        JSON.parse(JSON.stringify(component.get("v.ParentContainer")))
      );
      helper.clearDetailsWhenUnsecuredLoanSelected(component);
    }
  },

  onFinancialInstitutionChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "financialInstitution",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
    console.log(selected);
    let disabilityFlag = toggleAccountTypeDisability(selected);
    component.set("v.accountTypeDisableFlag", disabilityFlag);
    helper.updateAccountTypeOptions(component, selected);
    toggleAccountNumberComponent(selected, component);
  },

  onAccountTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  validateBalance: function (component, event, helper) {
    const capLimit = 0.8;
    let data = component.get("v.ParentContainer");
    console.log("data: ", JSON.parse(JSON.stringify(data)));
    const inputCmpArray = component.find(
      "cash-investments-numerical-component"
    );
    inputCmpArray.forEach((element) => {
      if (element.get("v.name") == "deposit") {
        if (element.get("v.value") > data.requestedCreditLimit * capLimit) {
          element.setCustomValidity(
            "Balance cannot be greater than 80% of your requested card limit"
          );
          element.reportValidity();
        } else {
          element.setCustomValidity("");
        }
      }
    });
  },

  onIsHypothecatedChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
    let childKeyValuePairs = [
      {
        key: "existingBalance",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
    toggleHypothecatedLoanFlag(selected, component);
    console.log(selected);
  },

  onDepositCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});
