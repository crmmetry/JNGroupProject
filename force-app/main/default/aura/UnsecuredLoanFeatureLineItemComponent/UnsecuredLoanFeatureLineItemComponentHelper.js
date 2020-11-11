({
  toggleShowIncludeInLoanAmount: function (component, parentObj) {
    if (parentObj.hasOwnProperty("waiveProcessingFeeFlag")) {
      if (parentObj.waiveProcessingFeeFlag) {
        component.set(`v.showIncludeInLoanAmount`, true);
      } else {
        component.set(`v.showIncludeInLoanAmount`, false);
      }
    }
  },
  toggleShowIndicateApplicableProcessingFees: function (component, parentObj) {
    if (
      parentObj.hasOwnProperty("waiveProcessingFeeFlag") &&
      parentObj.waiveProcessingFeeFlag === false
    ) {
      component.set("v.showIndicateApplicableProcessingFees", false);
    } else {
      component.set("v.showIndicateApplicableProcessingFees", true);
    }
  },
  resetProcessingFieldsValues: function (data, component) {
    if (typeof data["waiveProcessingFeeFlag"] !== "undefined") {
      if (data["waiveProcessingFeeFlag"] === true) {
        component.set("v.processingFeePercentagePerAnum", null);
        component.find("includeInLoanAmountId").set("v.value", "select one...");
      }
    }
  },
  onProposedSavingsChange: function (component) {
    const selected = component.get("v.value");
    let childContainer = component.get("v.ChildContainer");
    if (selected === "percent") {
      childContainer.amount = null;
      childContainer.selection = selected;
    } else if (selected === "amount") {
      childContainer.percentage = null;
      childContainer.selection = selected;
    }
  },
});
