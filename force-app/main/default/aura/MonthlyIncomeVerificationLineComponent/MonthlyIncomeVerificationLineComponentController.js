({
  doinit: function (component, event) {
    let auraList = [
      "primaryIncomeSource",
      "grossSalaryAllowances",
      "otherIncome",
      "netBusinessIncomeSoleTrader",
      "directorEmoluments",
      "netBusinessIncomePartnership",
      "netBusinessIncomeCompanyShareholding",
      "pension",
      "propertyRental",
      "totalOtherIncome",
      "totalMonthlyIncome"
    ];
    component.set("v.auraIdList", auraList);
    let verifiedMonthlyIncome = {
      primarySourceOfIncome: null,
      grossSalaryAllowances: null,
      otherIncome: null,
      netBusinessIncomeSoleTrader: null,
      netBusinessIncomePartnership: null,
      netBusinessIncomeCompanyShareholding: null,
      directorEmoluments: null,
      pensionIncome: null,
      propertyRental: null,
      totalOtherIncome: null,
      totalMonthlyIncome: null
    };
    component.set("v.verifiedMonthlyIncomeMap", verifiedMonthlyIncome);
    console.log("component was initialised");
  },
  onToggleCheckAlChange: function (component, event, helper) {
    console.log("check all change handler");
    let checkBoxCmp = component.find("verificationToggle");
    checkBoxCmp.forEach((element) => {
      element.set("v.checked", component.get("v.toggleCheckAll"));
      if (component.get("v.toggleCheckAll")) {
        //set all verified fields to disabled
        let inputCmpIdList = component.get("v.auraIdList");
        inputCmpIdList.forEach((element) => {
          let inputCmp = component.find(element);
          inputCmp.set("v.disabled", true);
        });
      } else {
        //set all verified fields to undisabled
        let inputCmpIdList = component.get("v.auraIdList");
        inputCmpIdList.forEach((element) => {
          let inputCmp = component.find(element);
          inputCmp.set("v.disabled", false);
        });
      }
      console.log("component checkbox set to true");
    });
  },

  fireComponentEvent: function (cmp, event) {
    let cmpEvent = cmp.getEvent("MonthlyIncomeEvent");
    let checkBoxCmpName = event.getSource().get("v.name");
    let checkBoxValue = event.getSource().get("v.checked");
    console.log(checkBoxCmpName);
    console.log(checkBoxValue);
    cmpEvent.setParams({
      componentName: checkBoxCmpName,
      checkedVar: checkBoxValue
    });
    cmpEvent.fire();
  },

  handleComponentEvent: function (component, event) {
    let componentName = event.getParam("componentName");
    let checkedValue = event.getParam("checkedVar");
    let inputCmp = component.find(componentName);
    if (checkedValue) {
      inputCmp.set("v.disabled", true);
      //set value to the value of related unverified amount
    } else {
      inputCmp.set("v.disabled", false);
    }
  },

  onVerifiedMonthlyIncomeMapChange: function (component, event) {
    console.log(
      JSON.parse(JSON.stringify(component.get("v.verifiedMonthlyIncomeMap")))
    );
    let verifiedMonthlyIncomeData = component.get("v.verifiedMonthlyIncomeMap");
    let verifiedData = component.get("v.verifiedDataMap");
    let data = Object.assign(verifiedData, verifiedMonthlyIncomeData);
    component.set("v.verifiedDataMap", data);
  }
});
