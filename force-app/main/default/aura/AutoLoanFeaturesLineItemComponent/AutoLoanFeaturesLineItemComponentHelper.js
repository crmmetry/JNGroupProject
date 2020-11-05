({
    toggleShowIncludeInLoanAmount: function (component, parentObj) {
        console.info("toggleShowIncludeInLoanAmount", JSON.parse(JSON.stringify(parentObj)));
        if (parentObj.hasOwnProperty('waiveProcessingFeeFlag')) {
            if (parentObj.waiveProcessingFeeFlag) {
                component.set(`v.showIncludeInLoanAmount`, true);
            } else {
                component.set(`v.showIncludeInLoanAmount`, false);
            }
        }
    },
    toggleShowIndicateApplicableProcessingFees: function (component, parentObj) {
        if (parentObj.hasOwnProperty('waiveProcessingFeeFlag') && parentObj.waiveProcessingFeeFlag === false) {
            component.set("v.showIndicateApplicableProcessingFees", false);
        } else {
            component.set("v.showIndicateApplicableProcessingFees", true);
        }
    }
})
