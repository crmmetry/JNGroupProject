({
  GenrateScore: function (
    cmp,
    evt,
    helper,
    Empcategory,
    Empage,
    edu,
    res,
    ResidenceYr,
    CreditHis,
    Net_Worth,
    PoliticallyExposed,
    sanctionTrace,
    StatusOfEmployment,
    IndustryEmployment,
    LengthofCurrentEmployment,
    Professional_Category,
    CollateralType,
    LoanValue,
    AbilityService,
    Repayment_Method
  ) {
    //            Test: PoliticallyExposed,
    //            test: sanctionTrace,
    //            test: ,

    console.log("Save============================1");
    /*
        
            
            
        */
    var action = cmp.get("c.creditscorecalculation");
    action.setParams({
      category: Empcategory,
      Age1: Empage,
      Education: edu,
      ResidentialStatus: res,
      Yearsatcurrentresidence1: ResidenceYr,
      CreditHistory1: CreditHis,
      NetWorth: Net_Worth,
      EmploymentStatus: StatusOfEmployment,
      IndustryofEmployment: IndustryEmployment,
      ProfessionalCategory: Professional_Category,
      Collateral: CollateralType,
      LoantoValue1: LoanValue,
      Abilitytoservice1: AbilityService,
      RepaymentMethod: Repayment_Method,
      LengthofCurrentEmployment1: LengthofCurrentEmployment,
      ProductSelection: cmp.find("selectapplicant").get("v.value"),
      WorkingCapital: "Good",
      NatureEngagement: "Professional service provider",
      TypeIndustry: "Manufacturing",
      FinancialPerformance: "Good growth and or profit trends for 3-4 years",
      FinancialSupport: "Strongly Supported",
      LengthTrade1: "3",
      PoliticallyExposed: cmp.find("PoliticallyExposedPerson").get("v.value"),
      NegaticeTrace: cmp
        .find("sanctionScreeningResultedInNegativeTrace")
        .get("v.value")
    });
    console.log("Save--------------------------2-");
    action.setCallback(this, function (response) {
      var state = response.getState();
      var msg = response.getReturnValue();

      console.log("Save--------------------------3-" + msg);
      if (state == "SUCCESS") {
        cmp.set("v.score", msg);
        cmp.set("v.Calculated", false);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Success",
          message: "The Credit Score Calculated successfully.",
          duration: " 5000",
          key: "info_alt",
          type: "success",
          mode: "pester"
        });
        toastEvent.fire();
      } else {
        console.log("Save--------------------------4-" + msg);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Error",
          message: msg,
          duration: " 5000",
          key: "info_alt",
          type: "error",
          mode: "pester"
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action);
    console.log("Save============================End");
  },
  calculateAge: function (dob) {
    console.log("DOB=" + dob);
    var birth = new Date(dob);
    var curr = new Date();
    var diff = curr.getTime() - birth.getTime();
    var age = diff / (1000 * 60 * 60 * 24 * 365.25);
    console.log("Age=" + age);
    return age;
  },
  Percentage: function (data, per) {
    return (data * per) / 100;
  },
  Education: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Post Graduate";
        break;
      case "2":
        return "Undergraduate";
        break;
      case "3":
        return "Vocational";
        break;
      case "4":
        return "High School";
        break;
    }
  },
  ResidentialStatus: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Own";
        break;
      case "2":
        return "Rent";
        break;
      case "3":
        return "Family";
        break;
      case "4":
        return "Other";
        break;
    }
  },
  /* CreditHistory : function(data){
        switch(data){
            case '1':
                return 'No delinquency';
                break;
            case '10':
                return '1 - 10 days Delinquent';
                break;
                case '30':
                return '11 - 30 days Delinquent';
                break;
                case '2':
                return 'Over 90 Days Delinquent';
                break;
                case '2':
                return 'Over 90 Days Delinquent';
                break;
                case '2':
                return 'Over 90 Days Delinquent';
                break;
                case '2':
                return 'Over 90 Days Delinquent';
                break;
        }
    },*/
  NetWorth: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Low net worth";
        break;
      case "2":
        return "Reasonable net worth";
        break;
      case "3":
        return "Strong net worth";
        break;
      case "4":
        return "Net worth not commensurate with age and earning";
        break;
    }
  },
  EmploymentStatus: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Permanent";
        break;
      case "2":
        return "Contracted";
        break;
      case "3":
        return "Unemployed";
        break;
    }
  },
  PoliticallyExposedPerson: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "No";
        break;
    }
  },
  sanctionScreeningTrace: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "No";
        break;
    }
  },
  IndustryofEmployment: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Financial Services";
        break;
      case "2":
        return "Government";
        break;
      case "3":
        return "Manufacturing";
        break;
      case "4":
        return "Tourism";
        break;
      case "5":
        return "ICT";
        break;
      case "6":
        return "Other";
        break;
      case "7":
        return "None";
        break;
    }
  },

  ProfessionalCategory: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Professional";
        break;
      case "2":
        return "Officer";
        break;
      case "3":
        return "Clerical";
        break;
      case "4":
        return "Skilled Worker";
        break;
      case "5":
        return "Unskilled Worker";
        break;
      case "6":
        return "None";
        break;
    }
  },
  Collateral: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Cash";
        break;
      case "2":
        return "Real Estate - Residential";
        break;
      case "3":
        return "Real Estate - Commercial";
        break;
      case "4":
        return "Motor Vehicle";
        break;
      case "5":
        return "None";
        break;
    }
  },
  RepaymentMethod: function (data) {
    switch (data) {
      case "0":
        return "";
        break;
      case "1":
        return "Standing Order";
        break;
      case "2":
        return "Salary Deduction";
        break;
      case "3":
        return "Over the counter";
        break;
    }
  }
});