({
  doInit: function (component, event, helper) {
    let personalAutoLoan = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null,
      purchasePrice: 0,
      marketValue: 0,
      loanToValueRatio: 0
    };
    component.set("v.ChildContainer", personalAutoLoan);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    console.log(
      "Child ContainerAUTO:",
      JSON.parse(JSON.stringify(component.get("v.ChildContainer")))
    );
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    data["containerName"] = component.get("v.containerName");
    component.set("v.ParentContainer", data);
    helper.getApplicants(component); //TODO: REFACTOR CANNOT BE CALLED LIKE THIS
    console.log(
      "Child Container After getApplicant:",
      JSON.parse(JSON.stringify(component.get("v.ChildContainer")))
    );
  },

  onParentContainerChange: function (component, event, helper) {
    const containerName = component.get("v.ParentContainer.containerName");
    if (
      component.get("v.scriptsLoaded") &&
      containerName !== component.get("v.containerName")
    ) {
      console.info(
        "ParentAUTO",
        JSON.parse(JSON.stringify(component.get("v.ParentContainer")))
      );
      //when purchase price or market value gets updated
      helper.setMinimumValue(component);
      //calculated LTV
      helper.calculateLTV(component);
    }
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
