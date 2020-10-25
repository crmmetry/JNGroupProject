({
  calculateMonthlyP_ILoanAmount: function (component, RequestedDetails) {
    let rate;
    let totalMonths;
    let pmtResult;
    if (RequestedDetails != null) {
      const fields = {
        loanAmount: false,
        months: false,
        years: false,
        market: false
      };
      
      Object.keys(fields).forEach((field) => {
        if (RequestedDetails.hasOwnProperty(field)) {
          if (isEmpty(RequestedDetails[field]) === false) {
            fields[field] = true;
          }
        }
      });
      console.info(fields);
      //Calculate Percentage
      if (fields.market) {
        rate = calculateRatePerPeriod(RequestedDetails.market);
        console.log("rate", rate);
      }
      if (fields.years && fields.months) {
        totalMonths = calculateMonths(
          RequestedDetails.years,
          RequestedDetails.months
        );
        console.log("totalMonths", totalMonths);
      }

      if (rate && totalMonths && RequestedDetails.loanAmount) {
        pmtResult = calculatePMT(
          rate,
          totalMonths,
          -RequestedDetails.loanAmount,
          0,
          0
        );
        console.log("pmtResult", pmtResult);
        pmtResult = parseFloat(pmtResult).toFixed(2);
        component.set("v.monthly_PI_LoanAmount", pmtResult);
        return;
      }
      //default
      component.set("v.monthly_PI_LoanAmount", 0);
    }
  }
});
