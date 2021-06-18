({
  doInit: function (componet, event, helper) {
    componet.get("v.recordId");
    var str = window.location.href.toString();
    if (str.indexOf("Lead") != -1) {
      componet.set("v.sobjectName", "Lead");
      console.log(
        "Lead found ===========================" + componet.get("v.sobjectName")
      );
    } else if (str.indexOf("Opportunity") != -1) {
      componet.set("v.sobjectName", "Opportunity");
      console.log(
        "Opportunity found ===========================" +
          componet.get("v.sobjectName")
      );
    }
  },

  SaveInstallmentAffordablityCalculator: function (component, event, helper) {
    var RId = component.get("v.recordId");
    var leadid = "";
    var oppid = "";
    var objType = component.get("v.sobjectName");
    switch (objType) {
      case "Lead":
        leadid = RId;
        break;
      case "Opportunity":
        oppid = RId;
        break;
    }

    var RId = component.get("v.recordId");
    console.log("RId=" + RId);
    var SelectedRadioGrpValue = component.get("v.radioGrpValue");
    switch (SelectedRadioGrpValue) {
      case "AffordabilityCalculator":
        var DesiredMonthlyPayments = 0;
        var MonthlyGrossIncome = 0;
        var ExistingMonthlyPayments = 0;
        var acMethodCal = component.find("methodCalucaltion").get("v.value");
        console.log("Method of Calculation=" + acMethodCal);
        switch (acMethodCal) {
          case "3":
            MonthlyGrossIncome = component.find("GrossIncome").get("v.value");
            ExistingMonthlyPayments = component
              .find("existingMthlyPayment")
              .get("v.value");
            break;
          case "2":
            DesiredMonthlyPayments = component
              .find("desiredMonthly")
              .get("v.value");
            break;
        }

        var newLoan_Calculator = {
          sObject: "Loan_Calculator__c",
          Lead_and_Referral__c: leadid,
          Opportunity__c: oppid,
          Interest_Rate__c: component.find("InterestRate").get("v.value"),
          Maximum_Loan_Amount__c: component
            .find("maximumLoanamt")
            .get("v.value"),
          Months__c: component.find("loanTermMth").get("v.value"),
          Years__c: component.find("loanTermYr").get("v.value"),
          Desired_Monthly_Payments__c: DesiredMonthlyPayments,
          Monthly_Gross_Income__c: MonthlyGrossIncome,
          Existing_Monthly_Payments__c: ExistingMonthlyPayments,
          Method_Of_Calculation__c:
            component.find("methodCalucaltion").get("v.value") == "2"
              ? "Desired Monthly Payment"
              : "Affordability"
        };
        console.log("newLoan Affordability Calculator==>" + newLoan_Calculator);
        var dataForSave = JSON.stringify(newLoan_Calculator);
        helper.saveCalculation(
          component,
          dataForSave,
          SelectedRadioGrpValue,
          event
        );
        break;
      case "InstallmentPayment":
        var newLoan_Calculator = {
          sObject: "Loan_Calculator__c",
          Lead_and_Referral__c: leadid,
          Opportunity__c: oppid,
          Interest_Rate__c: component
            .find("InterestRatePayment")
            .get("v.value"),
          Years__c: component.find("loanTermYrPayment").get("v.value"),
          Months__c: component.find("loanTermMthPayment").get("v.value"),
          Total_Monthly__c: component
            .find("maximumLoanamtPayment")
            .get("v.value"),
          Other_Financing__c: component
            .find("otherfinancingPayment")
            .get("v.value"),
          Maximum_Loan_Amount__c: component
            .find("loanAmtPayment")
            .get("v.value")
        };
        console.log(
          "newLoan Installment Payment Calculator==>" + newLoan_Calculator
        );
        var dataForSave = JSON.stringify(newLoan_Calculator);
        helper.saveCalculation(
          component,
          dataForSave,
          SelectedRadioGrpValue,
          event
        );
        break;
      case "RevolvingCreditLimitUnsecured":
        console.log(
          "Revolving Credit Limit Unsecured Save called========================="
        );
        var newLoan_Calculator = {
          sObject: "Loan_Calculator__c",
          Lead_and_Referral__c: leadid,
          Opportunity__c: oppid,
          Product_Type__c:
            component.find("productType").get("v.value") == "1"
              ? "Credit Card"
              : "Line of credit",
          Reqeusted_Limit__c: component
            .find("requestedlimitRCL")
            .get("v.value"),
          Interest_Rate__c: component.find("interestrateRCL").get("v.value"),
          Monthly_Gross_Income__c: component
            .find("grossmonthlyincomeRCL")
            .get("v.value"),
          Existing_Monthly_Credit_Payment__c: component
            .find("existingmonthlycreditpayment")
            .get("v.value"),
          Proposed_Starting_Limit__c: component
            .find("totalmonthlyPaymentUnsecure")
            .get("v.value")
        };
        console.log(
          "Revolving Credit Limit Unsecured Calculator==>" + newLoan_Calculator
        );
        var dataForSave = JSON.stringify(newLoan_Calculator);
        helper.saveCalculation(
          component,
          dataForSave,
          SelectedRadioGrpValue,
          event
        );
        break;
      case "RevolvingCreditLimitSecured":
        console.log(
          "Revolving Credit Limit Secured Save called========================="
        );
        var CollateralType = "";
        var ct = component.find("colleteral").get("v.value");
        switch (ct) {
          case "1":
            CollateralType = "Cash-JNB-High Yield Account";
            break;
          case "2":
            CollateralType = "Cash-JNB-Direct Gain Account";
            break;
          case "3":
            CollateralType = "Cash-JNFM-Repo Agreement";
            break;
          case "4":
            CollateralType = "Cash-JNFM-Mutual Fund";
            break;
          case "5":
            CollateralType = "Real-Estate";
            break;
        }
        console.log("colleteral=" + CollateralType);
        var newLoan_Calculator = {
          sObject: "Loan_Calculator__c",
          Lead_and_Referral__c: leadid,
          Opportunity__c: oppid,
          Product_Type__c:
            component.find("prodTypeSecured").get("v.value") == "1"
              ? "Credit Card"
              : "Line of credit",
          Collateral_Type__c: CollateralType,
          Reqeusted_Limit__c: component
            .find("requestedlimitRCLsecure")
            .get("v.value"),
          Interest_Rate__c: component.find("interestRateprocal").get("v.value"),
          Value_of_Security__c: component
            .find("valueofSecurity")
            .get("v.value"),
          Proposed_Starting_Limit__c: component
            .find("proposeStartingLimit")
            .get("v.value")
        };
        console.log(
          "Revolving Credit Limit Secured Calculator==>" + newLoan_Calculator
        );
        var dataForSave = JSON.stringify(newLoan_Calculator);
        helper.saveCalculation(
          component,
          dataForSave,
          SelectedRadioGrpValue,
          event
        );
        break;
      case "MultiProductCalculator":
        break;
    }
  },

  showHideCalc: function (component, event, helper) {
    var radioGrpValue = component.get("v.radioGrpValue");
    console.log("radioGrpValue", radioGrpValue);
    $A.util.addClass(component.find("AffordabilityCalculator"), "slds-hide");
    $A.util.addClass(component.find("InstallmentPayment"), "slds-hide");
    $A.util.addClass(
      component.find("RevolvingCreditLimitUnsecured"),
      "slds-hide"
    );
    $A.util.addClass(
      component.find("RevolvingCreditLimitSecured"),
      "slds-hide"
    );
    $A.util.addClass(component.find("MultiProductCalculator"), "slds-hide");
    $A.util.removeClass(component.find(radioGrpValue), "slds-hide");
    $A.util.addClass(component.find("affordablitySave"), "slds-hide");
  },
  showhideONmethod: function (cmp, evt, helper) {
    helper.clearFieldsFromMethodSelectionChange(cmp, evt);
    var acMethod = cmp.find("methodCalucaltion").get("v.value");
    console.log("methodOfCalucaltion == " + acMethod);
    switch (acMethod) {
      case "3":
        $A.util.addClass(cmp.find("desiredMonthly"), "slds-hide");
        $A.util.removeClass(cmp.find("GrossIncome"), "slds-hide");
        $A.util.removeClass(cmp.find("existingMthlyPayment"), "slds-hide");
        $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        cmp.set("v.showErrorIR", false); //Aff
        cmp.set("v.showErrorLT", false); //Aff
        cmp.set("v.showErrorDP", false); //Aff
        cmp.set("v.showErrorMOC", false);
        break;
      case "2":
        $A.util.removeClass(cmp.find("desiredMonthly"), "slds-hide");
        $A.util.addClass(cmp.find("GrossIncome"), "slds-hide");
        $A.util.addClass(cmp.find("existingMthlyPayment"), "slds-hide");
        $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        cmp.set("v.showErrorMGI", false); //Aff 2
        cmp.set("v.showErrorEMP", false); //Aff 2
        cmp.set("v.showErrorMOC", false);
        break;
      case "0":
        $A.util.addClass(cmp.find("desiredMonthly"), "slds-hide");
        $A.util.addClass(cmp.find("GrossIncome"), "slds-hide");
        $A.util.addClass(cmp.find("existingMthlyPayment"), "slds-hide");
        $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        cmp.set("v.showErrorIR", false); //Aff
        cmp.set("v.showErrorLT", false); //Aff
        cmp.set("v.showErrorDP", false); //Aff
        cmp.set("v.showErrorMGI", false); //Aff 2
        cmp.set("v.showErrorEMP", false); //Aff 2
        break;
    }
  },

  runCalculation: function (cmp, evt, helper) {
    var selCalc = cmp.find("calculatorType").get("v.value");
    var getCalc = "";
    var TDSR = 50;
    var rounder = 100000;
    console.log("Selected Calculator = " + selCalc);
    switch (selCalc) {
      case "AffordabilityCalculator":
        helper.SetDefaultVal(cmp.find("loanTermYr"), 0);
        helper.SetDefaultVal(cmp.find("loanTermMth"), 0);
        helper.SetDefaultVal(cmp.find("InterestRate"), 0);
        helper.SetDefaultVal(cmp.find("existingMthlyPayment"), 0);
        helper.SetDefaultVal(cmp.find("desiredMonthly"), 0);
        helper.SetDefaultVal(cmp.find("GrossIncome"), 0);

        var acPeriod =
          cmp.find("loanTermYr").get("v.value") * 12 +
          parseFloat(cmp.find("loanTermMth").get("v.value"));
        var acInterest = cmp.find("InterestRate").get("v.value") / 100;
        var acGrossIncome = cmp.find("GrossIncome").get("v.value");
        var acexistingMthlyPayment = cmp
          .find("existingMthlyPayment")
          .get("v.value");
        var acMethod = cmp.find("methodCalucaltion").get("v.value");
        var acDesiredPayment = cmp.find("desiredMonthly").get("v.value");
        console.log("Months Calculated: " + acPeriod);
        switch (acMethod) {
          case "0":
            cmp.set("v.showErrorMOC", true);
            break;
          case "2":
            /*=PV((rate/12),(time in months,-disried monthly payment)*/
            console.log("acInterest: " + acInterest);
            console.log("acPeriod: " + acPeriod);
            console.log("acDesiredPayment: " + acDesiredPayment);

            var isValid = helper.validateAffordabilityCalculator(
              cmp,
              evt,
              acMethod
            );
            if (isValid) {
              console.log("Validation Fail : =====>");
              break;
            } else {
              console.log("Validation fass =======================>");
              getCalc = helper.RoundTo(
                helper.PV(acInterest / 12, acPeriod, acDesiredPayment),
                rounder
              );
              console.log("getCalc: " + getCalc);
              if (isNaN(getCalc)) cmp.find("maximumLoanamt").set("v.value", "");
              else cmp.find("maximumLoanamt").set("v.value", getCalc);
              break;
            }
          case "3":
            var isValid = helper.validateAffordabilityCalculator(
              cmp,
              evt,
              acMethod
            );
            if (isValid) {
              console.log("Validation Fail: =====>");
              break;
            } else {
              console.log("Validation Pass: =====>");

              var maxpayment = acGrossIncome * 0.5 - acexistingMthlyPayment;
              getCalc = helper.RoundTo(
                helper.SpecialPv(maxpayment, acInterest / 12, acPeriod),
                rounder
              );
              getCalc = parseFloat(getCalc);
              if (isNaN(getCalc)) {
                cmp.find("maximumLoanamt").set("v.value", "");
              } else {
                cmp.find("maximumLoanamt").set("v.value", getCalc);
              }

              break;
            }
        }

        var acMethodCal = cmp.find("methodCalucaltion").get("v.value");
        if (
          cmp.find("desiredMonthly").get("v.value") > 0 &&
          acMethodCal == "2" &&
          cmp.find("maximumLoanamt").get("v.value") > 0 &&
          cmp.get("v.isHomePage") == "Lead"
        ) {
          $A.util.removeClass(cmp.find("affordablitySave"), "slds-hide");
        } else if (
          cmp.find("existingMthlyPayment").get("v.value") > 0 &&
          cmp.find("GrossIncome").get("v.value") > 0 &&
          acMethodCal == "3" &&
          cmp.find("maximumLoanamt").get("v.value") > 0 &&
          cmp.get("v.isHomePage") == "Lead"
        ) {
          $A.util.removeClass(cmp.find("affordablitySave"), "slds-hide");
        } else {
          $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        }

        break;
      case "InstallmentPayment":
        console.log("InstallmentPayment fired");
        helper.SetDefaultVal(cmp.find("InterestRatePayment"), 0);
        helper.SetDefaultVal(cmp.find("loanAmtPayment"), 0);

        helper.SetDefaultVal(cmp.find("loanTermYrPayment"), 0);
        helper.SetDefaultVal(cmp.find("loanTermMthPayment"), 0);
        helper.SetDefaultVal(cmp.find("otherfinancingPayment"), 0);

        var ipInterest = cmp.find("InterestRatePayment").get("v.value") / 100;
        var ipTerm =
          cmp.find("loanTermYrPayment").get("v.value") * 12 +
          parseFloat(cmp.find("loanTermMthPayment").get("v.value"));
        var iploanAmtPayment = cmp.find("loanAmtPayment").get("v.value");
        var ipotherfinancingPayment = cmp
          .find("otherfinancingPayment")
          .get("v.value");
        console.log(ipTerm);
        var totalLoanamt =
          parseFloat(iploanAmtPayment) + parseFloat(ipotherfinancingPayment);
        console.log("totalLoanamt" + totalLoanamt);
        //JN1-2171 getCalc =helper.round_to_precision(helper.InstallmentPv(totalLoanamt,ipInterest/12,ipTerm),2);
        //console.log("getCalc"+getCalc);
        var isValid = helper.validateInstallmentPaymentCalculator(cmp, evt);
        console.log("Validation isValid: =====>" + isValid);
        if (isValid) {
          console.log("Validation Fail: =====>");
          break;
        } else {
          console.log("totalLoanamt: =====>" + totalLoanamt);
          console.log("Validation Fail: =====>" + ipInterest);
          console.log("Validation Fail: =====>" + ipTerm);

          getCalc = helper.InstallmentPv(totalLoanamt, ipInterest / 12, ipTerm); //Updated by NS JN1-2171
          console.log("getCalc111 =" + getCalc);
          if (isNaN(getCalc)) {
            cmp.find("maximumLoanamtPayment").set("v.value", "");
          } else {
            cmp.find("maximumLoanamtPayment").set("v.value", getCalc);
          }

          if (
            ipInterest > 0 &&
            ipTerm > 0 &&
            iploanAmtPayment > 0 &&
            cmp.find("maximumLoanamtPayment").get("v.value") > 0 &&
            cmp.get("v.isHomePage") == "Lead"
          ) {
            $A.util.removeClass(cmp.find("affordablitySave"), "slds-hide");
          } else {
            $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
          }
          break;
        }

      case "RevolvingCreditLimitUnsecured":
        console.log("fired");
        helper.SetDefaultVal(cmp.find("requestedlimitRCL"), 0);
        helper.SetDefaultVal(cmp.find("interestrateRCL"), 0);
        helper.SetDefaultVal(cmp.find("grossmonthlyincomeRCL"), 0);
        helper.SetDefaultVal(cmp.find("existingmonthlycreditpayment"), 0);
        var validationArray = [cmp.find("productType")];
        var notValid = validationArray.reduce(function (validSoFar, inputCmp) {
          inputCmp.showHelpMessageIfInvalid();
          return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        if (!notValid) {
          return;
        }
        helper.SetDefaultVal(cmp.find("totalmonthlyPaymentUnsecure"), 0);
        var productType = cmp.find("productType").get("v.value");
        var requestedlimitRCL = cmp.find("requestedlimitRCL").get("v.value");
        var interestrateRCL = cmp.find("interestrateRCL").get("v.value");
        var grossmonthlyincomeRCL = cmp
          .find("grossmonthlyincomeRCL")
          .get("v.value");
        var existingmonthlycreditpayment = cmp
          .find("existingmonthlycreditpayment")
          .get("v.value");
        var grossmonthly = cmp.find("grossmonthlyincomeRCL").get("v.value");
        var totalmonthlyPaymentUnsecure = cmp
          .find("totalmonthlyPaymentUnsecure")
          .get("v.value");
        console.log("grossmonthly " + grossmonthly);
        console.log(productType);
        switch (productType) {
          case "1":
            console.log("credit card");
            var CardInterest = interestrateRCL / 100 / 12;
            console.log("Card Interest " + CardInterest);
            var MaximumDebt = grossmonthly * (TDSR / 100);
            console.log("MaximumDebt " + MaximumDebt);
            var MinimumPayment = MaximumDebt - existingmonthlycreditpayment;
            console.log("MinimumPayment " + MinimumPayment);
            //JN1-2172
            if (grossmonthly < 250001) {
              var maxaLimitCalc = 20.0 / 100;
            } else {
              var maxaLimitCalc = 30.0 / 100;
            }
            console.log("maxaLimitCalc " + maxaLimitCalc);
            var monthlyPrincipal = 2.5 / 100;
            var minimumOutstanding = CardInterest + monthlyPrincipal;
            console.log("minimumOutstanding " + minimumOutstanding);
            var maxmumlimit_annual = grossmonthly * 12 * maxaLimitCalc;
            console.log("maxmumlimit_annual " + maxmumlimit_annual);
            var maximumlimit_payment = helper.RoundTo(
              MinimumPayment / minimumOutstanding,
              rounder
            );
            console.log("maximumlimit_payment " + maximumlimit_payment);
            var proposedLimit_beforecredit = Math.min(
              maxmumlimit_annual,
              maximumlimit_payment
            );
            console.log(
              "proposedLimit_beforecredit " + proposedLimit_beforecredit
            );
            var startingCreditLimit = 66.67 / 100;
            //JN1-2172 var proposedStartingLimit = Math.min(proposedLimit_beforecredit*startingCreditLimit,requestedlimitRCL);
            var proposedStartingLimit = helper.RoundTo(
              Math.min(
                proposedLimit_beforecredit * startingCreditLimit,
                requestedlimitRCL
              ),
              rounder
            ); //JN1-2172 applied round
            if (requestedlimitRCL > 0)
              var proposedStartingLimit = helper.RoundTo(
                Math.min(
                  proposedLimit_beforecredit * startingCreditLimit,
                  requestedlimitRCL
                ),
                rounder
              );
            //JN1-2172 applied round
            else
              var proposedStartingLimit = helper.RoundTo(
                proposedLimit_beforecredit * startingCreditLimit,
                rounder
              ); //JN1-2172 applied round

            console.log("proposedStartingLimit " + proposedStartingLimit);
            cmp
              .find("totalmonthlyPaymentUnsecure")
              .set("v.value", proposedStartingLimit);
            console.log(
              "xtotalmonthlyPaymentUnsecure: x:" + proposedStartingLimit
            );
            break;
          case "2":
            console.log("credit line");
            var CardInterest = interestrateRCL / 100 / 12;
            console.log("CardInterest" + CardInterest);
            var MaximumDebt = grossmonthly * TDSR;
            console.log("MaximumDebt" + MaximumDebt);
            var MinimumPayment = MaximumDebt - existingmonthlycreditpayment;
            console.log("MinimumPayment" + MinimumPayment);
            var monthlyPrincipal = 3.0 / 100;
            console.log("monthlyPrincipal" + monthlyPrincipal);
            var minimumOutstanding = CardInterest + monthlyPrincipal;
            console.log("minimumOutstanding" + minimumOutstanding);
            var maxaLimitCalc = 30.0 / 100;
            console.log("maxaLimitCalc" + maxaLimitCalc);
            var maxmumlimit = grossmonthly * 12 * maxaLimitCalc;
            console.log("maxmumlimit" + maxmumlimit);
            var maxmumlimit_annual = grossmonthly * 12 * maxaLimitCalc;
            console.log("maxmumlimit_annual" + maxmumlimit_annual);
            var maximumlimit_payment = helper.RoundTo(
              MinimumPayment / minimumOutstanding,
              rounder
            );
            console.log("maximumlimit_payment" + maximumlimit_payment);
            var proposedLimit_beforecredit = Math.min(
              maxmumlimit_annual,
              maximumlimit_payment
            );
            console.log(
              "proposedLimit_beforecredit" + proposedLimit_beforecredit
            );
            var startingCreditLimit = 66.67 / 100;
            console.log("startingCreditLimit" + startingCreditLimit);
            var proposedStartingLimit = Math.min(
              proposedLimit_beforecredit * startingCreditLimit,
              requestedlimitRCL
            );
            if (requestedlimitRCL > 0)
              proposedStartingLimit = Math.min(
                proposedLimit_beforecredit * startingCreditLimit,
                requestedlimitRCL
              );
            else
              proposedStartingLimit =
                proposedLimit_beforecredit * startingCreditLimit;
            console.log("proposedStartingLimit" + proposedStartingLimit);
            cmp
              .find("totalmonthlyPaymentUnsecure")
              .set("v.value", helper.RoundTo(proposedStartingLimit, 10000));
            break;
        }
        if (
          cmp.find("totalmonthlyPaymentUnsecure").get("v.value") > 0 &&
          cmp.get("v.isHomePage") == "Lead"
        ) {
          $A.util.removeClass(cmp.find("affordablitySave"), "slds-hide");
        } else {
          $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        }

        break;

      case "RevolvingCreditLimitSecured":
        helper.SetDefaultVal(cmp.find("requestedlimitRCLsecure"), 0);
        helper.SetDefaultVal(cmp.find("interestRateprocal"), 0);
        helper.SetDefaultVal(cmp.find("valueofSecurity"), 0);

        var productType = cmp.find("prodTypeSecured").get("v.value");
        var collateral = "";
        var ct = cmp.find("colleteral").get("v.value");

        var validationArray = [
          cmp.find("prodTypeSecured"),
          cmp.find("colleteral")
        ];
        var notValid = validationArray.reduce(function (validSoFar, inputCmp) {
          inputCmp.showHelpMessageIfInvalid();
          return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
        if (!notValid) {
          return;
        }
        helper.SetDefaultVal(cmp.find("proposeStartingLimit"), 0);
        switch (ct) {
          case "1":
            collateral = "95";
            break;
          case "2":
            collateral = "95";
            break;
          case "3":
            collateral = "90";
            break;
          case "4":
            collateral = "50";
            break;
          case "5":
            collateral = "70";
            break;
        }
        console.log("collateral=" + collateral);
        var requestedlimitRCL = cmp
          .find("requestedlimitRCLsecure")
          .get("v.value");
        var interestrateRCL = cmp.find("interestRateprocal").get("v.value");
        var valueofSecurity = cmp.find("valueofSecurity").get("v.value");
        var existingmonthlycreditpayment = cmp
          .find("existingmonthlycreditpayment")
          .get("v.value");

        switch (productType) {
          case "1":
            console.log("credit line");
            var maximumLineofCredit = 0;

            var CardInterest = interestrateRCL / 100 / 12;
            console.log("Card Interest " + CardInterest);
            // var MinimumPayment = MaximumDebt - existingmonthlycreditpayment;
            //console.log("MinimumPayment "+MinimumPayment);
            var MaximumlimitCalc_accountbal = collateral / 100;
            console.log(
              "MaximumlimitCalc_accountbal " + MaximumlimitCalc_accountbal
            );
            var monthlyPrincpalPayment = 2.5 / 100;
            console.log("monthlyPrincpalPayment " + monthlyPrincpalPayment);
            var MinpaymentOfOutstandingBalance =
              CardInterest + monthlyPrincpalPayment;
            console.log(
              "MinpaymentOfOutstandingBalance " + MinpaymentOfOutstandingBalance
            );
            var MaximumLoanPosssible =
              MaximumlimitCalc_accountbal * valueofSecurity;
            console.log("MaximumLoanPosssible " + MaximumLoanPosssible);
            var maximumlimit_payment = helper.RoundTo(
              MaximumLoanPosssible / MinpaymentOfOutstandingBalance,
              rounder
            );
            console.log("maximumlimit_payment " + maximumlimit_payment);
            var proposedLimit_beforecredit = Math.min(
              MaximumLoanPosssible,
              maximumlimit_payment
            );
            console.log(
              "proposedLimit_beforecredit " + proposedLimit_beforecredit
            );
            var startingCreditLimit = 66.67 / 100;
            if (collateral == "70") {
              var proposedStartingLimit = Math.min(
                proposedLimit_beforecredit,
                maximumLineofCredit,
                requestedlimitRCL
              );
              if (requestedlimitRCL > 0)
                proposedStartingLimit = helper.RoundTo(
                  Math.min(
                    proposedLimit_beforecredit,
                    maximumLineofCredit,
                    requestedlimitRCL
                  ),
                  rounder
                );
              else
                proposedStartingLimit = helper.RoundTo(
                  proposedLimit_beforecredit,
                  rounder
                );
            } else {
              var proposedStartingLimit = Math.min(
                proposedLimit_beforecredit,
                requestedlimitRCL
              );
              if (requestedlimitRCL > 0)
                proposedStartingLimit = helper.RoundTo(
                  Math.min(proposedLimit_beforecredit, requestedlimitRCL),
                  rounder
                );
              else
                proposedStartingLimit = helper.RoundTo(
                  proposedLimit_beforecredit,
                  rounder
                );
            }
            console.log("proposeStartingLimit " + proposedStartingLimit);
            cmp
              .find("proposeStartingLimit")
              .set("v.value", proposedStartingLimit);
            console.log("proposeStartingLimit: x:" + proposedStartingLimit);
            break;
          case "2":
            console.log("Line of credit");
            var maximumLineofCredit = 5000000;

            var CardInterest = interestrateRCL / 100 / 12;
            console.log("Card Interest " + CardInterest);
            var MinimumPayment = MaximumDebt - existingmonthlycreditpayment;
            console.log("MinimumPayment " + MinimumPayment);
            var MaximumlimitCalc_accountbal = collateral / 100;
            console.log(
              "MaximumlimitCalc_accountbal " + MaximumlimitCalc_accountbal
            );
            var monthlyPrincpalPayment = 3.0 / 100;
            console.log("monthlyPrincpalPayment " + monthlyPrincpalPayment);
            var MinpaymentOfOutstandingBalance =
              parseFloat(CardInterest) + parseFloat(monthlyPrincpalPayment);
            console.log(
              "MinpaymentOfOutstandingBalance " + MinpaymentOfOutstandingBalance
            );
            //var MaximumLoanPosssible = (parseFloat(MaximumlimitCalc_accountbal)+parseFloat(valueofSecurity));
            var MaximumLoanPosssible =
              parseFloat(MaximumlimitCalc_accountbal) *
              parseFloat(valueofSecurity); //Updated by NS
            console.log("MaximumLoanPosssible " + MaximumLoanPosssible);
            //var maximumlimit_payment=helper.RoundTo((parseFloat(MinimuMaximumLoanPosssiblemPayment)/parseFloat(MinpaymentOfOutstandingBalance)),10000);
            var maximumlimit_payment = helper.RoundTo(
              parseFloat(MaximumLoanPosssible) /
                parseFloat(MinpaymentOfOutstandingBalance),
              rounder
            ); //Updated by NS
            console.log("maximumlimit_payment " + maximumlimit_payment);
            var proposedLimit_beforecredit = Math.min(
              MaximumLoanPosssible,
              maximumlimit_payment
            );
            console.log(
              "proposedLimit_beforecredit " + proposedLimit_beforecredit
            );
            var startingCreditLimit = 66.67 / 100;
            if (collateral == "70") {
              var proposedStartingLimit = Math.min(
                proposedLimit_beforecredit,
                maximumLineofCredit,
                requestedlimitRCL
              );
              if (requestedlimitRCL > 0)
                proposedStartingLimit = helper.RoundTo(
                  Math.min(
                    proposedLimit_beforecredit,
                    maximumLineofCredit,
                    requestedlimitRCL
                  ),
                  rounder
                );
              else
                proposedStartingLimit = helper.RoundTo(
                  proposedLimit_beforecredit,
                  rounder
                );
            } else {
              var proposedStartingLimit = Math.min(
                proposedLimit_beforecredit,
                requestedlimitRCL
              );
              if (requestedlimitRCL > 0)
                proposedStartingLimit = helper.RoundTo(
                  Math.min(proposedLimit_beforecredit, requestedlimitRCL),
                  rounder
                );
              else
                proposedStartingLimit = helper.RoundTo(
                  proposedLimit_beforecredit,
                  rounder
                );
            }
            console.log("proposedStartingLimit " + proposedStartingLimit);
            cmp
              .find("proposeStartingLimit")
              .set("v.value", proposedStartingLimit);
            console.log("proposeStartingLimit: x:" + proposedStartingLimit);
            break;
        }
        if (
          cmp.find("proposeStartingLimit").get("v.value") > 0 &&
          cmp.get("v.isHomePage") == "Lead"
        ) {
          $A.util.removeClass(cmp.find("affordablitySave"), "slds-hide");
        } else {
          $A.util.addClass(cmp.find("affordablitySave"), "slds-hide");
        }

        break;
      case "MultiProductCalculator":
        break;
    }
  }
});
