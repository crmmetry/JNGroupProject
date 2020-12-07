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
      existingBalance: 0,
      loanToValueRatio: 0
    };
    component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },

  onChildContainerChange: function (component, event, helper) {
    let container = component.get("v.ParentContainer");
    const childContainer = component.get("v.ChildContainer");
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      childContainer.LTVValue = LTVCalculatorCash(
        container.approvedStartingLimit,
        container.existingDebt,
        childContainer.depositBalance
      );
      helper.clearDetailsWhenUnsecuredLoanSelected(component, container);
      fireProductDetailsEvent(null, childContainer, component);
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
    let disabilityFlag = toggleAccountTypeDisability(selected);
    component.set("v.accountTypeDisableFlag", disabilityFlag);
    helper.updateAccountTypeOptions(component, selected);
    toggleAccountNumberComponent(selected, component);
  },

  onAccountTypeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  },

  validateBalance: function (component, event, helper) {
    if (
      validNumber(data.existingDebt) &&
      validNumber(data.approvedStartingLimit)
    ) {
      let data = component.get("v.ParentContainer");
      const inputCmpArray = component.find(
        "cash-investments-numerical-component"
      );
      inputCmpArray.forEach((element) => {
        if (element.get("v.name") == "deposit") {
          if (
            data.existingDebt + data.approvedStartingLimit >
            calculatRequestedCreditBalanceLimit(element.get("v.value"))
          ) {
            element.setCustomValidity(
              "Existing Debt and Starting Limit cannot be greater than 80% of the deposit"
            );
            element.reportValidity();
          } else {
            element.setCustomValidity("");
            element.reportValidity();
          }
        }
      });
    } else {
      element.setCustomValidity(
        "Please note that the existing debt and starting limit has not been calculated."
      );
      element.reportValidity();
    }
  },

  onIsHypothecatedChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let childKeyValuePairs = [
      {
        key: "existingBalance",
        value: selected
      }
    ];
    helper.updateChildContainer(component, childKeyValuePairs, false);
    toggleHypothecatedLoanFlag(selected, component);
  },

  onDepositCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
  }
});
