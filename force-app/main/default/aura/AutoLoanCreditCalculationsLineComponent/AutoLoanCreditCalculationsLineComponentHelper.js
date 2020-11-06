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

  calculateSavings: function (component) {
    var PIMonthlyPayment = component.get("v.monthly_PI_LoanAmount");
    var personalAutoLoan = component.get("v.PersonalAutoLoan");
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
