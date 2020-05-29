({
    doInit : function(cmp, event, helper) {
        $A.util.addClass(cmp.find("payslipyes"),"slds-hide");
        $A.util.addClass(cmp.find("payslipyes1"),"slds-hide");
        $A.util.addClass(cmp.find("mycheckboxgroupkyc"),"slds-hide");
        $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
        $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
        $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
        $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
        $A.util.addClass(cmp.find("choosepayslip"),"slds-hide");
        $A.util.addClass(cmp.find("Ispropertystrata1"),"slds-hide");
        var action = cmp.get("c.getLocationValues");
        action.setCallback(this, function(response) {
                var Locations = response.getReturnValue();
            var state = response.getState();
                if (state === "SUCCESS") {
                     cmp.set("v.Locationoptions", Locations);
                } else if (state === "ERROR") {
                }
            });
            $A.enqueueAction(action);
            
    },
    showhideONSelectcombination: function(cmp, evt, helper){
        var acMethod = cmp.find("Selectcombination").get("v.value");
        switch(acMethod){
            case "0":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "1":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "3":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "4":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "5":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "6":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "7":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "8":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "9":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "10":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "11":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "12":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "13":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.addClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "14":
                $A.util.addClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
            case "15":
                $A.util.removeClass(cmp.find("AUTOLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("UNSECUREDLOANCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("CREDITCARDCRITERIA"),"slds-hide");
                $A.util.removeClass(cmp.find("LINEOFCREDITCRITERIA"),"slds-hide");
                break;
        }
        
    },
    OnChangeLoanPurpose: function(cmp, evt, helper){
        var acMethod = cmp.find("LoanPurpose").get("v.value");
        switch(acMethod){
            case "0":
                cmp.set("v.LoanPurposeNew", true);
                break;
            case "1":
                cmp.set("v.LoanPurposeNew", true);
                break;
            case "2":
                cmp.set("v.LoanPurposeUsed", true);
                cmp.set("v.LoanPurposeNew", false);
                break;
            case "3":
                cmp.set("v.LoanPurposeUsed", true);
                cmp.set("v.LoanPurposeNew", false);
                break;
        }
    },
    OnChangeCollateralTypeLOC: function(cmp, evt, helper){
        cmp.find("Ispropertystrata").set("v.value", '0');
        if(cmp.find("CollateralTypeLineofCredit").get("v.value")=='3'){
            $A.util.removeClass(cmp.find("Ispropertystrata1"),"slds-hide");
           
        } else
            $A.util.addClass(cmp.find("Ispropertystrata1"),"slds-hide");
        
    },
    OnChangeMembershipStatusApplicant: function(cmp, evt, helper){
        if(cmp.find("MembershipStatusApplicant").get("v.value")=='3')
            $A.util.removeClass(cmp.find("mycheckboxgroupkyc"),"slds-hide");
        else{
            $A.util.addClass(cmp.find("mycheckboxgroupkyc"),"slds-hide");
            cmp.set("v.checkboxGroupValuekyc" , '');
        }
    },
    checkboxGrouphandleChange: function(cmp, evt, helper){
        //alert(cmp.get("v.checkboxGroupValue"));
    },
    checkboxGrouphandleChangeApplicant: function(cmp, evt, helper){
        var checkboxGroupapplicant=cmp.get("v.checkboxGroupValueapplicant");

        if(checkboxGroupapplicant.includes("Salaried")) {
            $A.util.removeClass(cmp.find("choosepayslip"),"slds-hide"); 
            $A.enqueueAction(cmp.get("c.OnChangerecievepayslip"));   
        } else {
            $A.util.addClass(cmp.find("payslipyes"),"slds-hide");
            $A.util.addClass(cmp.find("payslipyes1"),"slds-hide");
            $A.util.addClass(cmp.find("choosepayslip"),"slds-hide");
        }            
        
    },
    checkboxGrouphandleChangepayslip: function(cmp, evt, helper){
        //alert(cmp.get("v.checkboxGroupValuepayslip"));
    },
    OnChangerecievepayslip: function(cmp, evt, helper){
        var acMethod = cmp.find("Doesreceivepayslips").get("v.value");
        switch(acMethod){
            case "0":
                $A.util.addClass(cmp.find("payslipyes"),"slds-hide");
                $A.util.addClass(cmp.find("payslipyes1"),"slds-hide");
                break;
            case "1":
                $A.util.removeClass(cmp.find("payslipyes"),"slds-hide");
                $A.util.removeClass(cmp.find("payslipyes1"),"slds-hide");
                break;
            case "2":
                $A.util.addClass(cmp.find("payslipyes"),"slds-hide");
                $A.util.addClass(cmp.find("payslipyes1"),"slds-hide");
                break;
                
        }
    },
    checkboxGrouphandleChangekyc: function(cmp, evt, helper){
        //alert(cmp.get("v.checkboxGroupValuekyc"));
    },
    downloadDocument: function(cmp, evt, helper){
        var appEvent = $A.get("e.c:DocumentCriteriaEvent1"); 
        //Set event attribute value
        appEvent.setParams({"message1" : "Welcome pavit"}); 
        appEvent.fire(); 
        
    },
    documentChecklistDoc: function(cmp, event, helper){
       const isNone = helper.validateCalateralType(cmp);
       let validForm = helper.validateForm(cmp);
        if(validForm == false){
			//show toast
			const toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"type":"error",
				"title": "Incomplete Information",
				"message": "Please complete all mandatory fields to generate a checklist!"
			});
			toastEvent.fire();
		} else {
            var ctarget = event.currentTarget;
            var id_str = ctarget.dataset.value;
            if(id_str=="Applicant"){
            var url='?incr='+cmp.get("v.checkboxGroupValueapplicant")+'&kycdone='+cmp.find("MembershipStatusApplicant").get("v.value")+'&kyc='+cmp.get("v.checkboxGroupValuekyc")+'&autolp='+cmp.find("LoanPurpose").get("v.value")+'&autovc='+cmp.find("VehicleClassification").get("v.value")+'&autoin='+cmp.find("InterestedinJNGIProgramme").get("v.value")+'&uns='+cmp.get("v.checkboxGroupValue")+'&credit='+cmp.find("CollateralTypeCredit").get("v.value")+'&loc='+cmp.find("CollateralTypeLineofCredit").get("v.value")+'&isloc='+cmp.find("Ispropertystrata").get("v.value")+'&payslip='+cmp.find("Doesreceivepayslips").get("v.value")+'&commision='+cmp.get("v.checkboxGroupValuepayslip")+'&location='+cmp.get("v.selectedValue")+'&isNone='+isNone;
            window.open(""+window.location.origin+"/apex/DocumentCriteriaApplicant"+url+""+"&CalType="+cmp.find("Selectcombination").get("v.value"));
            }
            else{    
            var url='?incr='+cmp.get("v.checkboxGroupValueapplicant")+'&kycdone='+cmp.find("MembershipStatusApplicant").get("v.value")+'&kyc='+cmp.get("v.checkboxGroupValuekyc")+'&autolp='+cmp.find("LoanPurpose").get("v.value")+'&autovc='+cmp.find("VehicleClassification").get("v.value")+'&autoin='+cmp.find("InterestedinJNGIProgramme").get("v.value")+'&uns='+cmp.get("v.checkboxGroupValue")+'&credit='+cmp.find("CollateralTypeCredit").get("v.value")+'&loc='+cmp.find("CollateralTypeLineofCredit").get("v.value")+'&isloc='+cmp.find("Ispropertystrata").get("v.value")+'&payslip='+cmp.find("Doesreceivepayslips").get("v.value")+'&commision='+cmp.get("v.checkboxGroupValuepayslip")+'&location='+cmp.get("v.selectedValue")+'&isNone='+isNone;
            window.open(""+window.location.origin+"/apex/DocumentCriteriaOfficer"+url+""+"&CalType="+cmp.find("Selectcombination").get("v.value"));
        }
   }
    },
})