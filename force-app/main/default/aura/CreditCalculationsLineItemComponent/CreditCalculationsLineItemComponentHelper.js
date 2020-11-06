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
  },

  calculateSavings: function (component) {
    var PIMonthlyPayment = component.get("v.monthly_PI_LoanAmount");
    var personalAutoLoan = component.get("v.RequestedDetails");
    var loanSavings = component.get("v.LoanSavings");
    console.log("Calcualte Savings Heloper");
    if (PIMonthlyPayment > 0) {
      console.log("Calculate Savings begin");
      var tenure =
        Number(personalAutoLoan.years) * 12 + Number(personalAutoLoan.months);
      console.log(tenure);
      console.log(loanSavings.percentage);
      if (loanSavings.percentage > 0 && loanSavings.percentage) {
        console.log("Percentage>0");
        var monthlyCompulsorySavings =
          PIMonthlyPayment * loanSavings.percentage;
        var totalCompulsorySavings = monthlyCompulsorySavings * tenure;
        console.log(monthlyCompulsorySavings);
        console.log(totalCompulsorySavings);
        component.set("v.monthlyCompulsorySavings", monthlyCompulsorySavings);
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
      } else if (loanSavings.amount > 0 && loanSavings.amount) {
        component.set("v.monthlyCompulsorySavings", loanSavings.amount);
        var totalCompulsorySavings = loanSavings.amount * tenure;
        component.set(
          "v.totalCompulsorySavingsBalance",
          totalCompulsorySavings
        );
      } else {
        component.set("v.monthlyCompulsorySavings", 0);
        component.set("v.totalCompulsorySavingsBalance", 0);
      }
    }
  }
});
