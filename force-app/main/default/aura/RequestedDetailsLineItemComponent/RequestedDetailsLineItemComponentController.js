({
  doInit: function (component, event, helper) {
    let data = {
      loanAmount: component.get("v.productPrice"),
      years: null,
      months: null,
      market: null
    };
    component.set("v.ChildContainer", data);
  },
  scriptsLoaded: function (component, event, helper) {
    component.set("v.scriptsLoaded", true);
  },
  onChildContainerChange: function (component, event, helper) {
    if (component.get("v.scriptsLoaded")) {
      let container = component.get("v.ChildContainer");
      fireProductDetailsEvent(null, container);
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
  }
});
