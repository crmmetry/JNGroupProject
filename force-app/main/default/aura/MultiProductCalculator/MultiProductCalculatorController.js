({
    doInit : function(cmp, event, helper) {
        helper.calculateScoreCalculate(cmp); 
        var isprod=cmp.get("v.isProductDetail");
        
        if(isprod){
            var opp_id=cmp.get("v.isRecordIdM");
         helper.isRequiredFieldMissingForCreditScore(cmp, opp_id);
       var action = cmp.get("c.FetchAllApplicant");
            action.setParams({      
                oppId: cmp.get("v.isRecordIdM"),
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var applicantlst=response.getReturnValue();
                    console.log('applicantlst====kkkk========>'+applicantlst);
                    cmp.set("v.ApplicantCount", applicantlst.length);
                    var EmpRow;
                    for(var k in applicantlst){
                        console.log('applicantlst====k========>'+k);
                        var RowIndex=1+Number(k);
                        var FirstName="";
                        var  LastName="";
                        var DateOfBirth="";
                        var GMIncome="";
                        var EMCPayment="";
                        var IsJNEmployee="";
                        /*
                        if(applicantlst[k].Account__r.firstname!=null)
                            FirstName=applicantlst[k].Account__r.firstname;
                        if(applicantlst[k].Account__r.lastname!=null)
                            LastName=applicantlst[k].Account__r.lastname;
                        if(applicantlst[k].Account__r.PersonBirthdate!=null)
                            DateOfBirth=applicantlst[k].Account__r.PersonBirthdate;
                        if(applicantlst[k].Account__r.Gross_Monthly_Income__pc!=null)
                            GMIncome=applicantlst[k].Account__r.Gross_Monthly_Income__pc;
                        if(applicantlst[k].Opportunity__r.Existing_monthly_debts_being_serviced__c!=null)
                            EMCPayment=applicantlst[k].Opportunity__r.Existing_monthly_debts_being_serviced__c;
                        if(applicantlst[k].Account__r.JN_Bank_Affiliation__pc!=null)
                            IsJNEmployee=applicantlst[k].Account__r.JN_Bank_Affiliation__pc;*/
                        if(applicantlst[k].First_Name!=null)
                            FirstName=applicantlst[k].First_Name;
                        if(applicantlst[k].Last_Name!=null)
                            LastName=applicantlst[k].Last_Name;
                        if(applicantlst[k].DateOf_Birth!=null)
                            DateOfBirth=applicantlst[k].DateOf_Birth;
                        if(applicantlst[k].GM_Income!=null)
                            GMIncome=applicantlst[k].GM_Income;
                        if(applicantlst[k].EMC_Payment!=null)
                            EMCPayment=applicantlst[k].EMC_Payment;
                        if(applicantlst[k].IsJNEmp!=null)
                            IsJNEmployee=applicantlst[k].IsJNEmp;
                        
                        console.log('applicantlst====FirstName========>'+FirstName);
                        console.log('applicantlst====LastName========>'+LastName);
                        console.log('applicantlst====DateOfBirth========>'+DateOfBirth);
                        console.log('applicantlst====GMIncome========>'+GMIncome);
                        console.log('applicantlst====EMCPayment========>'+EMCPayment);
                        console.log('applicantlst====IsJNEmployee========>'+IsJNEmployee);
                        
                        
                        if(k==0){
                            EmpRow=[{
                                "Id":RowIndex,
                                "FirstName":FirstName,
                                "LastName":LastName,
                                "DateOfBirth":DateOfBirth,
                                "GMIncome":GMIncome,
                                "EMCPayment":EMCPayment,
                                "IsJNEmployee":IsJNEmployee
                            }]
                        }
                        else{
                            EmpRow.push({
                                "Id":RowIndex,
                                "FirstName":FirstName,
                                "LastName":LastName,
                                "DateOfBirth":DateOfBirth,
                                "GMIncome":GMIncome,
                                "EMCPayment":EMCPayment,
                                "IsJNEmployee":IsJNEmployee
                            })
                        }
                    }
                    console.log('EmpRow====kkkk========>'+EmpRow);
                    cmp.set("v.RowNum",EmpRow);
                    var rdetail=cmp.get("v.RowNum");
                }
                else if (state === "ERROR")  
                {
                }
            }); 
            $A.enqueueAction(action);
            var action = cmp.get("c.getproductselection");
            action.setParams({      
                oppId: cmp.get("v.isRecordIdM"),
            }); 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var productselection=response.getReturnValue(); 
                    cmp.find("selectapplicant").set("v.value",productselection);
                    $A.enqueueAction(cmp.get('c.showhideONmethod'));
                }
                else if (state === "ERROR")  
                {
                }
            }); 
            $A.enqueueAction(action);
            
        }
        
        
        if(!isprod)
            $A.enqueueAction(cmp.get('c.Createapplicantlist'));
        cmp.set("v.IsExistingLoan",false);
        cmp.set("v.AutoMarketCurrency", 'JMD');
        $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
        $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
        $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
        $A.util.addClass(cmp.find("CalculationSection"),"slds-hide");
        $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
        $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
        $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
        $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
        $A.util.addClass(cmp.find("Total"),"slds-hide");
        
        
        var str = window.location.href.toString(); 
        if(str.indexOf('Lead') != -1){
            cmp.set("v.sobjectName","Lead");
        }
        else if(str.indexOf('Opportunity') != -1){ 
            cmp.set("v.sobjectName","Opportunity");
        }
        
    },
    Createapplicantlist : function(cmp, event, helper){
        var ApplicantRow=[{
            "Id":1,
            "FirstName":"",
            "LastName":"",
            "DateOfBirth":"",
            "GMIncome":"",
            "EMCPayment":"",
            "IsJNEmployee":false
        }]
        cmp.set("v.RowNum",ApplicantRow)
        cmp.find("NumberofApplicant").set("v.value", "0");
    },
    updateRequestdetail : function(cmp, event, helper){
        var childCmp = cmp.find('AutoLoanchild');
        const param1=cmp.get("v.RowNum");
        childCmp.CallRequestDetails(param1);
        for(var k in param1){
            if(param1[k].Id==1 && param1[k].IsJNEmployee){
                $A.util.removeClass(cmp.find("JNstaff1"),"slds-hide"); 
                $A.util.removeClass(cmp.find("JNstaff1Un"),"slds-hide"); 
            }
            if(param1[k].Id==2 && param1[k].IsJNEmployee){
                $A.util.removeClass(cmp.find("JNstaff2"),"slds-hide");
                $A.util.removeClass(cmp.find("JNstaff2Un"),"slds-hide");}
            if(param1[k].Id==3 && param1[k].IsJNEmployee){
                $A.util.removeClass(cmp.find("JNstaff3"),"slds-hide");
                $A.util.removeClass(cmp.find("JNstaff3Un"),"slds-hide");
            }
            if(param1[k].Id==1 && param1[k].IsJNEmployee==false){
                $A.util.addClass(cmp.find("JNstaff1"),"slds-hide"); 
                $A.util.addClass(cmp.find("JNstaff1Un"),"slds-hide");
            }
            if(param1[k].Id==2 && param1[k].IsJNEmployee==false){
                $A.util.addClass(cmp.find("JNstaff2"),"slds-hide");
                $A.util.addClass(cmp.find("JNstaff2Un"),"slds-hide");
            }  
            if(param1[k].Id==3 && param1[k].IsJNEmployee==false){
                $A.util.addClass(cmp.find("JNstaff3"),"slds-hide");
                $A.util.addClass(cmp.find("JNstaff3Un"),"slds-hide");
            }
        }
        var acMethod = cmp.find("selectapplicant").get("v.value");
        switch(acMethod){
            case "2":
            case "8":
            case "9":
            case "14":           
                $A.enqueueAction(cmp.get('c.addrowdatarequestDetail'));
                break;
        }
        $A.enqueueAction(cmp.get('c.ApplicantDetailsChange'));
        
        
    },
    Requestdetaileventhandler : function(cmp, event, helper){
        console.log('Test4===========');
        var RequestData = event.getParam("RequestData");
        cmp.set("v.RDetailAuto", RequestData);
        var loanterm = Number(RequestData[0].LoanTerm1*12)+Number(RequestData[0].LoanTerm2);
        cmp.set("v.LoanTermMarket", loanterm);
        for(var k in RequestData) {
            var i =RequestData[k].Interestrate;
            var im =RequestData[k].Interestrate/ 1200;
            console.log('im========'+im);
            var n = Number(RequestData[k].LoanTerm1*12)+Number(RequestData[k].LoanTerm2);
            var p = RequestData[k].LoanAmount;
            console.log('imp========'+p);
            console.log('n====='+n);
            var bmla= helper.PMTcalculator(i, n, p);
            console.log('n====='+bmla);
            if(RequestData[k].colIndex=='Market'){
                console.log('n1=====1');
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
                var AmortizationSC1C12=0;
                if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==1 && (cmp.find("IndicateTerm").get("v.value")==1 || cmp.find("IndicateTerm").get("v.value")==2||cmp.find("IndicateTerm").get("v.value")==3)){
                    AmortizationSC1C12=im*p;
                    cmp.set("v.BMLoanamountMarketAutoloan", AmortizationSC1C12);
                    cmp.set("v.LoanamountMarketAutoloannew", AmortizationSC1C12.toFixed(2)); 
                }
                else if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==2){
                    var a=0;
                    cmp.set("v.BMLoanamountMarketAutoloan", a);
                    cmp.set("v.LoanamountMarketAutoloannew", a.toFixed(2));
                }
                    else{
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
                
                if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==2 && cmp.find("Othee_post_moratorium__id").get("v.value")==1){
                    var n1=n-cmp.find("IndicateTerm").get("v.value");
                    var AmortizationSC1C121=im*p*cmp.find("IndicateTerm").get("v.value");
                    var p1=Number(p)+Number(AmortizationSC1C121);
                    var amla=0;
                    amla= helper.PMTcalculator(i, n1, p1);
                    if(isNaN(amla)==false){
                        cmp.set("v.AMLoanamountMarketAutoloan", amla);
                        cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
                    }
                }
                if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==1 && cmp.find("Othee_post_moratorium__id").get("v.value")==1){
                    var n1=n-cmp.find("IndicateTerm").get("v.value");
                    var amla=0;
                    amla= helper.PMTcalculator(i, n1, p);
                    if(isNaN(amla)==false){
                        cmp.set("v.AMLoanamountMarketAutoloan", amla);
                        cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
                    }
                }
                if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==2 && cmp.find("Othee_post_moratorium__id").get("v.value")==2){
                    var AmortizationSC1C122=im*p*cmp.find("IndicateTerm").get("v.value");
                    var p1=Number(p)+Number(AmortizationSC1C122);
                    var amla=0;
                    amla= helper.PMTcalculator(i, n, p1);
                    if(isNaN(amla)==false){
                        cmp.set("v.AMLoanamountMarketAutoloan", amla);
                        cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
                    }
                }
                if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")==0 && cmp.find("IndicateType").get("v.value")==1 && cmp.find("Othee_post_moratorium__id").get("v.value")==2){
                    var amla=0;
                    amla= helper.PMTcalculator(i, n, p);
                    if(isNaN(amla)==false){
                        cmp.set("v.AMLoanamountMarketAutoloan", amla);
                        cmp.set("v.AMLoanamountMarketAutoloannew", amla.toFixed(2));
                    }
                }
                //--------------------------------
            }
            if(RequestData[k].colIndex=='JN Staff 1'){
                var ijn1 =RequestData[k-1].Interestrate;
                var njn1 = Number(RequestData[k-1].LoanTerm1*12)+Number(RequestData[k-1].LoanTerm2);
                var pjn1 = RequestData[k].LoanAmount;
                var bmlajn1= helper.PMTcalculator(ijn1, njn1, pjn1);
                cmp.set("v.LoanamountJNStaff1Autoloan", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff1Autoloan", bmlajn1);
                    //cmp.set("v.LoanamountJNStaff1Autoloannew", bmlajn1.toFixed(2));
                    cmp.find("MonthlyLoanPaymentJN11").set("v.value", bmlajn1.toFixed(2));
                    cmp.set("v.MonthlyLoanPaymentJN12New", bmlajn1);
                    cmp.find("MonthlyLoanPaymentJN12").set("v.value", bmlajn1.toFixed(2));
                    
                }
            }
            if(RequestData[k].colIndex=='JN Staff 2'){
                var ijn2 =RequestData[k-1].Interestrate;
                var njn2 = Number(RequestData[k-1].LoanTerm1*12)+Number(RequestData[k-1].LoanTerm2);
                var pjn2 = RequestData[k].LoanAmount;
                var bmlajn2= helper.PMTcalculator(ijn2, njn2, pjn2);
                cmp.set("v.LoanamountJNStaff2Autoloan", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff2Autoloan", bmlajn2);
                    //cmp.set("v.LoanamountJNStaff2Autoloannew", bmlajn2.toFixed(2));
                    cmp.find("MonthlyLoanPaymentJN21").set("v.value", bmlajn2.toFixed(2))
                    cmp.set("v.MonthlyLoanPaymentJN22New", bmlajn2);
                    cmp.find("MonthlyLoanPaymentJN22").set("v.value", bmlajn2.toFixed(2))
                }
                
            }
            if(RequestData[k].colIndex=='JN Staff 3'){
                var ijn3 =RequestData[k-1].Interestrate;
                var njn3 = Number(RequestData[k-1].LoanTerm1*12)+Number(RequestData[k-1].LoanTerm2);
                var pjn3 = RequestData[k].LoanAmount;
                var bmlajn3= helper.PMTcalculator(ijn3, njn3, pjn3);
                cmp.set("v.LoanamountJNStaff3Autoloan", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff3Autoloan", bmlajn3);
                    //cmp.set("v.LoanamountJNStaff3Autoloannew", bmlajn3.toFixed(2));
                    cmp.find("MonthlyLoanPaymentJN31").set("v.value", bmlajn3.toFixed(2))
                    cmp.set("v.MonthlyLoanPaymentJN32New", bmlajn3);
                    cmp.find("MonthlyLoanPaymentJN32").set("v.value", bmlajn3.toFixed(2))
                }
            }
        }
        
        helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
        helper.calculateProcessingFeehelper(cmp, event);
        helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event); 
        
    },
    addrowdatarequestDetail : function(cmp, event, helper) {
        const RDetailUnsecured=cmp.get("v.RDetailUnsecured");
        var param1 = cmp.get("v.RowNum");
        for(var k in param1) {
            var EmpRowstr=JSON.stringify(RDetailUnsecured);
            var str="JN Staff "+param1[k].Id;
            if(param1[k].Id==1 && param1[k].IsJNEmployee &&  ! (EmpRowstr.includes(str))){
                helper.AddRowRequestDetail(param1[k].Id,RDetailUnsecured,cmp);
            }
            if(param1[k].Id==2 && param1[k].IsJNEmployee &&  ! (EmpRowstr.includes(str))){
                helper.AddRowRequestDetail(param1[k].Id,RDetailUnsecured,cmp);
            }
            if(param1[k].Id==3 && param1[k].IsJNEmployee &&  ! (EmpRowstr.includes(str))){
                helper.AddRowRequestDetail(param1[k].Id,RDetailUnsecured,cmp);
            }
            if(param1[k].Id==1 && !param1[k].IsJNEmployee && (EmpRowstr.includes(str))){
                helper.RemoveRowRequestDetail(param1[k].Id,1,RDetailUnsecured,cmp);
            }
            if(param1[k].Id==2 && !param1[k].IsJNEmployee && (EmpRowstr.includes(str))){
                helper.RemoveRowRequestDetail(param1[k].Id,1,RDetailUnsecured,cmp);
            }
            if(param1[k].Id==3 && !param1[k].IsJNEmployee && (EmpRowstr.includes(str))){
                helper.RemoveRowRequestDetail(param1[k].Id,1,RDetailUnsecured,cmp);
            }
            
        }
    },
    calculateJNLifeMonthlyPremium:function(cmp, event, helper) {
        helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
    },
    calculateJNGIMonthlyPremium:function(cmp, event, helper) {
        console.log('c1==');
        helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        
    },
    calculateProcessingFee:function(cmp, event, helper) {
        helper.calculateProcessingFeehelper(cmp, event);
        helper.calculateTotalautoloan(cmp, event);
        
    },
    calculateLoansaving:function(cmp, event, helper) {       
        var amount = cmp.find("ProposedSavings5").get("v.value");
        var percentage = cmp.find("ProposedSavings1").get("v.value");
        console.log('percentage ----------'+percentage);
        console.log('amount ----------'+amount);
        if(percentage!=''){
            cmp.set("v.disabledPSP", false);
            cmp.set("v.disabledPSA", true);          
        }
        else if(amount!=''){
            console.log('NUll ----------');
            cmp.set("v.disabledPSP", true);
            cmp.set("v.disabledPSA", false);
        }
            else if(percentage=='' && amount==''){
                console.log('Both NUll ----------');
                cmp.set("v.disabledPSP", false);
                cmp.set("v.disabledPSA", false);
            }
        
        helper.calculateTotalautoloan(cmp, event);
        
        
        
    },
    OnChangeclear:function(cmp, event, helper){
        var rdetail=cmp.get("v.RowNum");
        var isprod=cmp.get("v.isProductDetail");
        if(isprod){
            $A.enqueueAction(cmp.get('c.updateRequestdetail'));
            $A.enqueueAction(cmp.get('c.showhideCoverageType'));
        }
        cmp.find("PolicyLimit").set("v.value", "");
        cmp.find("PriortoProposedCredit").set("v.value", "");
        cmp.find("AfterProposedCredit").set("v.value", "");
        if(!isprod){
            cmp.set("v.applicant1age", false);
            cmp.set("v.applicant2age", false);
            cmp.set("v.applicant3age", false);
        }
        cmp.set("v.AutoMarketCurrency", 'JMD');
        cmp.find("Interestedinprogramme").set("v.value", '1');
        cmp.find("InterestedinCreditorLife").set("v.value", '1');
        cmp.find("WaiveProcessingFee").set("v.value", '0');
        cmp.find("Includeamoratoriumofloanrepayments").set("v.value", '1');
        cmp.find("MarketValueofVehicle1").set("v.value", '');
        cmp.find("PurchasePriceofVehicle").set("v.value", '');
        cmp.find("MotorVehicleDeposit").set("v.value", '');
        cmp.find("ProposedSavings1").set("v.value", '');
        
        
        
        $A.util.addClass(cmp.find("IndicateType"),"slds-hide");
        $A.util.addClass(cmp.find("IndicateTerm"),"slds-hide");
        $A.util.addClass(cmp.find("IndicateTerm1"),"slds-hide");
        $A.util.addClass(cmp.find("IncludeinLoanAmountfee"),"slds-hide");
        $A.util.addClass(cmp.find("Indicateapplicableprocessingfees"),"slds-hide");
        $A.util.addClass(cmp.find("CoverageType"),"slds-hide");
        $A.util.addClass(cmp.find("IncludeinLoanAmountinsurence"),"slds-hide");
        $A.util.addClass(cmp.find("Include1stYearPremiuminLoanAmount"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyPremium"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff1"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff2"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff3"),"slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorPremium"),"slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorPremium1"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifecal"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeescal"),"slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifeCreditorInsurancePremium"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeesGCT"),"slds-hide");
        $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifeCreditorInsurancePremium1"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeesGCT1"),"slds-hide");
        $A.util.addClass(cmp.find("AfterMoratoriumhead"),"slds-hide");
        $A.util.addClass(cmp.find("DuringMoratoriumhead"),"slds-hide");
        $A.util.addClass(cmp.find("Othee_post_moratorium__id"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentMarket2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN12"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN22"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentJN32"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyJNGIMotorPremium1stYear2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyJNLifeCreditorLifePremium2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyProcessingFees2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPayment2"),"slds-hide");
        $A.util.addClass(cmp.find("MonthlyLoanPaymentsaving2"),"slds-hide");
        $A.util.addClass(cmp.find("OtherPurpose"),"slds-hide");
        $A.util.addClass(cmp.find("IncludeinLoanAmountfeeUn"),"slds-hide");
        $A.util.addClass(cmp.find("IndicateapplicableprocessingfeesUn"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeescalUn"),"slds-hide");
        $A.util.addClass(cmp.find("CoverageTypeUn"),"slds-hide");
        $A.util.addClass(cmp.find("IncludeinLoanAmountinsurenceUn"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifecalUn"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingFeescalUn"),"slds-hide");
        $A.util.addClass(cmp.find("ProcessingUn"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifecalUn"),"slds-hide");
        $A.util.addClass(cmp.find("JNLifeCreditorUn"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff1Un"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff2Un"),"slds-hide");
        $A.util.addClass(cmp.find("JNstaff3Un"),"slds-hide");
    },
    ApplicantSelectionChange:function(cmp, event, helper) {
        var rowVal = cmp.find("NumberofApplicant").get("v.value");
        if(rowVal==0){
            const EmpRow=cmp.get("v.RowNum");
            if(EmpRow.length==3){
                helper.RemoveRow(1,2,EmpRow,cmp);
            }
            else if(EmpRow.length==2){
                helper.RemoveRow(1,1,EmpRow,cmp);
            }
        }
        else  if(rowVal==1){
            const EmpRow=cmp.get("v.RowNum");
            if(EmpRow.length==1){
                helper.AddRow(2,EmpRow,cmp);
            }
            else if(EmpRow.length==3){            
                helper.RemoveRow(2,1,EmpRow,cmp);
            }
        }
            else if(rowVal==2){  
                const EmpRow=cmp.get("v.RowNum");
                if(EmpRow.length==2){                
                    helper.AddRow(3,EmpRow,cmp);
                }
                else if(EmpRow.length==1){
                    helper.AddRow(2,EmpRow,cmp);
                    helper.AddRow(3,EmpRow,cmp);
                }
            }
    },
    SetMotorVehicleDeposit: function(cmp, evt, helper){
        if(cmp.find("LoanPurpose").get("v.value")=='1'){ 
            var amount = cmp.find("PurchasePriceofVehicle").get("v.value");
            var percentage = cmp.find("MotorVehicleDeposit").get("v.value");
            if(amount!=null && percentage!=null){
                var val=(amount*percentage)/100;
                if(val>0)
                    cmp.set("v.MarketValueofVehicleA", val);
                else
                    cmp.set("v.MarketValueofVehicleA", ''); 
            }
            else
                cmp.set("v.MarketValueofVehicleA", ''); 
            
            
            
            if(percentage!=''){
                cmp.set("v.disabledA", true);
                //cmp.set("v.ReqA", false);  
                //cmp.set("v.ReqP", true);  
                cmp.find("MotorVehicleDeposit4").set("v.value",'');
                //$A.util.removeClass(cmp.find("PurchasePriceofVehicle"),"slds-has-error");
            }
            else{
                console.log('NUll ----------');
                cmp.set("v.disabledA", false);
                //cmp.set("v.ReqA", false);  
                //cmp.set("v.ReqP", true);
            }
        }
        
    },
    hidePersentage : function(cmp, evt, helper){
        var amount = cmp.find("MotorVehicleDeposit4").get("v.value");                   
        if(amount!=''){
            cmp.set("v.disabledP", true);
            //cmp.set("v.ReqA", true);  
            //cmp.set("v.ReqP", false);
            cmp.find("MotorVehicleDeposit").set("v.value",'');
            //$A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-has-error");
        }
        else{
            console.log('NUll ----------');
            cmp.set("v.disabledP", false);
            //cmp.set("v.ReqA", false);  
            //cmp.set("v.ReqP", true);
            //$A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-has-error");
        }
        
        
    },
    
    showhideCoverageType: function(cmp, evt, helper){
        cmp.set("v.applicant1age", false);
        cmp.set("v.applicant2age", false);
        cmp.set("v.applicant3age", false);
        var param1 = cmp.get("v.RowNum");
        for(var k in param1) {
            var str="JN Staff "+param1[k].Id;
            if(param1[k].Id==1){
                helper.Applicantagecalculation(cmp,param1[k].DateOfBirth, param1[k].Id);
            }
            if(param1[k].Id==2){
                helper.Applicantagecalculation(cmp,param1[k].DateOfBirth, param1[k].Id);
            }
            if(param1[k].Id==3){
                helper.Applicantagecalculation(cmp,param1[k].DateOfBirth, param1[k].Id);
            }
        }
    },
    ShowHideOnInterestedinprogramme: function(cmp, evt, helper){
        var acMethod = cmp.find("Interestedinprogramme").get("v.value");
        switch(acMethod){
            case "0":
                $A.util.removeClass(cmp.find("Include1stYearPremiuminLoanAmount"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyPremium"),"slds-hide");
                $A.util.removeClass(cmp.find("JNGIMotorPremium"),"slds-hide");
                $A.util.removeClass(cmp.find("JNGIMotorPremium1"),"slds-hide");
                if(cmp.find("Include1stYearPremiuminLoanAmount").get("v.value")=='1'){
                    $A.util.removeClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
                    $A.util.removeClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
                }
                if(cmp.find("Include1stYearPremiuminLoanAmount").get("v.value")=='0'){
                    $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
                    $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
                }
                helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
                helper.calculateTotalautoloan(cmp, event);
                break;
            case "1":
                $A.util.addClass(cmp.find("Include1stYearPremiuminLoanAmount"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyPremium"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorPremium"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorPremium1"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
                helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
                helper.calculateTotalautoloan(cmp, event);
                break;
        }
        
    },
    ShowHideOnInterestedinCreditorLife: function(cmp, evt, helper){
        var acMethod = cmp.find("InterestedinCreditorLife").get("v.value");
        switch(acMethod){
            case "0":
                $A.util.removeClass(cmp.find("CoverageType"),"slds-hide");
                $A.util.removeClass(cmp.find("IncludeinLoanAmountinsurence"),"slds-hide");
                $A.util.removeClass(cmp.find("JNLifecal"),"slds-hide");
                break;
            case "1":
                $A.util.addClass(cmp.find("CoverageType"),"slds-hide");
                $A.util.addClass(cmp.find("IncludeinLoanAmountinsurence"),"slds-hide");
                $A.util.addClass(cmp.find("JNLifecal"),"slds-hide");
                break;
        }
    },
    ShowHideOnWaiveProcessingFee: function(cmp, evt, helper){
        var acMethod = cmp.find("WaiveProcessingFee").get("v.value");
        switch(acMethod){
            case "1":
                $A.util.removeClass(cmp.find("IncludeinLoanAmountfee"),"slds-hide");
                $A.util.removeClass(cmp.find("Indicateapplicableprocessingfees"),"slds-hide");
                
                if(cmp.find("IncludeinLoanAmountfee").get("v.value")=='0'){
                    $A.util.addClass(cmp.find("ProcessingFeesGCT"),"slds-hide");
                    $A.util.addClass(cmp.find("ProcessingFeesGCT1"),"slds-hide");
                    $A.util.removeClass(cmp.find("ProcessingFeescal"),"slds-hide");
                }
                else if(cmp.find("IncludeinLoanAmountfee").get("v.value")=='1'){
                    $A.util.removeClass(cmp.find("ProcessingFeesGCT"),"slds-hide");
                    $A.util.removeClass(cmp.find("ProcessingFeesGCT1"),"slds-hide");
                    $A.util.addClass(cmp.find("ProcessingFeescal"),"slds-hide");
                }
                
                helper.calculateProcessingFeehelper(cmp, event);
                helper.calculateTotalautoloan(cmp, event);
                break;
            case "0":
                $A.util.addClass(cmp.find("IncludeinLoanAmountfee"),"slds-hide");
                $A.util.addClass(cmp.find("Indicateapplicableprocessingfees"),"slds-hide");
                $A.util.addClass(cmp.find("ProcessingFeescal"),"slds-hide");
                helper.calculateProcessingFeehelper(cmp, event);
                helper.calculateTotalautoloan(cmp, event);
                break;
        }
    },
    ShowHideOnIncludeamoratoriumofloanrepayments: function(cmp, evt, helper){
        helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
        console.log('moratorium===========1');
        helper.calculateProcessingFeehelper(cmp, event);
        console.log('moratorium===========2');
        helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        console.log('moratorium===========3');
        helper.calculateTotalautoloan(cmp, event);
        var acMethod = cmp.find("Includeamoratoriumofloanrepayments").get("v.value");
        console.log('moratorium==========='+acMethod);
        switch(acMethod){
            case "0":
                $A.util.removeClass(cmp.find("IndicateType"),"slds-hide");
                $A.util.removeClass(cmp.find("IndicateTerm"),"slds-hide");
                $A.util.removeClass(cmp.find("IndicateTerm1"),"slds-hide");
                $A.util.removeClass(cmp.find("AfterMoratoriumhead"),"slds-hide");
                $A.util.removeClass(cmp.find("DuringMoratoriumhead"),"slds-hide");
                $A.util.removeClass(cmp.find("Othee_post_moratorium__id"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPaymentMarket2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN12"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN22"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPaymentJN32"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyJNGIMotorPremium1stYear2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyJNLifeCreditorLifePremium2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyProcessingFees2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPayment2"),"slds-hide");
                $A.util.removeClass(cmp.find("MonthlyLoanPaymentsaving2"),"slds-hide");
                $A.util.removeClass(cmp.find("JNLifecal"),"slds-hide");
                
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
                
                break;
            case "1":
                $A.util.addClass(cmp.find("IndicateType"),"slds-hide");
                $A.util.addClass(cmp.find("IndicateTerm"),"slds-hide");
                $A.util.addClass(cmp.find("IndicateTerm1"),"slds-hide");
                $A.util.addClass(cmp.find("AfterMoratoriumhead"),"slds-hide");
                $A.util.addClass(cmp.find("DuringMoratoriumhead"),"slds-hide");
                $A.util.addClass(cmp.find("Othee_post_moratorium__id"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPaymentMarket2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPaymentJN12"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPaymentJN22"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPaymentJN32"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyJNGIMotorPremium1stYear2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyJNGIMotorPremiumhalfPayment2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyJNLifeCreditorLifePremium2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyProcessingFees2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPayment2"),"slds-hide");
                $A.util.addClass(cmp.find("MonthlyLoanPaymentsaving2"),"slds-hide");
                
                break;
        }
    },
    UpdateMarketCurrency: function(cmp, evt, helper){
        var acMethod = cmp.find("MarketValueofVehicle").get("v.value");
        switch(acMethod){
            case "0":
                cmp.set("v.AutoMarketCurrency",'');
                break;
            case "1":
                cmp.set("v.AutoMarketCurrency",'JMD');
                break;
            case "2":
                cmp.set("v.AutoMarketCurrency",'USD');
                break;
            case "3":
                cmp.set("v.AutoMarketCurrency",'CAD');
                break;
            case "4":
                cmp.set("v.AutoMarketCurrency",'GBP');
                break;
        }
        
    },
    showhideONLoanPurpose: function(cmp, evt, helper){
        helper.calculateTotalautoloan(cmp, event);
        var acMethod = cmp.find("LoanPurpose").get("v.value");
        switch(acMethod){
            case "0":
                cmp.set("v.IsExistingLoan",false);
                $A.util.addClass(cmp.find("LoanBalanceofVehicle"),"slds-hide");
                $A.util.removeClass(cmp.find("PurchasePriceofVehicle"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit1"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit2"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit3"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDepositCurr"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDepositor"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit4"),"slds-hide");
                break;
            case "1":
                
                cmp.set("v.IsExistingLoan",false);
                $A.util.addClass(cmp.find("LoanBalanceofVehicle"),"slds-hide");
                $A.util.removeClass(cmp.find("PurchasePriceofVehicle"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit1"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit2"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit3"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDepositCurr"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDepositor"),"slds-hide");
                $A.util.removeClass(cmp.find("MotorVehicleDeposit4"),"slds-hide");
                break;
            case "2":
                cmp.set("v.IsExistingLoan",true);
                $A.util.removeClass(cmp.find("LoanBalanceofVehicle"),"slds-hide");
                $A.util.addClass(cmp.find("PurchasePriceofVehicle"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit1"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit2"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit3"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDepositCurr"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDepositor"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit4"),"slds-hide");
                break;
            case "3":
                $A.util.addClass(cmp.find("LoanBalanceofVehicle"),"slds-hide");
                $A.util.addClass(cmp.find("PurchasePriceofVehicle"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit1"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit2"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit3"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDepositCurr"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDepositor"),"slds-hide");
                $A.util.addClass(cmp.find("MotorVehicleDeposit4"),"slds-hide");
                break;
        }
        
    },
    showhideONmethod: function(cmp, evt, helper){
        var acMethod = cmp.find("selectapplicant").get("v.value");
        //$A.enqueueAction(cmp.get('c.Createapplicantlist'));
        $A.enqueueAction(cmp.get('c.OnChangeclear'));
        switch(acMethod){
            case "0":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.addClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                // $A.util.addClass(cmp.find("Total"),"slds-hide");
                
                break;
            case "1":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st1"),"slds-hide");
                $A.util.addClass(cmp.find("JNGIMotorInsurancePremium1st"),"slds-hide");
                
                break;
            case "2":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                
                
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                break;
            case "3":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.util.addClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                //========
                cmp.find("NumberofApplicant").set("v.value", "0");
                var appdata=cmp.get("v.RowNum");
                if(appdata.length==2){
                    appdata.splice(1, 1);  
                    cmp.set("v.RowNum", appdata);
                }
                else if(appdata.length==3){
                    appdata.splice(1, 2);
                    cmp.set("v.RowNum", appdata);
                    
                }
                //===========
                break;
            case "4":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                
                break;
            case "5":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                break;
            case "6":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                break;
            case "7":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                break;
            case "8":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                break;
            case "9":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                break;
            case "10":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                break;
            case "11":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                
                break;
            case "12":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                break;
            case "13":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.addClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                break;
            case "14":
                $A.util.addClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.addClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                break;
            case "15":
                $A.util.removeClass(cmp.find("AutoLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoan"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCard"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCredit"),"slds-hide");
                $A.util.removeClass(cmp.find("CalculationSection"),"slds-hide");
                $A.util.removeClass(cmp.find("AutoLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("UnsecuredLoanCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("CreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("LineofCreditCalculations"),"slds-hide");
                $A.util.removeClass(cmp.find("NumberofApplicant"),"slds-hide");
                $A.util.removeClass(cmp.find("Total"),"slds-hide");
                $A.enqueueAction(cmp.get('c.CreditCardOnLoad'));
                $A.enqueueAction(cmp.get('c.LineOfCreditOnLoad'));
                $A.enqueueAction(cmp.get('c.RequestdetailUnsecured'));
                break;
        }
        helper.calculateScoreCalculate(cmp); 
    },
    
    //=====Unsecured Loan==========
    RequestdetailUnsecured : function(cmp, event, helper){
        console.log('usecured');
        var ApplicantRow=[{
            "Id":0,
            "colIndex":"Market",
            "Interestrate":"",
            "LoanTerm1":"",
            "LoanTerm2":"",
            "LoanAmount":""
        }]
        cmp.set("v.RDetailUnsecured",ApplicantRow);
    },
    updateRequestdetailsUnsecured: function(cmp, event, helper){
        var RequestData = cmp.get("v.RDetailUnsecured");
        var loanterm = Number(RequestData[0].LoanTerm1*12)+Number(RequestData[0].LoanTerm2);
        cmp.set("v.LoanTermMarketUn", loanterm);
        
        for(var k in RequestData) {
            var i =RequestData[k].Interestrate / 1200;
            var n = Number(RequestData[k].LoanTerm1*12)+Number(RequestData[k].LoanTerm2);
            var p = RequestData[k].LoanAmount;
            var bmla= -(i * p * Math.pow((1 + i), n) / (1 - Math.pow((1 + i), n)));
            if(RequestData[k].colIndex=='Market'){
                cmp.set("v.LoanAmountMarket1UnNew", RequestData[k].LoanAmount);
                cmp.find("LoanAmountMarket1Un").set("v.value", RequestData[k].LoanAmount);
                console.log('2=====');
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountMarketAutoloanUn", bmla);
                    cmp.set("v.BMLoanamountMarketAutoloanUnNew", bmla.toFixed(2));
                }
                console.log('3=====');
            }
            if(RequestData[k].colIndex=='JN Staff 1'){
                cmp.set("v.LoanAmountJN11UnNew", RequestData[k].LoanAmount);
                cmp.find("LoanAmountJN11Un").set("v.value", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff1AutoloanUn", bmla);
                    cmp.set("v.BMLoanamountJNStaff1AutoloanUnNew", bmla.toFixed(2));
                }
            }
            if(RequestData[k].colIndex=='JN Staff 2'){
                cmp.set("v.LoanAmountJN21UnNew", RequestData[k].LoanAmount);
                cmp.find("LoanAmountJN21Un").set("v.value", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff2AutoloanUn", bmla);
                    cmp.set("v.BMLoanamountJNStaff2AutoloanUnNew", bmla.toFixed(2));
                }
            }
            if(RequestData[k].colIndex=='JN Staff 3'){
                cmp.set("v.LoanAmountJN31UnNew", RequestData[k].LoanAmount);
                cmp.find("LoanAmountJN31Un").set("v.value", RequestData[k].LoanAmount);
                if(isNaN(bmla)==false){
                    cmp.set("v.BMLoanamountJNStaff3AutoloanUn", bmla);
                    cmp.set("v.BMLoanamountJNStaff3AutoloanUnNew", bmla.toFixed(2));
                }
            }
        }
        helper.calculateProcessingFeeUnsecuredhelper(cmp, event);
        console.log('Test1=====');
        helper.calculateJNLifeMonthlyPremiumUnsecuredhelper(cmp, event);
        console.log('Test2=====');
        helper.calculateTotalUnsecuredloan(cmp, event);
        console.log('Test3=====');
    },
    showhideONLoanPurposeUnsecured: function(cmp, evt, helper){
        var acMethod = cmp.find("LoanPurposeUn").get("v.value");
        if(acMethod=="7")
            $A.util.removeClass(cmp.find("OtherPurpose"),"slds-hide");
        else
            $A.util.addClass(cmp.find("OtherPurpose"),"slds-hide");
        
    },
    ShowHideOnInterestedinCreditorLifeUnsecured: function(cmp, evt, helper){
        helper.calculateJNLifeMonthlyPremiumUnsecuredhelper(cmp, event);
        helper.calculateTotalUnsecuredloan(cmp, event);
        var acMethod = cmp.find("InterestedinCreditorLifeUn").get("v.value");
        switch(acMethod){
            case "0":
                $A.util.removeClass(cmp.find("CoverageTypeUn"),"slds-hide");
                $A.util.removeClass(cmp.find("IncludeinLoanAmountinsurenceUn"),"slds-hide");
                $A.util.removeClass(cmp.find("JNLifeCreditorUn"),"slds-hide");
                $A.util.removeClass(cmp.find("JNLifecalUn"),"slds-hide");
                
                break;
            case "1":
                $A.util.addClass(cmp.find("CoverageTypeUn"),"slds-hide");
                $A.util.addClass(cmp.find("IncludeinLoanAmountinsurenceUn"),"slds-hide");
                $A.util.addClass(cmp.find("JNLifecalUn"),"slds-hide");
                $A.util.addClass(cmp.find("JNLifeCreditorUn"),"slds-hide");
                //$A.util.addclass(cmp.find("JNLifeCreditorUn"),"slds-hide");
                break;
        }
    },
    ShowHideOnWaiveProcessingFeeUnsecured: function(cmp, evt, helper){
        helper.calculateProcessingFeeUnsecuredhelper(cmp, event);
        console.log('pavitUafter');
        helper.calculateTotalUnsecuredloan(cmp, event);
        console.log('pavitafter1');
        var acMethod = cmp.find("WaiveProcessingFeeUn").get("v.value");
        switch(acMethod){
            case "1":
                $A.util.removeClass(cmp.find("IncludeinLoanAmountfeeUn"),"slds-hide");
                $A.util.removeClass(cmp.find("IndicateapplicableprocessingfeesUn"),"slds-hide");
                //helper.calculateProcessingFeehelper(cmp, event);
                break;
            case "0":
                $A.util.addClass(cmp.find("IncludeinLoanAmountfeeUn"),"slds-hide");
                $A.util.addClass(cmp.find("IndicateapplicableprocessingfeesUn"),"slds-hide");
                //helper.calculateProcessingFeehelper(cmp, event);
                break;
        }
    },
    calculateLoansavingUnsecured: function(cmp, evt, helper){
        var amount = cmp.find("ProposedSavings5Un").get("v.value");
        var percentage = cmp.find("ProposedSavings1Un").get("v.value");
        console.log('percentage ----------'+percentage);
        console.log('amount ----------'+amount);
        if(percentage!=''){
            cmp.set("v.disabledPSP", false);
            cmp.set("v.disabledPSA", true);          
        }
        else if(amount!=''){
            console.log('NUll ----------');
            cmp.set("v.disabledPSP", true);
            cmp.set("v.disabledPSA", false);
        }
            else if(percentage=='' && amount==''){
                console.log('Both NUll ----------');
                cmp.set("v.disabledPSP", false);
                cmp.set("v.disabledPSA", false);
            }
        helper.calculateTotalUnsecuredloan(cmp, event);
    },
    
    //-----------common for Credit card and Line of Credit--------------------------------------
    ApplicantDetailsChange : function(cmp,evt,helper){
        var acMethod = cmp.find("selectapplicant").get("v.value");
        console.log("ApplicantDetailsChange==>"+acMethod);
        switch(acMethod){
            case "3":
                $A.enqueueAction(cmp.get("c.CreditCardCalculation"));
                break;
            case "4":
                $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
                break;
        }
        
        
    },
    //--------Credit Card calculation start -------------------------------------
    CreditCardOnLoad : function(cmp,evt,helper){
        // $A.util.addClass(cmp.find("NumberofApplicant"),"slds-hide");
        
        // $A.enqueueAction(cmp.get('c.ApplicantSelectionChange'));
        
        // $A.enqueueAction(cmp.get('c.ccSupplementaryApplicants'));
        // $A.enqueueAction(cmp.get('c.ccCollateralTypeChange'));
        console.log('CreditCardOnLoad==================N');
        $A.util.addClass(cmp.find("ccAnnualMembershipdiv"),"slds-hide");
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS"),"slds-hide");
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1"),"slds-hide");
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1P"),"slds-hide");
        
    },
    ccSupplementaryApplicants: function(cmp,evt,helper){
        var SupplementaryApplicants = cmp.find("ccNumberofSupplementaryApplicants").get("v.value");
        console.log('SupplementaryApplicants=================='+SupplementaryApplicants);
        switch(SupplementaryApplicants){
            case "0":
                $A.util.addClass(cmp.find("ccAnnualMembershipdiv"),"slds-hide");
                break;
            case "1":
            case "2":
            case "3":
            case "4":
            case "5":
                $A.util.removeClass(cmp.find("ccAnnualMembershipdiv"),"slds-hide");
                break;
        }           
    },
    ccCollateralTypeChange : function(cmp,evt,helper){
        var type = cmp.find("ccCollateralType").get("v.value");
        console.log('Collateral Type=================='+type);
        switch(type){
            case "0":
                $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS"),"slds-hide");
                $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1"),"slds-hide");
                $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1P"),"slds-hide");
                $A.util.addClass(cmp.find("ccTotalExistingLoanBalanceCurrency"),"slds-hide");
                //$A.enqueueAction(cmp.get('c.CreditCardCalculation'));
                break;
            case "1":
                $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS"),"slds-hide");
                $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS1"),"slds-hide");
                $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS1P"),"slds-hide");
                
                $A.util.addClass(cmp.find("ccTotalExistingLoanBalanceCurrency"),"slds-hide");
                cmp.find("ccIsthisAccounthypothecatedforanotherloan").set("v.value","0");
                $A.enqueueAction(cmp.get('c.cchypothecatedAccountChange'));
                break;
        }
        $A.enqueueAction(cmp.get('c.CreditCardCalculation'));
    },
    cchypothecatedAccountChange : function(cmp,evt,helper){
        var hypothecated = cmp.find("ccIsthisAccounthypothecatedforanotherloan").get("v.value");
        if(hypothecated=="0"){
            $A.util.addClass(cmp.find("ccTotalExistingLoanBalance"),"slds-hide");
            $A.util.addClass(cmp.find("ccTotalExistingLoanBalanceCurrency"),"slds-hide");
        }
        else{
            $A.util.removeClass(cmp.find("ccTotalExistingLoanBalance"),"slds-hide"); 
            $A.util.removeClass(cmp.find("ccTotalExistingLoanBalanceCurrency"),"slds-hide");
        }
        cmp.find("ccTotalExistingLoanBalance").set("v.value","");
        $A.enqueueAction(cmp.get('c.CreditCardCalculation'));
    },
    CreditCardCalculation: function(cmp, evt, helper){
        var GrossMonthlyIncome=0; //$AB$56
        var ExistingMonthlyCreditPayment = 0; //$AI$56 = EXISTING MONTHLY CREDIT PAYMENT
        var RequestedCreditLimit = cmp.find("ccRequestedCreditLimit").get("v.value"); // $J$122
        var interestRate = cmp.find("ccInterestRate").get("v.value");
        var CollateralType = cmp.find("ccCollateralType").get("v.value");
        var SupplementaryApplicants = cmp.find("ccNumberofSupplementaryApplicants").get("v.value");
        
        var isError =false;
        var EmpRow=cmp.get("v.RowNum");
        
        for(var k in EmpRow) {
            console.log('income======');
            console.log('income1======'+EmpRow[k].GMIncome);
            console.log('income2======'+EmpRow[k].EMCPayment);
            GrossMonthlyIncome=EmpRow[k].GMIncome;
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
        interestRate = interestRate/12;
        var startingLimit =0;
        var AV127=0;
        var AV128=0;
        var AV125=0;
        var AV126 = 0;
        var AV129 =0;
        var AV130=0; //AV130 = =MIN($AV$128:$AV$129)
        
        AV126 = interestRate + monthlyPrincipalRepayment_CCRate; //In %
        console.log('AV126 In %=====>'+AV126);
        AV126 =AV126/100;
        
        switch(CollateralType){
            case "0":
                if(GrossMonthlyIncome < 250001){
                    AV127 = 20/100;
                }
                else if(GrossMonthlyIncome > 250000){
                    AV127 = 30/100;
                }
                AV128 = AV127*GrossMonthlyIncome*12;
                var AV124 = GrossMonthlyIncome*50/100;
                AV125 = AV124-ExistingMonthlyCreditPayment; //$AV$124-$AI$56
                AV129 =helper.RoundTo(AV125/AV126, 10000);
                AV130 = Math.min(AV128, AV129);
                var Admin_TablesM20 = 66.67/100;
                startingLimit = helper.RoundTo(Math.min(AV130*Admin_TablesM20,RequestedCreditLimit),10000);
                console.log('startingLimit In None Case =====>'+startingLimit);
                break;
            case "1":
                var Admin_TablesBF7 = 95/100; //In%
                var Admin_TablesBF8 = 90/100; //In%
                var Admin_TablesBF9 = 50/100; //In%
                var AB129 = cmp.find("ccDepositAccountBalance").get("v.value");
                var AC131 = cmp.find("ccTotalExistingLoanBalance").get("v.value");
                var AX124 = 0;
                var isprod=cmp.get("v.isProductDetail");
                if(isprod){
                    var financial = cmp.find("Financial_Institution__id").get("v.value");
                    var accounttype = cmp.find("Account_Type__id").get("v.value");
                    var SecuredCollateral="0";
                    if(financial=="JN Bank Limited" && accounttype=="High Yield")
                        SecuredCollateral="1";
                    if(financial=="JN Bank Limited" && accounttype=="Direct Gain")
                        SecuredCollateral="2";
                    if(financial=="JN Fund Managers Limited" && accounttype=="Repo")
                        SecuredCollateral="3";
                    if(financial=="JN Fund Managers Limited" && accounttype=="Mutual Fund")
                        SecuredCollateral="4";
                    
                    switch(SecuredCollateral){
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
                }
                
                else{
                    var SecuredCollateral = cmp.find("ccTypeofCashSecuredCollateral").get("v.value");
                    switch(SecuredCollateral){
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
                }
                var AX126 = AX124*AB129;
                var AX127 = AX126-AC131;
                var Admin_TablesBG14 = 2.50;
                var AX125 = (interestRate + Admin_TablesBG14)/100; //In %
                var AX128 = helper.RoundTo((AX126/AX125),10000);
                var AX129 = Math.min(AX127,AX128);
                startingLimit = helper.RoundTo(Math.min(AX129,RequestedCreditLimit),10000);
                console.log('startingLimit In Cash/Investment Case =====>'+startingLimit);
                break;
        } 
        
        cmp.find("ccStartingLimit").set("v.value",startingLimit);
        
        //------------------Minimum Payment As Per Credit Limit Start -----------------------
        var MinimumPaymentAsPerCreditLimit = startingLimit*AV126;
        cmp.find("ccMinimumPaymentAsPerCreditLimit").set("v.value",MinimumPaymentAsPerCreditLimit.toFixed(2));
        
        
        //----------------------Type Of Card calculation Start ---------------------------------
        var Admin_TablesN21 =500000.00; 
        var Admin_TablesO21='Gold';
        var Admin_TablesN20=500000.01;
        var Admin_TablesO20='Classic';
        
        var Admin_TablesF19 = '3253.96'; //1st Year Annual Membership - Primary (Classic)
        var Admin_TablesF20 = '6236.77'; //1st Year Annual Membership - Primary (Gold)
        if( startingLimit > Admin_TablesN21 && startingLimit > 0 ){
            cmp.find("ccTypeofCard").set("v.value",Admin_TablesO21);
            cmp.find("ccAnnualMembership").set("v.value",Admin_TablesF20);
        }
        else if(startingLimit < Admin_TablesN20  && startingLimit > 0){
            cmp.find("ccTypeofCard").set("v.value",Admin_TablesO20);
            cmp.find("ccAnnualMembership").set("v.value",Admin_TablesF19);
        }
            else
            {
                cmp.find("ccTypeofCard").set("v.value","TBD");
                cmp.find("ccAnnualMembership").set("v.value",0);
            }
        
        var AnnualMembershipPerSupplementaryCardClassic = 1720.01;//=Admin_Tables!$F$21
        cmp.find("ccAnnualMembershippersupplementaryApplicant").set("v.value",AnnualMembershipPerSupplementaryCardClassic);
        
        
        
        
        
        
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
    LineOfCreditOnLoad : function(cmp,evt,helper){
        // $A.enqueueAction(cmp.get("c.locCollateralTypeOnChange"));
        $A.util.addClass(cmp.find("locCashInvestmentDiv1"),"slds-hide");
        $A.util.addClass(cmp.find("locCashInvestmentDiv2"),"slds-hide");
        $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1PLOC"),"slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv1"),"slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv2"),"slds-hide");
        $A.util.addClass(cmp.find("locRealEstateDiv3"),"slds-hide");
        $A.util.addClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");    
        
        
    },
    locCollateralTypeOnChange : function(cmp,evt,helper){
        var type = cmp.find("locCollateralType").get("v.value");
        console.log('Collateral Type=================='+type);
        switch(type){
            case "0":
                $A.util.addClass(cmp.find("locCashInvestmentDiv1"),"slds-hide");
                $A.util.addClass(cmp.find("locCashInvestmentDiv2"),"slds-hide");
                $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1PLOC"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv1"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv2"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv3"),"slds-hide");
                $A.util.addClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");
                $A.util.addClass(cmp.find("realstatePLOC"),"slds-hide");
                $A.util.addClass(cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),"slds-hide");
                //$A.enqueueAction(cmp.get('c.CreditCardCalculation'));
                break;
            case "1":
                $A.util.removeClass(cmp.find("locCashInvestmentDiv1"),"slds-hide");
                $A.util.removeClass(cmp.find("locCashInvestmentDiv2"),"slds-hide");
                $A.util.removeClass(cmp.find("CASH_INVESTMENTDETAILS1PLOC"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv1"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv2"),"slds-hide");
                $A.util.addClass(cmp.find("locRealEstateDiv3"),"slds-hide");
                $A.util.addClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");
                $A.util.addClass(cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),"slds-hide");
                $A.enqueueAction(cmp.get('c.locIsThisAccountHypothecatedForAnotherLoanOnchange'));
                $A.util.addClass(cmp.find("realstatePLOC"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("locCashInvestmentDiv1"),"slds-hide");
                $A.util.addClass(cmp.find("locCashInvestmentDiv2"),"slds-hide");
                $A.util.addClass(cmp.find("CASH_INVESTMENTDETAILS1PLOC"),"slds-hide");
                $A.util.removeClass(cmp.find("locRealEstateDiv1"),"slds-hide");
                $A.util.removeClass(cmp.find("locRealEstateDiv2"),"slds-hide");
                $A.util.removeClass(cmp.find("locRealEstateDiv3"),"slds-hide");
                $A.util.removeClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");
                $A.util.addClass(cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),"slds-hide");
                $A.util.removeClass(cmp.find("realstatePLOC"),"slds-hide");
                $A.enqueueAction(cmp.get('c.locIsthereanexistingleinonthispropertyOnchange'));
                break;
        }
        $A.enqueueAction(cmp.get('c.lineOfCreditCalculation'));
    },
    locIsThisAccountHypothecatedForAnotherLoanOnchange : function(cmp,evt,helper){
        var str = cmp.find("locIsThisAccountHypothecatedForAnotherLoan").get("v.value");
        switch(str){
            case "0":
                $A.util.addClass(cmp.find("locTotalExistingLoanBalance"),"slds-hide");
                $A.util.addClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");
                break;
            case "1":
                $A.util.removeClass(cmp.find("locTotalExistingLoanBalance"),"slds-hide");
                $A.util.removeClass(cmp.find("locToatLoanBalCurrency"),"slds-hide");
                break
        }
        $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
    },
    locIsthereanexistingleinonthispropertyOnchange : function(cmp,evt,helper){
        var str = cmp.find("locIsthereanexistingleinonthisproperty").get("v.value");
        switch(str){
            case "0":
                $A.util.addClass(cmp.find("locTotalExistingLoanBalanceRS"),"slds-hide");
                $A.util.addClass(cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),"slds-hide");
                break;
            case "1":
                $A.util.removeClass(cmp.find("locTotalExistingLoanBalanceRS"),"slds-hide");
                $A.util.removeClass(cmp.find("locTotalExistingLoanBalanceRSToatLoanBalCurrency"),"slds-hide");
                break
        }
        cmp.find("locTotalExistingLoanBalanceRS").set("v.value","");
        $A.enqueueAction(cmp.get("c.lineOfCreditCalculation"));
    },
    lineOfCreditCalculation : function(cmp,evt,helper){
        console.log('lineOfCreditCalculation====');
        var EmpRow=cmp.get("v.RowNum");
        var GrossMonthlyIncome=0; //$AB$56
        var ExistingMonthlyCreditPayment = 0; //$AI$56 = EXISTING MONTHLY CREDIT PAYMENT
        //var GrossMonthlyIncome2=0; 
        // var ExistingMonthlyCreditPayment2 = 0; 
        //var GrossMonthlyIncome3=0; 
        //var ExistingMonthlyCreditPayment3 = 0; 
        
        for(var k in EmpRow) {
            GrossMonthlyIncome +=parseFloat(EmpRow[k].GMIncome);
            ExistingMonthlyCreditPayment +=parseFloat(EmpRow[k].EMCPayment);         
        }
        console.log('GrossMonthlyIncome===='+GrossMonthlyIncome);
        console.log('ExistingMonthlyCreditPayment===='+ExistingMonthlyCreditPayment);
        
        
        //helper.SetDefaultVal(cmp.find("locRequestedCreditLimit"),0);
        //helper.SetDefaultVal(cmp.find("locInterestRate"),0);
        var RequestedCreditLimit=0;
        if(cmp.find("locRequestedCreditLimit").get("v.value")>0){
            RequestedCreditLimit = cmp.find("locRequestedCreditLimit").get("v.value");
        }
        var InterestRate =0;
        if(cmp.find("locInterestRate").get("v.value")>0){
            InterestRate = cmp.find("locInterestRate").get("v.value")/12;
        }
        var StartingLimit=0;
        var MinimumPaymentAsPerCreditLimit=0;
        var AnnualFacilityFee=0;
        var Admin_TablesBF14 = 3;
        var AV140 = (InterestRate+Admin_TablesBF14)/100;
        console.log('AV140===>'+AV140);
        //----------Annual Facility Fee calculation ---------------------
        //AnnualFacilityFee=Admin_Tables!$AO$27*$I$216
        //Admin_Tables!$AO$27 = 0.75%
        var Admin_TablesAO27 = .75/100;
        
        var AW56 =GrossMonthlyIncome;
        var AW57 = ExistingMonthlyCreditPayment;
        console.log('loc====1');
        var CollateralType = cmp.find("locCollateralType").get("v.value");
        console.log('CollateralType===='+CollateralType);
        switch(CollateralType){
            case "0":
                console.log('lineOfCreditCalculation====2');
                var Admin_TablesAN7 = 30/100; //IN %
                
                var AV142 = Admin_TablesAN7*AW56*12;
                console.log('AV142===='+AV142);
                console.log('AW57===='+AW57);
                var Admin_TablesBJ8 = 50/100; //IN %
                var AV138 =AW56*Admin_TablesBJ8;
                var AV139 = AV138 - AW57;
                console.log('AV139===='+AV139);
                //var Admin_TablesBF14 = 3;
                //var AV140 = (InterestRate+Admin_TablesBF14)/100;
                console.log('AV140===='+AV140);
                var AV143 = helper.RoundTo((AV139/AV140),10000);
                console.log('AV143===='+AV143);
                var AV144 = Math.min(AV142,AV143);
                var Admin_TablesAO7 = 66.67/100;
                console.log('AV144===='+AV144);
                
                StartingLimit = helper.RoundTo(Math.min(AV144*Admin_TablesAO7,RequestedCreditLimit),10000);
                console.log('StartingLimit In None Case==>'+StartingLimit);
                
                break;
            case "1":
                
                console.log('case 2==>');
                //helper.SetDefaultVal(cmp.find("locDepositAccountBalance"),0);
                //helper.SetDefaultVal(cmp.find("locTotalExistingLoanBalance"),0);
                var DepositAccountBalance =0;
                if(cmp.find("locDepositAccountBalance").get("v.value") >0){
                    DepositAccountBalance = cmp.find("locDepositAccountBalance").get("v.value");
                }
                var AC145 =0;
                if(cmp.find("locTotalExistingLoanBalance").get("v.value")>0){
                    AC145 = cmp.find("locTotalExistingLoanBalance").get("v.value");
                }
                
                console.log('case 2==>1');
                var AX138=0;
                var Admin_TablesBF7=95;
                var Admin_TablesBF8=90;
                var Admin_TablesBF9=50;
                var Admin_TablesBF10 =70; //For Real Estate
                var isprod=cmp.get("v.isProductDetail");
                if(isprod){var financial = cmp.find("Financial_Institution_LOC__id").get("v.value");
                           var accounttype = cmp.find("AccountTypeloc").get("v.value");
                           var cashType="0";
                           if(financial=="JN Bank Limited" && accounttype=="High Yield")
                               cashType="1";
                           if(financial=="JN Bank Limited" && accounttype=="Direct Gain")
                               cashType="2";
                           if(financial=="JN Fund Managers Limited" && accounttype=="Repo")
                               cashType="3";
                           if(financial=="JN Fund Managers Limited" && accounttype=="Mutual Fund")
                               cashType="4";
                           
                           switch(cashType){
                               case "1":
                                   AX138 = Admin_TablesBF7/100;
                                   break;
                               case "2":
                                   AX138 = Admin_TablesBF7/100;
                                   break;
                               case "3":
                                   AX138 = Admin_TablesBF8/100;
                                   break;
                               case "4":
                                   AX138 = Admin_TablesBF9/100;
                                   break;
                                   
                           }
                          }
                
                else{
                    var cashType = cmp.find("locTypeOfCashSecuredCollateral").get("v.value");
                    switch(cashType){
                        case "1":
                            AX138 = Admin_TablesBF7/100;
                            break;
                        case "2":
                            AX138 = Admin_TablesBF7/100;
                            break;
                        case "3":
                            AX138 = Admin_TablesBF8/100;
                            break;
                        case "4":
                            AX138 = Admin_TablesBF9/100;
                            break;
                            
                    }
                }
                console.log('case 2==>2');
                var AX140 = AX138*DepositAccountBalance;
                var AX141 = AX140-AC145;
                
                var Admin_TablesBF14 = 3; //In %
                var AX139 = (InterestRate + Admin_TablesBF14)/100;
                var AX142 = helper.RoundTo((AX140/AX139),10000);
                var AX143 = Math.min(AX141,AX142);
                console.log('case 2==>3');
                StartingLimit = helper.RoundTo(Math.min(AX143,RequestedCreditLimit),10000);
                console.log('StartingLimit In Cash/Investment Case==>'+StartingLimit);
                
                
                
                break;
            case "2":
                
                console.log('case 3==>1');
                var Admin_TablesBG10 = 5000000.00;
                
                //helper.SetDefaultVal(cmp.find("locDepositAccountBalance"),0);
                //helper.SetDefaultVal(cmp.find("locTotalExistingLoanBalance"),0);
                // helper.SetDefaultVal(cmp.find("locMarketValueofProperty"),0);
                var K148=0;
                if(cmp.find("locMarketValueofProperty").get("v.value") >0){
                    K148 = cmp.find("locMarketValueofProperty").get("v.value");
                }
                var TotalExistingLoanBalanceRS =0;
                if(cmp.find("locTotalExistingLoanBalanceRS").get("v.value")>0){
                    TotalExistingLoanBalanceRS = cmp.find("locTotalExistingLoanBalanceRS").get("v.value");
                }
                //var AC145 = cmp.find("locTotalExistingLoanBalance").get("v.value");
                
                //------------------------------------------
                var AX138=0;
                var Admin_TablesBF10 =70/100; //For Real Estate
                AX138 = Admin_TablesBF10;
                console.log('case 3==>2');
                var AX140= AX138*Math.min(K148,Admin_TablesBG10);
                var AX141 = AX140-TotalExistingLoanBalanceRS;
                
                
                
                
                
                console.log('case 3==>3');
                var Admin_TablesBF14 = 3; //In %
                var AX139 = (InterestRate + Admin_TablesBF14)/100;
                var AX142 = helper.RoundTo((AX140/AX139),10000);
                var AX143 = Math.min(AX141,AX142);
                console.log('case 3==>4');
                StartingLimit = helper.RoundTo(Math.min(AX143,RequestedCreditLimit),10000);
                
                console.log('StartingLimit In Real Estate Case==>'+StartingLimit);
                
                
                
                
                
                break;
        }
        
        MinimumPaymentAsPerCreditLimit=StartingLimit*AV140;
        AnnualFacilityFee = Admin_TablesAO27*StartingLimit;
        
        
        //------------Set calculation value in text box --------------------------
        
        cmp.find("locStartingLimit").set("v.value",helper.checkNaN(StartingLimit).toFixed(2));
        cmp.find("locMinimumPaymentAsPerCreditLimit").set("v.value",helper.checkNaN(MinimumPaymentAsPerCreditLimit).toFixed(2));
        cmp.find("locAnnualFacilityFee").set("v.value",helper.checkNaN(AnnualFacilityFee).toFixed(2));
        helper.ShowTotalAsPerCalculatorSelected(cmp);
        
    },
    SaveData: function(cmp,evt,helper){
        
        var RId = cmp.get("v.recordId");
        var leadid='';
        var oppid='';
        var objType = cmp.get("v.sobjectName");
        switch(objType){
            case "Lead":
                leadid = RId;
                break
                case "Opportunity":
                oppid = RId;
                break
        }
        
        console.log('test--------------------------101-');
        
        var Nick_Name_Of_Calculation='';
        var Monthly_Gross_Income='';
        var Existing_Monthly_Credit_Payment='';
        //------------Auto loan ----------------
        var loanpuposeauto='';
        var interestedinprogramm='';
        var includeinfirstyear='';
        var includeincreditor='';
        var CoverageType='';
        var includeinjnlife='';
        var waivefee='';
        var includefee='';
        // var includeinjnlife='';
        var includemoratorium='';
        var moratoriumterm='';
        var loanpuposeun='';
        var includeincreditorun='';
        var CoverageTypeun='';
        var includeinjnlifeun='';
        var waivefeeun='';
        var includefeeUn='';
        var Indicate_applicable_process_fee_percent='';
        var Market_Value_of_Vehicle='';
        var Motor_Vehicle_Deposit='';
        var Motor_Vehicle_Deposit_Percentage='';
        var Monthly_Premium='';
        var Proposed_Savings='';
        var Proposed_SavingsPercentage='';
        //======================
        var Purchase_Price_of_Vehicle='';
        var Indicate_Type='';
        var Othee_post_moratorium='';
        var JN_Staff1_intereste_rate='';
        var JN_Staff1_loan_term='';
        var Monthly_Loan_Payment='';
        var JN_Life_Creditor_Life_Premium='';
        var JN_life_Creditor_Life_Premium_moratorium='';
        var Monthly_JNGI_Motor_Premium_moratorium='';
        var Monthly_JNGI_Motor_Premium_1_12_Pay='';
        var Monthly_JN_Life_Creditor_Life_Premium='';
        var Monthly_Processing_Fees_moratorium='';
        var Processing_Fees_including_GCT='';
        var Total_Loan_Amount='';
        var Monthly_Loan_Savings='';
        var Monthly_loan_Payment_Monthly_Savings='';
        var Total_Loan_Savings_Balance='';
        var Total_Interest_Payment='';
        var Legal_Fees_Including_GCT='';
        var Stamp_Duty='';
        var Total_Auto_Loan_Fees_Charges='';
        var JNGI_Motor_Premium_1st_Year='';
        var Staff1_Mthly_Loan_Payment_D_Moratorium='';
        var Staff1_Mthly_Loan_Payment_A_Moratorium='';
        var Staff2_Mthly_Loan_Payment_D_Moratorium='';
        var Staff2_Mthly_Loan_Payment_A_Moratorium='';
        var Staff3_Mthly_Loan_Payment_D_Moratorium='';
        var Staff3_Mthly_Loan_Payment_A_Moratorium='';
        
        
        
        if(cmp.find("LoanPurposeUn").get("v.value")=='1')
            loanpuposeun='Asset Acquisition';
        if(cmp.find("LoanPurposeUn").get("v.value")=='2')
            loanpuposeun='Auto Repairs';
        if(cmp.find("LoanPurposeUn").get("v.value")=='3')
            loanpuposeun='Debt Consolidation';
        if(cmp.find("LoanPurposeUn").get("v.value")=='4')
            loanpuposeun='Education';
        if(cmp.find("LoanPurposeUn").get("v.value")=='5')
            loanpuposeun='Home Improvement';
        if(cmp.find("LoanPurposeUn").get("v.value")=='6')
            loanpuposeun='Medical Expenses';
        if(cmp.find("LoanPurposeUn").get("v.value")=='7')
            loanpuposeun='Other';
        
        console.log('test--------------------------106-');
        var RequestDataAuto='';
        var interestrateauto='';
        var yearauto='';
        var monthauto='';
        var loanamountauto = '';
        console.log('test--------------------------107-');
        var RDetailUnsecured='';
        var interestrateun='';
        var yearun='';
        var monthun='';
        var loanamountun = '';
        var Moratorium_Indicate_Term='';
        var Unsecure_Indcate_applicable_process_fee='';
        var Unsecure_Proposed_Savings='';
        var Unsecure_Proposed_Savings_percentage='';
        var Unsecure_Fee_Include_in_Loan_Amount='';
        var unsecure_Total_Loan_Amount='';
        var Unsecure_Monthly_Loan_Payment='';
        var unsecure_Monthly_Loan_Savings='';
        var unsecure_Total_Loan_Savings_Balance='';
        var unsecure_Total_Interest_Payment='';
        var unsecure_Legal_Fees_Including_GCT='';
        var Stamp_Duty_Security_Documents='';
        var Total_unsecured_Loan_Fee_Charges='';
        console.log('test--------------------------108-'); 
        //-----------credit card-------------
        var PC_Credit_Limit ='';
        var Reqeusted_Limit='';
        var PC_Interest_Rate='';
        var Number_of_Supplementary_Applicant='';
        var PC_Collateral_Type='';
        var Proposed_Starting_Limit = '';
        var Type_of_Card='';
        var PC_Type_of_Cash_Secured_Collateral='';
        var PC_Deposit_Account_Balance= '';
        var PC_Account_Hypothecated_for_another_Loan='';
        var PC_Total_existing_Loan_Balance= '';
        //-----------Line of credit-----------------
        var PCL_Requested_Credit_Limit='';
        var PLC_Credit_Limit_Currency='';
        var PCL_Interest_Rate='';
        var PCL_Collateral_Type = '';
        var PCL_Type_of_Cash_Secured_Collateral='';
        var PCL_Deposit_Account_Balance='';
        var PCL_Account_Hypothecated_another_Loan='';
        var PCL_Total_Existing_Loan_Balance='';
        //var Market Value of Property
        var isprod=cmp.get("v.isProductDetail");
        //=====Oppotunity Fields===========
        var Deduct1stmonthAuto='';
        var Account_Type='';
        var Account_Type_LOC='';
        var Financial_Institution='';
        var Financial_Institution_LOC='';
        var Card_used_by_other_not_cardholder='';
        console.log('test------------clc');
        //=================================
        var Account_Holders  =''; 
        var Account_Holders_LOC ='';
        var Account_Number ='';
       var Annual_Interest_Rate_on_Deposit_Acc_LOC ='';
        var Annual_Interest_Rate_on_Deposit_Account ='';
        var Desired_Monthly_Repayment_Date ='';
        var Desired_Monthly_Repayment_Date_LOC ='';
        var Desired_Monthly_Repayment_Date_UL ='';
        var Desired_Statement_Date ='';
        var Forced_Sale_Value ='';
        var Insurer ='';
        var interest_in_JN_Life_CC_Creditor_Life_iIn ='';
        var Is_a_Lien_on_Property ='';
        var Is_Property_a_Strata ='';
        var Legal_Related_Activities ='';
        var Make_and_Model_of_Motor_Vehicle ='';
        var Name_of_Valuer ='';
        var Occupancy_Type ='';
        var Othee_post_moratorium ='';
        var Property_Classification ='';
        var Property_Title_Information_Folio ='';
        var Property_Title_information_Vol ='';
        var Repayment_Method_Auto ='';
        var Repayment_Method_UL ='';
        var Replacement_Value ='';
        var Security_Address ='';
        var Vehicle_Classification ='';
        var Waive_Process_Fee ='';
        var Year_of_Motor_Vehicle ='';
        var Market_Value_of_Propert='';
        
        
        var EmpRow=cmp.get("v.RowNum");
        for(var k in EmpRow) {
            Monthly_Gross_Income=EmpRow[k].GMIncome;
            Existing_Monthly_Credit_Payment = EmpRow[k].EMCPayment;
        }
        
        
        
        var calc = cmp.find("selectapplicant").get("v.value");
        console.log('test------------'+calc);
        if(calc=='1' || calc=='5' || calc=='6' || calc=='7' ||calc=='11' || calc=='12' || calc=='13' || calc=='15'){
            console.log('test--------------------------Auto Loan');
            Nick_Name_Of_Calculation='Auto Loan';
            if(cmp.find("LoanPurpose").get("v.value")=='1')
                loanpuposeauto='Purchase a Motor Vehicle';
            if(cmp.find("LoanPurpose").get("v.value")=='2')
                loanpuposeauto='Refinance Existing Auto Loan';
            if(cmp.find("LoanPurpose").get("v.value")=='3')
                loanpuposeauto='Equity in a Motor Vehicle';
            
            if(cmp.find("Interestedinprogramme").get("v.value")=='0')
                interestedinprogramm='Yes';
            if(cmp.find("Interestedinprogramme").get("v.value")=='1')
                interestedinprogramm='No';
            if(cmp.find("Include1stYearPremiuminLoanAmount").get("v.value")=='0')
                includeinfirstyear='Yes (Include in Loan Amount)';
            if(cmp.find("Include1stYearPremiuminLoanAmount").get("v.value")=='1')
                includeinfirstyear='No (Paid by the Applicant)';
            console.log('test--------------------------Auto Loan 1');
            if(cmp.find("WaiveProcessingFee").get("v.value")=='0')
                waivefee='Yes';
            if(cmp.find("WaiveProcessingFee").get("v.value")=='1')
                waivefee='No';
            if(cmp.find("IncludeinLoanAmountinsurence").get("v.value")=='0')
                includeinjnlife='Yes (Include in Loan Amount)';
            if(cmp.find("IncludeinLoanAmountinsurence").get("v.value")=='1')
                includeinjnlife='No (Paid by the Applicant)';
            if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")=='0')
                includemoratorium='Yes';
            if(cmp.find("Includeamoratoriumofloanrepayments").get("v.value")=='1')
                includemoratorium='No';
            console.log('test--------------------------Auto Loan 2');
            if(cmp.find("IncludeinLoanAmountfee").get("v.value")=='0')
                includefee='Yes (Include in Loan Amount)';
            if(cmp.find("IncludeinLoanAmountfee").get("v.value")=='1')
                includefee='No (Paid by the Applicant)';
            if(cmp.find("InterestedinCreditorLife").get("v.value")=='0')
                includeincreditor='Yes';
            if(cmp.find("InterestedinCreditorLife").get("v.value")=='1')
                includeincreditor='No';
            console.log('test--------------------------Auto Loan 3');
            if(cmp.find("CoverageType").get("v.value")=='1')
                CoverageType='Applicant 1 Only';
            if(cmp.find("CoverageType").get("v.value")=='2')
                CoverageType='Applicant 2 Only';
            if(cmp.find("CoverageType").get("v.value")=='3')
                CoverageType='Applicant 3 Only';
            if(cmp.find("CoverageType").get("v.value")=='4')
                CoverageType='Applicant 1 & Applicant 2';
            if(cmp.find("CoverageType").get("v.value")=='5')
                CoverageType='Applicant 1 & Applicant 3';
            if(cmp.find("CoverageType").get("v.value")=='6')
                CoverageType='Applicant 2 & Applicant 3';
            if(cmp.find("CoverageType").get("v.value")=='7')
                CoverageType='No Suitable Applicants';
            console.log('test--------------------------Auto Loan 3 '+CoverageType);
            
            Indicate_applicable_process_fee_percent =cmp.find("Indicateapplicableprocessingfees").get("v.value");
            Market_Value_of_Vehicle = cmp.find("MarketValueofVehicle1").get("v.value");
            Motor_Vehicle_Deposit = cmp.find("MotorVehicleDeposit4").get("v.value");
            Motor_Vehicle_Deposit_Percentage=cmp.find("MotorVehicleDeposit").get("v.value");
            Monthly_Premium= cmp.find("MonthlyPremium").get("v.value");
            Proposed_Savings = cmp.find("ProposedSavings5").get("v.value");
            Proposed_SavingsPercentage = cmp.find("ProposedSavings1").get("v.value");
            
            if(cmp.find("IndicateTerm").get("v.value") !='0'){
                Moratorium_Indicate_Term = cmp.find("IndicateTerm").get("v.value");
            }
            RequestDataAuto=cmp.get("v.RDetailAuto");
            interestrateauto=RequestDataAuto[0].Interestrate;
            yearauto=RequestDataAuto[0].LoanTerm1;
            monthauto=RequestDataAuto[0].LoanTerm2;
            loanamountauto = RequestDataAuto[0].LoanAmount;
            //===========
            console.log('pavit--------------------------Auto Loan');
            Purchase_Price_of_Vehicle=cmp.find("PurchasePriceofVehicle").get("v.value");
            if(cmp.find("IndicateType").get("v.value") =='1'){
                Indicate_Type = 'Principal Only';
            } else if(cmp.find("IndicateType").get("v.value") =='2'){
                Indicate_Type = 'Principal and Interest';
            }
            
            Othee_post_moratorium = cmp.find("Othee_post_moratorium__id").get("v.value");
            
            if(RequestDataAuto.length>=2){
                JN_Staff1_intereste_rate=RequestDataAuto[1].Interestrate;
                JN_Staff1_loan_term=(RequestDataAuto[1].LoanTerm1*12)+RequestDataAuto[1].LoanTerm2;
            }
            console.log('pavit1--------------------------Auto Loan');
            Monthly_Loan_Payment=cmp.find("MonthlyLoanPayment1").get("v.value");
            JN_Life_Creditor_Life_Premium=cmp.find("JNLifeCreditorLifePremium1").get("v.value");
            JN_life_Creditor_Life_Premium_moratorium=cmp.find("MonthlyJNLifeCreditorLifePremium2").get("v.value");
            Monthly_JNGI_Motor_Premium_moratorium=cmp.find("MonthlyJNGIMotorPremium1stYear2").get("v.value");
            Monthly_JNGI_Motor_Premium_1_12_Pay=cmp.find("MonthlyJNGIMotorPremiumhalfPayment1").get("v.value");
            Monthly_JN_Life_Creditor_Life_Premium=cmp.find("MonthlyJNLifeCreditorLifePremium1").get("v.value");
            Monthly_Processing_Fees_moratorium=cmp.find("MonthlyProcessingFees2").get("v.value");
            console.log('pavit2--------------------------Auto Loan');
            // Processing_Fees_including_GCT=cmp.find("ProcessingFeesincludingGCT").get("v.value");
            
            // Total_Loan_Amount=cmp.find("TotalLoanAmount1").get("v.value");
            console.log('pavit3.1--------------------------Auto Loan');
            Monthly_Loan_Savings=cmp.find("MonthlyLoanSavings1").get("v.value");
            Monthly_loan_Payment_Monthly_Savings=cmp.find("MonthlyLoanPaymentsaving1").get("v.value");
            console.log('pavit3.2--------------------------Auto Loan');
            Total_Loan_Savings_Balance=cmp.find("TotalLSB1").get("v.value");
            Total_Interest_Payment=cmp.find("TotalIP1").get("v.value");
            console.log('pavit3.3--------------------------Auto Loan');
            Legal_Fees_Including_GCT=cmp.find("LegalFeesGCT1").get("v.value");
            Stamp_Duty=cmp.find("StampDutyDoc1").get("v.value");
            Total_Auto_Loan_Fees_Charges=cmp.find("TotalAutoLoanFeesCharges1").get("v.value");
            console.log('pavit3--------------------------Auto Loan');
            JNGI_Motor_Premium_1st_Year=cmp.find("JNGIMotorPremium1stYear1").get("v.value");
            if(RequestDataAuto.length>=2){
                Staff1_Mthly_Loan_Payment_D_Moratorium=cmp.find("MonthlyLoanPaymentJN11").get("v.value");
                Staff1_Mthly_Loan_Payment_A_Moratorium=cmp.find("MonthlyLoanPaymentJN12").get("v.value");
            }
            if(RequestDataAuto.length>=3){
                Staff2_Mthly_Loan_Payment_D_Moratorium=cmp.find("MonthlyLoanPaymentJN21").get("v.value");
                Staff2_Mthly_Loan_Payment_A_Moratorium=cmp.find("MonthlyLoanPaymentJN22").get("v.value");
            }
            if(RequestDataAuto.length>=4){
                Staff3_Mthly_Loan_Payment_D_Moratorium=cmp.find("MonthlyLoanPaymentJN31").get("v.value");
                Staff3_Mthly_Loan_Payment_A_Moratorium=cmp.find("MonthlyLoanPaymentJN32").get("v.value");
            }
            //=============opportunity======================= 
            if(isprod){
                if(cmp.find("Deductthe1stmonthrepayment").get("v.value") =='1'){
                    Deduct1stmonthAuto = 'Yes';
                } else if(cmp.find("Deductthe1stmonthrepayment").get("v.value") =='2'){
                    Deduct1stmonthAuto = 'No';
                }
                Vehicle_Classification = cmp.find('Vehicle_Classification__id').get('v.value');
                Desired_Monthly_Repayment_Date = cmp.find('Desired_Monthly_Repayment_Date__id').get('v.value');
                Make_and_Model_of_Motor_Vehicle = cmp.find('Make_and_Model_of_Motor_Vehicle__id').get('v.value');
                Year_of_Motor_Vehicle = cmp.find('Year_of_Motor_Vehicle__id').get('v.value');
                Othee_post_moratorium = cmp.find('Othee_post_moratorium__id').get('v.value');
                Repayment_Method_Auto = cmp.find('Repayment_Method_Auto__id').get('v.value');
                console.log('11/2/2019--------------------------1');
            }
        }
        if(calc=='2' || calc=='5' || calc=='8' || calc=='9' ||calc=='11' || calc=='12' || calc=='14' || calc=='15'){
            console.log('test--------------------------Unsecured Loan');
            Nick_Name_Of_Calculation='Unsecured Loan';
            if(cmp.find("InterestedinCreditorLifeUn").get("v.value")=='0')
                includeincreditorun='Yes';
            if(cmp.find("InterestedinCreditorLifeUn").get("v.value")=='1')
                includeincreditorun='No';
            if(cmp.find("WaiveProcessingFeeUn").get("v.value")=='0')
                waivefeeun='Yes';
            console.log('test--------------------------Unsecured Loan 1');
            if(cmp.find("WaiveProcessingFeeUn").get("v.value")=='1')
                waivefeeun='No';
            if(cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value")=='0')
                includeinjnlifeun='Yes (Include in Loan Amount)';
            console.log('test--------------------------Unsecured Loan 2');
            if(cmp.find("IncludeinLoanAmountinsurenceUn").get("v.value")=='1')
                includeinjnlifeun='No (Paid by the Applicant)';
            
            if(cmp.find("CoverageTypeUn").get("v.value")=='1')
                CoverageTypeun='Applicant 1 Only';
            if(cmp.find("CoverageTypeUn").get("v.value")=='2')
                CoverageTypeun='Applicant 2 Only';
            if(cmp.find("CoverageTypeUn").get("v.value")=='3')
                CoverageTypeun='Applicant 3 Only';
            console.log('test--------------------------Unsecured Loan 3');
            if(cmp.find("CoverageTypeUn").get("v.value")=='4')
                CoverageTypeun='Applicant 1 & Applicant 2';
            if(cmp.find("CoverageTypeUn").get("v.value")=='5')
                CoverageTypeun='Applicant 1 & Applicant 3';
            if(cmp.find("CoverageTypeUn").get("v.value")=='6')
                CoverageTypeun='Applicant 2 & Applicant 3';
            console.log('test--------------------------Unsecured Loan 4');
            if(cmp.find("CoverageTypeUn").get("v.value")=='7')
                CoverageTypeun='No Suitable Applicants';
            
            Unsecure_Indcate_applicable_process_fee=cmp.find("IndicateapplicableprocessingfeesUn").get("v.value");
            Unsecure_Proposed_Savings=cmp.find("ProposedSavings5Un").get("v.value");
            Unsecure_Proposed_Savings_percentage=cmp.find("ProposedSavings1Un").get("v.value");
            
            RDetailUnsecured=cmp.get("v.RDetailUnsecured");
            interestrateun=RDetailUnsecured[0].Interestrate;
            yearun=RDetailUnsecured[0].LoanTerm1;
            monthun=RDetailUnsecured[0].LoanTerm2;
            loanamountun = RDetailUnsecured[0].LoanAmount;
            if(cmp.find("IncludeinLoanAmountfeeUn").get("v.value")=='0')
                Unsecure_Fee_Include_in_Loan_Amount='Yes';
            else if(cmp.find("IncludeinLoanAmountfeeUn").get("v.value")=='1')
                Unsecure_Fee_Include_in_Loan_Amount='No';
            
            unsecure_Total_Loan_Amount=cmp.find("TotalLoanAmount1Un").get("v.value");
            Unsecure_Monthly_Loan_Payment=cmp.find("MonthlyLoanPayment1Un").get("v.value");
            unsecure_Monthly_Loan_Savings=cmp.find("MonthlyLoanSavings1Un").get("v.value");
            unsecure_Total_Loan_Savings_Balance=cmp.find("TotalLSB1Un").get("v.value");
            unsecure_Total_Interest_Payment=cmp.find("TotalIP1Un").get("v.value");
            unsecure_Legal_Fees_Including_GCT=cmp.find("LegalFeesGCT1Un").get("v.value");
            Stamp_Duty_Security_Documents=cmp.find("StampDutyDoc1Un").get("v.value");
            Total_unsecured_Loan_Fee_Charges=cmp.find("TotalAutoLoanFeesCharges1Un").get("v.value");
            if(isprod){
                Repayment_Method_UL = cmp.find('Repayment_Method_UL__id').get('v.value');
                Desired_Monthly_Repayment_Date_UL = cmp.find('Desired_Monthly_Repayment_Date_UL__id').get('v.value');
                console.log('11/2/2019--------------------------2');
            }
        }
        if(calc=='3' || calc=='6' || calc=='8' || calc=='10' ||calc=='11' || calc=='13' || calc=='14' || calc=='15'){
            console.log('11/2/2019--------------------------3');
            Nick_Name_Of_Calculation='Credit Card';
            PC_Credit_Limit ='JMD';
            
            Proposed_Starting_Limit = cmp.find("ccStartingLimit").get("v.value");
            console.log('11/2/2019--------------------------3a');
            PC_Collateral_Type=(cmp.find("ccCollateralType").get("v.value")=='0')?'None':'Cash/Investment';
            console.log('11/2/2019--------------------------3b');
            Reqeusted_Limit=cmp.find("ccRequestedCreditLimit").get("v.value");
            console.log('11/2/2019--------------------------3c');
            PC_Interest_Rate=cmp.find("ccInterestRate").get("v.value");
            console.log('11/2/2019--------------------------3d');
            PC_Deposit_Account_Balance= cmp.find("ccDepositAccountBalance").get("v.value");
            PC_Account_Hypothecated_for_another_Loan=(cmp.find("ccIsthisAccounthypothecatedforanotherloan").get("v.value")=='0')?'No':'Yes';
            PC_Total_existing_Loan_Balance= cmp.find("ccTotalExistingLoanBalance").get("v.value");
            
            var suppCard = cmp.find("ccNumberofSupplementaryApplicants").get("v.value");
            switch(suppCard){
                case '1':
                    Number_of_Supplementary_Applicant='1 Supplementary Cardholder';
                    break;
                case '2':
                    Number_of_Supplementary_Applicant='2 Supplementary Cardholder';
                    break;
                case '3':
                    Number_of_Supplementary_Applicant='3 Supplementary Cardholder';
                    break;
                case '4':
                    Number_of_Supplementary_Applicant='4 Supplementary Cardholder';
                    break;
                case '5':
                    Number_of_Supplementary_Applicant='5 Supplementary Cardholder';
                    break;    
            }
            console.log('11/2/2019--------------------------3e');
            if(!isprod){
                console.log('11/2/2019--------------------------3f');
                var SecuredCollateral = cmp.find("ccTypeofCashSecuredCollateral").get("v.value");
                switch(SecuredCollateral){
                    case "1":
                        PC_Type_of_Cash_Secured_Collateral = 'JN Bank - High Yield Account';
                        break;
                    case "2":
                        PC_Type_of_Cash_Secured_Collateral = 'JN Bank - Direct Gain Account';
                        break;
                    case "3":
                        PC_Type_of_Cash_Secured_Collateral = 'JNFM - Repurchase Agreement';
                        break;
                    case "4":
                        PC_Type_of_Cash_Secured_Collateral = 'JNFM - Mutual Fund';
                        break;
                }
                
            }
            
            if(isprod){
                console.log('11/2/2019--------------------------3g');
                if(cmp.find("WillCardHolder").get("v.value")=='1')
                    Card_used_by_other_not_cardholder='Yes';
                if(cmp.find("WillCardHolder").get("v.value")=='2')
                    Card_used_by_other_not_cardholder='No';
                
                var pclAcc = cmp.find("Account_Type__id").get("v.value");
                /*switch(pclAcc){
                    case "1":
                        Account_Type = 'Hight Yield';
                        break;
                    case "2":
                        Account_Type = 'Direct Gain';
                        break;
                    case "3":
                        Account_Type = 'Repo';
                        break;
                    case "4":
                        Account_Type = 'Mutual Fund';
                        break;
                }*/
                //var Financial_Institution = cmp.find("Financial_Institution__id").get("v.value");
                /*switch(pcInstitution){
                    case "1":
                        Financial_Institution = 'JN Bank Limited';
                        break;
                    case "2":
                        Financial_Institution = 'JN Fund Managers Limited';
                        break;
                }*/
                console.log('11/2/2019--------------------------3.1');
                Account_Holders = cmp.find('Account_Holders__id').get('v.value');
                console.log('11/2/2019--------------------------3.2');
                Account_Number = cmp.find('Account_Number__id').get('v.value');
                console.log('11/2/2019--------------------------3.3');
                Account_Type = cmp.find('Account_Type__id').get('v.value');
                console.log('11/2/2019--------------------------3.4');
                Annual_Interest_Rate_on_Deposit_Account = cmp.find('Annual_Interest_Rate_on_Deposit_Account__id').get('v.value');
                Financial_Institution = cmp.find('Financial_Institution__id').get('v.value');
                console.log('11/2/2019--------------------------3.2');
                //Market_Value_of_Propert=cmp.find('loc_MarketValueofProperty').get('v.value');
                //Legal_Related_Activities=cmp.find('Legal_Related_Activities__id').get('v.value');
            }
            
        }
        if(calc=='4' || calc=='7' || calc=='9' || calc=='10' ||calc=='12' || calc=='13' || calc=='14' || calc=='15'){
            console.log('testk--------------------------1-1');
            Nick_Name_Of_Calculation='Line of Credit';
            PLC_Credit_Limit_Currency='JMD';
            PCL_Interest_Rate=cmp.find("locInterestRate").get("v.value");
            PCL_Requested_Credit_Limit=cmp.find("locRequestedCreditLimit").get("v.value");
            var pclCT = cmp.find("locCollateralType").get("v.value");
            switch(pclCT){
                case "0":
                    PCL_Collateral_Type = 'None';
                    break;
                case "1":
                    PCL_Collateral_Type = 'Cash/Investment';
                    if(!isprod){
                        var pclSecuredCollateral = cmp.find("locTypeOfCashSecuredCollateral").get("v.value");
                        switch(pclSecuredCollateral){
                            case "1":
                                PCL_Type_of_Cash_Secured_Collateral = 'JN Bank - High Yield Account';
                                break;
                            case "2":
                                PCL_Type_of_Cash_Secured_Collateral = 'JN Bank - Direct Gain Account';
                                break;
                            case "3":
                                PCL_Type_of_Cash_Secured_Collateral = 'JNFM - Repurchase Agreement';
                                break;
                            case "4":
                                PCL_Type_of_Cash_Secured_Collateral = 'JNFM - Mutual Fund';
                                break;
                        }
                    }
                    PCL_Deposit_Account_Balance=cmp.find("locDepositAccountBalance").get("v.value");
                    PCL_Account_Hypothecated_another_Loan=(cmp.find("locIsThisAccountHypothecatedForAnotherLoan").get("v.value")=='0')?'No':'Yes';
                    PCL_Total_Existing_Loan_Balance=cmp.find("locTotalExistingLoanBalance").get("v.value");
                    break;
                case "2":
                    PCL_Collateral_Type = 'Real-Estate';
                    PCL_Account_Hypothecated_another_Loan=(cmp.find("locIsthereanexistingleinonthisproperty").get("v.value")=='0')?'No':'Yes';
                    PCL_Total_Existing_Loan_Balance=cmp.find("locTotalExistingLoanBalanceRS").get("v.value");
                    break;               
            }
            console.log('testk--------------------------1-');
            if(isprod){
                var pclAcc = cmp.find("AccountTypeloc").get("v.value");
                /* console.log('testk--------------------------2-');
                switch(pclAcc){
                    case "1":
                        Account_Type_LOC = 'Hight Yield';
                        break;
                    case "2":
                        Account_Type_LOC = 'Direct Gain';
                        break;
                    case "3":
                        Account_Type_LOC = 'Repo';
                        break;
                    case "4":
                        Account_Type_LOC = 'Mutual Fund';
                        break;
                }*/
                // var pcInstitution = cmp.find("Financial_Institution_LOC__id").get("v.value");
                /* console.log('testk--------------------------3-');
                switch(pcInstitution){
                    case "1":
                        Financial_Institution_LOC = 'JN Bank Limited';
                        break;
                    case "2":
                        Financial_Institution_LOC = 'JN Fund Managers Limited';
                        break;
                }*/
                Account_Holders_LOC = cmp.find('Account_Holders_LOC__id').get('v.value');
                Desired_Monthly_Repayment_Date_LOC = cmp.find('Desired_Monthly_Repayment_Date_LOC__id').get('v.value');
                Annual_Interest_Rate_on_Deposit_Acc_LOC = cmp.find('Annual_Interest_Rate_on_Deposit_Acc_LOC__id').get('v.value');
                Financial_Institution_LOC = cmp.find('Financial_Institution_LOC__id').get('v.value');
                Forced_Sale_Value = cmp.find('Forced_Sale_Value__id').get('v.value');
                Insurer = cmp.find('Insurer__id').get('v.value');
                Is_a_Lien_on_Property = cmp.find('Is_a_Lien_on_Property__id').get('v.value');
                Is_Property_a_Strata = cmp.find('Is_Property_a_Strata__id').get('v.value');
                Legal_Related_Activities = cmp.find('Legal_Related_Activities__id').get('v.value');
                Name_of_Valuer = cmp.find('Name_of_Valuer__id').get('v.value');
                Occupancy_Type = cmp.find('Occupancy_Type__id').get('v.value');
                Property_Classification = cmp.find('Property_Classification__id').get('v.value');
                Property_Title_Information_Folio = cmp.find('Property_Title_Information_Folio__id').get('v.value');
                Property_Title_information_Vol = cmp.find('Property_Title_information_Vol__id').get('v.value');
                Replacement_Value = cmp.find('Replacement_Value__id').get('v.value');
                Security_Address = cmp.find('Security_Address__id').get('v.value');
                console.log('11/2/2019--------------------------4'); 
            }
            
        }
        
        console.log('test ###############--------------------------1-');
        //Desired_Statement_Date = cmp.find('Desired_Statement_Date__id').get('v.value');
        //interest_in_JN_Life_CC_Creditor_Life_iIn = cmp.find('interest_in_JN_Life_CC_Creditor_Life_iIn__id').get('v.value');  
        console.log('Account_Holders=====>'+Account_Holders);
        console.log('Account_Holders_LOC=====>'+Account_Holders_LOC);
        console.log('Account_Number=====>'+Account_Number);
        console.log('Account_Type=====>'+Account_Type);
        console.log('Annual_Interest_Rate_on_Deposit_Acc_LOC=====>'+Annual_Interest_Rate_on_Deposit_Acc_LOC);
        console.log('Annual_Interest_Rate_on_Deposit_Account=====>'+Annual_Interest_Rate_on_Deposit_Account);
        console.log('Desired_Monthly_Repayment_Date=====>'+Desired_Monthly_Repayment_Date);
        console.log('Desired_Monthly_Repayment_Date_LOC=====>'+Desired_Monthly_Repayment_Date_LOC);
        console.log('Desired_Monthly_Repayment_Date_UL=====>'+Desired_Monthly_Repayment_Date_UL);
        console.log('Financial_Institution=====>'+Financial_Institution);
        console.log('Financial_Institution_LOC=====>'+Financial_Institution_LOC);
        console.log('Forced_Sale_Value=====>'+Forced_Sale_Value);
        console.log('Insurer=====1>'+Insurer);
        /* 
        var newCalculator = {
            'sobjectType':'Loan_Calculator__c',
            'Nick_Name_Of_Calculation__c':Nick_Name_Of_Calculation,
            'Lead_and_Referral__c':leadid,
            'Opportunity__c':oppid,
            'Monthly_Gross_Income__c':Monthly_Gross_Income,
            'Existing_Monthly_Credit_Payment__c':Existing_Monthly_Credit_Payment,
            
            'Auto_Loan_Purpose__c': loanpuposeauto,
            'Market_Value_of_Vehicle__c':Market_Value_of_Vehicle,
            'Motor_Vehicle_Deposit__c':Motor_Vehicle_Deposit,
            'Motor_Vehicle_Deposit_Percentage__c':Motor_Vehicle_Deposit_Percentage,
            'Interested_in_programme__c': interestedinprogramm,
            'Include_first_year_premium_in_loan_amt__c': includeinfirstyear, 
            'Monthly_Premium__c':Monthly_Premium,
            'Interested_in_Creditor_Life__c':includeincreditor,
            'Coverage_Type__c':CoverageType,
            'Include_in_Loan_Amount_jnlife__c':includeinjnlife,
            'Waive_Process_Fee__c':waivefee,
            'Include_in_Loan_Amount_Processing_Fee__c':includefee,
            'Indicate_applicable_process_fee_percent__c':Indicate_applicable_process_fee_percent,
            'Include_a_moratorium_of_Loan_Payment__c':includemoratorium,
            'Moratorium_Indicate_Term__c':Moratorium_Indicate_Term,
            'Proposed_Savings__c':Proposed_Savings,
            'Proposed_SavingsPercentage__c':Proposed_SavingsPercentage,
            'Interest_Rate__c':interestrateauto,
            'Years__c':yearauto,
            'Months__c':monthauto,
            'Loan_Amount__c':loanamountauto,
            'Deduct_1st_moth_Payment_from_Loan__c':Deduct1stmonthAuto,
            
            
            'unsecure_Loan_Purpose__c':loanpuposeun,
            'unsecure_Jn_Life_Creditor_Life_Insurance__c':includeincreditorun,
            'Unsecure_Coverage_Type__c':CoverageTypeun,
            'Unsecure_Include_in_Loan_Amount__c':includeinjnlifeun,
            'Unsecure_Waive_Processing_Fee__c':waivefeeun,
            
            'Unsecure_Indcate_applicable_process_fee__c':Unsecure_Indcate_applicable_process_fee,
            'Unsecure_Loan_Savings_currency__c':'',
            'Unsecure_Proposed_Savings__c':Unsecure_Proposed_Savings,
            'Unsecure_Proposed_Savings_percentage__c':Unsecure_Proposed_Savings_percentage,
            'Unsecure_Market_Per_Annum__c':interestrateun,
            'Unsecure_Years__c':yearun,
            'Unsecure_Months__c':monthun,
            
            'PC_Credit_Limit__c':PC_Credit_Limit,
            'PC_Credit_Limit_Amount__c':Reqeusted_Limit,
            'Reqeusted_Limit__c':Reqeusted_Limit,
            'PC_Interest_Rate__c':PC_Interest_Rate,
            'Number_of_Supplementary_Applicant__c':Number_of_Supplementary_Applicant,
            'PC_Collateral_Type__c' : PC_Collateral_Type,
            'PC_Type_of_Cash_Secured_Collateral__c':PC_Type_of_Cash_Secured_Collateral,
            'PC_Deposit_Account_Balance__c':PC_Deposit_Account_Balance,
            'PC_Account_Hypothecated_for_another_Loan__c':PC_Account_Hypothecated_for_another_Loan,
            'PC_Total_existing_Loan_Balance__c':PC_Total_existing_Loan_Balance,
            'Proposed_Starting_Limit__c':Proposed_Starting_Limit,
            'PCL_Requested_Credit_Limit__c':PCL_Requested_Credit_Limit,
            'PLC_Credit_Limit_Currency__c':PLC_Credit_Limit_Currency,
            'PCL_Interest_Rate__c':PCL_Interest_Rate,
            'PCL_Collateral_Type__c' : PCL_Collateral_Type,
            'PCL_Type_of_Cash_Secured_Collateral__c':PCL_Type_of_Cash_Secured_Collateral,
            'PCL_Deposit_Account_Balance__c':PCL_Deposit_Account_Balance,
            'PCL_Account_Hypothecated_another_Loan__c':PCL_Account_Hypothecated_another_Loan,
            'PCL_Total_Existing_Loan_Balance__c':PCL_Total_Existing_Loan_Balance,
            'Purchase_Price_of_Vehicle__c':Purchase_Price_of_Vehicle,
            'Processing_Fees_including_GCT__c':Processing_Fees_including_GCT,
            'Total_Loan_Amount__c':Total_Loan_Amount,
            'Monthly_Loan_Savings__c':Monthly_Loan_Savings,
            'Monthly_loan_Payment_Monthly_Savings__c':Monthly_loan_Payment_Monthly_Savings,
            'Total_Loan_Savings_Balance__c':Total_Loan_Savings_Balance,
            'Total_Interest_Payment__c':Total_Interest_Payment,
            'Legal_Fees_Including_GCT__c':Legal_Fees_Including_GCT,
            'Stamp_Duty__c':Stamp_Duty,
            'Total_Auto_Loan_Fees_Charges__c':Total_Auto_Loan_Fees_Charges,
            'Indicate_Type__c':Indicate_Type,
            
            'JN_Staff1_intereste_rate__c':JN_Staff1_intereste_rate,
            'JN_Staff1_loan_term__c':JN_Staff1_loan_term,
            'JN_Life_Creditor_Life_Premium__c':JN_Life_Creditor_Life_Premium,
            'JN_life_Creditor_Life_Premium_moratorium__c':JN_life_Creditor_Life_Premium_moratorium,
            'Monthly_JNGI_Motor_Premium_moratorium__c':Monthly_JNGI_Motor_Premium_moratorium,
            'Monthly_JNGI_Motor_Premium_1_12_Pay__c':Monthly_JNGI_Motor_Premium_1_12_Pay,
            'Monthly_JN_Life_Creditor_Life_Premium__c':Monthly_JN_Life_Creditor_Life_Premium,
            'Monthly_Processing_Fees_moratorium__c':Monthly_Processing_Fees_moratorium,
            'Monthly_Loan_Payment__c':Monthly_Loan_Payment,
            'Unsecured_Loan_Amount__c':loanamountun,
            'Unsecure_Fee_Include_in_Loan_Amount__c':Unsecure_Fee_Include_in_Loan_Amount,
            'unsecure_Total_Loan_Amount__c':unsecure_Total_Loan_Amount,
            'Unsecure_Monthly_Loan_Payment__c':Unsecure_Monthly_Loan_Payment,
            'unsecure_Monthly_Loan_Savings__c':unsecure_Monthly_Loan_Savings,
            'unsecure_Total_Loan_Savings_Balance__c':unsecure_Total_Loan_Savings_Balance,
            'unsecure_Total_Interest_Payment__c':unsecure_Total_Interest_Payment,
            'unsecure_Legal_Fees_Including_GCT__c':unsecure_Legal_Fees_Including_GCT,
            'Stamp_Duty_Security_Documents__c':Stamp_Duty_Security_Documents,
            'Total_unsecured_Loan_Fee_Charges__c':Total_unsecured_Loan_Fee_Charges,
            'JNGI_Motor_Premium_1st_Year__c':JNGI_Motor_Premium_1st_Year,
            
           
           
            
             'Staff1_Mthly_Loan_Payment_D_Moratorium__c':Staff1_Mthly_Loan_Payment_D_Moratorium,
            'Staff1_Mthly_Loan_Payment_A_Moratorium__c':Staff1_Mthly_Loan_Payment_A_Moratorium,
            'Staff2_Mthly_Loan_Payment_D_Moratorium__c':Staff2_Mthly_Loan_Payment_D_Moratorium,
            'Staff2_Mthly_Loan_Payment_A_Moratorium__c':Staff2_Mthly_Loan_Payment_A_Moratorium,
            'Staff3_Mthly_Loan_Payment_D_Moratorium__c':Staff3_Mthly_Loan_Payment_D_Moratorium,
            'Staff3_Mthly_Loan_Payment_A_Moratorium__c':Staff3_Mthly_Loan_Payment_A_Moratorium,
            
            'Account_Holders__c' :Account_Holders,
            'Account_Holders_LOC__c':Account_Holders_LOC,
            'Account_Number__c':Account_Number,
            'Account_Type__c':Account_Type,
            
            'Annual_Interest_Rate_on_Deposit_Acc_LOC__c':Annual_Interest_Rate_on_Deposit_Acc_LOC,   
           'Annual_Interest_Rate_on_Deposit_Account__c':Annual_Interest_Rate_on_Deposit_Account,
          
           //  'Desired_Monthly_Repayment_Date__c':Desired_Monthly_Repayment_Date,
           // 'Desired_Monthly_Repayment_Date_LOC__c':Desired_Monthly_Repayment_Date_LOC,
           // 'Desired_Monthly_Repayment_Date_UL__c':Desired_Monthly_Repayment_Date_UL,
            'Financial_Institution__c':Financial_Institution,
            'Financial_Institution_LOC__c':Financial_Institution_LOC,
            'Forced_Sale_Value__c':Forced_Sale_Value,
            'Insurer__c':Insurer,
            'interest_in_JN_Life_CC_Creditor_Life_iIn__c':interest_in_JN_Life_CC_Creditor_Life_iIn,
            'Is_a_Lien_on_Property__c':Is_a_Lien_on_Property,
            'Is_Property_a_Strata__c':Is_Property_a_Strata,
            'Legal_Related_Activities__c':Legal_Related_Activities,
            'Make_and_Model_of_Motor_Vehicle__c':Make_and_Model_of_Motor_Vehicle,
            'Name_of_Valuer__c':Name_of_Valuer,
            'Occupancy_Type__c':Occupancy_Type,
            
            'Property_Classification__c':Property_Classification,
            'Property_Title_Information_Folio__c':Property_Title_Information_Folio,
            'Property_Title_information_Vol__c':Property_Title_information_Vol,
            'Repayment_Method_Auto__c':Repayment_Method_Auto,
            'Repayment_Method_UL__c':Repayment_Method_UL,
            'Replacement_Value__c':Replacement_Value,
            'Security_Address__c':Security_Address,
            'Vehicle_Classification__c':Vehicle_Classification,
            //'Waive_Process_Fee__c':Waive_Process_Fee,
            //'Year_of_Motor_Vehicle__c':Year_of_Motor_Vehicle
        };
        
        
        */
        var newCalculator1 = {
            'sobjectType':'Loan_Calculator__c',
            'Nick_Name_Of_Calculation__c':Nick_Name_Of_Calculation,
            'Lead_and_Referral__c':leadid,
            'Opportunity__c':oppid,
            'Monthly_Gross_Income__c':Monthly_Gross_Income,
            'Existing_Monthly_Credit_Payment__c':Existing_Monthly_Credit_Payment,
            'Auto_Loan_Purpose__c': loanpuposeauto,
            'Market_Value_of_Vehicle__c':Market_Value_of_Vehicle,
            'Motor_Vehicle_Deposit__c':Motor_Vehicle_Deposit,
            'Motor_Vehicle_Deposit_Percentage__c':Motor_Vehicle_Deposit_Percentage,
            'Interested_in_programme__c': interestedinprogramm,
            'Include_first_year_premium_in_loan_amt__c': includeinfirstyear, 
            'Monthly_Premium__c':Monthly_Premium,
            'Interested_in_Creditor_Life__c':includeincreditor,
            'Coverage_Type__c':CoverageType,
            'Include_in_Loan_Amount_jnlife__c':includeinjnlife,
            'Waive_Process_Fee__c':waivefee,
            'Include_in_Loan_Amount_Processing_Fee__c':includefee,
            'Indicate_applicable_process_fee_percent__c':Indicate_applicable_process_fee_percent,
            'Include_a_moratorium_of_Loan_Payment__c':includemoratorium,
            'Moratorium_Indicate_Term__c':Moratorium_Indicate_Term,
            'Proposed_Savings__c':Proposed_Savings,
            'Proposed_SavingsPercentage__c':Proposed_SavingsPercentage,
            'Interest_Rate__c':interestrateauto,
            'Years__c':yearauto,
            'Months__c':monthauto,
            'Loan_Amount__c':loanamountauto,
            'Deduct_1st_moth_Payment_from_Loan__c':Deduct1stmonthAuto,
            'unsecure_Loan_Purpose__c':loanpuposeun,
            'unsecure_Jn_Life_Creditor_Life_Insurance__c':includeincreditorun,
            'Unsecure_Coverage_Type__c':CoverageTypeun,
            'Unsecure_Include_in_Loan_Amount__c':includeinjnlifeun,
            'Unsecure_Waive_Processing_Fee__c':waivefeeun,
            'Unsecure_Indcate_applicable_process_fee__c':Unsecure_Indcate_applicable_process_fee,
            'Unsecure_Loan_Savings_currency__c':'',
            'Unsecure_Proposed_Savings__c':Unsecure_Proposed_Savings,
            'Unsecure_Proposed_Savings_percentage__c':Unsecure_Proposed_Savings_percentage,
            'Unsecure_Market_Per_Annum__c':interestrateun,
            'Unsecure_Years__c':yearun,
            'Unsecure_Months__c':monthun,
            'PC_Credit_Limit__c':PC_Credit_Limit,
            'PC_Credit_Limit_Amount__c':Reqeusted_Limit,
            'Reqeusted_Limit__c':Reqeusted_Limit,
            'PC_Interest_Rate__c':PC_Interest_Rate,
            'Number_of_Supplementary_Applicant__c':Number_of_Supplementary_Applicant,
            'PC_Collateral_Type__c' : PC_Collateral_Type,
            'PC_Type_of_Cash_Secured_Collateral__c':PC_Type_of_Cash_Secured_Collateral,
            'PC_Deposit_Account_Balance__c':PC_Deposit_Account_Balance,
            'PC_Account_Hypothecated_for_another_Loan__c':PC_Account_Hypothecated_for_another_Loan,
            'PC_Total_existing_Loan_Balance__c':PC_Total_existing_Loan_Balance,
            'Proposed_Starting_Limit__c':Proposed_Starting_Limit,
            'PCL_Requested_Credit_Limit__c':PCL_Requested_Credit_Limit,
            'PLC_Credit_Limit_Currency__c':PLC_Credit_Limit_Currency,
            'PCL_Interest_Rate__c':PCL_Interest_Rate,
            'PCL_Collateral_Type__c' : PCL_Collateral_Type,
            'PCL_Type_of_Cash_Secured_Collateral__c':PCL_Type_of_Cash_Secured_Collateral,
            'PCL_Deposit_Account_Balance__c':PCL_Deposit_Account_Balance,
            'PCL_Account_Hypothecated_another_Loan__c':PCL_Account_Hypothecated_another_Loan,
            'PCL_Total_Existing_Loan_Balance__c':PCL_Total_Existing_Loan_Balance,
            'Purchase_Price_of_Vehicle__c':Purchase_Price_of_Vehicle,
            'Processing_Fees_including_GCT__c':Processing_Fees_including_GCT,
            'Total_Loan_Amount__c':Total_Loan_Amount,
            'Monthly_Loan_Savings__c':Monthly_Loan_Savings,
            'Monthly_loan_Payment_Monthly_Savings__c':Monthly_loan_Payment_Monthly_Savings,
            'Total_Loan_Savings_Balance__c':Total_Loan_Savings_Balance,
            'Total_Interest_Payment__c':Total_Interest_Payment,
            'Legal_Fees_Including_GCT__c':Legal_Fees_Including_GCT,
            'Stamp_Duty__c':Stamp_Duty,
            'Total_Auto_Loan_Fees_Charges__c':Total_Auto_Loan_Fees_Charges,
            'Indicate_Type__c':Indicate_Type,
            'JN_Staff1_intereste_rate__c':JN_Staff1_intereste_rate,
            'JN_Staff1_loan_term__c':JN_Staff1_loan_term,
            'JN_Life_Creditor_Life_Premium__c':JN_Life_Creditor_Life_Premium,
            'JN_life_Creditor_Life_Premium_moratorium__c':JN_life_Creditor_Life_Premium_moratorium,
            'Monthly_JNGI_Motor_Premium_moratorium__c':Monthly_JNGI_Motor_Premium_moratorium,
            'Monthly_JNGI_Motor_Premium_1_12_Pay__c':Monthly_JNGI_Motor_Premium_1_12_Pay,
            'Monthly_JN_Life_Creditor_Life_Premium__c':Monthly_JN_Life_Creditor_Life_Premium,
            'Monthly_Processing_Fees_moratorium__c':Monthly_Processing_Fees_moratorium,
            'Monthly_Loan_Payment__c':Monthly_Loan_Payment,
            'Unsecured_Loan_Amount__c':loanamountun,
            'Unsecure_Fee_Include_in_Loan_Amount__c':Unsecure_Fee_Include_in_Loan_Amount,
            'unsecure_Total_Loan_Amount__c':unsecure_Total_Loan_Amount,
            'Unsecure_Monthly_Loan_Payment__c':Unsecure_Monthly_Loan_Payment,
            'unsecure_Monthly_Loan_Savings__c':unsecure_Monthly_Loan_Savings,
            'unsecure_Total_Loan_Savings_Balance__c':unsecure_Total_Loan_Savings_Balance,
            'unsecure_Total_Interest_Payment__c':unsecure_Total_Interest_Payment,
            'unsecure_Legal_Fees_Including_GCT__c':unsecure_Legal_Fees_Including_GCT,
            'Stamp_Duty_Security_Documents__c':Stamp_Duty_Security_Documents,
            'Total_unsecured_Loan_Fee_Charges__c':Total_unsecured_Loan_Fee_Charges,
            'JNGI_Motor_Premium_1st_Year__c':JNGI_Motor_Premium_1st_Year,
            'Staff1_Mthly_Loan_Payment_D_Moratorium__c':Staff1_Mthly_Loan_Payment_D_Moratorium,
            'Staff1_Mthly_Loan_Payment_A_Moratorium__c':Staff1_Mthly_Loan_Payment_A_Moratorium,
            'Staff2_Mthly_Loan_Payment_D_Moratorium__c':Staff2_Mthly_Loan_Payment_D_Moratorium,
            'Staff2_Mthly_Loan_Payment_A_Moratorium__c':Staff2_Mthly_Loan_Payment_A_Moratorium,
            'Staff3_Mthly_Loan_Payment_D_Moratorium__c':Staff3_Mthly_Loan_Payment_D_Moratorium,
            'Staff3_Mthly_Loan_Payment_A_Moratorium__c':Staff3_Mthly_Loan_Payment_A_Moratorium,
        };
        console.log('Insurer=====2>');
        var newCalculator2;
        var newCalculator3;
        var newCalculator4;
        var newCalculator5;
        var newCalculator6;
        var newCalculator7;
        
        if(isprod){
           console.log('Insurer=====3>');
            if(calc=='1' || calc=='5' || calc=='6' || calc=='7' ||calc=='11' || calc=='12' || calc=='13' || calc=='15'){
                console.log('Insurer=====4>'+Repayment_Method_Auto);
                newCalculator2 = {
                    // 'Desired_Monthly_Repayment_Date__c':Desired_Monthly_Repayment_Date,
                    'Make_and_Model_of_Motor_Vehicle__c':Make_and_Model_of_Motor_Vehicle,
                    'Repayment_Method_Auto__c':Repayment_Method_Auto,
                    'Vehicle_Classification__c':Vehicle_Classification,
                    //'Year_of_Motor_Vehicle__c':Year_of_Motor_Vehicle
                };
            }
            if(calc=='2' || calc=='5' || calc=='8' || calc=='9' ||calc=='11' || calc=='12' || calc=='14' || calc=='15'){
                console.log('Insurer=====5>');
                newCalculator3 = {
                    // 'Desired_Monthly_Repayment_Date_UL__c':Desired_Monthly_Repayment_Date_UL,
                    'Repayment_Method_UL__c':Repayment_Method_UL,
                };
            }
            if(calc=='3' || calc=='6' || calc=='8' || calc=='10' ||calc=='11' || calc=='13' || calc=='14' || calc=='15'){
                console.log('Insurer=====6>'+Account_Type);
                newCalculator7= {
                'interest_in_JN_Life_CC_Creditor_Life_iIn__c':interest_in_JN_Life_CC_Creditor_Life_iIn,
                };
                    if(cmp.find("ccCollateralType").get("v.value")=='1'){
                    console.log('Insurer=====7>');
                    newCalculator4 = {
                        'Account_Number__c':Account_Number,
                        'Account_Holders__c' :Account_Holders,
                        'Account_Type__c':Account_Type,
                        'Annual_Interest_Rate_on_Deposit_Account__c':Annual_Interest_Rate_on_Deposit_Account,
                        'Financial_Institution__c':Financial_Institution,
                        
                    };
                }
            }
            if(calc=='4' || calc=='7' || calc=='9' || calc=='10' ||calc=='12' || calc=='13' || calc=='14' || calc=='15'){
                console.log('Insurer=====8>');
                if(cmp.find("locCollateralType").get("v.value")=='1'){
                   console.log('Insurer=====9>');
                    newCalculator5 = {
                        'Financial_Institution_LOC__c':Financial_Institution_LOC,
                        'Account_Holders_LOC__c':Account_Holders_LOC,
                        'Annual_Interest_Rate_on_Deposit_Acc_LOC__c':Annual_Interest_Rate_on_Deposit_Acc_LOC,
                        //'Desired_Monthly_Repayment_Date_LOC__c':Desired_Monthly_Repayment_Date_LOC,
                    };
                }
                if(cmp.find("locCollateralType").get("v.value")=='2'){
                    console.log('Insurer=====10>');
                    newCalculator6 = {
                        'Name_of_Valuer__c':Name_of_Valuer,
                        'Occupancy_Type__c':Occupancy_Type,
                        'Property_Classification__c':Property_Classification,
                        'Property_Title_Information_Folio__c':Property_Title_Information_Folio,
                        'Property_Title_information_Vol__c':Property_Title_information_Vol,
                        'Forced_Sale_Value__c':Forced_Sale_Value,
                        'Insurer__c':Insurer,
                        'Is_a_Lien_on_Property__c':Is_a_Lien_on_Property,
                        'Is_Property_a_Strata__c':Is_Property_a_Strata,
                        'Replacement_Value__c':Replacement_Value,
                        'Security_Address__c':Security_Address,
                        'Market_Value_of_Property__c':Market_Value_of_Propert,
                        
                    };
                }
            }
        }
        var newCalculator=Object.assign(newCalculator1, newCalculator2, newCalculator3, newCalculator4, newCalculator5, newCalculator6, newCalculator7);
        
        
        
        
        
        console.log('Property_Classification=====1>'+Property_Classification);
        console.log('Property_Title_Information_Folio=====1>'+Property_Title_Information_Folio);
        console.log('Property_Title_information_Vol=====1>'+Property_Title_information_Vol);
        console.log('Repayment_Method_Auto=====1>'+Repayment_Method_Auto);
        console.log('Repayment_Method_UL=====1>'+Repayment_Method_UL);
        console.log('Replacement_Value=====1>'+Replacement_Value);
        console.log('Security_Address=====1>'+Security_Address);
        console.log('Vehicle_Classification=====1>'+Vehicle_Classification);
        console.log('Year_of_Motor_Vehicle=====1>'+Year_of_Motor_Vehicle);
        
        
        console.log('test 1###############-=====>'+newCalculator);
        
        console.log('testcalc--------------------------'+calc);
        if(isprod){
            var autoscore =cmp.find('CreditScoreAuto').get('v.value');
            var unscore =cmp.find('CreditScoreUn').get('v.value');
            var ccscore =cmp.find('CreditScoreCC').get('v.value');
            var locscore =cmp.find('CreditScoreLOC').get('v.value');
            var newopp;
            
            newopp = {
                'sobjectType':'Opportunity',
                'Id':cmp.get("v.isRecordIdM"),
                'Credit_Score_Auto__c':autoscore,
                'Credit_Risk_Score_Unsecured_Loan__c':unscore,
                'Credit_Risk_Score_Credit_Card__c':ccscore,
                'Credit_Risk_Score_Line_of_Credit__c':locscore                    
            };
            
            console.log('newopp--------------------------'+newopp);
            helper.saveCalculation(cmp,evt,newCalculator,newopp);   
        }
        else
            helper.saveCalculation(cmp,evt,newCalculator);
        
    },
    //======Product Detail=============
    ChangeAccountTypelistCC: function(cmp,evt,helper){
        var acMethod = cmp.find("Financial_Institution__id").get("v.value");
        switch(acMethod){
            case "None":
                cmp.set("v.JNBankCC", false);
                cmp.set("v.JNFundCC", false);
                break;
            case "JN Bank Limited":
                cmp.set("v.JNBankCC", true);
                cmp.set("v.JNFundCC", false);
                break;
            case "JN Fund Managers Limited":
                cmp.set("v.JNBankCC", false);
                cmp.set("v.JNFundCC", true);
                break;
        }
    },
    ChangeAccountTypelistLOC: function(cmp,evt,helper){
        var acMethod = cmp.find("Financial_Institution_LOC__id").get("v.value");
        switch(acMethod){
            case "None":
                cmp.set("v.JNBankCC", false);
                cmp.set("v.JNFundCC", false);
                break;
            case "JN Bank Limited":
                cmp.set("v.JNBankLOC", true);
                cmp.set("v.JNFundLOC", false);
                break;
            case "JN Fund Managers Limited":
                cmp.set("v.JNBankLOC", false);
                cmp.set("v.JNFundLOC", true);
                break;
        }
    },
    handleLookupSelectEventProductDetail : function (cmp, event, helper) {
        var selectedRecordId = event.getParam("recordId");
        var selectedrecordName = event.getParam("recordName");
        var selectedProductName = event.getParam("Producttype");
        if(selectedProductName="Auto")
            cmp.set("v.AutoPromotion",selectedRecordId);
        if(selectedProductName="Unsecured")
            cmp.set("v.UnsecuredPromotion",selectedRecordId);
        if(selectedProductName="Credit")
            cmp.set("v.CCPromotion",selectedRecordId);
        if(selectedProductName="LineofCredit")
            cmp.set("v.LOCPromotion",selectedRecordId);
    },
    ApplicationFormDoc: function(cmp, evt, helper){
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/ApplicationForm'+'?oppid='+cmp.get("v.isRecordIdM"));
        
    },
    StatementofAffairDoc1: function(cmp, evt, helper){
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/StatementofAffair');
        
    },
    StatementofAffairDoc2: function(cmp, evt, helper){
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/StatementofAffair');
        
    },
    StatementofAffairDoc3: function(cmp, evt, helper){
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/StatementofAffair');
        
    },
    Wasexceptiongrantonchange: function(cmp, evt, helper){
        var type = cmp.find("Wasexceptiongrant").get("v.value");
        switch(type){
            case "1":
                $A.util.removeClass(cmp.find("ExceptionalTermsApprovedBy"),"slds-hide");
                $A.util.removeClass(cmp.find("DateofApproval"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("ExceptionalTermsApprovedBy"),"slds-hide");
                $A.util.addClass(cmp.find("DateofApproval"),"slds-hide");
                break;
        }
    },
    WasexceptiongrantonchangeUn: function(cmp, evt, helper){
        var type = cmp.find("WasexceptiongrantUn").get("v.value");
        switch(type){
            case "1":
                $A.util.removeClass(cmp.find("ExceptionalTermsApprovedByUn"),"slds-hide");
                $A.util.removeClass(cmp.find("DateofApprovalUn"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("ExceptionalTermsApprovedByUn"),"slds-hide");
                $A.util.addClass(cmp.find("DateofApprovalUn"),"slds-hide");
                break;
        }
    },
    WasexceptiongrantonchangeCC: function(cmp, evt, helper){
        var type = cmp.find("WasexceptiongrantCC").get("v.value");
        switch(type){
            case "1":
                $A.util.removeClass(cmp.find("ExceptionalTermsApprovedByCC"),"slds-hide");
                $A.util.removeClass(cmp.find("DateofApprovalCC"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("ExceptionalTermsApprovedByCC"),"slds-hide");
                $A.util.addClass(cmp.find("DateofApprovalCC"),"slds-hide");
                break;
        }
    },
    WasexceptiongrantonchangeLOC: function(cmp, evt, helper){
        var type = cmp.find("WasexceptiongrantLOC").get("v.value");
        switch(type){
            case "1":
                $A.util.removeClass(cmp.find("ExceptionalTermsApprovedByLOC"),"slds-hide");
                $A.util.removeClass(cmp.find("DateofApprovalLOC"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("ExceptionalTermsApprovedByLOC"),"slds-hide");
                $A.util.addClass(cmp.find("DateofApprovalLOC"),"slds-hide");
                break;
        }
    },
    CalculateMinimumMV: function(cmp, evt, helper){
       
    },
    
    
    
})