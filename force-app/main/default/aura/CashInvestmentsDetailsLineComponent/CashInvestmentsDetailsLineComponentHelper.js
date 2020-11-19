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
  },

  updateAccountTypeOptions: function (component, selected) {
    let fundManagerAccountTypeOptions = component.get(
      "v.accountTypeWhenJNFundManagerIsSelected"
    );
    let jnBankAccountTypeOptions = component.get(
      "v.accountTypeWhenJNBankIsSelected"
    );
    let accountTypeOptions = updateAccountTypeOptionList(
      fundManagerAccountTypeOptions,
      jnBankAccountTypeOptions,
      selected
    );
    component.set("v.accountType", accountTypeOptions);
  },

  clearDetailsWhenUnsecuredLoanSelected: function (component) {
    let data = component.get("v.ParentContainer");
    if (data.collateralType === "Unsecured (None)") {
      clearSelectLists("cash-investments-select-component", component);
      clearNumericalInput("cash-investments-numerical-component", component);
      clearTextInput("cash-investments-text-component", component);
    }
    let childKeyValuePairs = [
      {
        key: "financialInstitution",
        value: null
      },
      {
        key: "accountType",
        value: null
      },
      {
        key: "depositAccountNumber",
        value: ""
      },
      {
        key: "jnBankAccountNumberPrefix",
        value: ""
      },
      {
        key: "jnBankAccountNumber",
        value: ""
      },
      {
        key: "accountHolder",
        value: ""
      },
      {
        key: "annualInterestRate",
        value: 0
      },
      {
        key: "depositBalance",
        value: 0
      },
      {
        key: "existingBalance",
        value: 0
      }
    ];
    this.updateChildContainer(component, childKeyValuePairs, false);
  }
});
