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
  },

  calcualateFirstYearPremium: function (premium) {
    if (premium != null) {
      return premium * 12;
    }
  },

  calculateJNGIPMT: function (component) {
    let jngiPremium = component.get("v.JNGIPremium");
    let personalAutoLoan = component.get("v.PersonalAutoLoan");
    const pmtData = {
      years: personalAutoLoan.years,
      months: personalAutoLoan.months,
      loanAmount: component.get("v.jngiMotorPremium"),
      market: personalAutoLoan.market
    };
    console.table("PMT DATA: ", JSON.stringify(pmtData));
    console.table("JNGI DATA: ", JSON.stringify(jngiPremium));
    if (jngiPremium.interested == "Yes" && jngiPremium.includeInLoan == "Yes") {
      console.log("SUCCESS");
      const result = basicPMTCalculator(
        ["years", "months", "loanAmount", "market"],
        pmtData
      );
      if (!result) {
        component.set("v.monthlyPIJNGIMotorPremium", 0);
      } else {
        component.set("v.monthlyPIJNGIMotorPremium", result);
      }
    } else if (jngiPremium.interested === "No") {
      component.set("v.monthlyPIJNGIMotorPremium", 0);
      component.set("v.jngiMotorPremium", 0);
    }
  }
});
