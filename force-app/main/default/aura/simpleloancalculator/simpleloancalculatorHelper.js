({
    helperMethod : function() {
        
    }, 
    RoundTo: function( number, roundto){
        return roundto * Math.round(number/roundto);
    },  
    InstallmentPv: function(pmt,rate,term){
        //= [Monthly Interest Rate x Total Loan Amount]/[1 - (1 + Monthly Interest Rate)^(-1 x Total Loan Term)]
        
        console.log("Period by Mth "+term);
        console.log("Pmt  "+pmt);
        console.log("Rate  "+rate);
        return ((rate * pmt ) / (1-(Math.pow((1+rate), (-1*term)))));     
    },
    SpecialPv: function(pmt,rate,term){
        //= ((Minimum Payment Ceiling x (1-((1+Monthly Interest Rate)^(-1 x Total Loan Term))))/Monthly Interest Rate)
        console.log("Period by Mth "+term);
        console.log("Pmt  "+pmt);
        console.log("Rate  "+rate);
        return parseFloat((pmt * (1-(Math.pow(1+rate, (-1*term)))))/rate);     
    },
    round_to_precision: function (x, precision) {
        var y = +x + (precision === undefined ? 0.5 : precision/2);
        return y - (y % (precision === undefined ? 1 : +precision));
    },
    PV: function (rate, nper, pmt){ 
        //(Desired Monthly Payment) x (((1 - (1 ÷ ((1 + Monthly Interest Rate)^Total Loan Term))) ÷ Monthly Interest Rate)))
        console.log("rate:"+rate+",nper:"+nper+",pmt:"+pmt);
        nper = -1*nper;
        
        return parseFloat(pmt / rate * (1 - Math.pow(1 + rate, nper))); 
    },
    SetDefaultVal: function(obj,val=0){
        if(obj.get("v.value")){   
            obj.set("v.value",obj.get("v.value"));
            return true;
        }
        obj.set("v.value",val); 
        return true;
    },
    
    saveCalculation : function(component,calculatedData,radioGrpValue,event){
        console.log("SimpleLoanCalculationHelper:saveCalculation Called "+calculatedData +".......radioGrpValue==>"+radioGrpValue);
        var action = component.get("c.SaveLoanCalculation");
        action.setParams({      
            CalculationData: calculatedData,
            radioGrpName : radioGrpValue
        }); 
        var self = this;
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var msg = response.getReturnValue();
                console.log("msg = "+msg); 
                if(msg==="Save"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'The record has been saved successfully.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    if(radioGrpValue =="AffordabilityCalculator"){
                        console.log('-----------------');
                        this.clearAffordabilityFields(component,event);
                    }else if(radioGrpValue =="InstallmentPayment"){
                        this.clearInstallmentPaymentFields(component,event);
                    }else if(radioGrpValue =="RevolvingCreditLimitUnsecured"){
                        this.clearRevolvingCreditLimitUnsecuredFields(component,event);
                    }else if(radioGrpValue =="RevolvingCreditLimitSecured"){
                        this.clearRevolvingCreditLimitSecuredFields(component,event);
                    }       
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:msg,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
                
                
                
            }
            else if (state === "ERROR")  
            { 
                console.log(response.getReturnValue()); 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:'There are some error in saving the record.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        }); 
        $A.enqueueAction(action);          
        console.log("prob save2"); 
    },
    clearAffordabilityFields : function(component,event){
        console.log("clearAffordabilityFields clear"); 
        component.find("methodCalucaltion").set("v.value", 0);
        component.find("InterestRate").set("v.value",'');
        component.find("maximumLoanamt").set("v.value",'');
        component.find("loanTermMth").set("v.value",'');
        component.find("loanTermYr").set("v.value",'');
        component.find("desiredMonthly").set("v.value",'');
        component.find("existingMthlyPayment").set("v.value",'');
        component.find("GrossIncome").set("v.value",'');
        console.log("prob clear"); 
    },
     clearInstallmentPaymentFields : function(component,event){
        component.find("InterestRatePayment").set("v.value",'');
        component.find("loanTermYrPayment").set("v.value", '');
        component.find("loanTermMthPayment").set("v.value",'');
        component.find("loanAmtPayment").set("v.value",'');
        component.find("otherfinancingPayment").set("v.value",'');
        component.find("maximumLoanamtPayment").set("v.value",'');
    },
     clearRevolvingCreditLimitUnsecuredFields : function(component,event){
        component.find("productType").set("v.value",'');
        component.find("requestedlimitRCL").set("v.value", '');
        component.find("interestrateRCL").set("v.value",'');
        component.find("grossmonthlyincomeRCL").set("v.value",'');
        component.find("existingmonthlycreditpayment").set("v.value",'');
        component.find("totalmonthlyPaymentUnsecure").set("v.value",'');
    },
     clearRevolvingCreditLimitSecuredFields : function(component,event){
        component.find("prodTypeSecured").set("v.value",'');
         component.find("colleteral").set("v.value",'');
        component.find("requestedlimitRCLsecure").set("v.value", '');
        component.find("interestRateprocal").set("v.value",'');
        component.find("valueofSecurity").set("v.value",'');
        component.find("proposeStartingLimit").set("v.value",'');
        
    },
     clearFieldsFromMethodSelectionChange : function(component,event){
        console.log("clearAffordabilityFields clear"); 
        
        component.find("InterestRate").set("v.value",'');
        component.find("maximumLoanamt").set("v.value",'');
        component.find("loanTermMth").set("v.value",'');
        component.find("loanTermYr").set("v.value",'');
        component.find("desiredMonthly").set("v.value",'');
        component.find("existingMthlyPayment").set("v.value",'');
        component.find("GrossIncome").set("v.value",'');
        console.log("prob clear"); 
    }
})