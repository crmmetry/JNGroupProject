({
  calculateMonthlyP_ILoanAmount: function (component, requestDetailMap) {
    let rate;
    let totalMonths;
    let pmtResult;
    if (requestedDetailMap != null) {
      const fields = [
        { name: "loanAmount", valid: false },
        { name: "years", valid: false },
        { name: "months", valid: false },
        { name: "market", valid: false }
      ];
      fields.forEach((field, index) => {
        console.log("success foreach");
        if (requestedDetailMap.hasOwnProperty(field.name)) {
          if (!isEmpty(requestedDetailMap[field])) {
            fields[index].valid = true;
          }
        }
      });
      //Calculations
      //Calculate Percentage
      if (fields[3].valid) {
        rate = calculateRatePerPeriod(requestedDetailMap.market);
      }
      if (fields[2].valid && fields[1].valid) {
        totalMonths = calculateMonths(
          requestDetailMap.years,
          requestDetailMap.months
        );
      }

      if (rate && totalMonths && requestDetailMap.loanAmount) {
        pmtResult = calculatePMT(
          rate,
          totalMonths,
          -requestDetailMap.loanAmount,
          0,
          0
        );
        pmtResult = parseFloat(pmtResult).toFixed(2);
        component.set("v.monthly_PI_LoanAmount", pmtResult);
      }
    }
  }
});
