({
  updateChildContainer: function (
    component,
    containerValues,
    shouldSetComponentValue
  ) {
    let data = updateChildContainerWithValue(
      component,
      containerValues,
      shouldSetComponentValue
    );
    component.set("v.ChildContainer", data);
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

  clearDetailsWhenUnsecuredLoanSelected: function (component, data) {
    if (data.collateralType === "Unsecured (None)") {
      resetComponentValue("cashInvestmentsSelectComponent", component, null);
      resetComponentValue("cashInvestmentsNumericalComponent", component, 0);
      resetComponentValue("cashInvestmentsTextComponent", component, "");

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
      updateChildContainerNoNotification(component, childKeyValuePairs);
    }
  }
});
