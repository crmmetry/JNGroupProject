({
  doInit: function (cmp, event, helper) {
    $A.enqueueAction(cmp.get("c.Createapplicantlist"));
    cmp.set("v.IsExistingLoan", false);
    cmp.set("v.AutoMarketCurrency", "JMD");
    $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
    $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
    $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
    $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
    $A.util.addClass(cmp.find("CalculationSection"), "slds-hide");
    $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
    $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
    $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
    $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
    $A.util.addClass(cmp.find("Total"), "slds-hide");
  },
  PrindPage: function (cmp, event, helper) {
    window.print();
  },
  Createapplicantlist: function (cmp, event, helper) {
    var ApplicantRow = [
      {
        Id: 1,
        FirstName: "",
        LastName: "",
        DateOfBirth: "",
        GMIncome: "",
        EMCPayment: "",
        IsJNEmployee: false
      }
    ];
    cmp.set("v.RowNum", ApplicantRow);
    cmp.find("NumberofApplicant").set("v.value", "0");
  },
  updateRequestdetail: function (cmp, event, helper) {
    var childCmp = cmp.find("AutoLoanchild");
    const param1 = cmp.get("v.RowNum");
    childCmp.CallRequestDetails(param1);
    for (var k in param1) {
      if (param1[k].Id == 1 && param1[k].IsJNEmployee) {
        $A.util.removeClass(cmp.find("JNstaff1"), "slds-hide");
        $A.util.removeClass(cmp.find("JNstaff1Un"), "slds-hide");
      }
      if (param1[k].Id == 2 && param1[k].IsJNEmployee) {
        $A.util.removeClass(cmp.find("JNstaff2"), "slds-hide");
        $A.util.removeClass(cmp.find("JNstaff2Un"), "slds-hide");
      }
      if (param1[k].Id == 3 && param1[k].IsJNEmployee) {
        $A.util.removeClass(cmp.find("JNstaff3"), "slds-hide");
        $A.util.removeClass(cmp.find("JNstaff3Un"), "slds-hide");
      }
      if (param1[k].Id == 1 && param1[k].IsJNEmployee == false) {
        $A.util.addClass(cmp.find("JNstaff1"), "slds-hide");
        $A.util.addClass(cmp.find("JNstaff1Un"), "slds-hide");
      }
      if (param1[k].Id == 2 && param1[k].IsJNEmployee == false) {
        $A.util.addClass(cmp.find("JNstaff2"), "slds-hide");
        $A.util.addClass(cmp.find("JNstaff2Un"), "slds-hide");
      }
      if (param1[k].Id == 3 && param1[k].IsJNEmployee == false) {
        $A.util.addClass(cmp.find("JNstaff3"), "slds-hide");
        $A.util.addClass(cmp.find("JNstaff3Un"), "slds-hide");
      }
    }
    var acMethod = cmp.find("selectapplicant").get("v.value");
    switch (acMethod) {
      case "2":
      case "8":
      case "9":
      case "14":
        $A.enqueueAction(cmp.get("c.addrowdatarequestDetail"));
        break;
    }

    $A.enqueueAction(cmp.get("c.ApplicantDetailsChange"));
  },
  Requestdetaileventhandler: function (cmp, event, helper) {
    var RequestData = event.getParam("RequestData");
    cmp.set("v.RDetailAuto", RequestData);
    var loanterm =
      Number(RequestData[0].LoanTerm1 * 12) + Number(RequestData[0].LoanTerm2);
    cmp.set("v.LoanTermMarket", loanterm);
    for (var k in RequestData) {
      var i = RequestData[k].Interestrate;
      var im = RequestData[k].Interestrate / 1200;
      console.log("im========" + im);
      var n =
        Number(RequestData[k].LoanTerm1 * 12) +
        Number(RequestData[k].LoanTerm2);
      var p = RequestData[k].LoanAmount;
      console.log("imp========" + p);
      console.log("n=====" + n);
      var bmla = helper.PMTcalculator(i, n, p);
      console.log("n=====" + bmla);
      if (RequestData[k].colIndex == "Market") {
        console.log("n1=====1");
        cmp.set("v.LoanamountMarketAutoloan", RequestData[k].LoanAmount);
        /*if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==1){
                    if(isNaN(bmla)==false){
                        cmp.set("v.BMLoanamountMarketAutoloan", bmla);
                        cmp.set("v.LoanamountMarketAutoloannew", bmla.toFixed(2));
                    }
                }*/
        //----------moratorium-----------
        /* IF(AND(M-y,I-P,T-1),AmortizationSC1!$C$12,
                  IF(AND(M-y,I-P,T-2),MAX(AmortizationSC1!$C$12:$C$13),
                  IF(AND(M-y,I-P, T-3),MAX(AmortizationSC1!$C$12:$C$14),
                  IF(AND(M-y,I-P&I),0,PMT($F$89/12,SUM($L$89*12,$O$89),-$M$158)))))
                */
        var AmortizationSC1C12 = 0;
        if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 1 &&
          (cmp.find("IndicateTerm").get("v.value") == 1 ||
            cmp.find("IndicateTerm").get("v.value") == 2 ||
            cmp.find("IndicateTerm").get("v.value") == 3)
        ) {
          AmortizationSC1C12 = im * p;
          cmp.set("v.BMLoanamountMarketAutoloan", AmortizationSC1C12);
          cmp.set(
            "v.LoanamountMarketAutoloannew",
            AmortizationSC1C12.toFixed(2)
          );
        } else if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 2
        ) {
          var a = 0;
          cmp.set("v.BMLoanamountMarketAutoloan", a);
          cmp.set("v.LoanamountMarketAutoloannew", a.toFixed(2));
        } else {
          cmp.set("v.BMLoanamountMarketAutoloan", bmla);
          cmp.set("v.LoanamountMarketAutoloannew", bmla.toFixed(2));
        }
        /*IF(AND(M-y,I-P&I,O-ori ,T-1),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$158,AmortizationSC1!$C$12)),
              IF(AND(M-y,I-P&I,O-ori ,T-2),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$158,AmortizationSC1!$C$12:$C$13)),
              IF(AND(M-y,I-P&I,O-ori ,T-3 ),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-SUM($M$158,AmortizationSC1!$C$12:$C$14)),
             IF(AND(M-y,I-P  ,O-ori ),PMT($F$89/12,SUM($L$89*12,$O$89)-$AI$78,-$M$158),
             IF(AND(M-y,I-P&I,O-Eori,T-1),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$158,AmortizationSC1!$C$12)),
             IF(AND(M-y,I-P&I,O-Eori,T-2),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$158,AmortizationSC1!$C$12:$C$13)),
             IF(AND(M-y,I-P&I,O-Eori,T-3),PMT($F$89/12,SUM($L$89*12,$O$89),-SUM($M$158,AmortizationSC1!$C$12:$C$14)),
             IF(AND(M-y,I-P  ,O-Eori),PMT($F$89/12,SUM($L$89*12,$O$89),-$M$158),0))))))))*/

        if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 2 &&
          cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1
        ) {
          var n1 = n - cmp.find("IndicateTerm").get("v.value");
          var AmortizationSC1C121 =
            im * p * cmp.find("IndicateTerm").get("v.value");
          var p1 = Number(p) + Number(AmortizationSC1C121);
          var amla = 0;
          amla = helper.PMTcalculator(i, n1, p1);
          if (isNaN(amla) == false) {
            cmp.set("v.AMLoanamountMarketAutoloan", amla);
            cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
          }
        }
        if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 1 &&
          cmp.find("Otherpostmoratoriumoptions").get("v.value") == 1
        ) {
          var n1 = n - cmp.find("IndicateTerm").get("v.value");
          var amla = 0;
          amla = helper.PMTcalculator(i, n1, p);
          if (isNaN(amla) == false) {
            cmp.set("v.AMLoanamountMarketAutoloan", amla);
            cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
          }
        }
        if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 2 &&
          cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2
        ) {
          var AmortizationSC1C122 =
            im * p * cmp.find("IndicateTerm").get("v.value");
          var p1 = Number(p) + Number(AmortizationSC1C122);
          var amla = 0;
          amla = helper.PMTcalculator(i, n, p1);
          if (isNaN(amla) == false) {
            cmp.set("v.AMLoanamountMarketAutoloan", amla);
            cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
          }
        }
        if (
          cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == 0 &&
          cmp.find("IndicateType").get("v.value") == 1 &&
          cmp.find("Otherpostmoratoriumoptions").get("v.value") == 2
        ) {
          var amla = 0;
          amla = helper.PMTcalculator(i, n, p);
          if (isNaN(amla) == false) {
            cmp.set("v.AMLoanamountMarketAutoloan", amla);
            cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
          }
        }
        //--------------------------------
      }
      if (RequestData[k].colIndex == "JN Staff 1") {
        var ijn1 = RequestData[k - 1].Interestrate;
        var njn1 =
          Number(RequestData[k - 1].LoanTerm1 * 12) +
          Number(RequestData[k - 1].LoanTerm2);
        var pjn1 = RequestData[k].LoanAmount;
        var bmlajn1 = helper.PMTcalculator(ijn1, njn1, pjn1);
        cmp.set("v.LoanamountJNStaff1Autoloan", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff1Autoloan", bmlajn1);
          //cmp.set("v.LoanamountJNStaff1Autoloannew", bmlajn1.toFixed(2));
          cmp.find("MonthlyLoanPaymentJN11").set("v.value", bmlajn1.toFixed(2));
          cmp.set("v.MonthlyLoanPaymentJN12New", bmlajn1);
          cmp.find("MonthlyLoanPaymentJN12").set("v.value", bmlajn1.toFixed(2));
        }
      }
      if (RequestData[k].colIndex == "JN Staff 2") {
        var ijn2 = RequestData[k - 1].Interestrate;
        var njn2 =
          Number(RequestData[k - 1].LoanTerm1 * 12) +
          Number(RequestData[k - 1].LoanTerm2);
        var pjn2 = RequestData[k].LoanAmount;
        var bmlajn2 = helper.PMTcalculator(ijn2, njn2, pjn2);
        cmp.set("v.LoanamountJNStaff2Autoloan", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff2Autoloan", bmlajn2);
          //cmp.set("v.LoanamountJNStaff2Autoloannew", bmlajn2.toFixed(2));
          cmp.find("MonthlyLoanPaymentJN21").set("v.value", bmlajn2.toFixed(2));
          cmp.set("v.MonthlyLoanPaymentJN22New", bmlajn2);
          cmp.find("MonthlyLoanPaymentJN22").set("v.value", bmlajn2.toFixed(2));
        }
      }
      if (RequestData[k].colIndex == "JN Staff 3") {
        var ijn3 = RequestData[k - 1].Interestrate;
        var njn3 =
          Number(RequestData[k - 1].LoanTerm1 * 12) +
          Number(RequestData[k - 1].LoanTerm2);
        var pjn3 = RequestData[k].LoanAmount;
        var bmlajn3 = helper.PMTcalculator(ijn3, njn3, pjn3);
        cmp.set("v.LoanamountJNStaff3Autoloan", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff3Autoloan", bmlajn3);
          //cmp.set("v.LoanamountJNStaff3Autoloannew", bmlajn3.toFixed(2));
          cmp.find("MonthlyLoanPaymentJN31").set("v.value", bmlajn3.toFixed(2));
          cmp.set("v.MonthlyLoanPaymentJN32New", bmlajn3);
          cmp.find("MonthlyLoanPaymentJN32").set("v.value", bmlajn3.toFixed(2));
        }
      }
    }

    helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
    helper.calculateProcessingFeehelper(cmp, event);
    helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
    helper.calculateTotalautoloan(cmp, event);
  },
  addrowdatarequestDetail: function (cmp, event, helper) {
    const RDetailUnsecured = cmp.get("v.RDetailUnsecured");
    var param1 = cmp.get("v.RowNum");
    for (var k in param1) {
      var EmpRowstr = JSON.stringify(RDetailUnsecured);
      var str = "JN Staff " + param1[k].Id;
      if (
        param1[k].Id == 1 &&
        param1[k].IsJNEmployee &&
        !EmpRowstr.includes(str)
      ) {
        helper.AddRowRequestDetail(param1[k].Id, RDetailUnsecured, cmp);
      }
      if (
        param1[k].Id == 2 &&
        param1[k].IsJNEmployee &&
        !EmpRowstr.includes(str)
      ) {
        helper.AddRowRequestDetail(param1[k].Id, RDetailUnsecured, cmp);
      }
      if (
        param1[k].Id == 3 &&
        param1[k].IsJNEmployee &&
        !EmpRowstr.includes(str)
      ) {
        helper.AddRowRequestDetail(param1[k].Id, RDetailUnsecured, cmp);
      }
      if (
        param1[k].Id == 1 &&
        !param1[k].IsJNEmployee &&
        EmpRowstr.includes(str)
      ) {
        helper.RemoveRowRequestDetail(param1[k].Id, 1, RDetailUnsecured, cmp);
      }
      if (
        param1[k].Id == 2 &&
        !param1[k].IsJNEmployee &&
        EmpRowstr.includes(str)
      ) {
        helper.RemoveRowRequestDetail(param1[k].Id, 1, RDetailUnsecured, cmp);
      }
      if (
        param1[k].Id == 3 &&
        !param1[k].IsJNEmployee &&
        EmpRowstr.includes(str)
      ) {
        helper.RemoveRowRequestDetail(param1[k].Id, 1, RDetailUnsecured, cmp);
      }
    }
  },
  calculateJNLifeMonthlyPremium: function (cmp, event, helper) {
    console.log("c1==");
    debugger;
    helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
    helper.calculateTotalautoloan(cmp, event);
  },
  calculateJNGIMonthlyPremium: function (cmp, event, helper) {
    console.log("c1==");
    helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
    helper.calculateTotalautoloan(cmp, event);
  },
  calculateProcessingFee: function (cmp, event, helper) {
    helper.calculateProcessingFeehelper(cmp, event);
    helper.calculateTotalautoloan(cmp, event);
  },
  calculateLoansaving: function (cmp, event, helper) {
    // console.log('==================1');
    //var currentEvt = event.currentTarget;
    //console.log('==================2='+currentEvt);
    // var data_Value = event.getSource().get("v.name");   //.dataset.value;
    // console.log('=================='+data_Value);

    var amount = cmp.find("ProposedSavings5").get("v.value");
    var percentage = cmp.find("ProposedSavings1").get("v.value");
    console.log("percentage ----------" + percentage);
    console.log("amount ----------" + amount);
    if (percentage != "") {
      cmp.set("v.disabledPSP", false);
      cmp.set("v.disabledPSA", true);
    } else if (amount != "") {
      console.log("NUll ----------");
      cmp.set("v.disabledPSP", true);
      cmp.set("v.disabledPSA", false);
    } else if (percentage == "" && amount == "") {
      console.log("Both NUll ----------");
      cmp.set("v.disabledPSP", false);
      cmp.set("v.disabledPSA", false);

      // if(data_Value=='Proposed Savings'){
      //cmp.set('v.ReqPSP',true);
      //    var inputCmp = cmp.find("ProposedSavings5");
      //    console.log('Both NUll ----------1='+inputCmp);
      //     inputCmp.set("v.errors", [{message:"This field is required!"}]);
      //}
    }

    helper.calculateTotalautoloan(cmp, event);
  },
  OnChangeclear: function (cmp, event, helper) {
    cmp.find("PolicyLimit").set("v.value", "");
    cmp.find("PriortoProposedCredit").set("v.value", "");
    cmp.find("AfterProposedCredit").set("v.value", "");
    cmp.set("v.applicant1age", false);
    cmp.set("v.applicant2age", false);
    cmp.set("v.applicant3age", false);
    cmp.set("v.AutoMarketCurrency", "JMD");

    $A.util.addClass(cmp.find("IndicateType"), "slds-hide");
    $A.util.addClass(cmp.find("IndicateTerm"), "slds-hide");
    $A.util.addClass(cmp.find("IndicateTerm1"), "slds-hide");
    $A.util.addClass(cmp.find("IncludeinLoanAmountfee"), "slds-hide");
    $A.util.addClass(cmp.find("Indicateapplicableprocessingfees"), "slds-hide");
    $A.util.addClass(cmp.find("CoverageType"), "slds-hide");
    $A.util.addClass(cmp.find("IncludeinLoanAmountinsurence"), "slds-hide");
    $A.util.addClass(
      cmp.find("Include1stYearPremiuminLoanAmount"),
      "slds-hide"
    );
    $A.util.addClass(cmp.find("MonthlyPremium"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff1"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff2"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff3"), "slds-hide");
    $A.util.addClass(cmp.find("JNGIMotorPremium"), "slds-hide");
    $A.util.addClass(cmp.find("JNGIMotorPremium1"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifecal"), "slds-hide");
    $A.util.addClass(cmp.find("ProcessingFeescal"), "slds-hide");
    $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifeCreditorInsurancePremium"), "slds-hide");
    $A.util.addClass(cmp.find("ProcessingFeesGCT"), "slds-hide");
    $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifeCreditorInsurancePremium1"), "slds-hide");
    $A.util.addClass(cmp.find("ProcessingFeesGCT1"), "slds-hide");
    $A.util.addClass(cmp.find("AfterMoratoriumhead"), "slds-hide");
    $A.util.addClass(cmp.find("DuringMoratoriumhead"), "slds-hide");
    $A.util.addClass(cmp.find("Otherpostmoratoriumoptions"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPaymentMarket2"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPaymentJN12"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPaymentJN22"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPaymentJN32"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyJNGIMotorPremium1stYear2"), "slds-hide");
    $A.util.addClass(
      cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),
      "slds-hide"
    );
    $A.util.addClass(
      cmp.find("MonthlyJNLifeCreditorLifePremium2"),
      "slds-hide"
    );
    $A.util.addClass(cmp.find("MonthlyProcessingFees2"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPayment2"), "slds-hide");
    $A.util.addClass(cmp.find("MonthlyLoanPaymentsaving2"), "slds-hide");

    $A.util.addClass(cmp.find("OtherPurpose"), "slds-hide");
    $A.util.addClass(cmp.find("IncludeinLoanAmountfeeUn"), "slds-hide");
    $A.util.addClass(
      cmp.find("IndicateapplicableprocessingfeesUn"),
      "slds-hide"
    );
    $A.util.addClass(cmp.find("ProcessingFeescalUn"), "slds-hide");
    $A.util.addClass(cmp.find("CoverageTypeUn"), "slds-hide");
    $A.util.addClass(cmp.find("IncludeinLoanAmountinsurenceUn"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifecalUn"), "slds-hide");
    $A.util.addClass(cmp.find("ProcessingFeescalUn"), "slds-hide");
    $A.util.addClass(cmp.find("ProcessingUn"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifecalUn"), "slds-hide");
    $A.util.addClass(cmp.find("JNLifeCreditorUn"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff1Un"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff2Un"), "slds-hide");
    $A.util.addClass(cmp.find("JNstaff3Un"), "slds-hide");
  },
  ApplicantSelectionChange: function (cmp, event, helper) {
    var rowVal = cmp.find("NumberofApplicant").get("v.value");
    if (rowVal == 0) {
      const EmpRow = cmp.get("v.RowNum");
      if (EmpRow.length == 3) {
        helper.RemoveRow(1, 2, EmpRow, cmp);
      } else if (EmpRow.length == 2) {
        helper.RemoveRow(1, 1, EmpRow, cmp);
      }
    } else if (rowVal == 1) {
      const EmpRow = cmp.get("v.RowNum");
      if (EmpRow.length == 1) {
        helper.AddRow(2, EmpRow, cmp);
      } else if (EmpRow.length == 3) {
        helper.RemoveRow(2, 1, EmpRow, cmp);
      }
    } else if (rowVal == 2) {
      const EmpRow = cmp.get("v.RowNum");
      if (EmpRow.length == 2) {
        helper.AddRow(3, EmpRow, cmp);
      } else if (EmpRow.length == 1) {
        helper.AddRow(2, EmpRow, cmp);
        helper.AddRow(3, EmpRow, cmp);
      }
    }
  },
  SetMotorVehicleDeposit: function (cmp, evt, helper) {
    if (cmp.find("LoanPurpose").get("v.value") == "1") {
      var amount = cmp.find("PurchasePriceofVehicle").get("v.value");
      var percentage = cmp.find("MotorVehicleDeposit").get("v.value");
      if (amount != null && percentage != null) {
        var val = (amount * percentage) / 100;
        if (val > 0) cmp.set("v.MarketValueofVehicleA", val);
        else cmp.set("v.MarketValueofVehicleA", "");
      } else cmp.set("v.MarketValueofVehicleA", "");

      if (percentage != "") {
        cmp.set("v.disabledA", true);
        //cmp.set("v.ReqA", false);
        //cmp.set("v.ReqP", true);
        cmp.find("MotorVehicleDeposit4").set("v.value", "");
        //$A.util.removeClass(cmp.find("PurchasePriceofVehicle"),"slds-has-error");
      } else {
        console.log("NUll ----------");
        cmp.set("v.disabledA", false);
        //cmp.set("v.ReqA", false);
        //cmp.set("v.ReqP", true);
      }
    }
  },
  hidePersentage: function (cmp, evt, helper) {
    var amount = cmp.find("MotorVehicleDeposit4").get("v.value");
    if (amount != "") {
      cmp.set("v.disabledP", true);
      //cmp.set("v.ReqA", true);
      //cmp.set("v.ReqP", false);
      cmp.find("MotorVehicleDeposit").set("v.value", "");
      //$A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-has-error");
    } else {
      console.log("NUll ----------");
      cmp.set("v.disabledP", false);
      //cmp.set("v.ReqA", false);
      //cmp.set("v.ReqP", true);
      //$A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-has-error");
    }
  },

  showhideCoverageType: function (cmp, evt, helper) {
    cmp.set("v.applicant1age", false);
    cmp.set("v.applicant2age", false);
    cmp.set("v.applicant3age", false);
    var param1 = cmp.get("v.RowNum");
    for (var k in param1) {
      var str = "JN Staff " + param1[k].Id;
      if (param1[k].Id == 1) {
        helper.Applicantagecalculation(
          cmp,
          param1[k].DateOfBirth,
          param1[k].Id
        );
      }
      if (param1[k].Id == 2) {
        helper.Applicantagecalculation(
          cmp,
          param1[k].DateOfBirth,
          param1[k].Id
        );
      }
      if (param1[k].Id == 3) {
        helper.Applicantagecalculation(
          cmp,
          param1[k].DateOfBirth,
          param1[k].Id
        );
      }
    }
  },
  ShowHideOnInterestedinprogramme: function (cmp, evt, helper) {
    var acMethod = cmp.find("Interestedinprogramme").get("v.value");
    switch (acMethod) {
      case "0":
        $A.util.removeClass(
          cmp.find("Include1stYearPremiuminLoanAmount"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("MonthlyPremium"), "slds-hide");
        $A.util.removeClass(cmp.find("JNGIMotorPremium"), "slds-hide");
        $A.util.removeClass(cmp.find("JNGIMotorPremium1"), "slds-hide");
        if (
          cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "1"
        ) {
          $A.util.removeClass(
            cmp.find("JNGIMotorInsurancePremium1st1"),
            "slds-hide"
          );
          $A.util.removeClass(
            cmp.find("JNGIMotorInsurancePremium1st"),
            "slds-hide"
          );
        }
        if (
          cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "0"
        ) {
          $A.util.addClass(
            cmp.find("JNGIMotorInsurancePremium1st1"),
            "slds-hide"
          );
          $A.util.addClass(
            cmp.find("JNGIMotorInsurancePremium1st"),
            "slds-hide"
          );
        }
        helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        break;
      case "1":
        $A.util.addClass(
          cmp.find("Include1stYearPremiuminLoanAmount"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("MonthlyPremium"), "slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorPremium"), "slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorPremium1"), "slds-hide");
        $A.util.addClass(
          cmp.find("JNGIMotorInsurancePremium1st1"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"), "slds-hide");
        helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        break;
    }
  },
  ShowHideOnInterestedinCreditorLife: function (cmp, evt, helper) {
    var acMethod = cmp.find("InterestedinCreditorLife").get("v.value");
    switch (acMethod) {
      case "0":
        $A.util.removeClass(cmp.find("CoverageType"), "slds-hide");
        $A.util.removeClass(
          cmp.find("IncludeinLoanAmountinsurence"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("JNLifecal"), "slds-hide");
        break;
      case "1":
        $A.util.addClass(cmp.find("CoverageType"), "slds-hide");
        $A.util.addClass(cmp.find("IncludeinLoanAmountinsurence"), "slds-hide");
        $A.util.addClass(cmp.find("JNLifecal"), "slds-hide");
        break;
    }
  },
  ShowHideOnWaiveProcessingFee: function (cmp, evt, helper) {
    var acMethod = cmp.find("WaiveProcessingFee").get("v.value");
    switch (acMethod) {
      case "1":
        $A.util.removeClass(cmp.find("IncludeinLoanAmountfee"), "slds-hide");
        $A.util.removeClass(
          cmp.find("Indicateapplicableprocessingfees"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("ProcessingFeescal"), "slds-hide");
        if (cmp.find("IncludeinLoanAmountfee").get("v.value") == "0") {
          $A.util.addClass(cmp.find("ProcessingFeesGCT"), "slds-hide");
          $A.util.addClass(cmp.find("ProcessingFeesGCT1"), "slds-hide");
        } else if (cmp.find("IncludeinLoanAmountfee").get("v.value") == "1") {
          $A.util.removeClass(cmp.find("ProcessingFeesGCT"), "slds-hide");
          $A.util.removeClass(cmp.find("ProcessingFeesGCT1"), "slds-hide");
          $A.util.addClass(cmp.find("ProcessingFeescal"), "slds-hide");
        }

        helper.calculateProcessingFeehelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        break;
      case "0":
        $A.util.addClass(cmp.find("IncludeinLoanAmountfee"), "slds-hide");
        $A.util.addClass(
          cmp.find("Indicateapplicableprocessingfees"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("ProcessingFeescal"), "slds-hide");
        helper.calculateProcessingFeehelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        break;
    }
  },
  ShowHideOnIncludeamoratoriumofloanrepayments: function (cmp, evt, helper) {
    helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
    helper.calculateProcessingFeehelper(cmp, event);
    helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
    helper.calculateTotalautoloan(cmp, event);
    var acMethod = cmp
      .find("Includeamoratoriumofloanrepayments")
      .get("v.value");
    switch (acMethod) {
      case "0":
        $A.util.removeClass(cmp.find("IndicateType"), "slds-hide");
        $A.util.removeClass(cmp.find("IndicateTerm"), "slds-hide");
        $A.util.removeClass(cmp.find("IndicateTerm1"), "slds-hide");
        $A.util.removeClass(cmp.find("AfterMoratoriumhead"), "slds-hide");
        $A.util.removeClass(cmp.find("DuringMoratoriumhead"), "slds-hide");
        $A.util.removeClass(
          cmp.find("Otherpostmoratoriumoptions"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("MonthlyLoanPaymentMarket2"), "slds-hide");
        $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN12"), "slds-hide");
        $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN22"), "slds-hide");
        $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN32"), "slds-hide");
        $A.util.removeClass(
          cmp.find("MonthlyJNGIMotorPremium1stYear2"),
          "slds-hide"
        );
        $A.util.removeClass(
          cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),
          "slds-hide"
        );
        $A.util.removeClass(
          cmp.find("MonthlyJNLifeCreditorLifePremium2"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("MonthlyProcessingFees2"), "slds-hide");
        $A.util.removeClass(cmp.find("MonthlyLoanPayment2"), "slds-hide");
        $A.util.removeClass(cmp.find("MonthlyLoanPaymentsaving2"), "slds-hide");
        $A.util.removeClass(cmp.find("JNLifecal"), "slds-hide");
        $A.util.removeClass(cmp.find("ProcessingFeescal"), "slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"), "slds-hide");
        $A.util.addClass(
          cmp.find("JNGIMotorInsurancePremium1st1"),
          "slds-hide"
        );

        break;
      case "1":
        $A.util.addClass(cmp.find("IndicateType"), "slds-hide");
        $A.util.addClass(cmp.find("IndicateTerm"), "slds-hide");
        $A.util.addClass(cmp.find("IndicateTerm1"), "slds-hide");
        $A.util.addClass(cmp.find("AfterMoratoriumhead"), "slds-hide");
        $A.util.addClass(cmp.find("DuringMoratoriumhead"), "slds-hide");
        $A.util.addClass(cmp.find("Otherpostmoratoriumoptions"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentMarket2"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN12"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN22"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN32"), "slds-hide");
        $A.util.addClass(
          cmp.find("MonthlyJNGIMotorPremium1stYear2"),
          "slds-hide"
        );
        $A.util.addClass(
          cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),
          "slds-hide"
        );
        $A.util.addClass(
          cmp.find("MonthlyJNLifeCreditorLifePremium2"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("MonthlyProcessingFees2"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPayment2"), "slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentsaving2"), "slds-hide");

        break;
    }
  },
  UpdateMarketCurrency: function (cmp, evt, helper) {
    var acMethod = cmp.find("MarketValueofVehicle").get("v.value");
    switch (acMethod) {
      case "0":
        cmp.set("v.AutoMarketCurrency", "");
        break;
      case "1":
        cmp.set("v.AutoMarketCurrency", "JMD");
        break;
      case "2":
        cmp.set("v.AutoMarketCurrency", "USD");
        break;
      case "3":
        cmp.set("v.AutoMarketCurrency", "CAD");
        break;
      case "4":
        cmp.set("v.AutoMarketCurrency", "GBP");
        break;
    }
  },
  showhideONLoanPurpose: function (cmp, evt, helper) {
    helper.calculateTotalautoloan(cmp, event);
    var acMethod = cmp.find("LoanPurpose").get("v.value");
    switch (acMethod) {
      case "0":
        cmp.set("v.IsExistingLoan", false);
        $A.util.addClass(cmp.find("LoanBalanceofVehicle"), "slds-hide");
        $A.util.removeClass(cmp.find("PurchasePriceofVehicle"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit1"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit2"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit3"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDepositCurr"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDepositor"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit4"), "slds-hide");
        break;
      case "1":
        cmp.set("v.IsExistingLoan", false);
        $A.util.addClass(cmp.find("LoanBalanceofVehicle"), "slds-hide");
        $A.util.removeClass(cmp.find("PurchasePriceofVehicle"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit1"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit2"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit3"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDepositCurr"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDepositor"), "slds-hide");
        $A.util.removeClass(cmp.find("MotorVehicleDeposit4"), "slds-hide");
        break;
      case "2":
        cmp.set("v.IsExistingLoan", true);
        $A.util.removeClass(cmp.find("LoanBalanceofVehicle"), "slds-hide");
        $A.util.addClass(cmp.find("PurchasePriceofVehicle"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit1"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit2"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit3"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDepositCurr"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDepositor"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit4"), "slds-hide");
        break;
      case "3":
        $A.util.addClass(cmp.find("LoanBalanceofVehicle"), "slds-hide");
        $A.util.addClass(cmp.find("PurchasePriceofVehicle"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit1"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit2"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit3"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDepositCurr"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDepositor"), "slds-hide");
        $A.util.addClass(cmp.find("MotorVehicleDeposit4"), "slds-hide");
        break;
    }
  },
  showhideONmethod: function (cmp, evt, helper) {
    var acMethod = cmp.find("selectapplicant").get("v.value");
    $A.enqueueAction(cmp.get("c.Createapplicantlist"));
    $A.enqueueAction(cmp.get("c.OnChangeclear"));
    switch (acMethod) {
      case "0":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.addClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        // $A.util.addClass(cmp.find("Total"),"slds-hide");

        break;
      case "1":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");

        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.addClass(
          cmp.find("JNGIMotorInsurancePremium1st1"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"), "slds-hide");
        break;
      case "2":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");

        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        break;
      case "3":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.util.addClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));

        break;
      case "4":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));

        break;
      case "5":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        break;
      case "6":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        break;
      case "7":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        break;
      case "8":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        break;
      case "9":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        break;
      case "10":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        break;
      case "11":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));

        break;
      case "12":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        break;
      case "13":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        break;
      case "14":
        $A.util.addClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        break;
      case "15":
        $A.util.removeClass(cmp.find("AutoLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoan"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCard"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCredit"), "slds-hide");
        $A.util.removeClass(cmp.find("CalculationSection"), "slds-hide");
        $A.util.removeClass(cmp.find("AutoLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("CreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("LineofCreditCalculations"), "slds-hide");
        $A.util.removeClass(cmp.find("NumberofApplicant"), "slds-hide");
        $A.util.removeClass(cmp.find("Total"), "slds-hide");
        $A.enqueueAction(cmp.get("c.CreditCardOnLoad"));
        $A.enqueueAction(cmp.get("c.LineOfCreditOnLoad"));
        $A.enqueueAction(cmp.get("c.RequestdetailUnsecured"));
        break;
    }
  },

  //=====Unsecured Loan==========
  RequestdetailUnsecured: function (cmp, event, helper) {
    console.log("usecured");
    var ApplicantRow = [
      {
        Id: 0,
        colIndex: "Market",
        Interestrate: "",
        LoanTerm1: "",
        LoanTerm2: "",
        LoanAmount: ""
      }
    ];
    cmp.set("v.RDetailUnsecured", ApplicantRow);
  },
  updateRequestdetailsUnsecured: function (cmp, event, helper) {
    var RequestData = cmp.get("v.RDetailUnsecured");
    var loanterm =
      Number(RequestData[0].LoanTerm1 * 12) + Number(RequestData[0].LoanTerm2);
    cmp.set("v.LoanTermMarketUn", loanterm);

    for (var k in RequestData) {
      var i = RequestData[k].Interestrate / 1200;
      var n =
        Number(RequestData[k].LoanTerm1 * 12) +
        Number(RequestData[k].LoanTerm2);
      var p = RequestData[k].LoanAmount;
      var bmla = -((i * p * Math.pow(1 + i, n)) / (1 - Math.pow(1 + i, n)));
      if (RequestData[k].colIndex == "Market") {
        cmp.set("v.LoanAmountMarket1UnNew", RequestData[k].LoanAmount);
        cmp
          .find("LoanAmountMarket1Un")
          .set("v.value", RequestData[k].LoanAmount);
        console.log("2=====");
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountMarketAutoloanUn", bmla);
          cmp.set("v.BMLoanamountMarketAutoloanUnNew", bmla.toFixed(2));
        }
      }
      if (RequestData[k].colIndex == "JN Staff 1") {
        cmp.set("v.LoanAmountJN11UnNew", RequestData[k].LoanAmount);
        cmp.find("LoanAmountJN11Un").set("v.value", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff1AutoloanUn", bmla);
          cmp.set("v.BMLoanamountJNStaff1AutoloanUnNew", bmla.toFixed(2));
        }
      }
      if (RequestData[k].colIndex == "JN Staff 2") {
        cmp.set("v.LoanAmountJN21UnNew", RequestData[k].LoanAmount);
        cmp.find("LoanAmountJN21Un").set("v.value", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff2AutoloanUn", bmla);
          cmp.set("v.BMLoanamountJNStaff2AutoloanUnNew", bmla.toFixed(2));
        }
      }
      if (RequestData[k].colIndex == "JN Staff 3") {
        cmp.set("v.LoanAmountJN31UnNew", RequestData[k].LoanAmount);
        cmp.find("LoanAmountJN31Un").set("v.value", RequestData[k].LoanAmount);
        if (isNaN(bmla) == false) {
          cmp.set("v.BMLoanamountJNStaff3AutoloanUn", bmla);
          cmp.set("v.BMLoanamountJNStaff3AutoloanUnNew", bmla.toFixed(2));
        }
      }
    }
    helper.calculateProcessingFeeUnsecuredhelper(cmp, event);
    helper.calculateJNLifeMonthlyPremiumUnsecuredhelper(cmp, event);
    helper.calculateTotalUnsecuredloan(cmp, event);
  },
  showhideONLoanPurposeUnsecured: function (cmp, evt, helper) {
    var acMethod = cmp.find("LoanPurposeUn").get("v.value");
    if (acMethod == "7")
      $A.util.removeClass(cmp.find("OtherPurpose"), "slds-hide");
    else $A.util.addClass(cmp.find("OtherPurpose"), "slds-hide");
  },
  ShowHideOnInterestedinCreditorLifeUnsecured: function (cmp, evt, helper) {
    helper.calculateJNLifeMonthlyPremiumUnsecuredhelper(cmp, event);
    helper.calculateTotalUnsecuredloan(cmp, event);
    var acMethod = cmp.find("InterestedinCreditorLifeUn").get("v.value");
    switch (acMethod) {
      case "0":
        $A.util.removeClass(cmp.find("CoverageTypeUn"), "slds-hide");
        $A.util.removeClass(
          cmp.find("IncludeinLoanAmountinsurenceUn"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("JNLifeCreditorUn"), "slds-hide");
        $A.util.removeClass(cmp.find("JNLifecalUn"), "slds-hide");

        break;
      case "1":
        $A.util.addClass(cmp.find("CoverageTypeUn"), "slds-hide");
        $A.util.addClass(
          cmp.find("IncludeinLoanAmountinsurenceUn"),
          "slds-hide"
        );
        $A.util.addClass(cmp.find("JNLifecalUn"), "slds-hide");
        $A.util.addClass(cmp.find("JNLifeCreditorUn"), "slds-hide");
        //$A.util.addclass(cmp.find("JNLifeCreditorUn"),"slds-hide");
        break;
    }
  },
  ShowHideOnWaiveProcessingFeeUnsecured: function (cmp, evt, helper) {
    helper.calculateProcessingFeeUnsecuredhelper(cmp, event);
    console.log("pavitUafter");
    helper.calculateTotalUnsecuredloan(cmp, event);
    console.log("pavitafter1");
    var acMethod = cmp.find("WaiveProcessingFeeUn").get("v.value");
    switch (acMethod) {
      case "1":
        $A.util.removeClass(cmp.find("IncludeinLoanAmountfeeUn"), "slds-hide");
        $A.util.removeClass(
          cmp.find("IndicateapplicableprocessingfeesUn"),
          "slds-hide"
        );
        //helper.calculateProcessingFeehelper(cmp, event);
        break;
      case "0":
        $A.util.addClass(cmp.find("IncludeinLoanAmountfeeUn"), "slds-hide");
        $A.util.addClass(
          cmp.find("IndicateapplicableprocessingfeesUn"),
          "slds-hide"
        );
        //helper.calculateProcessingFeehelper(cmp, event);
        break;
    }
  },
  calculateLoansavingUnsecured: function (cmp, evt, helper) {
    var amount = cmp.find("ProposedSavings5Un").get("v.value");
    var percentage = cmp.find("ProposedSavings1Un").get("v.value");
    console.log("percentage ----------" + percentage);
    console.log("amount ----------" + amount);
    if (percentage != "") {
      cmp.set("v.disabledPSP", false);
      cmp.set("v.disabledPSA", true);
    } else if (amount != "") {
      console.log("NUll ----------");
      cmp.set("v.disabledPSP", true);
      cmp.set("v.disabledPSA", false);
    } else if (percentage == "" && amount == "") {
      console.log("Both NUll ----------");
      cmp.set("v.disabledPSP", false);
      cmp.set("v.disabledPSA", false);
    }
    helper.calculateTotalUnsecuredloan(cmp, event);
  },

  //-----------common for Credit card and Line of Credit--------------------------------------
  ApplicantDetailsChange: function (cmp, evt, helper) {
    var acMethod = cmp.find("selectapplicant").get("v.value");
    console.log("ApplicantDetailsChange==>" + acMethod);
    switch (acMethod) {
      case "3":
        $A.enqueueAction(cmp.get("c.CreditCardCalculation"));
        break;
      case "4":
        $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
        break;
    }
  },
  //--------Credit Card calculation start -------------------------------------
  CreditCardOnLoad: function (cmp, evt, helper) {
    // $A.util.addClass(cmp.find("NumberofApplicant"),"slds-hide");
    // cmp.find("NumberofApplicant").set("v.value", "0");
    // $A.enqueueAction(cmp.get('c.ApplicantSelectionChange'));

    // $A.enqueueAction(cmp.get('c.ccSupplementaryApplicants'));
    // $A.enqueueAction(cmp.get('c.ccCollateralTypeChange'));
    console.log("CreditCardOnLoad==================N");
    $A.util.addClass(cmp.find("ccAnnualMembershipdiv"), "slds-hide");
    $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS"), "slds-hide");
    $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1"), "slds-hide");
  },
  ccSupplementaryApplicants: function (cmp, evt, helper) {
    var SupplementaryApplicants = cmp
      .find("ccNumberofSupplementaryApplicants")
      .get("v.value");
    console.log(
      "SupplementaryApplicants==================" + SupplementaryApplicants
    );
    switch (SupplementaryApplicants) {
      case "0":
        $A.util.addClass(cmp.find("ccAnnualMembershipdiv"), "slds-hide");
        break;
      case "1":
      case "2":
      case "3":
      case "4":
      case "5":
        $A.util.removeClass(cmp.find("ccAnnualMembershipdiv"), "slds-hide");
        break;
    }
  },
  ccCollateralTypeChange: function (cmp, evt, helper) {
    var type = cmp.find("ccCollateralType").get("v.value");
    console.log("Collateral Type==================" + type);
    switch (type) {
      case "0":
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS"), "slds-hide");
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1"), "slds-hide");
        $A.util.addClass(
          cmp.find("ccTotalExistingLoanBalanceCurrency"),
          "slds-hide"
        );
        $A.enqueueAction(cmp.get("c.CreditCardCalculation"));
        break;
      case "1":
        $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS"), "slds-hide");
        $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS1"), "slds-hide");
        $A.util.addClass(
          cmp.find("ccTotalExistingLoanBalanceCurrency"),
          "slds-hide"
        );
        cmp
          .find("ccIsthisAccounthypothecatedforanotherloan")
          .set("v.value", "0");
        $A.enqueueAction(cmp.get("c.cchypothecatedAccountChange"));
        break;
    }
  },
  cchypothecatedAccountChange: function (cmp, evt, helper) {
    var hypothecated = cmp
      .find("ccIsthisAccounthypothecatedforanotherloan")
      .get("v.value");
    if (hypothecated == "0") {
      $A.util.addClass(cmp.find("ccTotalExistingLoanBalance"), "slds-hide");
      $A.util.addClass(
        cmp.find("ccTotalExistingLoanBalanceCurrency"),
        "slds-hide"
      );
    } else {
      $A.util.removeClass(cmp.find("ccTotalExistingLoanBalance"), "slds-hide");
      $A.util.removeClass(
        cmp.find("ccTotalExistingLoanBalanceCurrency"),
        "slds-hide"
      );
    }
    cmp.find("ccTotalExistingLoanBalance").set("v.value", "");
    $A.enqueueAction(cmp.get("c.CreditCardCalculation"));
  },
  CreditCardCalculation: function (cmp, evt, helper) {
    var GrossMonthlyIncome = 0; //$AB$56
    var ExistingMonthlyCreditPayment = 0; //$AI$56 = EXISTING MONTHLY CREDIT PAYMENT
    var RequestedCreditLimit = cmp
      .find("ccRequestedCreditLimit")
      .get("v.value"); // $J$122
    var interestRate = cmp.find("ccInterestRate").get("v.value");
    var CollateralType = cmp.find("ccCollateralType").get("v.value");
    var SupplementaryApplicants = cmp
      .find("ccNumberofSupplementaryApplicants")
      .get("v.value");

    var isError = false;
    var EmpRow = cmp.get("v.RowNum");
    for (var k in EmpRow) {
      GrossMonthlyIncome = EmpRow[k].GMIncome;
      ExistingMonthlyCreditPayment = EmpRow[k].EMCPayment;
    }
    /*if(GrossMonthlyIncome == 0){
            //cmp.find('GMIncome').showHelpMessageIfInvalid();
            //isError = true;
        }
        if(ExistingMonthlyCreditPayment == 0){
            //cmp.find('EMCPayment').showHelpMessageIfInvalid();
            //isError = true;
        }
      
        if(RequestedCreditLimit == 0){
            cmp.find('ccRequestedCreditLimit').showHelpMessageIfInvalid();
            isError = true;
        }
        if(interestRate == 0){
            cmp.find('ccInterestRate').showHelpMessageIfInvalid();
            isError = true;
        }
        
       // used at time of saving records in object
         if(SupplementaryApplicants == 0){ 
            $A.util.removeClass(cmp.find("ccSupCard"),"slds-hide");
            $A.util.addClass(cmp.find("ccNumberofSupplementaryApplicants"),"slds-has-error");
            isError = true;
        }
        else{
            $A.util.addClass(cmp.find("ccSupCard"),"slds-hide");
        }
        if(isError)
            return;*/

    var monthlyPrincipalRepayment_CCRate = 2.5;
    interestRate = interestRate / 12;
    var startingLimit = 0;
    var AV127 = 0;
    var AV128 = 0;
    var AV125 = 0;
    var AV126 = 0;
    var AV129 = 0;
    var AV130 = 0; //AV130 = =MIN($AV$128:$AV$129)

    AV126 = interestRate + monthlyPrincipalRepayment_CCRate; //In %
    console.log("AV126 In %=====>" + AV126);
    AV126 = AV126 / 100;

    switch (CollateralType) {
      case "0":
        if (GrossMonthlyIncome < 250001) {
          AV127 = 20 / 100;
        } else if (GrossMonthlyIncome > 250000) {
          AV127 = 30 / 100;
        }
        AV128 = AV127 * GrossMonthlyIncome * 12;
        var AV124 = (GrossMonthlyIncome * 50) / 100;
        AV125 = AV124 - ExistingMonthlyCreditPayment; //$AV$124-$AI$56
        AV129 = helper.RoundTo(AV125 / AV126, 10000);
        AV130 = Math.min(AV128, AV129);
        var Admin_TablesM20 = 66.67 / 100;
        startingLimit = helper.RoundTo(
          Math.min(AV130 * Admin_TablesM20, RequestedCreditLimit),
          10000
        );
        console.log("startingLimit In None Case =====>" + startingLimit);
        break;
      case "1":
        var Admin_TablesBF7 = 95 / 100; //In%
        var Admin_TablesBF8 = 90 / 100; //In%
        var Admin_TablesBF9 = 50 / 100; //In%
        var AB129 = cmp.find("ccDepositAccountBalance").get("v.value");
        var AC131 = cmp.find("ccTotalExistingLoanBalance").get("v.value");
        var AX124 = 0;
        var SecuredCollateral = cmp
          .find("ccTypeofCashSecuredCollateral")
          .get("v.value");
        switch (SecuredCollateral) {
          case "1":
            AX124 = Admin_TablesBF7;
            break;
          case "2":
            AX124 = Admin_TablesBF7;
            break;
          case "3":
            AX124 = Admin_TablesBF8;
            break;
          case "4":
            AX124 = Admin_TablesBF9;
            break;
        }
        var AX126 = AX124 * AB129;
        var AX127 = AX126 - AC131;
        var Admin_TablesBG14 = 2.5;
        var AX125 = (interestRate + Admin_TablesBG14) / 100; //In %
        var AX128 = helper.RoundTo(AX126 / AX125, 10000);
        var AX129 = Math.min(AX127, AX128);
        startingLimit = helper.RoundTo(
          Math.min(AX129, RequestedCreditLimit),
          10000
        );
        console.log(
          "startingLimit In Cash/Investment Case =====>" + startingLimit
        );
        break;
    }

    cmp.find("ccStartingLimit").set("v.value", startingLimit);

    //------------------Minimum Payment As Per Credit Limit Start -----------------------
    var MinimumPaymentAsPerCreditLimit = startingLimit * AV126;
    cmp
      .find("ccMinimumPaymentAsPerCreditLimit")
      .set("v.value", MinimumPaymentAsPerCreditLimit.toFixed(2));

    //----------------------Type Of Card calculation Start ---------------------------------
    var Admin_TablesN21 = 500000.0;
    var Admin_TablesO21 = "Gold";
    var Admin_TablesN20 = 500000.01;
    var Admin_TablesO20 = "Classic";

    var Admin_TablesF19 = "3253.96"; //1st Year Annual Membership - Primary (Classic)
    var Admin_TablesF20 = "6236.77"; //1st Year Annual Membership - Primary (Gold)
    if (startingLimit > Admin_TablesN21 && startingLimit > 0) {
      cmp.find("ccTypeofCard").set("v.value", Admin_TablesO21);
      cmp.find("ccAnnualMembership").set("v.value", Admin_TablesF20);
    } else if (startingLimit < Admin_TablesN20 && startingLimit > 0) {
      cmp.find("ccTypeofCard").set("v.value", Admin_TablesO20);
      cmp.find("ccAnnualMembership").set("v.value", Admin_TablesF19);
    } else {
      cmp.find("ccTypeofCard").set("v.value", "TBD");
      cmp.find("ccAnnualMembership").set("v.value", 0);
    }

    var AnnualMembershipPerSupplementaryCardClassic = 1720.01; //=Admin_Tables!$F$21
    cmp
      .find("ccAnnualMembershippersupplementaryApplicant")
      .set("v.value", AnnualMembershipPerSupplementaryCardClassic);

    /*//----- ----------Calculation for total footer start --------------------------------------
        var Admin_TablesBJ7 = '50%';
        cmp.find("PolicyLimit").set("v.value",Admin_TablesBJ7);
        
        //Prior to Proposed Credit(s) =  Existing monthly credit payment /Gross Monthly Income
        var  PriorToProposedCredit = ExistingMonthlyCreditPayment/GrossMonthlyIncome*100;
        cmp.find("PriortoProposedCredit").set("v.value", PriorToProposedCredit.toFixed(2)+'%');
        
        var apc = parseFloat(ExistingMonthlyCreditPayment)+parseFloat(MinimumPaymentAsPerCreditLimit);
        apc = apc/parseFloat(GrossMonthlyIncome)*100;
        cmp.find("AfterProposedCredit").set("v.value", apc.toFixed(2)+'%');
        */
    //helper.creditCardTotal(cmp,ExistingMonthlyCreditPayment,GrossMonthlyIncome,MinimumPaymentAsPerCreditLimit);
    helper.ShowTotalAsPerCalculatorSelected(cmp);
  },
  //------Line of Credit calculation start------
  LineOfCreditOnLoad: function (cmp, evt, helper) {
    // $A.enqueueAction(cmp.get("c.locCollateralTypeOnChange"));
    $A.util.addClass(cmp.find("locCashInvestmentDiv1"), "slds-hide");
    $A.util.addClass(cmp.find("locCashInvestmentDiv2"), "slds-hide");
    $A.util.addClass(cmp.find("locRealEstateDiv1"), "slds-hide");
    $A.util.addClass(cmp.find("locRealEstateDiv2"), "slds-hide");
    $A.util.addClass(cmp.find("locRealEstateDiv3"), "slds-hide");
    $A.util.addClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
  },
  locCollateralTypeOnChange: function (cmp, evt, helper) {
    var type = cmp.find("locCollateralType").get("v.value");
    console.log("Collateral Type==================" + type);
    switch (type) {
      case "0":
        $A.util.addClass(cmp.find("locCashInvestmentDiv1"), "slds-hide");
        $A.util.addClass(cmp.find("locCashInvestmentDiv2"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv1"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv2"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv3"), "slds-hide");
        $A.util.addClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
        $A.util.addClass(
          cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),
          "slds-hide"
        );
        //$A.enqueueAction(cmp.get('c.CreditCardCalculation'));
        break;
      case "1":
        $A.util.removeClass(cmp.find("locCashInvestmentDiv1"), "slds-hide");
        $A.util.removeClass(cmp.find("locCashInvestmentDiv2"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv1"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv2"), "slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv3"), "slds-hide");
        $A.util.addClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
        $A.util.addClass(
          cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),
          "slds-hide"
        );
        $A.enqueueAction(
          cmp.get("c.locIsThisAccountHypothecatedForAnotherLoanOnchange")
        );
        break;
      case "2":
        $A.util.addClass(cmp.find("locCashInvestmentDiv1"), "slds-hide");
        $A.util.addClass(cmp.find("locCashInvestmentDiv2"), "slds-hide");
        $A.util.removeClass(cmp.find("locRealEstateDiv1"), "slds-hide");
        $A.util.removeClass(cmp.find("locRealEstateDiv2"), "slds-hide");
        $A.util.removeClass(cmp.find("locRealEstateDiv3"), "slds-hide");
        $A.util.removeClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
        $A.util.addClass(
          cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),
          "slds-hide"
        );
        $A.enqueueAction(
          cmp.get("c.locIsthereanexistingleinonthispropertyOnchange")
        );
        break;
    }
    $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
  },
  locIsThisAccountHypothecatedForAnotherLoanOnchange: function (
    cmp,
    evt,
    helper
  ) {
    var str = cmp
      .find("locIsThisAccountHypothecatedForAnotherLoan")
      .get("v.value");
    switch (str) {
      case "0":
        $A.util.addClass(cmp.find("locTotalExistingLoanBalance"), "slds-hide");
        $A.util.addClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
        break;
      case "1":
        $A.util.removeClass(
          cmp.find("locTotalExistingLoanBalance"),
          "slds-hide"
        );
        $A.util.removeClass(cmp.find("locToatLoanBalCurrency"), "slds-hide");
        break;
    }
    $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
  },
  locIsthereanexistingleinonthispropertyOnchange: function (cmp, evt, helper) {
    var str = cmp.find("locIsthereanexistingleinonthisproperty").get("v.value");
    switch (str) {
      case "0":
        $A.util.addClass(
          cmp.find("locTotalExistingLoanBalanceRS"),
          "slds-hide"
        );
        $A.util.addClass(
          cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),
          "slds-hide"
        );
        break;
      case "1":
        $A.util.removeClass(
          cmp.find("locTotalExistingLoanBalanceRS"),
          "slds-hide"
        );
        $A.util.removeClass(
          cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),
          "slds-hide"
        );
        break;
    }
    cmp.find("locTotalExistingLoanBalanceRS").set("v.value", "");
    $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
  },
  lineOfCreditCalculation: function (cmp, evt, helper) {
    console.log("lineOfCreditCalculation====");
    var EmpRow = cmp.get("v.RowNum");
    var GrossMonthlyIncome = 0; //$AB$56
    var ExistingMonthlyCreditPayment = 0; //$AI$56 = EXISTING MONTHLY CREDIT PAYMENT
    //var GrossMonthlyIncome2=0;
    // var ExistingMonthlyCreditPayment2 = 0;
    //var GrossMonthlyIncome3=0;
    //var ExistingMonthlyCreditPayment3 = 0;

    for (var k in EmpRow) {
      GrossMonthlyIncome += parseFloat(EmpRow[k].GMIncome);
      ExistingMonthlyCreditPayment += parseFloat(EmpRow[k].EMCPayment);
    }
    console.log("GrossMonthlyIncome====" + GrossMonthlyIncome);
    console.log(
      "ExistingMonthlyCreditPayment====" + ExistingMonthlyCreditPayment
    );

    //helper.SetDefaultVal(cmp.find("locRequestedCreditLimit"),0);
    //helper.SetDefaultVal(cmp.find("locInterestRate"),0);
    var RequestedCreditLimit = 0;
    if (cmp.find("locRequestedCreditLimit").get("v.value") > 0) {
      RequestedCreditLimit = cmp.find("locRequestedCreditLimit").get("v.value");
    }
    var InterestRate = 0;
    if (cmp.find("locInterestRate").get("v.value") > 0) {
      InterestRate = cmp.find("locInterestRate").get("v.value") / 12;
    }
    var StartingLimit = 0;
    var MinimumPaymentAsPerCreditLimit = 0;
    var AnnualFacilityFee = 0;
    var Admin_TablesBF14 = 3;
    var AV140 = (InterestRate + Admin_TablesBF14) / 100;
    console.log("AV140===>" + AV140);
    //----------Annual Facility Fee calculation ---------------------
    //AnnualFacilityFee=Admin_Tables!$AO$27*$I$216
    //Admin_Tables!$AO$27 = 0.75%
    var Admin_TablesAO27 = 0.75 / 100;

    var AW56 = GrossMonthlyIncome;
    var AW57 = ExistingMonthlyCreditPayment;

    var CollateralType = cmp.find("locCollateralType").get("v.value");
    console.log("CollateralType====" + CollateralType);
    switch (CollateralType) {
      case "0":
        console.log("lineOfCreditCalculation====2");
        var Admin_TablesAN7 = 30 / 100; //IN %

        var AV142 = Admin_TablesAN7 * AW56 * 12;
        console.log("AV142====" + AV142);
        console.log("AW57====" + AW57);
        var Admin_TablesBJ8 = 50 / 100; //IN %
        var AV138 = AW56 * Admin_TablesBJ8;
        var AV139 = AV138 - AW57;
        console.log("AV139====" + AV139);
        //var Admin_TablesBF14 = 3;
        //var AV140 = (InterestRate+Admin_TablesBF14)/100;
        console.log("AV140====" + AV140);
        var AV143 = helper.RoundTo(AV139 / AV140, 10000);
        console.log("AV143====" + AV143);
        var AV144 = Math.min(AV142, AV143);
        var Admin_TablesAO7 = 66.67 / 100;
        console.log("AV144====" + AV144);

        StartingLimit = helper.RoundTo(
          Math.min(AV144 * Admin_TablesAO7, RequestedCreditLimit),
          10000
        );
        console.log("StartingLimit In None Case==>" + StartingLimit);

        break;
      case "1":
        console.log("case 2==>");
        //helper.SetDefaultVal(cmp.find("locDepositAccountBalance"),0);
        //helper.SetDefaultVal(cmp.find("locTotalExistingLoanBalance"),0);
        var DepositAccountBalance = 0;
        if (cmp.find("locDepositAccountBalance").get("v.value") > 0) {
          DepositAccountBalance = cmp
            .find("locDepositAccountBalance")
            .get("v.value");
        }
        var AC145 = 0;
        if (cmp.find("locTotalExistingLoanBalance").get("v.value") > 0) {
          AC145 = cmp.find("locTotalExistingLoanBalance").get("v.value");
        }

        console.log("case 2==>1");
        var AX138 = 0;
        var Admin_TablesBF7 = 95;
        var Admin_TablesBF8 = 90;
        var Admin_TablesBF9 = 50;
        var Admin_TablesBF10 = 70; //For Real Estate
        var cashType = cmp
          .find("locTypeOfCashSecuredCollateral")
          .get("v.value");
        switch (cashType) {
          case "1":
            AX138 = Admin_TablesBF7 / 100;
            break;
          case "2":
            AX138 = Admin_TablesBF7 / 100;
            break;
          case "3":
            AX138 = Admin_TablesBF8 / 100;
            break;
          case "4":
            AX138 = Admin_TablesBF9 / 100;
            break;
        }
        console.log("case 2==>2");
        var AX140 = AX138 * DepositAccountBalance;
        var AX141 = AX140 - AC145;

        var Admin_TablesBF14 = 3; //In %
        var AX139 = (InterestRate + Admin_TablesBF14) / 100;
        var AX142 = helper.RoundTo(AX140 / AX139, 10000);
        var AX143 = Math.min(AX141, AX142);
        console.log("case 2==>3");
        StartingLimit = helper.RoundTo(
          Math.min(AX143, RequestedCreditLimit),
          10000
        );
        console.log("StartingLimit In Cash/Investment Case==>" + StartingLimit);

        break;
      case "2":
        console.log("case 3==>1");
        var Admin_TablesBG10 = 5000000.0;

        //helper.SetDefaultVal(cmp.find("locDepositAccountBalance"),0);
        //helper.SetDefaultVal(cmp.find("locTotalExistingLoanBalance"),0);
        // helper.SetDefaultVal(cmp.find("locMarketValueofProperty"),0);
        var K148 = 0;
        if (cmp.find("locMarketValueofProperty").get("v.value") > 0) {
          K148 = cmp.find("locMarketValueofProperty").get("v.value");
        }
        var TotalExistingLoanBalanceRS = 0;
        if (cmp.find("locTotalExistingLoanBalanceRS").get("v.value") > 0) {
          TotalExistingLoanBalanceRS = cmp
            .find("locTotalExistingLoanBalanceRS")
            .get("v.value");
        }
        //var AC145 = cmp.find("locTotalExistingLoanBalance").get("v.value");

        //------------------------------------------
        var AX138 = 0;
        var Admin_TablesBF10 = 70 / 100; //For Real Estate
        AX138 = Admin_TablesBF10;
        console.log("case 3==>2");
        var AX140 = AX138 * Math.min(K148, Admin_TablesBG10);
        var AX141 = AX140 - TotalExistingLoanBalanceRS;

        console.log("case 3==>3");
        var Admin_TablesBF14 = 3; //In %
        var AX139 = (InterestRate + Admin_TablesBF14) / 100;
        var AX142 = helper.RoundTo(AX140 / AX139, 10000);
        var AX143 = Math.min(AX141, AX142);
        console.log("case 3==>4");
        StartingLimit = helper.RoundTo(
          Math.min(AX143, RequestedCreditLimit),
          10000
        );

        console.log("StartingLimit In Real Estate Case==>" + StartingLimit);

        break;
    }

    MinimumPaymentAsPerCreditLimit = StartingLimit * AV140;
    AnnualFacilityFee = Admin_TablesAO27 * StartingLimit;

    //------------Set calculation value in text box --------------------------

    cmp
      .find("locStartingLimit")
      .set("v.value", helper.checkNaN(StartingLimit).toFixed(2));
    cmp
      .find("locMinimumPaymentAsPerCreditLimit")
      .set(
        "v.value",
        helper.checkNaN(MinimumPaymentAsPerCreditLimit).toFixed(2)
      );
    cmp
      .find("locAnnualFacilityFee")
      .set("v.value", helper.checkNaN(AnnualFacilityFee).toFixed(2));

    /* var Admin_TablesBJ7 = '50%';
        cmp.find("PolicyLimit").set("v.value", Admin_TablesBJ7);*/

    /* //PriortoProposedCredit=IFERROR($AW$57/$AW$56,0)
        
        var PriortoProposedCredit=parseFloat(AW57)/parseFloat(AW56);
        PriortoProposedCredit = PriortoProposedCredit*100;
        PriortoProposedCredit =helper.checkNaN(PriortoProposedCredit);
        PriortoProposedCredit=PriortoProposedCredit.toFixed(2)+'%'
        cmp.find("PriortoProposedCredit").set("v.value", PriortoProposedCredit);*/

    /*
        //After Proposed Credit(s)=IFERROR(VLOOKUP($L$53,$AU$156:$AV$170,2,0),0)
        //=IFERROR(SUM($AW$57,$AA$216)/$AW$56,0)
        //$AW$57 = Existing Monthly credit payment Sum
        //$AA$216 = Minimum Payment as per Credit Limit
        //$AW$56 = =SUM($AB$56:$AF$58) //Sum of Gross Monthly Income
        console.log('AW57='+AW57);
        console.log('AW56='+AW56);
        console.log('MinimumPaymentAsPerCreditLimit='+MinimumPaymentAsPerCreditLimit);
		var apc =   (parseFloat(AW57)+parseFloat(MinimumPaymentAsPerCreditLimit));
        console.log("sum======"+apc);
        apc = apc/parseFloat(AW56);  
        
        console.log("sum 2======"+apc);
        apc = apc*100;
        apc =helper.checkNaN(apc);
        apc = apc.toFixed(2)+'%';
        cmp.find("AfterProposedCredit").set("v.value", apc);*/

    //helper.lineOfCreditTotal(cmp,AW57,AW56,MinimumPaymentAsPerCreditLimit);
    helper.ShowTotalAsPerCalculatorSelected(cmp);
  },
  SaveData: function (cmp, evt, helper) {
    var loanpuposeauto = "";
    var interestedinprogramm = "";
    var includeinfirstyear = "";
    var includeincreditor = "";
    var CoverageType = "";
    var includeinjnlife = "";
    var waivefee = "";
    var includefee = "";
    var includeinjnlife = "";
    var includemoratorium = "";
    var moratoriumterm = "";
    var loanpuposeun = "";
    var includeincreditorun = "";
    var CoverageTypeun = "";
    var includeinjnlifeun = "";
    var waivefeeun = "";
    var includefeeUn = "";
    if (cmp.find("LoanPurpose").get("v.value") == "1")
      loanpuposeauto = "Purchase a Motor Vehicle";
    if (cmp.find("LoanPurpose").get("v.value") == "2")
      loanpuposeauto = "Refinance Existing Auto Loan";
    if (cmp.find("LoanPurpose").get("v.value") == "3")
      loanpuposeauto = "Equity in a Motor Vehicle";
    if (cmp.find("Interestedinprogramme").get("v.value") == "0")
      interestedinprogramm = "Yes";
    if (cmp.find("Interestedinprogramme").get("v.value") == "1")
      interestedinprogramm = "No";
    if (cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "0")
      includeinfirstyear = "Yes (Include in Loan Amount)";
    if (cmp.find("Include1stYearPremiuminLoanAmount").get("v.value") == "1")
      includeinfirstyear = "No (Paid by the Applicant)";
    if (cmp.find("InterestedinCreditorLife").get("v.value") == "0")
      includeincreditor = "Yes";
    if (cmp.find("InterestedinCreditorLife").get("v.value") == "1")
      includeincreditor = "No";
    if (cmp.find("CoverageType").get("v.value") == "1")
      CoverageType = "Applicant 1 Only";
    if (cmp.find("CoverageType").get("v.value") == "2")
      CoverageType = "Applicant 2 Only";
    if (cmp.find("CoverageType").get("v.value") == "3")
      CoverageType = "Applicant 3 Only";
    if (cmp.find("CoverageType").get("v.value") == "4")
      CoverageType = "Applicant 1 & Applicant 2";
    if (cmp.find("CoverageType").get("v.value") == "5")
      CoverageType = "Applicant 1 & Applicant 3";
    if (cmp.find("CoverageType").get("v.value") == "6")
      CoverageType = "Applicant 2 & Applicant 3";
    if (cmp.find("CoverageType").get("v.value") == "7")
      CoverageType = "No Suitable Applicants";
    if (cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "0")
      includeinjnlife = "Yes (Include in Loan Amount)";
    if (cmp.find("IncludeinLoanAmountinsurence").get("v.value") == "1")
      includeinjnlife = "No (Paid by the Applicant)";
    if (cmp.find("WaiveProcessingFee").get("v.value") == "0") waivefee = "Yes";
    if (cmp.find("WaiveProcessingFee").get("v.value") == "1") waivefee = "No";
    if (cmp.find("IncludeinLoanAmountfee").get("v.value") == "0")
      includefee = "Yes (Include in Loan Amount)";
    if (cmp.find("IncludeinLoanAmountfee").get("v.value") == "1")
      includefee = "No (Paid by the Applicant)";
    if (cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == "0")
      includemoratorium = "Yes";
    if (cmp.find("Includeamoratoriumofloanrepayments").get("v.value") == "1")
      includemoratorium = "No";
    if (cmp.find("LoanPurposeUn").get("v.value") == "1")
      loanpuposeun = "Asset Acquisition";
    if (cmp.find("LoanPurposeUn").get("v.value") == "2")
      loanpuposeun = "Auto Repairs";
    if (cmp.find("LoanPurposeUn").get("v.value") == "3")
      loanpuposeun = "Debt Consolidation";
    if (cmp.find("LoanPurposeUn").get("v.value") == "4")
      loanpuposeun = "Education";
    if (cmp.find("LoanPurposeUn").get("v.value") == "5")
      loanpuposeun = "Home Improvement";
    if (cmp.find("LoanPurposeUn").get("v.value") == "6")
      loanpuposeun = "Medical Expenses";
    if (cmp.find("LoanPurposeUn").get("v.value") == "7") loanpuposeun = "Other";
    if (cmp.find("InterestedinCreditorLifeUn").get("v.value") == "0")
      includeincreditorun = "Yes";
    if (cmp.find("InterestedinCreditorLifeUn").get("v.value") == "1")
      includeincreditorun = "No";
    if (cmp.find("CoverageTypeUn").get("v.value") == "1")
      CoverageTypeun = "Applicant 1 Only";
    if (cmp.find("CoverageTypeUn").get("v.value") == "2")
      CoverageTypeun = "Applicant 2 Only";
    if (cmp.find("CoverageTypeUn").get("v.value") == "3")
      CoverageTypeun = "Applicant 3 Only";
    if (cmp.find("CoverageTypeUn").get("v.value") == "4")
      CoverageTypeun = "Applicant 1 & Applicant 2";
    if (cmp.find("CoverageTypeUn").get("v.value") == "5")
      CoverageTypeun = "Applicant 1 & Applicant 3";
    if (cmp.find("CoverageTypeUn").get("v.value") == "6")
      CoverageTypeun = "Applicant 2 & Applicant 3";
    if (cmp.find("CoverageTypeUn").get("v.value") == "7")
      CoverageTypeun = "No Suitable Applicants";
    if (cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value") == "0")
      includeinjnlifeun = "Yes (Include in Loan Amount)";
    if (cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value") == "1")
      includeinjnlifeun = "No (Paid by the Applicant)";
    if (cmp.find("WaiveProcessingFeeUn").get("v.value") == "0")
      waivefeeun = "Yes";
    if (cmp.find("WaiveProcessingFeeUn").get("v.value") == "1")
      waivefeeun = "No";
    if (cmp.find("IncludeinLoanAmountfeeUn").get("v.value") == "0")
      includefeeun = "Yes (Include in Loan Amount)";
    if (cmp.find("IncludeinLoanAmountfeeUn").get("v.value") == "1")
      includefeeun = "No (Paid by the Applicant)";

    var RequestDataAuto = cmp.get("v.RDetailAuto");
    var interestrateauto = RequestData[0].Interestrate;
    var yearauto = RequestData[0].LoanTerm1;
    var monthauto = RequestData[0].LoanTerm2;
    var loanamountauto = RequestData[0].LoanAmount;

    var RDetailUnsecured = cmp.get("v.RDetailUnsecured");
    var interestrateun = RDetailUnsecured[0].Interestrate;
    var yearun = RDetailUnsecured[0].LoanTerm1;
    var monthun = RDetailUnsecured[0].LoanTerm2;
    var loanamountun = RDetailUnsecured[0].LoanAmount;
    alert(1);

    var newCalculator = {
      sobjectType: "Loan_Calculator__c",
      Product_Type__c: "",
      Loan_Purpose__c: loanpuposeauto,
      Market_Value_of_Vehicle__c: cmp
        .find("PurchasePriceofVehicle")
        .get("v.value"),
      Motor_Vehicle_Deposit__c: cmp.find("MotorVehicleDeposit4").get("v.value"),
      Motor_Vehicle_Deposit_Percentage__c: cmp
        .find("MotorVehicleDeposit")
        .get("v.value"),
      Interested_in_programme__c: interestedinprogramm,
      Include_first_year_premium_in_loan_amt__c: includeinfirstyear,
      Monthly_Premium__c: cmp.find("MonthlyPremium").get("v.value"),
      Interested_in_Creditor_Life__c: includeincreditor,
      Coverage_Type__c: CoverageType,
      Include_in_Loan_Amount_jnlife__c: includeinjnlife,
      Waive_Process_Fee__c: waivefee,
      Include_in_Loan_Amount_Processing_Fee__c: includefee,
      Indicate_applicable_process_fee_percent__c: cmp
        .find("Indicateapplicableprocessingfees")
        .get("v.value"),
      Include_a_moratorium_of_Loan_Payment__c: includemoratorium,
      Moratorium_Indicate_Term__c: cmp.find("IndicateTerm").get("v.value"),
      Proposed_Savings__c: cmp.find("ProposedSavings5").get("v.value"),
      Proposed_SavingsPercentage__c: cmp
        .find("ProposedSavings1")
        .get("v.value"),
      Interest_Rate__c: interestrateauto,
      Years__c: yearauto,
      Months__c: monthauto,
      Loan_Amount__c: loanamountauto,
      unsecure_Loan_Purpose__c: loanpuposeun,
      unsecure_Jn_Life_Creditor_Life_Insurance__c: includeincreditorun,
      Unsecure_Coverage_Type__c: CoverageTypeun,
      Unsecure_Include_in_Loan_Amount__c: includeinjnlifeun,
      Unsecure_Waive_Processing_Fee__c: waivefeeun,
      Unsecure_Fee_Include_in_Loan_Amount__c: includefeeun,
      Unsecure_Indcate_applicable_process_fee__c: cmp
        .find("IndicateapplicableprocessingfeesUn")
        .get("v.value"),
      Unsecure_Loan_Savings_currency__c: "",
      Unsecure_Proposed_Savings__c: cmp
        .find("ProposedSavings5Un")
        .get("v.value"),
      Unsecure_Proposed_Savings_percentage__c: cmp
        .find("ProposedSavings1Un")
        .get("v.value"),
      Unsecure_Market_Per_Annum__c: interestrateun,
      Unsecure_Years__c: yearun,
      Unsecure_Months__c: monthun,
      Lead_and_Referral__c: "00Qq00000094swIEAQ"
    };
    alert(2);
    var action = cmp.get("c.createloancalculationRecord");

    //Setting the Apex Parameter
    action.setParams({
      loancalculation: newCalculator
    });

    //Setting the Callback
    action.setCallback(this, function (response) {
      //get the response state
      var state = response.getState();

      //check if result is successfull
      if (state == "SUCCESS") {
        //Reset Form

        var newCalculator = {
          sobjectType: "Loan_Calculator__c",
          Product_Type__c: "",
          Loan_Purpose__c: "",
          Market_Value_of_Vehicle__c: "",
          Motor_Vehicle_Deposit__c: "",
          Motor_Vehicle_Deposit_Percentage__c: "",
          Interested_in_programme__c: "",
          Include_first_year_premium_in_loan_amt__c: "",
          Monthly_Premium__c: "",
          Interested_in_Creditor_Life__c: "",
          Coverage_Type__c: "",
          Include_in_Loan_Amount_jnlife__c: "",
          Waive_Process_Fee__c: "",
          Include_in_Loan_Amount_Processing_Fee__c: "",
          Indicate_applicable_process_fee_percent__c: "",
          Include_a_moratorium_of_Loan_Payment__c: "",
          Moratorium_Indicate_Term__c: "",
          Proposed_Savings__c: "",
          Proposed_SavingsPercentage__c: "",
          Interest_Rate__c: "",
          Years__c: "",
          Months__c: "",
          Loan_Amount__c: "",
          Total_Monthly__c: "",
          unsecure_Loan_Purpose__c: "",
          unsecure_Jn_Life_Creditor_Life_Insurance__c: "",
          Unsecure_Coverage_Type__c: "",
          Unsecure_Include_in_Loan_Amount__c: "",
          Unsecure_Waive_Processing_Fee__c: "",
          Unsecure_Fee_Include_in_Loan_Amount__c: "",
          Unsecure_Indcate_applicable_process_fee__c: "",
          Unsecure_Loan_Savings_currency__c: "",
          Unsecure_Proposed_Savings__c: "",
          Unsecure_Proposed_Savings_percentage__c: "",
          Unsecure_Market_Per_Annum__c: "",
          Unsecure_Years__c: "",
          Unsecure_Months__c: "",
          Lead_and_Referral__c: "00Qq00000094swIEAQ"
        };
        //resetting the Values in the form
        component.set("v.LoanCalculation", newCalculator);
        alert("Record is Created Successfully");
      } else if (state == "ERROR") {
        alert("Error in calling server side action");
      }
    });

    //adds the server-side action to the queue
    $A.enqueueAction(action);
  }
});
