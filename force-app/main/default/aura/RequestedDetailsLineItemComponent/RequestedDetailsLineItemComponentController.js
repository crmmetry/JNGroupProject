({
  doInit: function (component, event, helper) {
    let data = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.ChildContainer", data);
    component.set("v.loanPurposeOptions", UNSECURED_LOAN_PURPOSE);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    const childContainer = component.get("v.ChildContainer");
    if (
      component.get("v.scriptsLoaded") &&
      component.get("v.notifyContainerChange")
    ) {
      helper.getApplicants(component);
      fireProductDetailsEvent(null, childContainer, component);
    }
  },

  onApplicantsChange: function (component, event, helper) {
    let applicant = component.get("v.applicants");
    if (applicant != {}) {
      const applicantsMap = {
        id: applicant[0].Id,
        rating: applicant[0].rating,
        age: applicant[0].age
      };
      const data = Object.assign(
        component.get("v.ParentContainer"),
        applicantsMap
      );
      component.set("v.ParentContainer", data);
    }
  },
  /**
   * JN1-4210 : For validating fields
   * @param {*} component
   * @param {*} event
   * @param {*} helper
   */
  validateFields: function (component, event, helper) {
    let fieldsToValidateArray = [
      "requestedYears",
      "requestedMonths",
      "requestedMarket"
    ];
    return validateFields(component, fieldsToValidateArray);
  },
  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    let values = [
      {
        key: "loanPurpose",
        value: selected
      }
    ];
    updateChildContainerWithValue(component, values, false);
  }
});
