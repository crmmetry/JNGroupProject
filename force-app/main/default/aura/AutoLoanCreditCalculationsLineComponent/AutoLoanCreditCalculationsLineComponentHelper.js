({
  calculateMonthlyP_ILoanAmount: function (component, PersonalAutoLoan) {
    console.log("Calculation METHOD");
    let rate;
    let totalMonths;
    let pmtResult;
    if (PersonalAutoLoan != null) {
      console.log("AutoLoan not null");
      const fields = {
        loanAmount: false,
        months: false,
        years: false,
        market: false
      };
      Object.keys(fields).forEach((field) => {
        if (PersonalAutoLoan.hasOwnProperty(field)) {
          if (isEmpty(PersonalAutoLoan[field]) === false) {
            console.log("validity true");
            fields[field] = true;
          }
        }
      });
      console.info(fields);
      //Calculate Percentage
      if (fields.market) {
        rate = calculateRatePerPeriod(PersonalAutoLoan.market);
        console.log("rate", rate);
      }
      if (fields.years && fields.months) {
        totalMonths = calculateMonths(
          PersonalAutoLoan.years,
          PersonalAutoLoan.months
        );
        console.log("totalMonths", totalMonths);
      }

      if (rate && totalMonths && PersonalAutoLoan.loanAmount) {
        pmtResult = calculatePMT(
          rate,
          totalMonths,
          -PersonalAutoLoan.loanAmount,
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
