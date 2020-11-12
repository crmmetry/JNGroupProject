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
  onChildContainerChange: function (component, event, helper) {
    const data = Object.assign(
      component.get("v.ParentContainer"),
      component.get("v.ChildContainer")
    );
    component.set("v.ParentContainer", data);
    console.info(JSON.stringify(component.get("v.ChildContainer")));
    helper.getApplicants(component);
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
  }
});
