({
    //CreditScoreController.js
	showhideONmethod: function(cmp, evt, helper){
        var acMethod = cmp.find("selectapplicant").get("v.value");
        switch(acMethod){
            case "0":

                
                break;
            case "1":
                 $A.util.removeClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.removeClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                
                break;
            case "2":
                $A.util.removeClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.removeClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                break;
            case "3":
                 $A.util.addClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.addClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                break;
            case "4":
                $A.util.removeClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.removeClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                
                break;
            case "5":
                $A.util.addClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.addClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                break;
            case "6":
                $A.util.addClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.addClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
                break;
            case "7":
                 $A.util.removeClass(cmp.find("PoliticallyExposedPerson"),"slds-hide");
                $A.util.removeClass(cmp.find("sanctionScreeningResultedInNegativeTrace"),"slds-hide");
                
              
                break;
            
            
           
            
           
            
           
        }
        
    },
    
    calculateCreditCardScore :function(cmp,evt,helper){
        console.log('Test============================1');
        var Empcategory = (cmp.find("EmployementType").get("v.value")=='1')?'Salaried':'Self-Employed';
        var Empage = helper.calculateAge(cmp.find("dob").get("v.value"));
        var edu = helper.Education(cmp.find("Education").get("v.value"));        
        var res = helper.ResidentialStatus(cmp.find("Residential").get("v.value"));
        var ResidenceYr = (cmp.find("YearsAtCurrentresidence").get("v.value")=='')?'0':cmp.find("YearsAtCurrentresidence").get("v.value");
        console.log('Test============================2');
        var CreditHis =cmp.find("CreditHistory").get("v.value");//helper.CreditHistory(cmp.find("CreditHistory").get("v.value"));
        var Net_Worth = helper.NetWorth(cmp.find("NetWorth").get("v.value"));
        var PoliticallyExposed = helper.PoliticallyExposedPerson(cmp.find("PoliticallyExposedPerson").get("v.value"));
        var sanctionTrace = helper.sanctionScreeningTrace(cmp.find("sanctionScreeningResultedInNegativeTrace").get("v.value"));
        console.log('Test============================3');
        var StatusOfEmployment = helper.EmploymentStatus(cmp.find("EmploymentStatus").get("v.value"));
        var IndustryofEmployment = helper.IndustryofEmployment(cmp.find("IndustryofEmployment").get("v.value"));
        var LengthofCurrentEmployment = cmp.find("LengthofCurrentEmployment").get("v.value");
        var Professional_Category = helper.ProfessionalCategory(cmp.find("ProfessionalCategory").get("v.value"));
        console.log('Test============================4');
        var CollateralType = helper.Collateral(cmp.find("Collateral").get("v.value"));
        var LoanValue = cmp.find("LoantoValue").get("v.value");
        var AbilityService = cmp.find("Abilitytoservice").get("v.value");
        var Repayment_Method = helper.RepaymentMethod(cmp.find("RepaymentMethod").get("v.value"));
        console.log('Test============================5');
        helper.GenrateScore(cmp,evt,helper,Empcategory,Empage,edu,res,ResidenceYr,CreditHis,Net_Worth,PoliticallyExposed,sanctionTrace,StatusOfEmployment,IndustryofEmployment,LengthofCurrentEmployment,Professional_Category,CollateralType,LoanValue,AbilityService,Repayment_Method);
    },
    SaveCreditScore :function(cmp,evt,helper){
        var action = cmp.get('c.SaveCreditScoreapex');
        action.setParams({
            AccountId : cmp.get("v.recordId"),
            Score : cmp.get("v.score"),
            });
        action.setCallback(this,function(response){
            var state = response.getState();
            var msg = response.getReturnValue();
            if(state=='SUCCESS'){
              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'The Credit Score Saved successfully.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire(); 
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
        });
        $A.enqueueAction(action);
    }
})