({
  setPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Loan_Calculation_Product__c",
      fieldApiNames: [
        "Include_in_Loan_Amount_Flag__c",
        "CurrencyIsoCode",
        "Repayment_Method_List__c",
        "Method_of_Fee_Payment_List__c"
      ]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const values = response.getReturnValue();
        component.set("v.requestedLoanCurrency", values["CurrencyIsoCode"]);
        component.set(
          "v.includeCreditorLifeInLoanAmount",
          values["Include_in_Loan_Amount_Flag__c"]
        );
        component.set("v.repaymentMethod", values["Repayment_Method_List__c"]);
        component.set(
          "v.methodFeePayment",
          values["Method_of_Fee_Payment_List__c"]
        );
      } else {
        console.error(JSON.parse(JSON.stringify(reponse.getError())));
      }
    });
    $A.enqueueAction(action);
  },

  calculateAge: function (component, selected) {
    let componentData = component.get("v.UnsecuredLoanContainer");
    console.log("container: ", JSON.parse(JSON.stringify(componentData)));
    let currentAge = component.get("v.applicantAge");
    let loanTerm = selected;
    if (currentAge != null && loanTerm != null) {
      //let ageInMonths = currentAge * 12;
      componentData.ageAtEndOfLoanTerm = currentAge + loanTerm / 12;
      console.log("current age", currentAge);
      console.log("age at end of loan term", componentData.ageAtEndOfLoanTerm);
      component.set("v.UnsecuredLoanContainer", componentData);
    }
  }
});
