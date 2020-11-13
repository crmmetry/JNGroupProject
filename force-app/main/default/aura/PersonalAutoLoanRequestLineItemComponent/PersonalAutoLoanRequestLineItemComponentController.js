({
  doInit: function (component, event, helper) {
    let personalAutoLoan = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.ChildContainer", personalAutoLoan);
  },

  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    data['containerName'] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
    helper.getApplicants(component);//TODO: REFACTOR CANNOT BE CALLED LIKE THIS
  },
  onApplicantsChange: function (component, event, helper) {
    let applicant = component.get("v.applicants");
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
    console.log(JSON.stringify(data));
  },

  onLoanPurposeChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onPurchasePriceCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onMarketCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onDepositCurrencyChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  },

  onVehicleClassificationChange: function (component, event, helper) {
    const selected = event.getSource().get("v.value");
    console.log(selected);
  }
});