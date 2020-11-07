({
  AddRow: function (RowIndex, EmpRow, cmp) {
    EmpRow.push({
      Id: RowIndex,
      FirstName: "",
      LastName: "",
      DateOfBirth: "",
      GMIncome: "",
      EMCPayment: "",
      IsJNEmployee: false
    });
    cmp.set("v.RowNum", EmpRow);
  },
  RemoveRow: function (StartIndex, length, EmpRow, cmp) {
    EmpRow.splice(StartIndex, length);
    cmp.set("v.RowNum", EmpRow);
  },
  calculateJNGIMonthlyPremiumhelper: function (cmp, event) {
    console.log("Kluh");
    var RequestData = cmp.get("v.RDetailAuto");
    var i = RequestData[0].Interestrate;
    var im = RequestData[0].Interestrate / 1200;
    var n = cmp.get("v.LoanTermMarket");
    var premium1styear = 0;
    console.log("Kluh2");
    if (
      cmp.find("Interestedinprogramme").get("v.value") == "0" &&
      cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "0"
    ) {
      console.log("Kluh1");
      premium1styear = cmp.find("MonthlyPremium").get("v.value") * 12;
      cmp.set("v.JNGIAutoloan", premium1styear);
      var zero = 0;
      cmp
        .find("JNGIMotorInsurancePremium1st1")
        .set("v.value", parseFloat(zero).toFixed(2));

      /*
         * IF(AND(M-y,I=P,T-1),AmortizationSC2!$C$12,
IF(AND(M-y,I=P,T-2),MAX(AmortizationSC2!$C$12:$C$13),
IF(AND(M-y,I=P,T-3),MAX(AmortizationSC2!$C$12:$C$14),
IF(AND(M-y,I-P&I),0,PMT($F$89/12,SUM($L$89*12,$O$89),-$M$162)))))
        */

      if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        (cmp.find("IndicateTerm").get("v.value") == 1 ||
          cmp.find("IndicateTerm").get("v.value") == 2 ||
          cmp.find("IndicateTerm").get("v.value") == 3)
      ) {
        var jngid = im * premium1styear;
        cmp.set("v.MonthlyJNGIMotorPremium1stYear1New", jngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2
      ) {
        var jngid = 0;
        cmp.set("v.MonthlyJNGIMotorPremium1stYear1New", jngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      } else {
        var jngid = this.PMTcalculator(i, n, premium1styear);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear1New", jngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      }
      /*IF(AND(M-y,I=P&I,O-ori,T-1),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$162,AmortizationSC2!$C$12)),
IF(AND(M-y,I=P&I,O-ori,T-2),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$162,AmortizationSC2!$C$12:$C$13)),
IF(AND(M-y,I=P&I,O-ori,T-3),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$162,AmortizationSC2!$C$12:$C$14)),
IF(AND(M-yI=P,O-ori),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-$M$162),
IF(AND(M-y,I=P&I,O-Eori,T-1),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$162,AmortizationSC2!$C$12)),
IF(AND(M-y,I=P&I,O-Eori,T-2),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$162,AmortizationSC2!$C$12:$C$13)),
IF(AND(M-y,I=P&I,O-Eori,T-3),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$162,AmortizationSC2!$C$12:$C$14)),
IF(AND(M-y,I=P,O-Eori),PMT($F$89/12,SUM($L$89*12,$O$89),-$M$162),0))))))))*/

      if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1 &&
        cmp.find("IndicateTerm").get("v.value") == 1
      ) {
        var n1 = n - 1;
        var AmortizationSC2C12 = im * premium1styear;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1 &&
        cmp.find("IndicateTerm").get("v.value") == 2
      ) {
        var n1 = n - 2;
        var AmortizationSC2C12 = im * premium1styear * 2;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1 &&
        cmp.find("IndicateTerm").get("v.value") == 3
      ) {
        var n1 = n - 3;
        var AmortizationSC2C12 = im * premium1styear * 3;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2 &&
        cmp.find("IndicateTerm").get("v.value") == 1
      ) {
        var n1 = n;
        var AmortizationSC2C12 = im * premium1styear;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2 &&
        cmp.find("IndicateTerm").get("v.value") == 2
      ) {
        var n1 = n;
        var AmortizationSC2C12 = im * premium1styear * 2;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2 &&
        cmp.find("IndicateTerm").get("v.value") == 3
      ) {
        var n1 = n;
        var AmortizationSC2C12 = im * premium1styear * 3;
        var premium1styear1 =
          parseFloat(premium1styear) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1
      ) {
        var n1 = n - cmp.find("IndicateTerm").get("v.value");
        var premium1styear1 = premium1styear;
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2
      ) {
        var ajngid = this.PMTcalculator(i, n, premium1styear);
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      } else {
        var ajngid = 0;
        cmp.set("v.MonthlyJNGIMotorPremium1stYear2New", ajngid);
        cmp
          .find("MonthlyJNGIMotorPremium1stYear2")
          .set("v.value", parseFloat(ajngid).toFixed(2));
      }
    } else if (cmp.find("Interestedinprogramme").get("v.value") == "1") {
      console.log("Kluh3");
      var notjngi = 0;
      cmp.set("v.JNGIAutoloan", parseFloat(notjngi).toFixed(2));
      cmp.set(
        "v.MonthlyJNGIMotorPremium1stYear1New",
        parseFloat(notjngi).toFixed(2)
      );
      cmp.set(
        "v.MonthlyJNGIMotorPremium1stYear2New",
        parseFloat(notjngi).toFixed(2)
      );
      cmp
        .find("MonthlyJNGIMotorPremium1stYear1")
        .set("v.value", parseFloat(notjngi).toFixed(2));
      cmp
        .find("MonthlyJNGIMotorPremium1stYear2")
        .set("v.value", parseFloat(notjngi).toFixed(2));
      cmp
        .find("JNGIMotorInsurancePremium1st1")
        .set("v.value", parseFloat(notjngi).toFixed(2));
    }
    if (
      cmp.find("Interestedinprogramme").get("v.value") == "0" &&
      cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "1"
    ) {
      console.log("Kluh4");
      var notinclude = 0;
      var premium1styearnew = cmp.find("MonthlyPremium").get("v.value") * 12;
      cmp.set("v.JNGIAutoloan", parseFloat(notinclude).toFixed(2));
      cmp.set(
        "v.MonthlyJNGIMotorPremium1stYear1New",
        parseFloat(notinclude).toFixed(2)
      );
      cmp.set(
        "v.MonthlyJNGIMotorPremium1stYear2New",
        parseFloat(notinclude).toFixed(2)
      );
      cmp
        .find("MonthlyJNGIMotorPremium1stYear1")
        .set("v.value", parseFloat(notinclude).toFixed(2));
      cmp
        .find("MonthlyJNGIMotorPremium1stYear2")
        .set("v.value", parseFloat(notinclude).toFixed(2));
      console.log("12aug==" + premium1styearnew);
      cmp
        .find("JNGIMotorInsurancePremium1st1")
        .set("v.value", parseFloat(premium1styearnew).toFixed(2));
    }

    var jngi2nd = cmp.find("MonthlyPremium").get("v.value");
    cmp.set("v.MonthlyJNGIMotorPremiumhalfPayment1New", jngi2nd);
    cmp.set("v.MonthlyJNGIMotorPremiumhalfPayment2New", jngi2nd);
    cmp.find("MonthlyJNGIMotorPremiumhalfPayment1").set("v.value", jngi2nd);
    cmp.find("MonthlyJNGIMotorPremiumhalfPayment2").set("v.value", jngi2nd);
  },
  calculateJNLifeMonthlyPremiumhelper: function (cmp, event) {
    console.log("pavit");
    if (cmp.find("InterestedinCreditorLife").get("v.value") == "0") {
      console.log("jnltpAVIT	1 === ");
      if (cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "0") {
        var valzero = 0;
        cmp
          .find("JNLifeCreditorInsurancePremium1")
          .set("v.value", parseFloat(valzero).toFixed(2));
        $A.util.addClass(
          cmp.find("JNLifeCreditorInsurancePremium"),
          "slds-hide"
        );
        $A.util.addClass(
          cmp.find("JNLifeCreditorInsurancePremium1"),
          "slds-hide"
        );
      } else if (
        cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "1"
      ) {
        $A.util.removeClass(
          cmp.find("JNLifeCreditorInsurancePremium"),
          "slds-hide"
        );
        $A.util.removeClass(
          cmp.find("JNLifeCreditorInsurancePremium1"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("JNLifecal"), "slds-hide");
      }
      $A.util.removeClass(cmp.find("JNLifecal"), "slds-hide");
      $A.util.removeClass(cmp.find("CoverageType"), "slds-hide");
      $A.util.removeClass(
        cmp.find("IncludeinLoanAmountinsurence"),
        "slds-hide"
      );
    } else if (cmp.find("InterestedinCreditorLife").get("v.value") == "1") {
      console.log("jnltpAVIT	2 === ");

      $A.util.addClass(cmp.find("JNLifecal"), "slds-hide");
      $A.util.addClass(cmp.find("CoverageType"), "slds-hide");
      $A.util.addClass(cmp.find("IncludeinLoanAmountinsurence"), "slds-hide");
    }
    /*IF(AND($J$72=Admin_Picklists!$H$10,$AH$72=Admin_Picklists!$U$16),$AV$72,0)

$AV$72=(SUM($U$89:$Y$92)/1000)*$AV$71

$AV$71==IF(OR($T$72=$AX$56,$T$72=$AX$57,$T$72=$AX$58),VLOOKUP(VLOOKUP($T$72,$AX$56:$AY$58,2,0),Admin_Tables!$E$7:$Y$16,((CEILING(SUM($L$89*12,$O$89)/12,0.5)/0.5)+1),FALSE),
IF(OR($T$72=$AX$59,$T$72=$AX$60,$T$72=$AX$61),1.85*VLOOKUP(VLOOKUP($T$72,$AX$59:$AY$61,2,0),Admin_Tables!$E$7:$Y$16,((CEILING(SUM($L$89*12,$O$89)/12,0.5)/0.5)+1),FALSE),0))
*/
    //----1-----------------
    var jnlp = 0;
    var ageavg;
    var loanamountsum = 0;
    var RequestData = cmp.get("v.RDetailAuto");
    var marketi = RequestData[0].Interestrate;
    var im = RequestData[0].Interestrate / 1200;
    var n = cmp.get("v.LoanTermMarket");
    for (var k in RequestData) {
      loanamountsum += parseFloat(RequestData[k].LoanAmount);
    }
    console.log("loanamountsum=====" + loanamountsum);
    if (cmp.find("NumberofApplicant").get("v.value") == 0) {
      var age1 = cmp.get("v.applicant1ageValue");
      ageavg = age1;
    }
    if (cmp.find("NumberofApplicant").get("v.value") == 1) {
      var age1 = cmp.get("v.applicant1ageValue");
      var age2 = cmp.get("v.applicant2ageValue");

      ageavg = (parseFloat(age1) + parseFloat(age2)) / 2;
    }
    if (cmp.find("NumberofApplicant").get("v.value") == 2) {
      var age1 = cmp.get("v.applicant1ageValue");
      var age2 = cmp.get("v.applicant2ageValue");
      var age3 = cmp.get("v.applicant3ageValue");
      var ageavg = (parseFloat(age1) + parseFloat(age2) + parseFloat(age3)) / 3;
      console.log("ageavg=====" + ageavg);
    }
    var agegroup = "";
    if (ageavg >= 18 && ageavg < 25) {
      agegroup = "18-24";
    }
    if (ageavg >= 25 && ageavg < 30) {
      agegroup = "25-29";
    }
    if (ageavg >= 30 && ageavg < 35) {
      agegroup = "30-34";
    }
    if (ageavg >= 35 && ageavg < 40) {
      agegroup = "35-39";
    }
    if (ageavg >= 40 && ageavg < 45) {
      agegroup = "40-44";
    }
    if (ageavg >= 45 && ageavg < 50) {
      agegroup = "45-49";
    }
    if (ageavg >= 50 && ageavg < 55) {
      agegroup = "50-54";
    }
    if (ageavg >= 55 && ageavg < 60) {
      agegroup = "55-59";
    }
    if (ageavg >= 60 && ageavg <= 64) {
      agegroup = "60-64";
    }
    console.log("agegroup=====" + agegroup);

    if (cmp.find("InterestedinCreditorLife").get("v.value") == "0") {
      //&& cmp.find("IncludeinLoanAmountinsurence").get("v.value")=='0'

      console.log("pavit1====");
      var rate = 0;
      var ir = cmp.get("v.LoanTermMarket") / 12;
      console.log("ir=====" + ir);
      var irceil;
      var i;
      for (i = 0; i <= ir; i++) {
        var j = i + 0.5;
        if (ir > i && ir < j) irceil = j;
        else if (ir == i) irceil = i;
        j = 0;
      }
      console.log("irceil=====" + irceil);
      console.log("agegroup === " + agegroup);

      var action = cmp.get("c.JNlifeCalculation");
      action.setParams({
        agegroup: agegroup,
        term: irceil
      });
      var self = this;
      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          rate = response.getReturnValue();
          console.log("loanamountsum === " + loanamountsum);
          jnlp = (loanamountsum / 1000) * rate;
          if (
            cmp.find("InterestedinCreditorLife").get("v.value") == "0" &&
            cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "0"
          ) {
            console.log("jnltpAVIT	1 === ");
            if (
              cmp.find("CoverageType").get("v.value") == "1" ||
              cmp.find("CoverageType").get("v.value") == "2" ||
              cmp.find("CoverageType").get("v.value") == "3"
            ) {
              console.log("1 === ");
              console.log("jnlp === " + jnlp);
              cmp.set("v.JNLifeCreditorLifePremium1New", jnlp);
              cmp
                .find("JNLifeCreditorLifePremium1")
                .set("v.value", parseFloat(jnlp).toFixed(2));
            }
            if (
              cmp.find("CoverageType").get("v.value") == "4" ||
              cmp.find("CoverageType").get("v.value") == "5" ||
              cmp.find("CoverageType").get("v.value") == "6"
            ) {
              console.log("2 === ");
              var jnlp = jnlp * 1.85;
              cmp.set("v.JNLifeCreditorLifePremium1New", jnlp);
              cmp
                .find("JNLifeCreditorLifePremium1")
                .set("v.value", parseFloat(jnlp).toFixed(2));
            }
            var bjnlp = 0;
            if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 1 &&
              (cmp.find("IndicateTerm").get("v.value") == 1 ||
                cmp.find("IndicateTerm").get("v.value") == 2 ||
                cmp.find("IndicateTerm").get("v.value") == 3)
            ) {
              console.log("3 === ");
              bjnlp = im * jnlp;
              console.log("3 === " + bjnlp);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium1New", bjnlp);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium1")
                .set("v.value", parseFloat(bjnlp).toFixed(2));
            } else if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 2
            ) {
              bjnlp = 0;
              cmp.set("v.MonthlyJNLifeCreditorLifePremium1New", bjnlp);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium1")
                .set("v.value", parseFloat(bjnlp).toFixed(2));
            } else {
              bjnlp = this.PMTcalculator(marketi, n, jnlp);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium1New", bjnlp);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium1")
                .set("v.value", parseFloat(bjnlp).toFixed(2));
            }

            ///=====================
            if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 2 &&
              cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1 &&
              cmp.find("IndicateTerm").get("v.value") == 1 &&
              cmp.find("IndicateTerm").get("v.value") == 2 &&
              cmp.find("IndicateTerm").get("v.value") == 3
            ) {
              console.log("4 === ");
              var n1 =
                parseFloat(n) -
                parseFloat(cmp.find("IndicateTerm").get("v.value"));
              console.log("4 n1=== " + n1);
              var AmortizationSC2C12 =
                im * jnlp * cmp.find("IndicateTerm").get("v.value");
              var premium1styear1 =
                parseFloat(jnlp) + parseFloat(AmortizationSC2C12);
              var ajngid = this.PMTcalculator(marketi, n1, premium1styear1);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium2New", ajngid);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium2")
                .set("v.value", parseFloat(ajngid).toFixed(2));
            } else if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 2 &&
              cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2 &&
              cmp.find("IndicateTerm").get("v.value") == 1 &&
              cmp.find("IndicateTerm").get("v.value") == 2 &&
              cmp.find("IndicateTerm").get("v.value") == 3
            ) {
              var n1 = n;
              var AmortizationSC2C12 =
                im * jnlp * cmp.find("IndicateTerm").get("v.value");
              console.log("4 im=== " + im);
              console.log("4 jnlp=== " + jnlp);
              console.log("4 AmortizationSC2C12=== " + AmortizationSC2C12);
              var premium1styear2 =
                parseFloat(jnlp) + parseFloat(AmortizationSC2C12);
              var ajngid = this.PMTcalculator(marketi, n1, premium1styear2);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium2New", ajngid);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium2")
                .set("v.value", parseFloat(ajngid).toFixed(2));
            } else if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 1 &&
              cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1
            ) {
              var n1 =
                parseFloat(n) -
                parseFloat(cmp.find("IndicateTerm").get("v.value"));
              console.log("5 n1=== " + i);
              console.log("5 n2=== " + n1);
              console.log("5 n3=== " + jnlp);
              var premium1styear3 = jnlp;
              var ajngid = this.PMTcalculator(marketi, n1, premium1styear3);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium2New", ajngid);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium2")
                .set("v.value", parseFloat(ajngid).toFixed(2));
            } else if (
              cmp.find("Includeamoratoriumofloanrepayments").get("v.value") ==
                0 &&
              cmp.find("IndicateType").get("v.value") == 1 &&
              cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2
            ) {
              var ajngid = this.PMTcalculator(marketi, n, jnlp);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium2New", ajngid);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium2")
                .set("v.value", parseFloat(ajngid).toFixed(2));
            } else {
              var ajngid = 0;
              cmp.set("v.MonthlyJNLifeCreditorLifePremium2New", ajngid);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium2")
                .set("v.value", parseFloat(ajngid).toFixed(2));
            }
          } else if (
            cmp.find("InterestedinCreditorLife").get("v.value") == "0" &&
            cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "1"
          ) {
            console.log("jnltpAVIT	2 === ");
            var jnlifenotincludeinloan = 0;
            if (
              cmp.find("CoverageType").get("v.value") == "4" ||
              cmp.find("CoverageType").get("v.value") == "5" ||
              cmp.find("CoverageType").get("v.value") == "6"
            )
              jnlp = jnlp * 1.85;
            cmp.set(
              "v.MonthlyJNLifeCreditorLifePremium1New",
              jnlifenotincludeinloan
            );
            cmp.set(
              "v.MonthlyJNLifeCreditorLifePremium2New",
              jnlifenotincludeinloan
            );
            cmp
              .find("JNLifeCreditorLifePremium1")
              .set("v.value", parseFloat(jnlifenotincludeinloan).toFixed(2));
            cmp
              .find("MonthlyJNLifeCreditorLifePremium1")
              .set("v.value", parseFloat(jnlifenotincludeinloan).toFixed(2));
            cmp
              .find("MonthlyJNLifeCreditorLifePremium2")
              .set("v.value", parseFloat(jnlifenotincludeinloan).toFixed(2));
            cmp
              .find("JNLifeCreditorInsurancePremium1")
              .set("v.value", parseFloat(jnlp).toFixed(2));
          }
          console.log("rate === " + rate);
          this.calculateTotalautoloan(cmp, event);
          console.log("jnlp === " + jnlp);
        } else if (state === "ERROR") {
          console.log(response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    }

    /* IF(AND(M-y,I=P,T-1),AmortizationSC3!$C$12,
IF(AND(M-yI=P,T-2),MAX(AmortizationSC3!$C$12:$C$13),
IF(AND(M-yI=P,T-2),MAX(AmortizationSC3!$C$12:$C$14),
IF(AND(M-y,I=P&I),0,PMT($F$89/12,SUM($L$89*12,$O$89),-$M$164)))))*/
  },
  calculateProcessingFeehelper: function (cmp, event) {
    if (
      cmp.find("WaiveProcessingFee").get("v.value") == "1" &&
      cmp.find("IncludeinLoanAmountfee").get("v.value") == "0"
    ) {
      var ProcessingFee =
        cmp.find("Indicateapplicableprocessingfees").get("v.value") *
        cmp.get("v.LoanamountMarketAutoloan");
      var ProcessingFee1 = ProcessingFee / 100;
      cmp.set("v.ProcessingFeesAutoloan", ProcessingFee1);
      /* IF(AND(M-y,I=P,T-1),AmortizationSC4!$C$12,
IF(AND(M-yI=P,T-2),MAX(AmortizationSC4!$C$12:$C$13),
IF(AND(M-y,I=P,T-3),MAX(AmortizationSC4!$C$12:$C$14),
IF(AND(M-y,I=P&I),0,PMT($F$89/12,SUM($L$89*12,$O$89),-$M$165)))))*/
      var RequestData = cmp.get("v.RDetailAuto");
      var i = RequestData[0].Interestrate;
      var im = RequestData[0].Interestrate / 1200;
      var n = cmp.get("v.LoanTermMarket");
      if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        (cmp.find("IndicateTerm").get("v.value") == 1 ||
          cmp.find("IndicateTerm").get("v.value") == 2 ||
          cmp.find("IndicateTerm").get("v.value") == 3)
      ) {
        var jngid = im * ProcessingFee1;
        cmp.set("v.MonthlyProcessingFees1New", jngid);
        cmp
          .find("MonthlyProcessingFees1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2
      ) {
        var jngid = 0;
        cmp.set("v.MonthlyProcessingFees1New", jngid);
        cmp
          .find("MonthlyProcessingFees1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      } else {
        var jngid = this.PMTcalculator(i, n, ProcessingFee1);
        cmp.set("v.MonthlyProcessingFees1New", jngid);
        cmp
          .find("MonthlyProcessingFees1")
          .set("v.value", parseFloat(jngid).toFixed(2));
      }

      /*IF(AND(M-y,I=P&I,O-ori,T-1),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$165,AmortizationSC4!$C$12)),
IF(AND(M-y,I=P&I,O-ori,T-2),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$165,AmortizationSC4!$C$12:$C$13)),
IF(AND(M-y,I=P&I,O-ori,T-3),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$165,AmortizationSC4!$C$12:$C$14)),
IF(AND(M-y,I=P,O-ori),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-$M$165),
IF(AND(M-y,I=P&I,O-Eori,T-1),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$165,AmortizationSC4!$C$12)),
IF(AND(M-y,I=P&I,O-Eori,T-2),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$165,AmortizationSC4!$C$12:$C$13)),
IF(AND(M-y,I=P&I,O-Eori,T-3),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$165,AmortizationSC4!$C$12:$C$14)),
IF(AND(M-y,I=P,O-Eori),PMT($F$89/12,SUM($L$89*12,$O$89),-$M$165),0))))))))*/

      if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1 &&
        (cmp.find("IndicateTerm").get("v.value") == 1 ||
          cmp.find("IndicateTerm").get("v.value") == 2 ||
          cmp.find("IndicateTerm").get("v.value") == 3)
      ) {
        var n1 = n - cmp.find("IndicateTerm").get("v.value");
        var AmortizationSC2C12 =
          im * ProcessingFee1 * cmp.find("IndicateTerm").get("v.value");
        var premium1styear1 =
          parseFloat(ProcessingFee1) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyProcessingFees2New", ajngid);
        cmp.find("MonthlyProcessingFees2").set("v.value", ajngid.toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 2 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2 &&
        (cmp.find("IndicateTerm").get("v.value") == 1 ||
          cmp.find("IndicateTerm").get("v.value") == 2 ||
          cmp.find("IndicateTerm").get("v.value") == 3)
      ) {
        var n1 = n;
        var AmortizationSC2C12 =
          im * ProcessingFee1 * cmp.find("IndicateTerm").get("v.value");
        var premium1styear1 =
          parseFloat(ProcessingFee1) + parseFloat(AmortizationSC2C12);
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyProcessingFees2New", ajngid);
        cmp.find("MonthlyProcessingFees2").set("v.value", ajngid.toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1
      ) {
        var n1 = n - cmp.find("IndicateTerm").get("v.value");
        var premium1styear1 = ProcessingFee1;
        var ajngid = this.PMTcalculator(i, n1, premium1styear1);
        cmp.set("v.MonthlyProcessingFees2New", ajngid);
        cmp.find("MonthlyProcessingFees2").set("v.value", ajngid.toFixed(2));
      } else if (
        cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
        cmp.find("IndicateType").get("v.value") == 1 &&
        cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2
      ) {
        var ajngid = this.PMTcalculator(i, n, ProcessingFee1);
        cmp.set("v.MonthlyProcessingFees2New", ajngid);
        cmp.find("MonthlyProcessingFees2").set("v.value", ajngid.toFixed(2));
      } else {
        var ajngid = 0;
        cmp.set("v.MonthlyProcessingFees2New", ajngid);
        cmp.find("MonthlyProcessingFees2").set("v.value", ajngid.toFixed(2));
      }
    }
    if (
      cmp.find("WaiveProcessingFee").get("v.value") == "1" &&
      cmp.find("IncludeinLoanAmountfee").get("v.value") == "1"
    ) {
      var ProcessingFee =
        cmp.find("Indicateapplicableprocessingfees").get("v.value") *
        cmp.get("v.LoanamountMarketAutoloan");
      var ProcessingFee1 = ProcessingFee / 100;
      var zeroval = 0;
      cmp.set("v.ProcessingFeesAutoloan", parseFloat(zeroval).toFixed(2));
      cmp.set("v.MonthlyProcessingFees1New", parseFloat(zeroval).toFixed(2));
      cmp
        .find("MonthlyProcessingFees1")
        .set("v.value", parseFloat(zeroval).toFixed(2));
      cmp.set("v.MonthlyProcessingFees2New", parseFloat(zeroval).toFixed(2));
      cmp
        .find("MonthlyProcessingFees2")
        .set("v.value", parseFloat(zeroval).toFixed(2));
      cmp
        .find("ProcessingFeesGCT1")
        .set("v.value", parseFloat(ProcessingFee1).toFixed(2));
    } else if (cmp.find("WaiveProcessingFee").get("v.value") == "0") {
      var zeroval = 0;
      cmp.set("v.ProcessingFeesAutoloan", parseFloat(zeroval).toFixed(2));
      cmp.set("v.MonthlyProcessingFees1New", parseFloat(zeroval).toFixed(2));
      cmp
        .find("MonthlyProcessingFees1")
        .set("v.value", parseFloat(zeroval).toFixed(2));
      cmp.set("v.MonthlyProcessingFees2New", parseFloat(zeroval).toFixed(2));
      cmp
        .find("MonthlyProcessingFees2")
        .set("v.value", parseFloat(zeroval).toFixed(2));
      cmp
        .find("ProcessingFeesGCT1")
        .set("v.value", parseFloat(zeroval).toFixed(2));
    }
  },
  calculateJNLifeMonthlyPremiumUnsecuredhelper: function (cmp, event) {
    /*=IF(AND($J$102=Admin_Picklists!$H$10,$AH$102=Admin_Picklists!$U$16),$AV$102,0)
  * =(SUM($U$114:$Y$117)/1000)*$AV$101
  * =IF(OR($T$102=$AX$56,$T$102=$AX$57,$T$102=$AX$58),VLOOKUP(VLOOKUP($T$102,$AX$56:$AY$58,2,0),Admin_Tables!$E$7:$Y$16,((CEILING(SUM($L$114*12,$O$114)/12,0.5)/0.5)+1),FALSE),
IF(OR($T$102=$AX$59,$T$102=$AX$60,$T$102=$AX$61),1.85*VLOOKUP(VLOOKUP($T$102,$AX$59:$AY$61,2,0),Admin_Tables!$E$7:$Y$16,((CEILING(SUM($L$114*12,$O$114)/12,0.5)/0.5)+1),FALSE),0))
*/

    //----1-----------------
    var jnlp = 0;
    var ageavg;
    var loanamountsum = 0;
    var RequestData = cmp.get("v.RDetailUnsecured");
    var marketi = RequestData[0].Interestrate;
    var im = RequestData[0].Interestrate / 1200;
    var n =
      Number(RequestData[0].LoanTerm1 * 12) + Number(RequestData[0].LoanTerm2);
    for (var k in RequestData) {
      loanamountsum += parseFloat(RequestData[k].LoanAmount);
    }
    console.log("loanamountsum=====" + loanamountsum);
    if (cmp.find("NumberofApplicant").get("v.value") == 0) {
      var age1 = cmp.get("v.applicant1ageValue");
      ageavg = age1;
    }
    if (cmp.find("NumberofApplicant").get("v.value") == 1) {
      var age1 = cmp.get("v.applicant1ageValue");
      var age2 = cmp.get("v.applicant2ageValue");

      ageavg = (parseFloat(age1) + parseFloat(age2)) / 2;
    }
    if (cmp.find("NumberofApplicant").get("v.value") == 2) {
      var age1 = cmp.get("v.applicant1ageValue");
      var age2 = cmp.get("v.applicant2ageValue");
      var age3 = cmp.get("v.applicant3ageValue");
      var ageavg = (parseFloat(age1) + parseFloat(age2) + parseFloat(age3)) / 3;
      console.log("ageavg=====" + ageavg);
    }
    var agegroup = "";
    if (ageavg >= 18 && ageavg < 25) {
      agegroup = "18-24";
    }
    if (ageavg >= 25 && ageavg < 30) {
      agegroup = "25-29";
    }
    if (ageavg >= 30 && ageavg < 35) {
      agegroup = "30-34";
    }
    if (ageavg >= 35 && ageavg < 40) {
      agegroup = "35-39";
    }
    if (ageavg >= 40 && ageavg < 45) {
      agegroup = "40-44";
    }
    if (ageavg >= 45 && ageavg < 50) {
      agegroup = "45-49";
    }
    if (ageavg >= 50 && ageavg < 55) {
      agegroup = "50-54";
    }
    if (ageavg >= 55 && ageavg < 60) {
      agegroup = "55-59";
    }
    if (ageavg >= 60 && ageavg <= 64) {
      agegroup = "60-64";
    }
    console.log("agegroup=====" + agegroup);

    if (cmp.find("InterestedinCreditorLifeUn").get("v.value") == "0") {
      //&& cmp.find("IncludeinLoanAmountinsurence").get("v.value")=='0'

      console.log("pavit1====");
      var rate = 0;
      var ir = n / 12;
      console.log("ir=====" + ir);
      var irceil;
      var i;
      for (i = 0; i <= ir; i++) {
        var j = i + 0.5;
        if (ir > i && ir < j) irceil = j;
        else if (ir == i) irceil = i;
        j = 0;
      }
      console.log("irceil=====" + irceil);
      console.log("agegroup === " + agegroup);

      var action = cmp.get("c.JNlifeCalculation");
      action.setParams({
        agegroup: agegroup,
        term: irceil
      });
      var self = this;

      action.setCallback(this, function (response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          rate = response.getReturnValue();
          console.log("rate1 === " + rate);
          console.log("loanamountsum === " + loanamountsum);
          jnlp = (loanamountsum / 1000) * rate;
          /*=IFERROR(PMT($F114/12,SUM($L114*12,$O114),-$M189),0)*/
          if (
            cmp.find("InterestedinCreditorLifeUn").get("v.value") == "0" &&
            cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value") == "0"
          ) {
            $A.util.addClass(
              cmp.find("JNLifeCreditorInsurancePremiumUn"),
              "slds-hide"
            );
            $A.util.addClass(
              cmp.find("JNLifeCreditorInsurancePremium1Un"),
              "slds-hide"
            );
            var addtoloanzero = 0;
            cmp
              .find("JNLifeCreditorInsurancePremium1Un")
              .set("v.value", parseFloat(addtoloanzero).toFixed(2));
            console.log("jnltpAVIT	1 === ");
            if (
              cmp.find("CoverageTypeUn").get("v.value") == "1" ||
              cmp.find("CoverageTypeUn").get("v.value") == "2" ||
              cmp.find("CoverageTypeUn").get("v.value") == "3"
            ) {
              console.log("1 === ");
              console.log("jnlp === " + jnlp);
              cmp.set("v.JNLifeCreditorLifePremium1UnNew", jnlp);
              cmp
                .find("JNLifeCreditorLifePremium1Un")
                .set("v.value", parseFloat(jnlp).toFixed(2));
              var jnlpmonthly = this.PMTcalculator(marketi, n, jnlp);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium1UnNew", jnlpmonthly);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium1Un")
                .set("v.value", parseFloat(jnlpmonthly).toFixed(2));
            }
            if (
              cmp.find("CoverageTypeUn").get("v.value") == "4" ||
              cmp.find("CoverageTypeUn").get("v.value") == "5" ||
              cmp.find("CoverageTypeUn").get("v.value") == "6"
            ) {
              console.log("2 === ");
              jnlp *= 1.85;
              cmp.set("v.JNLifeCreditorLifePremium1UnNew", jnlp);
              cmp
                .find("JNLifeCreditorLifePremium1Un")
                .set("v.value", parseFloat(jnlp).toFixed(2));
              var jnlpmonthly = this.PMTcalculator(marketi, n, jnlp);
              cmp.set("v.MonthlyJNLifeCreditorLifePremium1UnNew", jnlpmonthly);
              cmp
                .find("MonthlyJNLifeCreditorLifePremium1Un")
                .set("v.value", parseFloat(jnlpmonthly).toFixed(2));
            }
          } else if (
            cmp.find("InterestedinCreditorLifeUn").get("v.value") == "0" &&
            cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value") == "1"
          ) {
            $A.util.removeClass(
              cmp.find("JNLifeCreditorInsurancePremiumUn"),
              "slds-hide"
            );
            $A.util.removeClass(
              cmp.find("JNLifeCreditorInsurancePremium1Un"),
              "slds-hide"
            );
            console.log("jnltpAVIT	2 === ");
            if (
              cmp.find("CoverageTypeUn").get("v.value") == "4" ||
              cmp.find("CoverageTypeUn").get("v.value") == "5" ||
              cmp.find("CoverageTypeUn").get("v.value") == "6"
            ) {
              jnlp *= 1.85;
            }
            var jnlifezero = 0;
            cmp.set("v.JNLifeCreditorLifePremium1UnNew", jnlifezero);
            cmp
              .find("JNLifeCreditorLifePremium1Un")
              .set("v.value", parseFloat(jnlifezero).toFixed(2));
            cmp.set("v.MonthlyJNLifeCreditorLifePremium1UnNew", jnlifezero);
            cmp
              .find("MonthlyJNLifeCreditorLifePremium1Un")
              .set("v.value", parseFloat(jnlifezero).toFixed(2));
            cmp
              .find("JNLifeCreditorInsurancePremium1Un")
              .set("v.value", parseFloat(jnlp).toFixed(2));
          } else {
            $A.util.addClass(
              cmp.find("JNLifeCreditorInsurancePremiumUn"),
              "slds-hide"
            );
            $A.util.addClass(
              cmp.find("JNLifeCreditorInsurancePremium1Un"),
              "slds-hide"
            );
            var jnlifezero = 0;
            cmp.set("v.JNLifeCreditorLifePremium1UnNew", jnlifezero);
            cmp
              .find("JNLifeCreditorLifePremium1Un")
              .set("v.value", parseFloat(jnlifezero).toFixed(2));
            cmp.set("v.MonthlyJNLifeCreditorLifePremium1UnNew", jnlifezero);
            cmp
              .find("MonthlyJNLifeCreditorLifePremium1Un")
              .set("v.value", parseFloat(jnlifezero).toFixed(2));
            cmp
              .find("JNLifeCreditorInsurancePremium1Un")
              .set("v.value", parseFloat(jnlifezero).toFixed(2));
          }
          console.log("rate === " + rate);
          this.calculateTotalUnsecuredloan(cmp, event);
          console.log("jnlp === " + jnlp);
        } else if (state === "ERROR") {
          console.log(response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    }

    /* IF(AND(M-y,I=P,T-1),AmortizationSC3!$C$12,
IF(AND(M-yI=P,T-2),MAX(AmortizationSC3!$C$12:$C$13),
IF(AND(M-yI=P,T-2),MAX(AmortizationSC3!$C$12:$C$14),
IF(AND(M-y,I=P&I),0,PMT($F$89/12,SUM($L$89*12,$O$89),-$M$164)))))*/
  },
  calculateProcessingFeeUnsecuredhelper: function (cmp, event) {
    console.log("pavitUn1h");
    if (cmp.find("WaiveProcessingFeeUn").get("v.value") == "1") {
      console.log("pavitUn1h1");
      if (cmp.find("IncludeinLoanAmountfeeUn").get("v.value") == "0") {
        console.log("pavitUn1h2");
        $A.util.removeClass(cmp.find("ProcessingFeescalUn"), "slds-hide");
        $A.util.addClass(cmp.find("ProcessingUn"), "slds-hide");
      } else if (cmp.find("IncludeinLoanAmountfeeUn").get("v.value") == "1") {
        console.log("pavitUn1h");
        $A.util.removeClass(cmp.find("ProcessingUn"), "slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeescalUn"), "slds-hide");
      }
    } else if (cmp.find("WaiveProcessingFeeUn").get("v.value") == "0") {
      $A.util.removeClass(cmp.find("ProcessingFeescalUn"), "slds-hide");
    }
    var ProcessingFee10 = 0;
    cmp.set("v.ProcessingFeesincludingGCTUn1New", ProcessingFee10);
    cmp.set("v.MonthlyProcessingFees1UnNew", ProcessingFee10);
    cmp
      .find("ProcessingFeesincludingGCTUn1")
      .set("v.value", parseFloat(ProcessingFee10).toFixed(2));
    cmp
      .find("MonthlyProcessingFees1Un")
      .set("v.value", parseFloat(ProcessingFee10).toFixed(2));
    cmp
      .find("ProcessingFeesGCT1Un")
      .set("v.value", parseFloat(ProcessingFee10).toFixed(2));

    /* console.log('pavitUn');
        if(cmp.find("WaiveProcessingFeeUn").get("v.value")=='1'){
            console.log('pavitUn1');
            var RequestData=cmp.get("v.RDetailUnsecured");
            var i =RequestData[0].Interestrate;
            var n=Number(RequestData[0].LoanTerm1*12)+Number(RequestData[0].LoanTerm2);
            var loanam=RequestData[0].LoanAmount;
            var ProcessingFee=parseFloat(cmp.find("IndicateapplicableprocessingfeesUn").get("v.value"))*parseFloat(loanam);
            console.log('ProcessingFee========='+ProcessingFee);
            var ProcessingFee1=ProcessingFee/100;
            console.log('ProcessingFee1========='+ProcessingFee1);
            
            if(cmp.find("IncludeinLoanAmountfeeUn").get("v.value")=='0'){
                $A.util.addClass(cmp.find("ProcessingFeesGCTUn"),"slds-hide");
                $A.util.addClass(cmp.find("ProcessingFeesGCT1Un"),"slds-hide");
                var addtoloanzero=0.00;
                cmp.find("ProcessingFeesGCT1Un").set("v.value", parseFloat(addtoloanzero).toFixed(2));
                console.log('pavitUn2');
                cmp.find("ProcessingFeesincludingGCTUn1").set("v.value", parseFloat(ProcessingFee1).toFixed(2));
                var monthprocessfee=this.PMTcalculator(i,n,ProcessingFee1);
                cmp.find("MonthlyProcessingFees1Un").set("v.value", parseFloat(monthprocessfee).toFixed(2));
            }
            else if(cmp.find("IncludeinLoanAmountfeeUn").get("v.value")=='1'){
                $A.util.removeClass(cmp.find("ProcessingFeesGCTUn"),"slds-hide");
                $A.util.removeClass(cmp.find("ProcessingFeesGCT1Un"),"slds-hide");
                var ProcessingFee10=0;
                cmp.find("ProcessingFeesincludingGCTUn1").set("v.value", parseFloat(ProcessingFee10).toFixed(2));
                cmp.find("MonthlyProcessingFees1Un").set("v.value", parseFloat(ProcessingFee10).toFixed(2));
                cmp.find("ProcessingFeesGCT1Un").set("v.value", parseFloat(ProcessingFee1).toFixed(2));
            }
        }
        else if(cmp.find("WaiveProcessingFee").get("v.value")=='0'){
            $A.util.addClass(cmp.find("ProcessingFeesGCTUn"),"slds-hide");
            $A.util.addClass(cmp.find("ProcessingFeesGCT1Un"),"slds-hide");
            var ProcessingFee10=0;
            cmp.find("ProcessingFeesincludingGCTUn1").set("v.value", parseFloat(ProcessingFee10).toFixed(2));
            cmp.find("MonthlyProcessingFees1Un").set("v.value", parseFloat(ProcessingFee10).toFixed(2));
            
        }*/
  },
  calculateTotalautoloan: function (cmp, event) {
    var marketloanamount = 0;
    var JN1loanamount = 0;
    var JN2loanamount = 0;
    var JN3loanamount = 0;
    var JNLifeauto = 0;
    var JNGIauto = 0;

    var processingfeeauto = 0;
    if (cmp.get("v.LoanamountMarketAutoloan") > 0)
      marketloanamount = cmp.get("v.LoanamountMarketAutoloan");
    if (cmp.get("v.LoanamountJNStaff1Autoloan") > 0)
      JN1loanamount = cmp.get("v.LoanamountJNStaff1Autoloan");
    if (cmp.get("v.LoanamountJNStaff2Autoloan") > 0)
      JN2loanamount = cmp.get("v.LoanamountJNStaff2Autoloan");
    if (cmp.get("v.LoanamountJNStaff3Autoloan") > 0)
      JN3loanamount = cmp.get("v.LoanamountJNStaff3Autoloan");
    if (cmp.get("v.JNGIAutoloan") > 0) JNGIauto = cmp.get("v.JNGIAutoloan");
    if (cmp.get("v.JNLifeCreditorLifePremium1New"))
      JNLifeauto = cmp.get("v.JNLifeCreditorLifePremium1New");
    if (cmp.get("v.ProcessingFeesAutoloan") > 0)
      processingfeeauto = cmp.get("v.ProcessingFeesAutoloan");
    var totalloanauto =
      parseFloat(marketloanamount) +
      parseFloat(JN1loanamount) +
      parseFloat(JN2loanamount) +
      parseFloat(JN3loanamount) +
      parseFloat(JNLifeauto) +
      parseFloat(JNGIauto) +
      parseFloat(processingfeeauto);

    cmp.set("v.TotalLoanAmountAutoloan", totalloanauto);
    var marketloanamount1 = 0;
    var JN1loanamount1 = 0;
    var JN2loanamount1 = 0;
    var JN3loanamount1 = 0;
    var JNGIauto1 = 0;
    var JNGIauto2 = 0;
    var JNLifeauto1 = 0;
    var processingfeeauto1 = 0;
    if (cmp.get("v.BMLoanamountMarketAutoloan") > 0)
      marketloanamount1 = cmp.get("v.BMLoanamountMarketAutoloan");
    if (cmp.get("v.LoanamountJNStaff1Autoloan") > 0)
      JN1loanamount1 = cmp.get("v.BMLoanamountJNStaff1Autoloan");
    if (cmp.get("v.BMLoanamountJNStaff2Autoloan") > 0)
      JN2loanamount1 = cmp.get("v.BMLoanamountJNStaff2Autoloan");
    if (cmp.get("v.BMLoanamountJNStaff3Autoloan") > 0)
      JN3loanamount1 = cmp.get("v.BMLoanamountJNStaff3Autoloan");
    if (cmp.get("v.MonthlyJNGIMotorPremium1stYear1New") > 0)
      JNGIauto1 = cmp.get("v.MonthlyJNGIMotorPremium1stYear1New");
    console.log("JNGIauto1=====" + JNGIauto1);
    if (cmp.get("v.MonthlyJNGIMotorPremiumhalfPayment1New") > 0)
      JNGIauto2 = cmp.get("v.MonthlyJNGIMotorPremiumhalfPayment1New");
    console.log("JNGIauto2=====" + JNGIauto2);
    if (cmp.get("v.MonthlyJNLifeCreditorLifePremium1New") > 0)
      JNLifeauto1 = cmp.get("v.MonthlyJNLifeCreditorLifePremium1New");
    console.log("JNLifeauto1=====" + JNLifeauto1);
    if (cmp.get("v.MonthlyProcessingFees1New") > 0)
      processingfeeauto1 = cmp.get("v.MonthlyProcessingFees1New");
    var totalsavingsauto =
      parseFloat(marketloanamount1) +
      parseFloat(JN1loanamount1) +
      parseFloat(JN2loanamount1) +
      parseFloat(JN3loanamount1) +
      parseFloat(JNGIauto1) +
      parseFloat(JNGIauto2) +
      parseFloat(JNLifeauto1) +
      parseFloat(processingfeeauto1);
    cmp.find("MonthlyLoanPayment1").set("v.value", totalsavingsauto.toFixed(2));

    var marketloanamount2 = 0;
    var JN1loanamount2 = 0;
    var JN2loanamount2 = 0;
    var JN3loanamount2 = 0;
    var JNGIauto21 = 0;
    var JNGIauto22 = 0;
    var JNLifeauto2 = 0;
    var processingfeeauto2 = 0;
    var aftermpayment = 0;
    if (cmp.get("v.AMLoanamountMarketAutoloan") > 0)
      marketloanamount2 = cmp.get("v.AMLoanamountMarketAutoloan");
    if (cmp.get("v.MonthlyLoanPaymentJN12New") > 0)
      JN1loanamount2 = cmp.get("v.MonthlyLoanPaymentJN12New");
    if (cmp.get("v.MonthlyLoanPaymentJN22New") > 0)
      JN2loanamount2 = cmp.get("v.MonthlyLoanPaymentJN22New");
    if (cmp.get("v.MonthlyLoanPaymentJN32New") > 0)
      JN3loanamount2 = cmp.get("v.MonthlyLoanPaymentJN32New");
    if (cmp.get("v.MonthlyJNGIMotorPremium1stYear2New") > 0)
      JNGIauto21 = cmp.get("v.MonthlyJNGIMotorPremium1stYear2New");
    if (cmp.get("v.MonthlyJNGIMotorPremiumhalfPayment2New") > 0)
      JNGIauto22 = cmp.get("v.MonthlyJNGIMotorPremiumhalfPayment2New");
    if (cmp.get("v.MonthlyJNLifeCreditorLifePremium2New") > 0)
      JNLifeauto2 = cmp.get("v.MonthlyJNLifeCreditorLifePremium2New");
    if (cmp.get("v.MonthlyProcessingFees2New") > 0)
      processingfeeauto2 = cmp.get("v.MonthlyProcessingFees2New");
    aftermpayment =
      parseFloat(marketloanamount2) +
      parseFloat(JN1loanamount2) +
      parseFloat(JN2loanamount2) +
      parseFloat(JN3loanamount2) +
      parseFloat(JNGIauto21) +
      parseFloat(JNGIauto22) +
      parseFloat(JNLifeauto2) +
      parseFloat(processingfeeauto2);
    cmp.find("MonthlyLoanPayment2").set("v.value", aftermpayment.toFixed(2));

    /*  =IFERROR(IF(ISBLANK($N$83)=TRUE,($G$83*MAX($AG$166:$AQ$166))/100,IF(ISBLANK($G$83)=TRUE,$N$83,0)),0)*/
    var loansavingpercentage = cmp.find("ProposedSavings1").get("v.value");
    var loansavingamount = cmp.find("ProposedSavings5").get("v.value");
    var loanpaymentamountfinal = 0;
    var loanpaymentamount = 0;

    loanpaymentamount = Math.max(totalsavingsauto, aftermpayment);
    if (loansavingpercentage > 0 && loanpaymentamount > 0) {
      var LoanSavingsamount1 = loansavingpercentage * loanpaymentamount;
      var LoanSavingsamount2 = LoanSavingsamount1 / 100;
      loanpaymentamountfinal = LoanSavingsamount2;
    } else if (loansavingamount > 0) {
      loanpaymentamountfinal = loansavingamount;
    } else loanpaymentamountfinal = 0;

    console.log("loanpaymentamountfinal=======" + loanpaymentamountfinal);
    cmp
      .find("MonthlyLoanSavings1")
      .set("v.value", parseFloat(loanpaymentamountfinal).toFixed(2));
    //=============

    console.log("test1=======" + totalsavingsauto);
    var MonthlyLoanSavingsbefore =
      parseFloat(totalsavingsauto) + parseFloat(loanpaymentamountfinal);
    cmp
      .find("MonthlyLoanPaymentsaving1")
      .set("v.value", parseFloat(MonthlyLoanSavingsbefore).toFixed(2));
    //========
    console.log("test2=======");
    var MonthlyLoanSavingsafter =
      parseFloat(aftermpayment) + parseFloat(loanpaymentamountfinal);
    cmp
      .find("MonthlyLoanPaymentsaving2")
      .set("v.value", parseFloat(MonthlyLoanSavingsafter).toFixed(2));
    console.log("test3=======");
    //============
    var loanterm = cmp.get("v.LoanTermMarket");
    console.log("loanterm=========" + loanterm);
    var totloansavingsbalance = loanpaymentamountfinal * loanterm;
    if (isNaN(totloansavingsbalance)) cmp.find("TotalLSB1").set("v.value", 0.0);
    else
      cmp
        .find("TotalLSB1")
        .set("v.value", parseFloat(totloansavingsbalance).toFixed(2));
    //========
    var RDetailUnsecured = cmp.get("v.RDetailAuto");
    var ltmarket = 0;
    var ltjn1 = 0;
    var ltjn2 = 0;
    var ltjn3 = 0;
    for (var k in RDetailUnsecured) {
      if (k == 0)
        ltmarket =
          Number(RDetailUnsecured[0].LoanTerm1 * 12) +
          Number(RDetailUnsecured[0].LoanTerm2);
      if (k == 1)
        ltjn1 =
          Number(RDetailUnsecured[1].LoanTerm1 * 12) +
          Number(RDetailUnsecured[1].LoanTerm2);
      if (k == 2)
        ltjn2 =
          Number(RDetailUnsecured[2].LoanTerm1 * 12) +
          Number(RDetailUnsecured[2].LoanTerm2);
      if (k == 3)
        ltjn3 =
          Number(RDetailUnsecured[3].LoanTerm1 * 12) +
          Number(RDetailUnsecured[3].LoanTerm2);
    }
    /*=IF(AND(M$78=Admin_Picklists!H$10,W$78=Admin_Picklists!N$20),SUM(AG$158,AG$162,AG$164,AG$165,(SUM(AM$158,AM$162,AM$164:AQ$165)*(SUM(L$89*12,O$89)-AI$78)),(AG$159*SUM(L$90*12,O$90)),(AG$160*SUM(L$91*12,O$91)),(AG$161*SUM(L$92*12,O$92)))-M$166,
IF(AND(M$78=Admin_Picklists!H$10,W$78=Admin_Picklists!N$21),SUM((SUM(AM$158,AM$162,AM$164:AQ$165)*(SUM(L$89*12,O$89)-AI$78)),(AG$159*SUM(L$90*12,O$90)),(AG$160*SUM(L$91*12,O$91)),(AG$161*SUM(L$92*12,O$92)))-M$166,
SUM((SUM(AG$158,AG$162,AG$164:AL$165)*SUM(L$89*12,O$89)),(AG$159*SUM(L$90*12,O$90)),(AG$160*SUM(L$91*12,O$91)),(AG$161*SUM(L$92*12,O$92)))-M$166))*/
    console.log("marketloanamount2=========" + marketloanamount2);
    console.log("JNGIauto21=========" + JNGIauto21);
    console.log("JNLifeauto2=========" + JNLifeauto2);
    console.log("ltmarket=========" + ltmarket);
    console.log("processingfeeauto2=========" + processingfeeauto2);
    console.log("marketloanamount1=========" + marketloanamount1);
    console.log("JNGIauto1=========" + JNGIauto1);
    console.log("JNLifeauto1=========" + JNLifeauto1);
    console.log("processingfeeauto1=========" + processingfeeauto1);
    console.log("totalloanauto=========" + totalloanauto);

    var totloaninterest = 0;
    if (
      cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
      cmp.find("IndicateType").get("v.value") == 1
    ) {
      console.log("//////////////////////");
      var t1 = parseFloat(
        (parseFloat(marketloanamount2) +
          parseFloat(JNGIauto21) +
          parseFloat(JNLifeauto2) +
          parseFloat(processingfeeauto2)) *
          (parseFloat(ltmarket) -
            parseFloat(cmp.find("IndicateTerm").get("v.value")))
      );
      console.log("t1=========" + t1);
      totloaninterest =
        parseFloat(marketloanamount1) +
        parseFloat(JNGIauto1) +
        parseFloat(JNLifeauto1) +
        parseFloat(processingfeeauto1) +
        parseFloat(t1) +
        parseFloat(JN1loanamount1 * ltjn1) +
        parseFloat(JN2loanamount1 * ltjn2) +
        parseFloat(JN3loanamount1 * ltjn3) -
        parseFloat(totalloanauto);
    } else if (
      cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
      cmp.find("IndicateType").get("v.value") == 2
    ) {
      var t1 = parseFloat(
        (parseFloat(marketloanamount2) +
          parseFloat(JNGIauto21) +
          parseFloat(JNLifeauto2) +
          parseFloat(processingfeeauto2)) *
          (parseFloat(ltmarket) -
            parseFloat(cmp.find("IndicateTerm").get("v.value")))
      );
      totloaninterest =
        parseFloat(t1) +
        parseFloat(JN1loanamount1 * ltjn1) +
        parseFloat(JN2loanamount1 * ltjn2) +
        parseFloat(JN3loanamount1 * ltjn3) -
        parseFloat(totalloanauto);
    } else {
      console.log("t1total=========" + t1);
      totloaninterest =
        (parseFloat(marketloanamount1) +
          parseFloat(JNGIauto1) +
          parseFloat(JNLifeauto1) +
          parseFloat(processingfeeauto1)) *
          ltmarket +
        parseFloat(JN1loanamount1 * ltjn1) +
        parseFloat(JN2loanamount1 * ltjn2) +
        parseFloat(JN3loanamount1 * ltjn3) -
        parseFloat(totalloanauto);
    }

    // var totloaninterest=((ltmarket*marketloanamount1)+(ltjn1*JN1loanamount1)+(ltjn2*JN2loanamount1)+(ltjn3*JN3loanamount1))-totalloanauto;
    cmp.find("TotalIP1").set("v.value", parseFloat(totloaninterest).toFixed(2));
    cmp.find("LegalFeesGCT1").set("v.value", "5825");
    var stampdutyautoloan = 0;
    if (cmp.find("LoanPurpose").get("v.value") == "1") stampdutyautoloan = 1050; //Ao25+Ao23
    if (
      cmp.find("LoanPurpose").get("v.value") == "2" ||
      cmp.find("LoanPurpose").get("v.value") == "3"
    )
      stampdutyautoloan = 6000; //Ao25+Ao23
    cmp.find("StampDutyDoc1").set("v.value", stampdutyautoloan);
    console.log("test4=======");
    var jngitotalno = 0;
    var jnlifetotalno = 0;
    var profeetotalno = 0;
    if (
      cmp.find("Interestedinprogramme").get("v.value") == "0" &&
      cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "1"
    )
      jngitotalno = cmp.find("JNGIMotorInsurancePremium1st1").get("v.value");
    if (
      cmp.find("InterestedinCreditorLife").get("v.value") == "0" &&
      cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "1"
    )
      jnlifetotalno = cmp
        .find("JNLifeCreditorInsurancePremium1")
        .get("v.value");
    if (
      cmp.find("WaiveProcessingFee").get("v.value") == "1" &&
      cmp.find("IncludeinLoanAmountfee").get("v.value") == "1"
    )
      profeetotalno = cmp.find("ProcessingFeesGCT1").get("v.value");
    console.log("test5=======");
    var TotalAutoLoanFees =
      5825 +
      parseFloat(stampdutyautoloan) +
      parseFloat(jngitotalno) +
      parseFloat(jnlifetotalno) +
      parseFloat(profeetotalno);
    console.log("test6=======");
    cmp
      .find("TotalAutoLoanFeesCharges1")
      .set("v.value", parseFloat(TotalAutoLoanFees).toFixed(2));

    this.ShowTotalAsPerCalculatorSelected(cmp);
  },
  calculateTotalUnsecuredloan: function (cmp, event) {
    var marketloanamount = 0;
    var JN1loanamount = 0;
    var JN2loanamount = 0;
    var JN3loanamount = 0;
    var processfee = 0;
    var jnlife = 0;

    if (cmp.get("v.LoanAmountMarket1UnNew") > 0)
      marketloanamount = cmp.get("v.LoanAmountMarket1UnNew");
    if (cmp.get("v.LoanAmountJN11UnNew") > 0)
      JN1loanamount = cmp.get("v.LoanAmountJN11UnNew");
    if (cmp.get("v.LoanAmountJN21UnNew") > 0)
      JN2loanamount = cmp.get("v.LoanAmountJN21UnNew");
    if (cmp.get("v.LoanAmountJN31UnNew") > 0)
      JN3loanamount = cmp.get("v.LoanAmountJN31UnNew");
    if (cmp.get("v.ProcessingFeesincludingGCTUn1New") > 0)
      processfee = cmp.get("v.ProcessingFeesincludingGCTUn1New");
    if (cmp.get("v.JNLifeCreditorLifePremium1UnNew") > 0)
      jnlife = cmp.get("v.JNLifeCreditorLifePremium1UnNew");

    var totalloanauto =
      parseFloat(marketloanamount) +
      parseFloat(JN1loanamount) +
      parseFloat(JN2loanamount) +
      parseFloat(JN3loanamount) +
      parseFloat(processfee) +
      parseFloat(jnlife);

    cmp.find("TotalLoanAmount1Un").set("v.value", totalloanauto);
    var marketloanamount1 = 0;
    var JN1loanamount1 = 0;
    var JN2loanamount1 = 0;
    var JN3loanamount1 = 0;
    var processfee1 = 0;
    var jnlifeUn = 0;

    if (cmp.get("v.BMLoanamountMarketAutoloanUn") > 0)
      marketloanamount1 = cmp.get("v.BMLoanamountMarketAutoloanUn");
    if (cmp.get("v.BMLoanamountJNStaff1AutoloanUn") > 0)
      JN1loanamount1 = cmp.get("v.BMLoanamountJNStaff1AutoloanUn");
    if (cmp.get("v.BMLoanamountJNStaff2AutoloanUn") > 0)
      JN2loanamount1 = cmp.get("v.BMLoanamountJNStaff2AutoloanUn");
    if (cmp.get("v.BMLoanamountJNStaff3AutoloanUn") > 0)
      JN3loanamount1 = cmp.get("v.BMLoanamountJNStaff3AutoloanUn");
    if (cmp.get("v.MonthlyProcessingFees1UnNew") > 0)
      processfee1 = cmp.get("v.MonthlyProcessingFees1UnNew");
    if (cmp.get("v.MonthlyJNLifeCreditorLifePremium1UnNew") > 0)
      jnlifeUn = cmp.get("v.MonthlyJNLifeCreditorLifePremium1UnNew");

    var totalsavingsauto =
      parseFloat(marketloanamount1) +
      parseFloat(JN1loanamount1) +
      parseFloat(JN2loanamount1) +
      parseFloat(JN3loanamount1) +
      parseFloat(processfee1) +
      parseFloat(jnlifeUn);
    cmp
      .find("MonthlyLoanPayment1Un")
      .set("v.value", parseFloat(totalsavingsauto).toFixed(2));

    var loansavingpercentage = cmp.find("ProposedSavings1Un").get("v.value");
    var loansavingamount = cmp.find("ProposedSavings5Un").get("v.value");

    var loanpaymentamountfinal = 0;
    var loanpaymentamount = totalsavingsauto;
    if (loansavingpercentage > 0 && loanpaymentamount > 0) {
      var LoanSavingsamount1 = loansavingpercentage * loanpaymentamount;
      var LoanSavingsamount2 = LoanSavingsamount1 / 100;
      //cmp.find("MonthlyLoanSavings1").set("v.value", LoanSavingsamount2);
      loanpaymentamountfinal = LoanSavingsamount2;
    } else if (loansavingamount > 0) {
      //cmp.find("MonthlyLoanSavings1").set("v.value", loansavingamount);
      loanpaymentamountfinal = loansavingamount;
    } else loanpaymentamountfinal = 0;

    cmp
      .find("MonthlyLoanSavings1Un")
      .set("v.value", parseFloat(loanpaymentamountfinal).toFixed(2));
    //=============
    var totloansaving = loanpaymentamountfinal;
    var totloansavings =
      parseFloat(loanpaymentamount) + parseFloat(totloansaving);
    cmp
      .find("MonthlyLoanPaymentsaving1Un")
      .set("v.value", parseFloat(totloansavings).toFixed(2));
    //========
    var loanterm = cmp.get("v.LoanTermMarketUn");

    console.log("loanterm=========" + loanterm);
    console.log("totloansavings=========" + totloansaving);
    var totloansavingsbalance = totloansaving * loanterm;
    cmp
      .find("TotalLSB1Un")
      .set("v.value", parseFloat(totloansavingsbalance).toFixed(2));
    //========
    var RDetailUnsecured = cmp.get("v.RDetailUnsecured");
    var ltmarket = 0;
    var ltjn1 = 0;
    var ltjn2 = 0;
    var ltjn3 = 0;

    for (var k in RDetailUnsecured) {
      if (k == 0)
        ltmarket =
          Number(RDetailUnsecured[0].LoanTerm1 * 12) +
          Number(RDetailUnsecured[0].LoanTerm2);
      if (k == 1)
        ltjn1 =
          Number(RDetailUnsecured[1].LoanTerm1 * 12) +
          Number(RDetailUnsecured[1].LoanTerm2);
      if (k == 2)
        ltjn2 =
          Number(RDetailUnsecured[2].LoanTerm1 * 12) +
          Number(RDetailUnsecured[2].LoanTerm2);
      if (k == 3)
        ltjn3 =
          Number(RDetailUnsecured[3].LoanTerm1 * 12) +
          Number(RDetailUnsecured[3].LoanTerm2);
    }
    /*SUM(SUM($AG$185,$AG$189:$AL$190)*SUM($L$114*12,$O$114),$AG$186*SUM($L$115*12,$O$115),
     * $AG$187*SUM($L$116*12,$O$116),$AG$188*SUM($L$117*12,$O$117))-$M$191*/

    var totloaninterest =
      ltmarket *
        (parseFloat(marketloanamount1) +
          parseFloat(processfee1) +
          parseFloat(jnlifeUn)) +
      ltjn1 * JN1loanamount1 +
      ltjn2 * JN2loanamount1 +
      ltjn3 * JN3loanamount1 -
      parseFloat(totalloanauto);
    //var totloaninterest=(loanpaymentamount*loanterm)-totalloanauto;
    cmp
      .find("TotalIP1Un")
      .set("v.value", parseFloat(totloaninterest).toFixed(2));

    cmp.find("LegalFeesGCT1Un").set("v.value", "5825");
    cmp.find("StampDutyDoc1Un").set("v.value", "1020");
    var totalcharges =
      5825 +
      1020 +
      parseFloat(cmp.find("ProcessingFeesGCT1Un").get("v.value")) +
      parseFloat(cmp.find("JNLifeCreditorInsurancePremium1Un").get("v.value"));
    cmp
      .find("TotalAutoLoanFeesCharges1Un")
      .set("v.value", parseFloat(totalcharges).toFixed(2));
    /*//====total=================
        var Admin_TablesBJ7 = '50.00%';
        cmp.find("PolicyLimit").set("v.value",Admin_TablesBJ7);
        var ExistingMonthlyCreditPayment=0;
        var GrossMonthlyIncome=0;
        var applicantlst=cmp.get("v.RowNum");
        for(var k in applicantlst){
            GrossMonthlyIncome +=parseFloat(applicantlst[k].GMIncome);
            ExistingMonthlyCreditPayment +=parseFloat(applicantlst[k].EMCPayment);
        }
        var  PriorToProposedCredit = ExistingMonthlyCreditPayment/GrossMonthlyIncome*100;
        if(isNaN(apc))
            cmp.find("PriortoProposedCredit").set("v.value", 0+'%');
        else
            cmp.find("PriortoProposedCredit").set("v.value", PriorToProposedCredit.toFixed(2)+'%');  
        var apc = parseFloat(ExistingMonthlyCreditPayment)+parseFloat(totalsavingsauto);
        apc = apc/parseFloat(GrossMonthlyIncome)*100;
        if(isNaN(apc))
            cmp.find("AfterProposedCredit").set("v.value", 0+'%');
        else
            cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2)+'%');*/
    cmp.set("v.Unsecuredloan_totalsavingsauto", totalsavingsauto);
    this.ShowTotalAsPerCalculatorSelected(cmp);
  },
  AddRowRequestDetail: function (RowIndex, EmpRow, cmp) {
    EmpRow.push({
      Id: RowIndex,
      colIndex: "JN Staff " + RowIndex,
      Interestrate: "",
      LoanTerm1: "",
      LoanTerm2: "",
      LoanAmount: ""
    });
    EmpRow.sort((a, b) => a.Id - b.Id);
    cmp.set("v.RDetailUnsecured", EmpRow);
  },
  RemoveRowRequestDetail: function (StartIndex, length, EmpRow, cmp) {
    EmpRow.splice(StartIndex, length);
    cmp.set("v.RDetailUnsecured", EmpRow);
  },
  Applicantagecalculation: function (cmp, dob, appnum) {
    var birth = new Date(dob);
    var curr = new Date();
    var diff = curr.getTime() - birth.getTime();
    var age = diff / (1000 * 60 * 60 * 24 * 365.25);
    if (appnum == 1 && age > 18 && age < 64) {
      cmp.set("v.applicant1age", true);
      cmp.set("v.applicant1ageValue", age);
    }
    if (appnum == 2 && age > 18 && age < 64) {
      cmp.set("v.applicant2age", true);
      cmp.set("v.applicant2ageValue", age);
    }
    if (appnum == 3 && age > 18 && age < 64) {
      cmp.set("v.applicant3age", true);
      cmp.set("v.applicant3ageValue", age);
    }
  },
  PMTcalculator: function (Interestrate, LoanTerminMonth, LoanAmount) {
    var i = Interestrate / 1200;
    var n = LoanTerminMonth;
    var p = LoanAmount;
    console.log("n=====" + n);
    var bmla = -((i * p * Math.pow(1 + i, n)) / (1 - Math.pow(1 + i, n)));
    return bmla;
  },
  //---------------------------------------------

  ShowTotalAsPerCalculatorSelected: function (cmp) {
    var acMethod = cmp.find("selectapplicant").get("v.value");
    switch (acMethod) {
      case "0":
        break;
      case "1":
        //Auto Loan
        this.autoLoanTotal(cmp);
        break;
      case "2":
        //Unsecured Loan
        this.unsecuredLoanTotal(cmp);
        break;
      case "3":
        //Credit Card
        this.creditCardTotal(cmp);
        break;
      case "4":
        //Line of Credit
        this.lineOfCreditTotal(cmp);
        break;
      case "5":
        //Auto Loan &amp; Unsecured Loan
        this.autoLoanAndUnsecuredLoanTotal(cmp);
        break;
      case "6":
        //Auto Loan &amp; Credit Card
        this.autoLoanAndCreditCardTotal(cmp);
        break;
      case "7":
        //Auto Loan &amp; Line of Credit
        this.autoLoanAndLineOfCredit(cmp);
        break;
      case "8":
        //Unsecured Loan &amp; Credit Card
        this.unsecuredLoanAndCreditCard(cmp);
        break;
      case "9":
        //Unsecured Loan &amp; Line of Credit
        this.unsecuredLoanAndLineOfCredit(cmp);
        break;
      case "10":
        //Credit Card &amp; Line of Credit
        this.creditCardAndLineOfCredit(cmp);
        break;
      case "11":
        //Auto Loan, Unsecured Loan &amp; Credit Card
        this.autoLoanUnsecuredLoanAndCreditCard(cmp);
        break;
      case "12":
        //Auto Loan, Unsecured Loan &amp; Line of Credit
        this.autoLoanUnsecuredLoanAndLineOfCredit(cmp);
        break;
      case "13":
        //Auto Loan, Credit Card &amp; Line of Credit
        this.autoLoanCreditCardAndLineOfCredit(cmp);
        break;
      case "14":
        //Unsecured Loan, Credit Card &amp; Line of Credit
        this.unsecuredLoanCreditCardAndLineOfCredit(cmp);
        break;
      case "15":
        //Auto Loan, Unsecured Loan, Credit Card &amp; Line of Credit
        this.autoLoanUnsecuredLoanCreditCardAndLineOfCredit(cmp);
        break;
    }
  },
  SetDefaultVal: function (obj, val = 0) {
    if (obj.get("v.value")) {
      obj.set("v.value", obj.get("v.value"));
      return true;
    }
    obj.set("v.value", val);
    return true;
  },
  RoundTo: function (number, roundto) {
    return roundto * Math.round(number / roundto);
  },
  checkNaN: function (number) {
    if (isNaN(number)) {
      number = 0;
    }
    return number;
  },

  autoLoanTotal: function (cmp) {
    /*var Admin_TablesBJ7 = '50.00%';
        cmp.find("PolicyLimit").set("v.value",Admin_TablesBJ7);
        
        var ExistingMonthlyCreditPayment=0;
        var GrossMonthlyIncome=0;
        var applicantlst=cmp.get("v.RowNum");
        for(var k in applicantlst){
            GrossMonthlyIncome +=parseFloat(applicantlst[k].GMIncome);
            ExistingMonthlyCreditPayment +=parseFloat(applicantlst[k].EMCPayment);
        }
        var  PriorToProposedCredit = ExistingMonthlyCreditPayment/GrossMonthlyIncome*100;
        if(isNaN(PriorToProposedCredit))
            cmp.find("PriortoProposedCredit").set("v.value", 0.00+'%');
        else
            cmp.find("PriortoProposedCredit").set("v.value", PriorToProposedCredit.toFixed(2)+'%');
        
        var maxval= cmp.get("v.AutoLoan_totalsavingsauto"); //   totalsavingsauto;//Math.max(marketloanamount1, JN1loanamount1, JN2loanamount1, JN3loanamount1);
        var apc = parseFloat(ExistingMonthlyCreditPayment)+parseFloat(maxval);
        apc = apc/parseFloat(GrossMonthlyIncome)*100;
        if(isNaN(apc))
            cmp.find("AfterProposedCredit").set("v.value", 0+'%');
        else
            cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2)+'%');
        */

    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //GrossMonthlyIncome
    var AW57 = 0; //ExistingMonthlyCreditPayment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    //this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"),0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);
    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);

    //var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");

    //console.log('AL208===='+AL208);

    var apc =
      (AW57 +
        Math.max(
          parseFloat(AG158_AL162_AG164_AL165),
          parseFloat(AM158_AQ162_AM164_AQ165)
        )) /
      AW56;
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  unsecuredLoanTotal: function (cmp) {
    var Admin_TablesBJ7 = "50.00%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    var ExistingMonthlyCreditPayment = 0;
    var GrossMonthlyIncome = 0;
    var applicantlst = cmp.get("v.RowNum");
    for (var k in applicantlst) {
      GrossMonthlyIncome += parseFloat(applicantlst[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(applicantlst[k].EMCPayment);
    }

    var PriorToProposedCredit =
      (ExistingMonthlyCreditPayment / GrossMonthlyIncome) * 100;
    if (isNaN(PriorToProposedCredit))
      cmp.find("PriortoProposedCredit").set("v.value", 0 + "%");
    else
      cmp
        .find("PriortoProposedCredit")
        .set("v.value", PriorToProposedCredit.toFixed(2) + "%");

    var totalsavingsauto = cmp.get("v.Unsecuredloan_totalsavingsauto");

    var apc =
      parseFloat(ExistingMonthlyCreditPayment) + parseFloat(totalsavingsauto);
    apc = (apc / parseFloat(GrossMonthlyIncome)) * 100;
    if (isNaN(apc)) cmp.find("AfterProposedCredit").set("v.value", 0 + "%");
    else cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");
  },
  creditCardTotal: function (cmp) {
    //----- ----------Calculation for total footer start --------------------------------------
    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //Prior to Proposed Credit(s) =  Existing monthly credit payment /Gross Monthly Income

    var GrossMonthlyIncome = 0; //$AB$56
    var ExistingMonthlyCreditPayment = 0; //$AI$56 = EXISTING MONTHLY CREDIT PAYMENT
    var EmpRow = cmp.get("v.RowNum");
    for (var k in EmpRow) {
      GrossMonthlyIncome = EmpRow[k].GMIncome;
      ExistingMonthlyCreditPayment = EmpRow[k].EMCPayment;
    }

    var PriorToProposedCredit =
      (ExistingMonthlyCreditPayment / GrossMonthlyIncome) * 100;
    cmp
      .find("PriortoProposedCredit")
      .set("v.value", PriorToProposedCredit.toFixed(2) + "%");

    var interestRate = cmp.find("ccInterestRate").get("v.value");
    interestRate = interestRate / 12;
    var monthlyPrincipalRepayment_CCRate = 2.5;

    var AV126 = interestRate + monthlyPrincipalRepayment_CCRate; //In %
    console.log("AV126 In %=====>" + AV126);
    AV126 = AV126 / 100;

    var startingLimit = cmp.find("ccStartingLimit").get("v.value");
    var MinimumPaymentAsPerCreditLimit = startingLimit * AV126;

    var apc =
      parseFloat(ExistingMonthlyCreditPayment) +
      parseFloat(MinimumPaymentAsPerCreditLimit);
    apc = (apc / parseFloat(GrossMonthlyIncome)) * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");
  },
  lineOfCreditTotal: function (cmp) {
    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)

    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;
    var EmpRow = cmp.get("v.RowNum");
    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);

    //After Proposed Credit(s)=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
    //=IFERROR(SUM($AW$57,$AA$216)/$AW$56,0)
    //$AW$57 = Existing Monthly credit payment Sum
    //$AA$216 = Minimum Payment as per Credit Limit
    //$AW$56 = =SUM($AB$56:$AF$58) //Sum of Gross Monthly Income
    //console.log('AW57='+AW57);
    //console.log('AW56='+AW56);
    // console.log('MinimumPaymentAsPerCreditLimit='+MinimumPaymentAsPerCreditLimit);

    var Admin_TablesBF14 = 3;
    var InterestRate = cmp.find("locInterestRate").get("v.value") / 12;
    var AV140 = (InterestRate + Admin_TablesBF14) / 100;

    var StartingLimit = cmp.find("locStartingLimit").get("v.value");

    var MinimumPaymentAsPerCreditLimit = StartingLimit * AV140;

    var apc = parseFloat(AW57) + parseFloat(MinimumPaymentAsPerCreditLimit);
    console.log("sum======" + apc);
    apc = apc / parseFloat(AW56);

    console.log("sum 2======" + apc);
    apc = apc * 100;
    apc = this.checkNaN(apc);
    apc = apc.toFixed(2) + "%";
    cmp.find("AfterProposedCredit").set("v.value", apc);
  },
  autoLoanAndUnsecuredLoanTotal: function (cmp) {
    /*
          After Proposed Credit(s) = =IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
     	 $AU$156:$AV$170   =IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AG$191)/$AW$56,0)
        $AW$57 = =SUM($AI$56:$AM$58) // Sum of Existing Monthly credit payment
        $AG$158:$AL$162 = sum of (
          + Monthly Loan Payment (Market)
          + Monthly Loan Payment (JN Staff 1)
          + Monthly Loan Payment (JN Staff 2)
          + Monthly Loan Payment (JN Staff 3)
          + Monthly JNGI Motor Premium (1st Year)
        )
        
        $AG$164:$AL$165 = sum of{
          + Monthly JN Life Creditor Life Premium
            + Monthly Processing Fees
        }
          
        $AM$158:$AQ$162 = sum of ( // After Textbox
          + Monthly Loan Payment (Market)
          + Monthly Loan Payment (JN Staff 1)
          + Monthly Loan Payment (JN Staff 2)
          + Monthly Loan Payment (JN Staff 3)
          + Monthly JNGI Motor Premium (1st Year)
        )
        $AM$164:$AQ$165 = sum of{ //After Textbox
         + Monthly JN Life Creditor Life Premium
            + Monthly Processing Fees
        }
        
        $AG$191 = Monthly Loan Payment
        $AW$56 = =SUM($AB$56:$AF$58) / Sum of Gross Monthly Income
        */

    //$AW$57 = =SUM($AI$56:$AM$58) // Sum of Existing Monthly credit payment
    //$AW$56 = =SUM($AB$56:$AF$58) / Sum of Gross Monthly Income
    console.log("autoLoanAndUnsecuredLoanTotal=======================");

    var EmpRow = cmp.get("v.RowNum");
    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;

    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    console.log("GrossMonthlyIncome====" + GrossMonthlyIncome);
    console.log(
      "ExistingMonthlyCreditPayment====" + ExistingMonthlyCreditPayment
    );

    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    console.log("AW56====" + AW56);
    console.log("AW57====" + AW57);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);

    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);
    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value"); //Monthly Loan Payment
    console.log("AG191====" + AG191);
    var apc =
      (AW57 +
        Math.max(AG158_AL162_AG164_AL165, AM158_AQ162_AM164_AQ165) +
        AG191) /
      AW56;
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  autoLoanAndCreditCardTotal: function (cmp) {
    /*After Proposed Credit(s)=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        $AU$156:$AV$170 = =IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AL$208)/$AW$56,0)
        $AG$158:$AL$162 = sum of (
          + Monthly Loan Payment (Market)
          + Monthly Loan Payment (JN Staff 1)
          + Monthly Loan Payment (JN Staff 2)
          + Monthly Loan Payment (JN Staff 3)
          + Monthly JNGI Motor Premium (1st Year)
        )
        
        $AG$164:$AL$165  = sum of{
          + Monthly JN Life Creditor Life Premium
            + Monthly Processing Fees
        }
          
        $AM$158:$AQ$162 = sum of ( // After Textbox
          + Monthly Loan Payment (Market)
          + Monthly Loan Payment (JN Staff 1)
          + Monthly Loan Payment (JN Staff 2)
          + Monthly Loan Payment (JN Staff 3)
          + Monthly JNGI Motor Premium (1st Year)
        )
        $AM$164:$AQ$165 = sum of{ //After Textbox
         + Monthly JN Life Creditor Life Premium
            + Monthly Processing Fees
        }
        
       $AW$57 = SUM($AI$56:$AM$58) // Sum of Existing Monthly credit payment
       $AL$208 = Minimum Payment as per Credit Limit (credit card)
        $AW$56 = =SUM($AB$56:$AF$58) / Sum of Gross Monthly Income
        
        */
    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //GrossMonthlyIncome
    var AW57 = 0; //ExistingMonthlyCreditPayment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);
    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);

    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");

    console.log("AL208====" + AL208);
    var apc =
      (AW57 +
        Math.max(
          parseFloat(AG158_AL162_AG164_AL165),
          parseFloat(AM158_AQ162_AM164_AQ165)
        ) +
        parseFloat(AL208)) /
      AW56;
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },

  autoLoanAndLineOfCredit: function (cmp) {
    /* After Proposed Credit(s)=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        $AU$156:$AV$170 =IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AA$216)/$AW$56,0)
        */

    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //GrossMonthlyIncome
    var AW57 = 0; //ExistingMonthlyCreditPayment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;

    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc =
      (AW57 +
        Math.max(
          parseFloat(AG158_AL162_AG164_AL165),
          parseFloat(AM158_AQ162_AM164_AQ165)
        ) +
        parseFloat(AA216)) /
      AW56;
    apc = apc * 100;
    console.log("apc====" + apc);
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  unsecuredLoanAndCreditCard: function (cmp) {
    /*After Proposed Credit(s) =IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
     * $AU$156:$AV$170=IFERROR(SUM($AW$57,$AG$191,$AL$208)/$AW$56,0)
     *
     */

    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //Gross Monthly Income
    var AW57 = 0; //Existing Monthly Credit Payment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }
    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);
    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);

    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc = (parseFloat(AW57) + parseFloat(AG191) + parseFloat(AL208)) / AW56;
    apc = apc * 100;
    apc = this.checkNaN(apc);
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    //=IFERROR($AW$57/$AW$56,0)

    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);
  },
  unsecuredLoanAndLineOfCredit: function (cmp) {
    /*After Proposed Credit(s) =IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
     * $AU$156:$AV$170 = =IFERROR(SUM($AW$57,$AG$191,$AA$216)/$AW$56,0)
     *
     */

    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //Gross Monthly Income
    var AW57 = 0; //Existing Monthly Credit Payment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }
    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc = (parseFloat(AW57) + parseFloat(AG191) + parseFloat(AA216)) / AW56;
    apc = apc * 100;
    apc = this.checkNaN(apc);
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    //=IFERROR($AW$57/$AW$56,0)

    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);
  },
  creditCardAndLineOfCredit: function (cmp) {
    /* //=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        $AU$156:$AV$170 =IFERROR(SUM($AW$57,$AL$208,$AA$216)/$AW$56,0)
        $AW$57 = =SUM($AI$56:$AM$58) // Existing Monthly Credit Payment
        $AL$208 = Minimum Payment as per Credit Limit (Credit card)								
		$AA$216 = Minimum Payment as per Credit Limit	(Line of Credit)							
		$AW$56 = =SUM($AB$56:$AF$58) //Gross Monthly Income     
        */

    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;
    var EmpRow = cmp.get("v.RowNum");
    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");
    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc = (parseFloat(AW57) + parseFloat(AL208) + parseFloat(AA216)) / AW56;
    apc = apc * 100;
    apc = this.checkNaN(apc);
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    //=IFERROR($AW$57/$AW$56,0)

    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);
  },
  autoLoanUnsecuredLoanAndCreditCard: function (cmp) {
    /*After Proposed Credit(s)=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        $AU$156:$AV$170 =IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AG$191,$AL$208)/$AW$56,0)
        */

    var EmpRow = cmp.get("v.RowNum");
    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;

    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    console.log("GrossMonthlyIncome====" + GrossMonthlyIncome);
    console.log(
      "ExistingMonthlyCreditPayment====" + ExistingMonthlyCreditPayment
    );

    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    console.log("AW56====" + AW56);
    console.log("AW57====" + AW57);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);

    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);
    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value"); //Monthly Loan Payment
    console.log("AG191====" + AG191);

    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);
    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc =
      (parseFloat(AW57) +
        parseFloat(Math.max(AG158_AL162_AG164_AL165, AM158_AQ162_AM164_AQ165)) +
        parseFloat(AG191) +
        parseFloat(AL208)) /
      parseFloat(AW56);
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  autoLoanUnsecuredLoanAndLineOfCredit: function (cmp) {
    /*After Proposed Credit(s) =IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        $AU$156:$AV$170=IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AG$191,$AA$216)/$AW$56,0)
        */

    var EmpRow = cmp.get("v.RowNum");
    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;

    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    console.log("GrossMonthlyIncome====" + GrossMonthlyIncome);
    console.log(
      "ExistingMonthlyCreditPayment====" + ExistingMonthlyCreditPayment
    );

    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    console.log("AW56====" + AW56);
    console.log("AW57====" + AW57);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);

    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);
    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value"); //Monthly Loan Payment
    console.log("AG191====" + AG191);

    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc =
      (parseFloat(AW57) +
        parseFloat(Math.max(AG158_AL162_AG164_AL165, AM158_AQ162_AM164_AQ165)) +
        parseFloat(AG191) +
        parseFloat(AA216)) /
      AW56;
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  autoLoanCreditCardAndLineOfCredit: function (cmp) {
    /*
        =IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AL$208,$AA$216)/$AW$56,0)
        */
    console.log("autoLoanCreditCardAndLineOfCredit==============");
    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //Gross Monthly Income
    var AW57 = 0; //Existing Monthly Credit Payment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);
    console.log("AG158_AL162==" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165==" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165==" + AG158_AL162_AG164_AL165);
    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162==" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");

    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165==" + AM164_AQ165);
    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165==" + AM158_AQ162_AM164_AQ165);

    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");
    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");
    console.log("AL208==" + AL208);
    console.log("AA216==" + AA216);

    //=IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AL$208,$AA$216)/$AW$56,0)
    var apc =
      (parseFloat(AW57) +
        Math.max(AG158_AL162_AG164_AL165, AM158_AQ162_AM164_AQ165) +
        parseFloat(AL208) +
        parseFloat(AA216)) /
      AW56;
    console.log("apc==" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  },
  unsecuredLoanCreditCardAndLineOfCredit: function (cmp) {
    /*=IFERROR(SUM($AW$57,$AG$191,$AL$208,$AA$216)/$AW$56,0)
     */

    var EmpRow = cmp.get("v.RowNum");
    var AW56 = 0; //Gross Monthly Income
    var AW57 = 0; //Existing Monthly Credit Payment
    for (var k in EmpRow) {
      AW56 += parseFloat(EmpRow[k].GMIncome);
      AW57 += parseFloat(EmpRow[k].EMCPayment);
    }
    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);
    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);

    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");
    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc =
      (parseFloat(AW57) +
        parseFloat(AG191) +
        parseFloat(AL208) +
        parseFloat(AA216)) /
      parseFloat(AW56);
    apc = apc * 100;
    apc = this.checkNaN(apc);
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    //=IFERROR($AW$57/$AW$56,0)

    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);
  },
  autoLoanUnsecuredLoanCreditCardAndLineOfCredit: function (cmp) {
    /*=IFERROR(SUM($AW$57,MAX(SUM($AG$158:$AL$162,$AG$164:$AL$165),SUM($AM$158:$AQ$162,$AM$164:$AQ$165)),$AG$191,$AL$208,$AA$216)/$AW$56,0)
     */

    var EmpRow = cmp.get("v.RowNum");
    var GrossMonthlyIncome = 0;
    var ExistingMonthlyCreditPayment = 0;

    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    console.log("GrossMonthlyIncome====" + GrossMonthlyIncome);
    console.log(
      "ExistingMonthlyCreditPayment====" + ExistingMonthlyCreditPayment
    );

    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    console.log("AW56====" + AW56);
    console.log("AW57====" + AW57);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN11"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN21"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN31"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium1"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees1"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentMarket2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN12"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN22"), 0);
    this.SetDefaultVal(cmp.find("MonthlyLoanPaymentJN32"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNGIMotorPremium1stYear2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyJNLifeCreditorLifePremium2"), 0);
    this.SetDefaultVal(cmp.find("MonthlyProcessingFees2"), 0);

    this.SetDefaultVal(cmp.find("MonthlyLoanPayment1Un"), 0);
    this.SetDefaultVal(cmp.find("locMinimumPaymentAsPerCreditLimit"), 0);
    this.SetDefaultVal(cmp.find("ccMinimumPaymentAsPerCreditLimit"), 0);

    var MonthlyLoanPaymentMarketDuring = cmp
      .find("MonthlyLoanPaymentMarket1")
      .get("v.value");
    var MonthlyLoanPaymentJNS1During = cmp
      .find("MonthlyLoanPaymentJN11")
      .get("v.value");
    var MonthlyLoanPaymentJNS2During = cmp
      .find("MonthlyLoanPaymentJN21")
      .get("v.value");
    var MonthlyLoanPaymentJNS3During = cmp
      .find("MonthlyLoanPaymentJN31")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYruring = cmp
      .find("MonthlyJNGIMotorPremium1stYear1")
      .get("v.value");
    var AG158_AL162 =
      parseFloat(MonthlyLoanPaymentMarketDuring) +
      parseFloat(MonthlyLoanPaymentJNS1During) +
      parseFloat(MonthlyLoanPaymentJNS2During) +
      parseFloat(MonthlyLoanPaymentJNS3During) +
      parseFloat(MonthlyJNGIMotorPremium1stYruring);

    console.log("AG158_AL162====" + AG158_AL162);

    var MonthlyJNLifeCreditorLifePremiumDuring = cmp
      .find("MonthlyJNLifeCreditorLifePremium1")
      .get("v.value");
    var MonthlyProcessingFeesDuring = cmp
      .find("MonthlyProcessingFees1")
      .get("v.value");
    var AG164_AL165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumDuring) +
      parseFloat(MonthlyProcessingFeesDuring);
    console.log("AG164_AL165====" + AG164_AL165);

    var AG158_AL162_AG164_AL165 = AG158_AL162 + AG164_AL165;
    console.log("AG158_AL162_AG164_AL165====" + AG158_AL162_AG164_AL165);

    var MonthlyLoanPaymentMarketAfter = cmp
      .find("MonthlyLoanPaymentMarket2")
      .get("v.value");
    var MonthlyLoanPaymentJNS1After = cmp
      .find("MonthlyLoanPaymentJN12")
      .get("v.value");
    var MonthlyLoanPaymentJNS2After = cmp
      .find("MonthlyLoanPaymentJN22")
      .get("v.value");
    var MonthlyLoanPaymentJNS3After = cmp
      .find("MonthlyLoanPaymentJN32")
      .get("v.value");
    var MonthlyJNGIMotorPremium1stYrAfter = cmp
      .find("MonthlyJNGIMotorPremium1stYear2")
      .get("v.value");
    var AM158_AQ162 =
      parseFloat(MonthlyLoanPaymentMarketAfter) +
      parseFloat(MonthlyLoanPaymentJNS1After) +
      parseFloat(MonthlyLoanPaymentJNS2After) +
      parseFloat(MonthlyLoanPaymentJNS3After) +
      parseFloat(MonthlyJNGIMotorPremium1stYrAfter);
    console.log("AM158_AQ162====" + AM158_AQ162);

    var MonthlyJNLifeCreditorLifePremiumAfter = cmp
      .find("MonthlyJNLifeCreditorLifePremium2")
      .get("v.value");
    var MonthlyProcessingFeesAfter = cmp
      .find("MonthlyProcessingFees2")
      .get("v.value");
    //var AG158_AL162 = parseFloat()+parseFloat()+parseFloat()+parseFloat()+parseFloat();
    var AM164_AQ165 =
      parseFloat(MonthlyJNLifeCreditorLifePremiumAfter) +
      parseFloat(MonthlyProcessingFeesAfter);
    console.log("AM164_AQ165====" + AM164_AQ165);

    var AM158_AQ162_AM164_AQ165 = AM158_AQ162 + AM164_AQ165;
    console.log("AM158_AQ162_AM164_AQ165====" + AM158_AQ162_AM164_AQ165);
    var AG191 = cmp.find("MonthlyLoanPayment1Un").get("v.value"); //Monthly Loan Payment
    console.log("AG191====" + AG191);

    var AL208 = cmp.find("ccMinimumPaymentAsPerCreditLimit").get("v.value");
    var AA216 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");

    var apc =
      (parseFloat(AW57) +
        parseFloat(Math.max(AG158_AL162_AG164_AL165, AM158_AQ162_AM164_AQ165)) +
        parseFloat(AG191) +
        parseFloat(AL208) +
        parseFloat(AA216)) /
      parseFloat(AW56);
    console.log("apc====" + apc);
    apc = apc * 100;
    cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2) + "%");

    var Admin_TablesBJ7 = "50%";
    cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);

    //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
    var PriortoProposedCredit = parseFloat(AW57) / parseFloat(AW56);
    PriortoProposedCredit = PriortoProposedCredit * 100;
    PriortoProposedCredit = this.checkNaN(PriortoProposedCredit);
    PriortoProposedCredit = PriortoProposedCredit.toFixed(2) + "%";
    cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);
  }
});
