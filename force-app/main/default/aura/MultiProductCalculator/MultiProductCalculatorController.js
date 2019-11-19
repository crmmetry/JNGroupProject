({
    doInit : function(cmp, event, helper) {
        
        var isprod=cmp.get("v.isProductDetail");
        
        if(isprod){
            helper.calculateScoreCalculate(cmp); 
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
                    var noOfApplicant = applicantlst.length;
                    console.log('applicantlst====kkkk========>'+applicantlst);
                    cmp.set("v.ApplicantCount", noOfApplicant);
                    if(noOfApplicant==1){
                        cmp.find("LoanAmountauto1").set("v.value",100);
                        cmp.find("MonthlyPaymentauto1").set("v.value",100);
                        
                        cmp.find("LoanAmountUn1").set("v.value",100);
                        cmp.find("MonthlyPaymentUn1").set("v.value",100);
                        
                        cmp.find("LOCLimit1").set("v.value",100);
                        cmp.find("MinimumPayment1").set("v.value",100);
                    }
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
                    var calc = productselection;
                    if(calc=='1' || calc=='5' || calc=='6' || calc=='7' ||calc=='11' || calc=='12' || calc=='13' || calc=='15'){
                        cmp.set('v.isAutoPD',true);
                    }
                    if(calc=='2' || calc=='5' || calc=='8' || calc=='9' ||calc=='11' || calc=='12' || calc=='14' || calc=='15'){
                        cmp.set('v.isUnsecurePD',true);
                    }
                    if(calc=='3' || calc=='6' || calc=='8' || calc=='10' ||calc=='11' || calc=='13' || calc=='14' || calc=='15'){
                        cmp.set('v.isCCPD',true);
                    }
                    if(calc=='4' || calc=='7' || calc=='9' || calc=='10' ||calc=='12' || calc=='13' || calc=='14' || calc=='15'){
                        cmp.set('v.isLocPD',true);
                    }
        
                    
                    
                    
                    
                    
                    
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
        var RequestData;
        var notevent=cmp.get("v.ismoratorium");
        if(notevent){
            RequestData=cmp.get("v.RDetailAuto");
            cmp.set("v.ismoratorium", false);
        }
        else{
            RequestData = event.getParam("RequestData");
            cmp.set("v.RDetailAuto", RequestData);
        }
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
                var ijn1 =RequestData[k].Interestrate;
                var njn1 = Number(RequestData[k].LoanTerm1*12)+Number(RequestData[k-1].LoanTerm2);
                console.log('1p========='+ijn1);
                console.log('1p========='+njn1);
                console.log('1p========='+RequestData[k].LoanAmount);
                var pjn1 = RequestData[k].LoanAmount;
                var bmlajn1= helper.PMTcalculator(ijn1, njn1, pjn1);
                cmp.set("v.LoanamountJNStaff1Autoloan", RequestData[k].LoanAmount);
                if(isNaN(bmlajn1)==false){
                    cmp.set("v.BMLoanamountJNStaff1Autoloan", bmlajn1);
                    //cmp.set("v.LoanamountJNStaff1Autoloannew", bmlajn1.toFixed(2));
                    cmp.find("MonthlyLoanPaymentJN11").set("v.value", bmlajn1.toFixed(2));
                    cmp.set("v.MonthlyLoanPaymentJN12New", bmlajn1);
                    cmp.find("MonthlyLoanPaymentJN12").set("v.value", bmlajn1.toFixed(2));
                    
                }
            }
            if(RequestData[k].colIndex=='JN Staff 2'){
                var ijn2 =RequestData[k].Interestrate;
                var njn2 = Number(RequestData[k].LoanTerm1*12)+Number(RequestData[k].LoanTerm2);
                console.log('2p========='+ijn2);
                console.log('2p========='+njn2);
                console.log('2p========='+RequestData[k].LoanAmount);
                var pjn2 = RequestData[k].LoanAmount;
                
                var bmlajn2= helper.PMTcalculator(ijn2, njn2, pjn2);
                cmp.set("v.LoanamountJNStaff2Autoloan", RequestData[k].LoanAmount);
                if(isNaN(bmlajn2)==false){
                    cmp.set("v.BMLoanamountJNStaff2Autoloan", bmlajn2);
                    //cmp.set("v.LoanamountJNStaff2Autoloannew", bmlajn2.toFixed(2));
                    cmp.find("MonthlyLoanPaymentJN21").set("v.value", bmlajn2.toFixed(2))
                    cmp.set("v.MonthlyLoanPaymentJN22New", bmlajn2);
                    cmp.find("MonthlyLoanPaymentJN22").set("v.value", bmlajn2.toFixed(2))
                }
                
            }
            if(RequestData[k].colIndex=='JN Staff 3'){
                var ijn3 =RequestData[k].Interestrate;
                var njn3 = Number(RequestData[k].LoanTerm1*12)+Number(RequestData[k].LoanTerm2);
                console.log('3========='+RequestData[k].LoanAmount);
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
        $A.enqueueAction(cmp.get("c.calculateAppAutoPortionOnchange"));
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
        
        // helper.calculateJNLifeMonthlyPremiumhelper(cmp, event);
        console.log('moratorium===========1');
        //helper.calculateProcessingFeehelper(cmp, event);
        console.log('moratorium===========2');
        // helper.calculateJNGIMonthlyPremiumhelper(cmp, event);
        console.log('moratorium===========3');
        // helper.calculateTotalautoloan(cmp, event);
        cmp.set("v.ismoratorium", true);
        console.log('enqueueAction===========1'+cmp.get("v.ismoratorium"));
        $A.enqueueAction(cmp.get('c.Requestdetaileventhandler'));
        
        console.log('enqueueAction===========2');
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
        $A.enqueueAction(cmp.get("c.calculateAppUnsecurePortionOnchange"));
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
        var count =1;
        for(var k in EmpRow) {
            if(count==1){
                console.log('CC income======'+EmpRow[k].GMIncome);
                console.log('CC Payment======'+EmpRow[k].EMCPayment);
                GrossMonthlyIncome=EmpRow[k].GMIncome;
                ExistingMonthlyCreditPayment = EmpRow[k].EMCPayment;
            }
            count = count+1;
        }
        
        var monthlyPrincipalRepayment_CCRate = 2.5;
        interestRate = interestRate/12;
        var startingLimit =0;
        var AV127 =0;
        var AV128 =0;
        var AV125 =0;
        var AV126 =0;
        var AV129 =0;
        var AV130 =0; //AV130 = =MIN($AV$128:$AV$129)
        
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
                if(RequestedCreditLimit!=''){ //JN1-2254
                    startingLimit = helper.RoundTo(Math.min(AV130*Admin_TablesM20,RequestedCreditLimit),10000);
                }else{
                    startingLimit = helper.RoundTo(AV130*Admin_TablesM20,10000);
                }
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
        
        if(cmp.get("v.isProductDetail"))
            helper.ExistingAssetsandLiabilities(cmp);
        else
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
        
        
        for(var k in EmpRow) {
            if(EmpRow[k].GMIncome !='')
                GrossMonthlyIncome +=parseFloat(EmpRow[k].GMIncome);
            if(EmpRow[k].EMCPayment !='')
                ExistingMonthlyCreditPayment +=parseFloat(EmpRow[k].EMCPayment);         
        }
        console.log('LOC GrossMonthlyIncome===='+GrossMonthlyIncome);
        console.log('LOC ExistingMonthlyCreditPayment===='+ExistingMonthlyCreditPayment);
        
        
        //helper.SetDefaultVal(cmp.find("locRequestedCreditLimit"),0);
        //helper.SetDefaultVal(cmp.find("locInterestRate"),0);
        var RequestedCreditLimit='';
        //if(cmp.find("locRequestedCreditLimit").get("v.value")>0){
        RequestedCreditLimit = cmp.find("locRequestedCreditLimit").get("v.value");
        // }
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
                console.log('Loc RequestedCreditLimit==>'+RequestedCreditLimit);
                if(RequestedCreditLimit !=''){
                    StartingLimit = helper.RoundTo(Math.min(AV144*Admin_TablesAO7,RequestedCreditLimit),10000);
                }else{
                    StartingLimit = helper.RoundTo(AV144*Admin_TablesAO7,10000);
                }
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
                console.log('Loc RequestedCreditLimit 1==>'+RequestedCreditLimit);
                if(RequestedCreditLimit !=''){
                    StartingLimit = helper.RoundTo(Math.min(AX143,RequestedCreditLimit),10000);
                }
                else{
                    StartingLimit = helper.RoundTo(AX143,10000);
                }
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
                console.log('Loc RequestedCreditLimit 2==>'+RequestedCreditLimit);
                if(RequestedCreditLimit !=''){
                    StartingLimit = helper.RoundTo(Math.min(AX143,RequestedCreditLimit),10000);
                }
                else{
                    StartingLimit = helper.RoundTo(AX143,10000);
                }
                
                console.log('StartingLimit In Real Estate Case==>'+StartingLimit);
                
                
                
                
                
                break;
        }
        
        MinimumPaymentAsPerCreditLimit=StartingLimit*AV140;
        AnnualFacilityFee = Admin_TablesAO27*StartingLimit;
        
        
        //------------Set calculation value in text box --------------------------
        
        cmp.find("locStartingLimit").set("v.value",helper.checkNaN(StartingLimit).toFixed(2));
        cmp.find("locMinimumPaymentAsPerCreditLimit").set("v.value",helper.checkNaN(MinimumPaymentAsPerCreditLimit).toFixed(2));
        cmp.find("locAnnualFacilityFee").set("v.value",helper.checkNaN(AnnualFacilityFee).toFixed(2));
        
        if(cmp.get("v.isProductDetail"))
            helper.ExistingAssetsandLiabilities(cmp);
        else
            helper.ShowTotalAsPerCalculatorSelected(cmp);
       $A.enqueueAction(cmp.get("c.calculateAppLocPortionOnchange")); 
    },
    SaveData: function(cmp,evt,helper){
        var calc = cmp.find("selectapplicant").get("v.value");
        var isprod=cmp.get("v.isProductDetail");
        if(isprod){
            var isPortionValid=true;
            var isProposedHaveValue=true;
            if(calc=='1' || calc=='6'){
                var App1Portion=cmp.get('v.isAutoLoanPortionValid');
                var App1PortionPay=cmp.get('v.isAutoPayPortionValid');
                if(App1Portion || App1PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 1 & 6 ===========>'+isPortionValid);
                var psautoP = cmp.find('ProposedSavings1').get('v.value');
                var psautoA = cmp.find('ProposedSavings5').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedAuto',true);
                }
                else{
                    cmp.set('v.isProposedAuto',false);
                }
                
            }        
            if(calc=='2' || calc=='8'){
                var App2Portion=cmp.get('v.isUnsecureLoanPortionValid');
                var App2PortionPay=cmp.get('v.isUnsecurePayPortionValid');
                if(App2Portion || App2PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 2 & 8 ===========>'+isPortionValid);
                var psautoP = cmp.find('ProposedSavings1Un').get('v.value');
                var psautoA = cmp.find('ProposedSavings5Un').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedUN',true);
                }
                else{
                    cmp.set('v.isProposedUN',false);
                }
            }
            if(calc=='4' || calc=='10'){
                var App3Portion=cmp.get('v.isLocLoanPortionValid');
                var App3PortionPay=cmp.get('v.isLocPayPortionValid');
                if(App3Portion || App3PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 4 & 10 ===========>'+isPortionValid);
            }
            if(calc=='5' || calc=='11'){
                var App1Portion=cmp.get('v.isAutoLoanPortionValid');
                var App1PortionPay=cmp.get('v.isAutoPayPortionValid');
                var App2Portion=cmp.get('v.isUnsecureLoanPortionValid');
                var App2PortionPay=cmp.get('v.isUnsecurePayPortionValid');
                if(App1Portion || App2Portion || App1PortionPay || App2PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 5 & 11 ===========>'+isPortionValid);
                var psautoP = cmp.find('ProposedSavings1').get('v.value');
                var psautoA = cmp.find('ProposedSavings5').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedAuto',true);
                }
                else{
                    cmp.set('v.isProposedAuto',false);
                }
                
                var psautoP = cmp.find('ProposedSavings1Un').get('v.value');
                var psautoA = cmp.find('ProposedSavings5Un').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedUN',true);
                }
                else{
                    cmp.set('v.isProposedUN',false);
                }
            }
            if(calc=='7' || calc=='13'){
                var App1Portion=cmp.get('v.isAutoLoanPortionValid');
                var App1PortionPay=cmp.get('v.isAutoPayPortionValid');
                var App3Portion=cmp.get('v.isLocLoanPortionValid');
                var App3PortionPay=cmp.get('v.isLocPayPortionValid');
                if(App1Portion || App3Portion || App1PortionPay || App3PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 7 & 13 ===========>'+isPortionValid);
                 var psautoP = cmp.find('ProposedSavings1').get('v.value');
                var psautoA = cmp.find('ProposedSavings5').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedAuto',true);
                }
                else{
                    cmp.set('v.isProposedAuto',false);
                }
               
            }
            if(calc=='9' || calc=='14'){
                var App2Portion=cmp.get('v.isUnsecureLoanPortionValid');
                var App2PortionPay=cmp.get('v.isUnsecurePayPortionValid');
                var App3Portion=cmp.get('v.isLocLoanPortionValid');
                var App3PortionPay=cmp.get('v.isLocPayPortionValid');
                if(App2Portion || App3Portion || App2PortionPay || App3PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 9 & 14 ===========>'+isPortionValid);
               
                var psautoP = cmp.find('ProposedSavings1Un').get('v.value');
                var psautoA = cmp.find('ProposedSavings5Un').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedUN',true);
                }
                else{
                    cmp.set('v.isProposedUN',false);
                }
            }
            if(calc=='15' || calc=='12'){
                var App1Portion=cmp.get('v.isAutoLoanPortionValid');
                var App1PortionPay=cmp.get('v.isAutoPayPortionValid');
                var App2Portion=cmp.get('v.isUnsecureLoanPortionValid');
                var App2PortionPay=cmp.get('v.isUnsecurePayPortionValid');
                var App3Portion=cmp.get('v.isLocLoanPortionValid');
                var App3PortionPay=cmp.get('v.isLocPayPortionValid');
                if(App1Portion || App2Portion || App3Portion || App1PortionPay || App2PortionPay || App3PortionPay){
                    isPortionValid=false; 
                }
                console.log('validation 15 & 12 ===========>'+isPortionValid);
                 var psautoP = cmp.find('ProposedSavings1').get('v.value');
                var psautoA = cmp.find('ProposedSavings5').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedAuto',true);
                }
                else{
                    cmp.set('v.isProposedAuto',false);
                }
                var psautoP = cmp.find('ProposedSavings1Un').get('v.value');
                var psautoA = cmp.find('ProposedSavings5Un').get('v.value');
                if(psautoP =='' && psautoA==''){
                    isProposedHaveValue=false;
                    cmp.set('v.isProposedUN',true);
                }
                else{
                    cmp.set('v.isProposedUN',false);
                }
            }
            console.log('validation of 100===========>'+isPortionValid);
            if(!isPortionValid){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please update the fields against page validation/s to proceed and Save.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return null;
            }
            if(!isProposedHaveValue){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please update the fields against page validation/s to proceed and Save.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return null;
            }
        }
        console.log('############### validation Pass ###############');
        
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
        
        console.log('objType---------------------------'+objType);
       
        var applicant1name='';
        var applicant1dob='';
        var applicant1gmi='';
        var applicant1mcp='';
        var applicant1isjn=false;
        var applicant2name='';
        var applicant2dob='';
        var applicant2gmi='';
        var applicant2mcp='';
        var applicant2isjn=false;
        var applicant3name='';
        var applicant3dob='';
        var applicant3gmi='';
        var applicant3mcp='';
        var applicant3isjn=false;
        var numberapp;
        
        
        console.log('pavit1');
        var numberapplst=cmp.get("v.RowNum");
        if(numberapplst != undefined)
            numberapp = numberapplst.length;
        console.log('pavit-1');
        console.log('pavit-1.1111==>'+cmp.find("CoverageType").get("v.value"));
        //var calc = cmp.find("selectapplicant").get("v.value");
        if(calc=='1' || calc=='5' || calc=='6' || calc=='7' ||calc=='11' || calc=='12' || calc=='13' || calc=='15' ||calc=='2' || calc=='8' || calc=='9'  || calc=='14'){
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
            console.log('pavit-1.222==>'+cmp.find("CoverageType").get("v.value"));
            var invaliddobstr='ok';
            var coveragetypeselected=cmp.find("CoverageType").get("v.value");
            var coveragetypeselectedUn=cmp.find("CoverageTypeUn").get("v.value");
            if(numberapp>=1){
                applicant1name=numberapplst[0].FirstName+' '+numberapplst[0].LastName; 
                applicant1dob=numberapplst[0].DateOfBirth;
                applicant1gmi=numberapplst[0].GMIncome;
                applicant1mcp=numberapplst[0].EMCPayment;
                applicant1isjn=numberapplst[0].IsJNEmployee;
                var dob1=cmp.get("v.applicant1age");
                if(dob1==false &&(coveragetypeselected==1 || coveragetypeselected==4 || coveragetypeselected==5 || coveragetypeselectedUn==1 || coveragetypeselectedUn==4 || coveragetypeselectedUn==5)){
                    invaliddobstr='Applicant1 must be over 18 or under 65.';
                    
                }
            }
            
            console.log('pavit2');
            if(numberapp>=2){
                applicant2name=numberapplst[1].FirstName+' '+numberapplst[1].LastName;
                console.log('pavit2');
                applicant2dob=numberapplst[1].DateOfBirth;
                console.log('pavit2');
                applicant2gmi=numberapplst[1].GMIncome;
                console.log('pavit2');
                applicant2mcp=numberapplst[1].EMCPayment;
                console.log('pavit2');
                applicant2isjn=numberapplst[1].IsJNEmployee;
                var dob2=cmp.get("v.applicant2age");
                if(dob2==false && (coveragetypeselected==2 || coveragetypeselected==4 || coveragetypeselected==6 || coveragetypeselectedUn==2 || coveragetypeselectedUn==4 || coveragetypeselectedUn==6)){
                    if(invaliddobstr=='ok')
                        invaliddobstr='Applicant 2 must be over 18 or under 65.';
                    else
                        invaliddobstr=invaliddobstr+'Applicant 2 must be over 18 or under 65.';
                    
                }
            }
            
            console.log('pavit3');
            if(numberapp==3){
                applicant3name=numberapplst[2].FirstName+' '+numberapplst[2].LastName;
                applicant3dob=numberapplst[2].DateOfBirth;
                applicant3gmi=numberapplst[2].GMIncome;
                applicant3mcp=numberapplst[2].EMCPayment;
                applicant3isjn=numberapplst[2].IsJNEmployee;
                var dob3=cmp.get("v.applicant3age");
                if(dob3==false && (coveragetypeselected==3 ||coveragetypeselected==5 ||coveragetypeselected==6 || coveragetypeselectedUn==3 || coveragetypeselectedUn==5 || coveragetypeselectedUn==6)){
                    if(invaliddobstr=='ok')
                        invaliddobstr='Applicant 3 must be over 18 or under 65.';
                    else
                        invaliddobstr=invaliddobstr+'Applicant 3 must be over 18 or under 65.';
                    
                }
            }
            
            if(invaliddobstr!='ok'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: invaliddobstr,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'Error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return null;
            }    
        }
        
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
        //CREDIT REPAYMENT ALLOCATION 
        var App_1_Loan_Amount_A='';
        var App_2_Loan_Amount_A='';
        var App_3_Loan_Amount_A='';
        
        var App1_Monthly_Payment_A='';
        var App_2_Monthly_Payment_A='';
        var App_3_Monthly_Payment_A='';
        
        var App_1_LOC_limit='';
        var App_2_LOC_Limit='';
        var App_3_LOC_Limit='';
        
        var App_1_Min_Payment='';
        var App_2_Min_Payment_LOC='';
        var App_3_Min_Payment_LOC='';
        
        var App_1_Loan_Amount_UL='';
        var App_2_Loan_Amount_UL='';
        var App_3_Loan_Amount_UL='';
        
        var App_1_Monthly_Payment_UL='';
        var App_2_Monthly_Payment_UL='';
        var App_3_Monthly_Payment_UL='';
        
        
        var App1_Loan_Amt_Alloc_UL='';
        var App2_Loan_Amt_Alloc_UL='';
        var App3_Loan_Amt_Alloc_UL='';
        var App1_Mnthly_Pmt_Alloc_UL='';
        var App2_Mnthly_Pmt_Alloc_UL='';
        var App3_Mnthly_Pmt_Alloc_UL='';
        var App1_Loan_Amt_Alloc='';
        var App2_Loan_Amt_Alloc='';
        var App3_Loan_Amt_Alloc='';
        var App1_Mnthly_Pmt_Alloc='';
        var App2_Mnthly_Pmt_Alloc='';
        var App3_Mnthly_Pmt_Alloc='';
        var App1_Portion_LOC_Lim='';
        var App2_Portion_LOC_Lim='';
        var App3_Portion_LOC_Lim='';
        var App1_Portion_Min_Pay_LOC='';
        var App2_Portion_Min_Pay_LOC='';
        var App3_Portion_Min_Pay_LOC='';
        
        
        
        
        
        
        var EmpRow=cmp.get("v.RowNum");
        for(var k in EmpRow) {
            Monthly_Gross_Income=EmpRow[k].GMIncome;
            Existing_Monthly_Credit_Payment = EmpRow[k].EMCPayment;
        }
        
        
        
        
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
                console.log('asdfsdfas------------Auto Loan');
                console.log('cmp.find("ApplicantCount").get("v.value")-----------Auto Loan'+cmp.get("v.ApplicantCount"));
                if(cmp.get("v.ApplicantCount")>=1){
                    App1_Loan_Amt_Alloc= cmp.find('LoanAmountauto11').get('v.value');
                    App1_Mnthly_Pmt_Alloc= cmp.find('MonthlyPaymentauto11').get('v.value');
                    App_1_Loan_Amount_A=parseFloat(cmp.find("LoanAmountauto1").get("v.value"));
                    App1_Monthly_Payment_A=parseFloat(cmp.find("MonthlyPaymentauto1").get("v.value"));
                }
                if(cmp.get("v.ApplicantCount")>=2){
                    App2_Loan_Amt_Alloc= cmp.find('LoanAmountauto21').get('v.value');
					App2_Mnthly_Pmt_Alloc= cmp.find('MonthlyPaymentauto21').get('v.value');
                    App_2_Loan_Amount_A=parseFloat(cmp.find("LoanAmountauto2").get("v.value"));
                    App_2_Monthly_Payment_A=parseFloat(cmp.find("MonthlyPaymentauto2").get("v.value"));
                }
                if(cmp.get("v.ApplicantCount")>=3){
                    App3_Loan_Amt_Alloc= cmp.find('LoanAmountauto31').get('v.value');
					App3_Mnthly_Pmt_Alloc= cmp.find('MonthlyPaymentauto31').get('v.value');
                    App_3_Loan_Amount_A=parseFloat(cmp.find("LoanAmountauto3").get("v.value"));
                    App_3_Monthly_Payment_A=parseFloat(cmp.find("MonthlyPaymentauto3").get("v.value"));
                }
                
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
                if(cmp.get("v.ApplicantCount")>=1){
                    App1_Loan_Amt_Alloc_UL= cmp.find('LoanAmountUn11').get('v.value');
					App1_Mnthly_Pmt_Alloc_UL= cmp.find('MonthlyPaymentUn11').get('v.value');
                    App_1_Loan_Amount_UL=parseFloat(cmp.find("LoanAmountUn1").get("v.value"));
                    App_1_Monthly_Payment_UL=(cmp.find("MonthlyPaymentUn1").get("v.value"));
                }
                if(cmp.get("v.ApplicantCount")>=2){
                    App2_Loan_Amt_Alloc_UL= cmp.find('LoanAmountUn21').get('v.value');
					App2_Mnthly_Pmt_Alloc_UL= cmp.find('MonthlyPaymentUn21').get('v.value');
                    App_2_Loan_Amount_UL=parseFloat(cmp.find("LoanAmountUn2").get("v.value"));
                    App_2_Monthly_Payment_UL=parseFloat(cmp.find("MonthlyPaymentUn2").get("v.value"));
                }
                
                if(cmp.get("v.ApplicantCount")>=3){
                    App3_Loan_Amt_Alloc_UL= cmp.find('LoanAmountUn31').get('v.value');
					App3_Mnthly_Pmt_Alloc_UL= cmp.find('MonthlyPaymentUn31').get('v.value');
                    App_3_Loan_Amount_UL=parseFloat(cmp.find("LoanAmountUn3").get("v.value"));
                    App_3_Monthly_Payment_UL=parseFloat(cmp.find("MonthlyPaymentUn3").get("v.value"));
                }
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
                if(cmp.get("v.ApplicantCount")>=1){
                    App1_Portion_LOC_Lim= cmp.find('LOCLimit11').get('v.value');
					App1_Portion_Min_Pay_LOC= cmp.find('MinimumPayment11').get('v.value');
                    App_1_LOC_limit=parseFloat(cmp.find("LOCLimit1").get("v.value"));
                    App_1_Min_Payment=parseFloat(cmp.find("MinimumPayment1").get("v.value"));
                }
                if(cmp.get("v.ApplicantCount")>=2){
                    App2_Portion_LOC_Lim= cmp.find('LOCLimit21').get('v.value');
					App2_Portion_Min_Pay_LOC= cmp.find('MinimumPayment21').get('v.value');
                    App_2_LOC_Limit=parseFloat(cmp.find("LOCLimit2").get("v.value"));
                    App_2_Min_Payment_LOC=parseFloat(cmp.find("MinimumPayment2").get("v.value"));
                }
                if(cmp.get("v.ApplicantCount")>=3){
                    App3_Portion_LOC_Lim= cmp.find('LOCLimit31').get('v.value');
					App3_Portion_Min_Pay_LOC= cmp.find('MinimumPayment31').get('v.value');
                    App_3_LOC_Limit=parseFloat(cmp.find("LOCLimit3").get("v.value"));
                    App_3_Min_Payment_LOC=parseFloat(cmp.find("MinimumPayment3").get("v.value"));
                }
                
                var pclAcc = cmp.find("AccountTypeloc").get("v.value");
                
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
        
        //console.log('test ###############--------------------------1-');
        //Desired_Statement_Date = cmp.find('Desired_Statement_Date__id').get('v.value');
        //interest_in_JN_Life_CC_Creditor_Life_iIn = cmp.find('interest_in_JN_Life_CC_Creditor_Life_iIn__id').get('v.value');  
       // console.log('Account_Holders=====>'+Account_Holders);
        //console.log('Account_Holders_LOC=====>'+Account_Holders_LOC);
        //console.log('Account_Number=====>'+Account_Number);
        //console.log('Account_Type=====>'+Account_Type);
        //console.log('Annual_Interest_Rate_on_Deposit_Acc_LOC=====>'+Annual_Interest_Rate_on_Deposit_Acc_LOC);
        //console.log('Annual_Interest_Rate_on_Deposit_Account=====>'+Annual_Interest_Rate_on_Deposit_Account);
        //console.log('Desired_Monthly_Repayment_Date=====>'+Desired_Monthly_Repayment_Date);
        //console.log('Desired_Monthly_Repayment_Date_LOC=====>'+Desired_Monthly_Repayment_Date_LOC);
        //console.log('Desired_Monthly_Repayment_Date_UL=====>'+Desired_Monthly_Repayment_Date_UL);
        //console.log('Financial_Institution=====>'+Financial_Institution);
        //console.log('Financial_Institution_LOC=====>'+Financial_Institution_LOC);
        //console.log('Forced_Sale_Value=====>'+Forced_Sale_Value);
        //console.log('Insurer=====1>'+Insurer);
        
        
        
        var newCalculator1 = {
            'sobjectType':'Loan_Calculator__c',
            'Applicant_1_Name__c':applicant1name,
            'Applocant_2_Name__c':applicant2name,
            'Applicant_3_Name__c':applicant3name,
            'Applicant_1_Date_of_Birth__c':applicant1dob,
            'Applicant_1_Gross_Monthly_Income__c':applicant1gmi,
            'Applicant_1_Existing_Monthly_Payment__c':applicant1mcp,
            'Applicant_1_Jn_Employee__c':applicant1isjn,
            'Applicant_2_Date_of_Birth__c':applicant2dob,
            'Applicant_2_Gross_Monthly_income__c':applicant2gmi,
            'Applicant_2_existing_monthly_credit__c':applicant2mcp,
            'Applicant_2_JN_Employee__c':applicant2isjn,
            'Applicant_3_Date_of_Birth__c':applicant2dob,
            'Applicant_3_Gross_Monthly_income__c':applicant2gmi,
            'Applicant_3_Existing_Monthly__c':applicant2mcp,
            'Applicant_3_Jn_Employee__c':applicant2isjn,
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
        //console.log('Insurer=====2>');
        var newCalculator2;
        var newCalculator3;
        var newCalculator4;
        var newCalculator5;
        var newCalculator6;
        var newCalculator7;
        var newCalculator8;//For CREDIT REPAYMENT ALLOCATION
        //console.log('newCalculator8=====ff>'+newCalculator8);
        
        //console.log('newCalculator8=====1>'+App_1_Loan_Amount_A);
        //console.log('newCalculator8=====12>'+App_2_Loan_Amount_A);
        //console.log('newCalculator8=====13>'+App_3_Loan_Amount_A);
        //console.log('newCalculator8=====14>'+App1_Monthly_Payment_A);
        //console.log('newCalculator8=====15>'+App_2_Monthly_Payment_A);
        //console.log('newCalculator8=====16>'+App_3_Monthly_Payment_A);
       // console.log('newCalculator8=====17>'+App_1_LOC_limit);
        //console.log('newCalculator8=====18>'+App_2_LOC_Limit);
        //console.log('newCalculator8=====19>'+App_3_LOC_Limit);
        //console.log('newCalculator8=====110>'+App_1_Min_Payment);
        //console.log('newCalculator8=====111>'+App_2_Min_Payment_LOC);
        //console.log('newCalculator8=====112>'+App_3_Min_Payment_LOC);
        //console.log('newCalculator8=====113>'+App_1_Loan_Amount_UL);
        //console.log('newCalculator8=====114>'+App_2_Loan_Amount_UL);
        //console.log('newCalculator8=====115>'+App_3_Loan_Amount_UL);
        //console.log('newCalculator8=====116>'+App_1_Monthly_Payment_UL);
        //console.log('newCalculator8=====117>'+App_2_Monthly_Payment_UL);
        //console.log('newCalculator8=====118>'+App_3_Monthly_Payment_UL);
        
        if(isprod){
            newCalculator8 = {
                'App_1_Loan_Amount_A__c':App_1_Loan_Amount_A,
                'App_2_Loan_Amount_A__c':App_2_Loan_Amount_A,
                'App_3_Loan_Amount_A__c':App_3_Loan_Amount_A,
                'App1_Monthly_Payment_A__c':App1_Monthly_Payment_A,
                'App_2_Monthly_Payment_A__c':App_2_Monthly_Payment_A,
                'App_3_Monthly_Payment_A__c':App_3_Monthly_Payment_A,
                'App_1_LOC_limit__c':App_1_LOC_limit,
                'App_2_LOC_Limit__c':App_2_LOC_Limit,
                'App_3_LOC_Limit__c':App_3_LOC_Limit,
                'App_1_Min_Payment__c':App_1_Min_Payment,
                'App_2_Min_Payment_LOC__c':App_2_Min_Payment_LOC,
                'App_3_Min_Payment_LOC__c':App_3_Min_Payment_LOC,
                'App_1_Loan_Amount_UL__c':App_1_Loan_Amount_UL,
                'App_2_Loan_Amount_UL__c':App_2_Loan_Amount_UL,
                'App_3_Loan_Amount_UL__c':App_3_Loan_Amount_UL,
                'App_1_Monthly_Payment_UL__c':App_1_Monthly_Payment_UL,
                'App_2_Monthly_Payment_UL__c':App_2_Monthly_Payment_UL,
                'App_3_Monthly_Payment_UL__c':App_3_Monthly_Payment_UL,
                
                'App1_Loan_Amt_Alloc_UL__c':App1_Loan_Amt_Alloc_UL,
                'App2_Loan_Amt_Alloc_UL__c':App2_Loan_Amt_Alloc_UL,
                'App3_Loan_Amt_Alloc_UL__c':App3_Loan_Amt_Alloc_UL,
                'App1_Mnthly_Pmt_Alloc_UL__c':App1_Mnthly_Pmt_Alloc_UL,
                'App2_Mnthly_Pmt_Alloc_UL__c':App2_Mnthly_Pmt_Alloc_UL,
                'App3_Mnthly_Pmt_Alloc_UL__c':App3_Mnthly_Pmt_Alloc_UL,
                'App1_Loan_Amt_Alloc__c':App1_Loan_Amt_Alloc,
                'App2_Loan_Amt_Alloc__c':App2_Loan_Amt_Alloc,
                'App3_Loan_Amt_Alloc__c':App3_Loan_Amt_Alloc,
                'App1_Mnthly_Pmt_Alloc__c':App1_Mnthly_Pmt_Alloc,
                'App2_Mnthly_Pmt_Alloc__c':App2_Mnthly_Pmt_Alloc,
                'App3_Mnthly_Pmt_Alloc__c':App3_Mnthly_Pmt_Alloc,
                'App1_Portion_LOC_Lim__c':App1_Portion_LOC_Lim,
                'App2_Portion_LOC_Lim__c':App2_Portion_LOC_Lim,
                'App3_Portion_LOC_Lim__c':App3_Portion_LOC_Lim,
                'App1_Portion_Min_Pay_LOC__c':App1_Portion_Min_Pay_LOC,
                'App2_Portion_Min_Pay_LOC__c':App2_Portion_Min_Pay_LOC,
                'App3_Portion_Min_Pay_LOC__c':App3_Portion_Min_Pay_LOC,
                
            };
            //console.log('newCalculator8after=====1>'+newCalculator8);
            //console.log('Insurer=====3>');
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
        //console.log('newCalculator8=====333>'+newCalculator8);
        var newCalculator=Object.assign(newCalculator1, newCalculator2, newCalculator3, newCalculator4, newCalculator5, newCalculator6, newCalculator7, newCalculator8);
        //var newCalculator=Object.assign(newCalculator1, newCalculator2, newCalculator3, newCalculator4, newCalculator5, newCalculator6, newCalculator7);
        //console.log('newCalculator8=====444>'+newCalculator8);
        
        
        
        
        //console.log('Property_Classification=====1>'+Property_Classification);
        //console.log('Property_Title_Information_Folio=====1>'+Property_Title_Information_Folio);
        //console.log('Property_Title_information_Vol=====1>'+Property_Title_information_Vol);
        //console.log('Repayment_Method_Auto=====1>'+Repayment_Method_Auto);
        //console.log('Repayment_Method_UL=====1>'+Repayment_Method_UL);
        //console.log('Replacement_Value=====1>'+Replacement_Value);
        //console.log('Security_Address=====1>'+Security_Address);
        //console.log('Vehicle_Classification=====1>'+Vehicle_Classification);
        //console.log('Year_of_Motor_Vehicle=====1>'+Year_of_Motor_Vehicle);
        
        
        console.log('loan calculator for save =====>'+newCalculator);
        
        console.log('Calc Type is Product Details ?------------'+isprod);
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
            helper.saveLoanCalculation(cmp,evt,newCalculator);
        
    },
    ValidateProposedSaving : function(cmp){
        
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
        var oppid = cmp.get("v.isRecordIdM");
        helper.savePdfOnOpp(cmp,oppid);   
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/ApplicationForm'+'?oppid='+oppid);
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
    
    //======CREDIT REPAYMENT ALLOCATION UnSecure=============
    calculateAppUnsecurePortionOnchange : function(cmp, evt, helper){
        $A.enqueueAction(cmp.get("c.showLoanAmountUn1"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentUn1"));
        
        $A.enqueueAction(cmp.get("c.showLoanAmountUn2"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentUn2"));
        
        $A.enqueueAction(cmp.get("c.showLoanAmountUn3"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentUn3"));
    },
    showLoanAmountUn1 : function(cmp, event, helper) {
        console.log('showLoanAmountUn1 == ');
        var loanamt1=cmp.find("LoanAmountUn1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("TotalLoanAmount1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountUn11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortion"));
    },
    showMonthlyPaymentUn1 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentUn1 == ');
        var loanamt1=cmp.find("MonthlyPaymentUn1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentUn11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortionPay"));
    },
    showLoanAmountUn2 : function(cmp, event, helper) {
        console.log('showLoanAmountUn2 == ');
        var loanamt1=cmp.find("LoanAmountUn2").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("TotalLoanAmount1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountUn21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortion"));
    },
    showMonthlyPaymentUn2 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentUn2 == ');
        var loanamt1=cmp.find("MonthlyPaymentUn2").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentUn21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortionPay"));
    },
    showLoanAmountUn3 : function(cmp, event, helper) {
        console.log('showLoanAmountUn3 == ');
        var loanamt1=cmp.find("LoanAmountUn3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("TotalLoanAmount1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountUn31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortion"));
    },
    showMonthlyPaymentUn3 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentUn3 == ');
        var loanamt1=cmp.find("MonthlyPaymentUn3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("MonthlyLoanPayment1Un").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentUn31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantUnSecurePortionPay"));
    },
    calculateApplicantUnSecurePortion : function(cmp){
        var loanamt1=0;
        var loanamt2=0;
        var loanamt3=0;
        
        
        var totalLoan =0;
        
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            loanamt1=cmp.find("LoanAmountUn1").get("v.value");
            if(loanamt1 !='')
                totalLoan +=parseFloat(loanamt1);
            
            
        }
        if(count>=2){
            loanamt2=cmp.find("LoanAmountUn2").get("v.value");
            if(loanamt2 !='')
                totalLoan +=parseFloat(loanamt2);
            
            
        }
        if(count>=3){
            loanamt3=cmp.find("LoanAmountUn3").get("v.value");
            if(loanamt3 !='')
                totalLoan +=parseFloat(loanamt3);
            
            
        }
        console.log('totalLoan UN=>'+totalLoan);
       
        if(totalLoan !=100){
            cmp.set("v.isUnsecureLoanPortionValid",true);           
        }
        else{
            cmp.set("v.isUnsecureLoanPortionValid",false);  
        }
        
        console.log('isUnsecureLoanPortionValid========>'+cmp.get("v.isUnsecureLoanPortionValid"));
        
    },
    calculateApplicantUnSecurePortionPay : function(cmp){
        
        var monthlyPay1=0;
        var monthlyPay2=0;
        var monthlyPay3=0;
        
        var totalPay =0;
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            monthlyPay1=cmp.find("MonthlyPaymentUn1").get("v.value");
            if(monthlyPay1 !='')
                totalPay +=parseFloat(monthlyPay1);
        }
        if(count>=2){
            monthlyPay2=cmp.find("MonthlyPaymentUn2").get("v.value");
            if(monthlyPay2 !='')
                totalPay +=parseFloat(monthlyPay2);
        }
        if(count>=3){
            monthlyPay3=cmp.find("MonthlyPaymentUn3").get("v.value");
            if(monthlyPay3 !='')
                totalPay +=parseFloat(monthlyPay3);
        }
        
        console.log('totalPay=>'+totalPay);
        if(totalPay !=100){
            cmp.set("v.isUnsecurePayPortionValid",true);           
        }
        else{
            cmp.set("v.isUnsecurePayPortionValid",false);  
        }
        
        console.log('isUnsecurePayPortionValid========>'+cmp.get("v.isUnsecurePayPortionValid"));
    },
    //======CREDIT REPAYMENT ALLOCATION Auto Loan=============
     calculateAppAutoPortionOnchange : function(cmp, evt, helper){
        $A.enqueueAction(cmp.get("c.showLoanAmountAuto1"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentAuto1"));
        
        $A.enqueueAction(cmp.get("c.showLoanAmountAuto2"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentAuto2"));
        
        $A.enqueueAction(cmp.get("c.showLoanAmountAuto3"));
        $A.enqueueAction(cmp.get("c.showMonthlyPaymentAuto3"));
    },
    
    showLoanAmountAuto1 : function(cmp, event, helper) {
        console.log('showLoanAmountAuto1 == ');
        var loanamt1=cmp.find("LoanAmountauto1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        console.log('perloanamt1 == '+perloanamt1);
        var totalval1 = cmp.find("TotalLoanAmount1").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountauto11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortion"));
    },
    showMonthlyPaymentAuto1 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentAuto1 == ');
        var loanamt1=cmp.find("MonthlyPaymentauto1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        
        var beforeMonthlyLoanPayment1 = parseFloat(cmp.find("MonthlyLoanPayment1").get("v.value"));
        console.log('beforeMonthlyLoanPayment1 == '+beforeMonthlyLoanPayment1);
        var afterMonthlyLoanPayment2 = parseFloat(cmp.find("MonthlyLoanPayment2").get("v.value"));
        console.log('afterMonthlyLoanPayment2 == '+afterMonthlyLoanPayment2);
        var maxMonthlyLoanPayment=Math.max(beforeMonthlyLoanPayment1,afterMonthlyLoanPayment2);
        console.log('maxMonthlyLoanPayment == '+maxMonthlyLoanPayment);
        var param1 = maxMonthlyLoanPayment*perloanamt1;
        
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentauto11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortionPay"));
    },
    showLoanAmountAuto2 : function(cmp, event, helper) {
        console.log('showLoanAmountAuto2 == ');
        var loanamt1=cmp.find("LoanAmountauto2").get("v.value");
        var perloanamt1=loanamt1/100;
        console.log('perloanamt1 == '+perloanamt1);
        var totalval1 = cmp.find("TotalLoanAmount1").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountauto21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortion"));
    },
    showMonthlyPaymentAuto2 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentAuto2 == ');
        var loanamt1=cmp.find("MonthlyPaymentauto2").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        
        var beforeMonthlyLoanPayment1 = parseFloat(cmp.find("MonthlyLoanPayment1").get("v.value"));
        console.log('beforeMonthlyLoanPayment1 == '+beforeMonthlyLoanPayment1);
        var afterMonthlyLoanPayment2 = parseFloat(cmp.find("MonthlyLoanPayment2").get("v.value"));
        console.log('afterMonthlyLoanPayment2 == '+afterMonthlyLoanPayment2);
        var maxMonthlyLoanPayment=Math.max(beforeMonthlyLoanPayment1,afterMonthlyLoanPayment2);
        console.log('maxMonthlyLoanPayment == '+maxMonthlyLoanPayment);
        var param1 = maxMonthlyLoanPayment*perloanamt1;
        
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentauto21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortionPay"));
    },
    showLoanAmountAuto3 : function(cmp, event, helper) {
        console.log('showLoanAmountAuto3 == ');
        var loanamt1=cmp.find("LoanAmountauto3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        console.log('perloanamt1 == '+perloanamt1);
        var totalval1 = cmp.find("TotalLoanAmount1").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LoanAmountauto31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortion"));
    },
    showMonthlyPaymentAuto3 : function(cmp, event, helper) {
        console.log('showMonthlyPaymentAuto3 == ');
        var loanamt1=cmp.find("MonthlyPaymentauto3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        console.log('perloanamt1 == '+perloanamt1);
        var beforeMonthlyLoanPayment1 = parseFloat(cmp.find("MonthlyLoanPayment1").get("v.value"));
        console.log('beforeMonthlyLoanPayment1 == '+beforeMonthlyLoanPayment1);
        var afterMonthlyLoanPayment2 = parseFloat(cmp.find("MonthlyLoanPayment2").get("v.value"));
        console.log('afterMonthlyLoanPayment2 == '+afterMonthlyLoanPayment2);
        var maxMonthlyLoanPayment=Math.max(beforeMonthlyLoanPayment1,afterMonthlyLoanPayment2);
        console.log('maxMonthlyLoanPayment == '+maxMonthlyLoanPayment);
        var param1 = maxMonthlyLoanPayment*perloanamt1;
        
        console.log('param1 == '+param1);
        cmp.find("MonthlyPaymentauto31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantAutoPortionPay"));
    },
    calculateApplicantAutoPortion : function(cmp){
        var loanamt1=0;
        var loanamt2=0;
        var loanamt3=0;
        
        
        var totalLoan =0;
        
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            loanamt1=cmp.find("LoanAmountauto1").get("v.value");
            if(loanamt1 !='')
                totalLoan +=parseFloat(loanamt1);
            
            
        }
        if(count>=2){
            loanamt2=cmp.find("LoanAmountauto2").get("v.value");
            if(loanamt2 !='')
                totalLoan +=parseFloat(loanamt2);
            
            
        }
        if(count>=3){
            loanamt3=cmp.find("LoanAmountauto3").get("v.value");
            if(loanamt3 !='')
                totalLoan +=parseFloat(loanamt3);
            
            
        }
        console.log('totalLoan=>'+totalLoan);
        
        if(totalLoan !=100){
            cmp.set("v.isAutoLoanPortionValid",true);           
        }
        else{
            cmp.set("v.isAutoLoanPortionValid",false);  
        }
        
        console.log('isAutoLoanPortionValid========>'+cmp.get("v.isAutoLoanPortionValid"));
        
    },
    calculateApplicantAutoPortionPay : function(cmp){
        
        
        var monthlyPay1=0;
        var monthlyPay2=0;
        var monthlyPay3=0;
        
        var totalPay =0;
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            monthlyPay1=cmp.find("MonthlyPaymentauto1").get("v.value");
            if(monthlyPay1 !='')
                totalPay +=parseFloat(monthlyPay1);
        }
        if(count>=2){
            monthlyPay2=cmp.find("MonthlyPaymentauto2").get("v.value");
            if(monthlyPay2 !='')
                totalPay +=parseFloat(monthlyPay2);
        }
        if(count>=3){
            monthlyPay3=cmp.find("MonthlyPaymentauto3").get("v.value");
            if(monthlyPay3 !='')
                totalPay +=parseFloat(monthlyPay3);
        }
        
        console.log('totalPay=>'+totalPay);
        
        if(totalPay !=100){
            cmp.set("v.isAutoPayPortionValid",true);           
        }
        else{
            cmp.set("v.isAutoPayPortionValid",false);  
        }
        console.log('isAutoPayPortionValid========>'+cmp.get("v.isAutoPayPortionValid"));
    },
    //======CREDIT REPAYMENT ALLOCATION LOC=============
    calculateAppLocPortionOnchange : function(cmp, evt, helper){
        $A.enqueueAction(cmp.get("c.showLOCLimit1"));
        $A.enqueueAction(cmp.get("c.showMinimumPayment1"));
        
        $A.enqueueAction(cmp.get("c.showLOCLimit2"));
        $A.enqueueAction(cmp.get("c.showMinimumPayment2"));
        
        $A.enqueueAction(cmp.get("c.showLOCLimit3"));
        $A.enqueueAction(cmp.get("c.showMinimumPayment3"));
    },
    showLOCLimit1 : function(cmp, event, helper) {
        console.log('showLOCLimit1 == ');
        var loanamt1=cmp.find("LOCLimit1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locStartingLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LOCLimit11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortion")); 
    },
    showMinimumPayment1 : function(cmp, event, helper) {
        console.log('showMinimumPayment1 == ');
        var loanamt1=cmp.find("MinimumPayment1").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MinimumPayment11").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortionPay")); 
    },
    showLOCLimit2 : function(cmp, event, helper) {
        console.log('showLOCLimit2 == ');
        var loanamt1=cmp.find("LOCLimit2").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locStartingLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LOCLimit21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortion")); 
    },
    showMinimumPayment2 : function(cmp, event, helper) {
        console.log('showMinimumPayment2 == ');
        var loanamt1=cmp.find("MinimumPayment2").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MinimumPayment21").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortionPay")); 
    },
    showLOCLimit3 : function(cmp, event, helper) {
        console.log('showLOCLimit3 == ');
        var loanamt1=cmp.find("LOCLimit3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locStartingLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("LOCLimit31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortion")); 
    },
    showMinimumPayment3 : function(cmp, event, helper) {
        console.log('showMinimumPayment3 == ');
        var loanamt1=cmp.find("MinimumPayment3").get("v.value");
        console.log('loanamt1 == '+loanamt1);
        var perloanamt1=loanamt1/100;
        var totalval1 = cmp.find("locMinimumPaymentAsPerCreditLimit").get("v.value");
        console.log('totalval1 == '+totalval1);
        var param1 = totalval1*perloanamt1;
        console.log('param1 == '+param1);
        cmp.find("MinimumPayment31").set("v.value",param1);
        $A.enqueueAction(cmp.get("c.calculateApplicantLocPortionPay")); 
    },
    calculateApplicantLocPortion : function(cmp){
        var loanamt1=0;
        var loanamt2=0;
        var loanamt3=0;
        
        
        var totalLoan =0;
        
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            loanamt1=cmp.find("LOCLimit1").get("v.value");
            if(loanamt1 !='')
                totalLoan +=parseFloat(loanamt1);
            
        }
        if(count>=2){
            loanamt2=cmp.find("LOCLimit2").get("v.value");
            if(loanamt2 !='')
                totalLoan +=parseFloat(loanamt2);
            
            
        }
        if(count>=3){
            loanamt3=cmp.find("LOCLimit3").get("v.value");
            if(loanamt3 !='')
                totalLoan +=parseFloat(loanamt3);
            
            
        }
        console.log('totalLoan=>'+totalLoan);
        
        if(totalLoan !=100){
            cmp.set("v.isLocLoanPortionValid",true);           
        }
        else{
            cmp.set("v.isLocLoanPortionValid",false);  
        }
        
        console.log('isLocLoanPortionValid========>'+cmp.get("v.isLocLoanPortionValid"));
        
    },
    calculateApplicantLocPortionPay : function(cmp){
        var monthlyPay1=0;
        var monthlyPay2=0;
        var monthlyPay3=0;
        
        var totalPay =0;
        var count = cmp.get("v.ApplicantCount");
        if(count>=1){
            monthlyPay1=cmp.find("MinimumPayment1").get("v.value");
            if(monthlyPay1 !='')
                totalPay +=parseFloat(monthlyPay1);
        }
        if(count>=2){
            monthlyPay2=cmp.find("MinimumPayment2").get("v.value");
            if(monthlyPay2 !='')
                totalPay +=parseFloat(monthlyPay2);
        }
        if(count>=3){
            monthlyPay3=cmp.find("MinimumPayment3").get("v.value");
            if(monthlyPay3 !='')
                totalPay +=parseFloat(monthlyPay3);
        }
        
        console.log('totalPay=>'+totalPay);
        
        if(totalPay !=100){
            cmp.set("v.isLocPayPortionValid",true);           
        }
        else{
            cmp.set("v.isLocPayPortionValid",false);  
        }
        console.log('isLocPayPortionValid========>'+cmp.get("v.isLocPayPortionValid"));
    },
    GenerateMultiCalcPdf : function(cmp, event, helper){
        var leadOrOppId = cmp.get("v.recordId");
        console.log('leadOrOppId==>'+leadOrOppId);
        var loanid = cmp.get('v.retLoanCalcId');
        console.log('loanid==>'+loanid);
        helper.saveMultiCalcPdf(cmp,leadOrOppId,loanid);   
        console.log('loanid================>');
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/MultiProductCalculatorDoc?loanid='+loanid);
        
        
    },
    creditScoringAuto : function(cmp, event, helper){
        var oppid = cmp.get("v.isRecordIdM");
        console.log('oppid==>'+oppid);
        //var loanid = cmp.get('v.retLoanCalcId');
        //console.log('loanid==>'+loanid);
        //helper.saveMultiCalcPdf(cmp,leadOrOppId,loanid);   
        //console.log('loanid================>');
        var numberOfApplicant=cmp.get('v.ApplicantCount');
        var loanAmount='';
        
        var Total_Loan_Amount1='0'; 
        var Market_Value_of_Vehicle1='0';
        var Proposed_Starting_Limit1='0';
        var PC_Deposit_Account_Balance1='0';
        var	Line_of_Credit_Starting_Limit1='0';
        var PCL_Deposit_Account_Balance1='0'; 
        
        var acMethod = cmp.find("selectapplicant").get("v.value");
                console.log('--------------------------2=> '+acMethod);
                if(acMethod=='1' || acMethod=='5' || acMethod=='6' || acMethod=='7' || acMethod=='11' || acMethod=='12' || acMethod=='13' || acMethod=='15'){ //Auto Loan
                    console.log('--------------------------2.1=> ');
                    var RequestDataAuto=cmp.get("v.RDetailAuto");
                    console.log('--------------------------2.2=> '+RequestDataAuto);
                    if(RequestDataAuto.length>0){
                        console.log('--------------------------2.3=> ');
                        Total_Loan_Amount1 = RequestDataAuto[0].LoanAmount;
                    }
                    loanAmount= Total_Loan_Amount1;
                    Market_Value_of_Vehicle1 = cmp.find('MarketValueofVehicle1').get('v.value');
                    console.log('Total_Loan_Amount1---------'+Total_Loan_Amount1);
                    console.log('Market_Value_of_Vehicle1---------'+Market_Value_of_Vehicle1);
                }
                if(acMethod=='2' || acMethod=='5' || acMethod=='8' || acMethod=='9' || acMethod=='11' || acMethod=='12' || acMethod=='14' || acMethod=='15'){ //Unsecured Loan
                    
                }
                if(acMethod=='3' || acMethod=='6' || acMethod=='8' || acMethod=='10' || acMethod=='11' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Credit Card
                   /* var type = cmp.find("ccCollateralType").get("v.value");
                    switch(type){
                        case "1":
                            Proposed_Starting_Limit1 = cmp.find("ccStartingLimit").get("v.value");
                            PC_Deposit_Account_Balance1 = cmp.find("ccDepositAccountBalance").get("v.value");
                            console.log('Proposed_Starting_Limit1---------'+Proposed_Starting_Limit1);
                            console.log('PC_Deposit_Account_Balance1---------'+PC_Deposit_Account_Balance1);
                            break;
                    }*/
                }
                if(acMethod=='4' || acMethod=='7' || acMethod=='9' || acMethod=='10' || acMethod=='12' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Line of Credit
                   /* var type = cmp.find("locCollateralType").get("v.value");
                    switch(type){
                        case "0":
                            // For NONE
                            break;
                        case "1":
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            PCL_Deposit_Account_Balance1  = cmp.find("locDepositAccountBalance").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1---------'+Line_of_Credit_Starting_Limit1);
                            console.log('PCL_Deposit_Account_Balance1---------'+PCL_Deposit_Account_Balance1);
                            break;
                        case "2":
                            //Real state
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1 RS---------'+Line_of_Credit_Starting_Limit1);
                            break;
                    }*/
                }
        
        if(Total_Loan_Amount1 =='undefined')
            Total_Loan_Amount1=0;
        if(Market_Value_of_Vehicle1 =='undefined')
            Market_Value_of_Vehicle1=0;
        if(Proposed_Starting_Limit1 =='undefined')
            Proposed_Starting_Limit1=0;
        if(PC_Deposit_Account_Balance1 =='undefined')
            PC_Deposit_Account_Balance1=0;
        if(Line_of_Credit_Starting_Limit1 =='undefined')
            Line_of_Credit_Starting_Limit1=0;
        if(PCL_Deposit_Account_Balance1 =='undefined')
            PCL_Deposit_Account_Balance1=0;
        
        
        
        var str ='?productName=Auto Loan&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid;
        str += '&Total_Loan_Amount='+Total_Loan_Amount1+'&marketValue='+Market_Value_of_Vehicle1;
        str += '&proposedStarting='+Proposed_Starting_Limit1+'&pcDeposit='+PC_Deposit_Account_Balance1;
        str += '&locStarting='+Line_of_Credit_Starting_Limit1+'&pclDeposit='+PCL_Deposit_Account_Balance1;
        
        console.log('Auto str======='+str);
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel'+str);
        
        
    },
    creditScoringUS : function(cmp, event, helper){
        var oppid = cmp.get("v.isRecordIdM");
        console.log('oppid==>'+oppid);
        //var loanid = cmp.get('v.retLoanCalcId');
        //console.log('loanid==>'+loanid);
        //helper.saveMultiCalcPdf(cmp,leadOrOppId,loanid);   
        //console.log('loanid================>');
        var numberOfApplicant=cmp.get('v.ApplicantCount');
        var loanAmount='';
        
        
        
        var Total_Loan_Amount1='0'; 
        var Market_Value_of_Vehicle1='0';
        var Proposed_Starting_Limit1='0';
        var PC_Deposit_Account_Balance1='0';
        var	Line_of_Credit_Starting_Limit1='0';
        var PCL_Deposit_Account_Balance1='0'; 
        
        var acMethod = cmp.find("selectapplicant").get("v.value");
                console.log('--------------------------2=> '+acMethod);
                if(acMethod=='1' || acMethod=='5' || acMethod=='6' || acMethod=='7' || acMethod=='11' || acMethod=='12' || acMethod=='13' || acMethod=='15'){ //Auto Loan
                    /*console.log('--------------------------2.1=> ');
                    var RequestDataAuto=cmp.get("v.RDetailAuto");
                    console.log('--------------------------2.2=> '+RequestDataAuto);
                    if(RequestDataAuto.length>0){
                        console.log('--------------------------2.3=> ');
                        Total_Loan_Amount1 = RequestDataAuto[0].LoanAmount;
                    }
                    Market_Value_of_Vehicle1 = cmp.find('MarketValueofVehicle1').get('v.value');
                    console.log('Total_Loan_Amount1---------'+Total_Loan_Amount1);
                    console.log('Market_Value_of_Vehicle1---------'+Market_Value_of_Vehicle1);*/
                }
                if(acMethod=='2' || acMethod=='5' || acMethod=='8' || acMethod=='9' || acMethod=='11' || acMethod=='12' || acMethod=='14' || acMethod=='15'){ //Unsecured Loan
                    var RDetailUnsecured='';
                    RDetailUnsecured=cmp.get("v.RDetailUnsecured");
                    
                    loanAmount = RDetailUnsecured[0].LoanAmount;
                }
                if(acMethod=='3' || acMethod=='6' || acMethod=='8' || acMethod=='10' || acMethod=='11' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Credit Card
                   /* var type = cmp.find("ccCollateralType").get("v.value");
                    switch(type){
                        case "1":
                            Proposed_Starting_Limit1 = cmp.find("ccStartingLimit").get("v.value");
                            PC_Deposit_Account_Balance1 = cmp.find("ccDepositAccountBalance").get("v.value");
                            console.log('Proposed_Starting_Limit1---------'+Proposed_Starting_Limit1);
                            console.log('PC_Deposit_Account_Balance1---------'+PC_Deposit_Account_Balance1);
                            break;
                    }*/
                }
                if(acMethod=='4' || acMethod=='7' || acMethod=='9' || acMethod=='10' || acMethod=='12' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Line of Credit
                   /* var type = cmp.find("locCollateralType").get("v.value");
                    switch(type){
                        case "0":
                            // For NONE
                            break;
                        case "1":
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            PCL_Deposit_Account_Balance1  = cmp.find("locDepositAccountBalance").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1---------'+Line_of_Credit_Starting_Limit1);
                            console.log('PCL_Deposit_Account_Balance1---------'+PCL_Deposit_Account_Balance1);
                            break;
                        case "2":
                            //Real state
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1 RS---------'+Line_of_Credit_Starting_Limit1);
                            break;
                    }*/
                }
        
        if(Total_Loan_Amount1 =='undefined')
            Total_Loan_Amount1=0;
        if(Market_Value_of_Vehicle1 =='undefined')
            Market_Value_of_Vehicle1=0;
        if(Proposed_Starting_Limit1 =='undefined')
            Proposed_Starting_Limit1=0;
        if(PC_Deposit_Account_Balance1 =='undefined')
            PC_Deposit_Account_Balance1=0;
        if(Line_of_Credit_Starting_Limit1 =='undefined')
            Line_of_Credit_Starting_Limit1=0;
        if(PCL_Deposit_Account_Balance1 =='undefined')
            PCL_Deposit_Account_Balance1=0;
        
        var str ='?productName=Unsecured Loan&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid;
        str += '&Total_Loan_Amount='+Total_Loan_Amount1+'&marketValue='+Market_Value_of_Vehicle1;
        str += '&proposedStarting='+Proposed_Starting_Limit1+'&pcDeposit='+PC_Deposit_Account_Balance1;
        str += '&locStarting='+Line_of_Credit_Starting_Limit1+'&pclDeposit='+PCL_Deposit_Account_Balance1;
        
        console.log('UN str======='+str);
        
        
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel'+str);
        
        
    },
    creditScoringCC : function(cmp, event, helper){
        var oppid = cmp.get("v.isRecordIdM");
        console.log('oppid==>'+oppid);
        //var loanid = cmp.get('v.retLoanCalcId');
        //console.log('loanid==>'+loanid);
        //helper.saveMultiCalcPdf(cmp,leadOrOppId,loanid);   
        //console.log('loanid================>');
        var numberOfApplicant=cmp.get('v.ApplicantCount');
        var loanAmount='';
        
        
        
        
        
        
        
         var Total_Loan_Amount1='0'; 
        var Market_Value_of_Vehicle1='0';
        var Proposed_Starting_Limit1='0';
        var PC_Deposit_Account_Balance1='0';
        var	Line_of_Credit_Starting_Limit1='0';
        var PCL_Deposit_Account_Balance1='0'; 
        
        var acMethod = cmp.find("selectapplicant").get("v.value");
                console.log('--------------------------2=> '+acMethod);
                if(acMethod=='1' || acMethod=='5' || acMethod=='6' || acMethod=='7' || acMethod=='11' || acMethod=='12' || acMethod=='13' || acMethod=='15'){ //Auto Loan
                   /* console.log('--------------------------2.1=> ');
                    var RequestDataAuto=cmp.get("v.RDetailAuto");
                    console.log('--------------------------2.2=> '+RequestDataAuto);
                    if(RequestDataAuto.length>0){
                        console.log('--------------------------2.3=> ');
                        Total_Loan_Amount1 = RequestDataAuto[0].LoanAmount;
                    }
                    Market_Value_of_Vehicle1 = cmp.find('MarketValueofVehicle1').get('v.value');
                    console.log('Total_Loan_Amount1---------'+Total_Loan_Amount1);
                    console.log('Market_Value_of_Vehicle1---------'+Market_Value_of_Vehicle1);*/
                }
                if(acMethod=='2' || acMethod=='5' || acMethod=='8' || acMethod=='9' || acMethod=='11' || acMethod=='12' || acMethod=='14' || acMethod=='15'){ //Unsecured Loan
                    
                }
                if(acMethod=='3' || acMethod=='6' || acMethod=='8' || acMethod=='10' || acMethod=='11' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Credit Card
                    var type = cmp.find("ccCollateralType").get("v.value");
                    switch(type){
                        case "0":
                            Proposed_Starting_Limit1 = cmp.find("ccStartingLimit").get("v.value");
                            break;
                        case "1":
                            Proposed_Starting_Limit1 = cmp.find("ccStartingLimit").get("v.value");
                            PC_Deposit_Account_Balance1 = cmp.find("ccDepositAccountBalance").get("v.value");
                            console.log('Proposed_Starting_Limit1---------'+Proposed_Starting_Limit1);
                            console.log('PC_Deposit_Account_Balance1---------'+PC_Deposit_Account_Balance1);
                            break;
                    }
                    
                }
                if(acMethod=='4' || acMethod=='7' || acMethod=='9' || acMethod=='10' || acMethod=='12' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Line of Credit
                   /* var type = cmp.find("locCollateralType").get("v.value");
                    switch(type){
                        case "0":
                            // For NONE
                            break;
                        case "1":
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            PCL_Deposit_Account_Balance1  = cmp.find("locDepositAccountBalance").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1---------'+Line_of_Credit_Starting_Limit1);
                            console.log('PCL_Deposit_Account_Balance1---------'+PCL_Deposit_Account_Balance1);
                            break;
                        case "2":
                            //Real state
                            Line_of_Credit_Starting_Limit1 = cmp.find("loc_StartingLimit").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1 RS---------'+Line_of_Credit_Starting_Limit1);
                            break;
                    }*/
                }
        if(Total_Loan_Amount1 =='undefined')
            Total_Loan_Amount1=0;
        if(Market_Value_of_Vehicle1 =='undefined')
            Market_Value_of_Vehicle1=0;
        if(Proposed_Starting_Limit1 =='undefined')
            Proposed_Starting_Limit1=0;
        if(PC_Deposit_Account_Balance1 =='undefined')
            PC_Deposit_Account_Balance1=0;
        if(Line_of_Credit_Starting_Limit1 =='undefined')
            Line_of_Credit_Starting_Limit1=0;
        if(PCL_Deposit_Account_Balance1 =='undefined')
            PCL_Deposit_Account_Balance1=0;
        loanAmount =Proposed_Starting_Limit1; 
        
        var str ='?productName=Credit Card&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid;
        str += '&Total_Loan_Amount='+Total_Loan_Amount1+'&marketValue='+Market_Value_of_Vehicle1;
        str += '&proposedStarting='+Proposed_Starting_Limit1+'&pcDeposit='+PC_Deposit_Account_Balance1;
        str += '&locStarting='+Line_of_Credit_Starting_Limit1+'&pclDeposit='+PCL_Deposit_Account_Balance1;
        
        
        console.log('CC str======='+str);
        
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel'+str);
        
        
        
       // window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel?productName=Credit Card&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid);
        
        
    },
    creditScoringLoc : function(cmp, event, helper){
        var oppid = cmp.get("v.isRecordIdM");
        console.log('oppid==>'+oppid);
        //var loanid = cmp.get('v.retLoanCalcId');
        //console.log('loanid==>'+loanid);
        //helper.saveMultiCalcPdf(cmp,leadOrOppId,loanid);   
        //console.log('loanid================>');
        var numberOfApplicant=cmp.get('v.ApplicantCount');
        var loanAmount='';
        
        
        var Total_Loan_Amount1='0'; 
        var Market_Value_of_Vehicle1='0';
        var Proposed_Starting_Limit1='0';
        var PC_Deposit_Account_Balance1='0';
        var	Line_of_Credit_Starting_Limit1='0';
        var PCL_Deposit_Account_Balance1='0'; 
        
        var acMethod = cmp.find("selectapplicant").get("v.value");
                console.log('--------------------------2=> '+acMethod);
                if(acMethod=='1' || acMethod=='5' || acMethod=='6' || acMethod=='7' || acMethod=='11' || acMethod=='12' || acMethod=='13' || acMethod=='15'){ //Auto Loan
                    /*console.log('--------------------------2.1=> ');
                    var RequestDataAuto=cmp.get("v.RDetailAuto");
                    console.log('--------------------------2.2=> '+RequestDataAuto);
                    if(RequestDataAuto.length>0){
                        console.log('--------------------------2.3=> ');
                        Total_Loan_Amount1 = RequestDataAuto[0].LoanAmount;
                    }
                    Market_Value_of_Vehicle1 = cmp.find('MarketValueofVehicle1').get('v.value');
                    console.log('Total_Loan_Amount1---------'+Total_Loan_Amount1);
                    console.log('Market_Value_of_Vehicle1---------'+Market_Value_of_Vehicle1);*/
                }
                if(acMethod=='2' || acMethod=='5' || acMethod=='8' || acMethod=='9' || acMethod=='11' || acMethod=='12' || acMethod=='14' || acMethod=='15'){ //Unsecured Loan
                    
                }
                if(acMethod=='3' || acMethod=='6' || acMethod=='8' || acMethod=='10' || acMethod=='11' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Credit Card
                   /* var type = cmp.find("ccCollateralType").get("v.value");
                    switch(type){
                        case "1":
                            Proposed_Starting_Limit1 = cmp.find("ccStartingLimit").get("v.value");
                            PC_Deposit_Account_Balance1 = cmp.find("ccDepositAccountBalance").get("v.value");
                            console.log('Proposed_Starting_Limit1---------'+Proposed_Starting_Limit1);
                            console.log('PC_Deposit_Account_Balance1---------'+PC_Deposit_Account_Balance1);
                            break;
                    }*/
                }
                if(acMethod=='4' || acMethod=='7' || acMethod=='9' || acMethod=='10' || acMethod=='12' || acMethod=='13' || acMethod=='14' || acMethod=='15'){//Line of Credit
                    var type = cmp.find("locCollateralType").get("v.value");
                    switch(type){
                        case "0":
                            Line_of_Credit_Starting_Limit1 = cmp.find("locStartingLimit").get("v.value");
                            break;
                        case "1":
                            Line_of_Credit_Starting_Limit1 = cmp.find("locStartingLimit").get("v.value");
                            PCL_Deposit_Account_Balance1  = cmp.find("locDepositAccountBalance").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1---------'+Line_of_Credit_Starting_Limit1);
                            console.log('PCL_Deposit_Account_Balance1---------'+PCL_Deposit_Account_Balance1);
                            break;
                        case "2":
                            //Real state
                            Line_of_Credit_Starting_Limit1 = cmp.find("locStartingLimit").get("v.value");
                            console.log('Line_of_Credit_Starting_Limit1 RS---------'+Line_of_Credit_Starting_Limit1);
                            
                            break;
                    }
                    
                }
        
        if(Total_Loan_Amount1 =='undefined')
            Total_Loan_Amount1=0;
        if(Market_Value_of_Vehicle1 =='undefined')
            Market_Value_of_Vehicle1=0;
        if(Proposed_Starting_Limit1 =='undefined')
            Proposed_Starting_Limit1=0;
        if(PC_Deposit_Account_Balance1 =='undefined')
            PC_Deposit_Account_Balance1=0;
        if(Line_of_Credit_Starting_Limit1 =='undefined')
            Line_of_Credit_Starting_Limit1=0;
        if(PCL_Deposit_Account_Balance1 =='undefined')
            PCL_Deposit_Account_Balance1=0;
        
        
        loanAmount = Line_of_Credit_Starting_Limit1;
        
        var str ='?productName=Line of Credit&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid;
        str += '&Total_Loan_Amount='+Total_Loan_Amount1+'&marketValue='+Market_Value_of_Vehicle1;
        str += '&proposedStarting='+Proposed_Starting_Limit1+'&pcDeposit='+PC_Deposit_Account_Balance1;
        str += '&locStarting='+Line_of_Credit_Starting_Limit1+'&pclDeposit='+PCL_Deposit_Account_Balance1;
        
        console.log('LOC str======='+str);
        
        
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel'+str);
        
        
        
       // window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditScoringModel?productName=Line of Credit&numberOfApplicant='+numberOfApplicant+'&loanAmount='+loanAmount+'&oppid='+oppid);
        
        
    },
    CreditCalclationsDoc: function(cmp, event, helper){
        var oppid = cmp.get("v.isRecordIdM");
        window.open('https://jnbank--jnbanksan.lightning.force.com/apex/CreditCalculations?oppid='+oppid);
    },
    
    
    
})