({
    validateForm : function(cmp) {
		cmp.set("v.requiredFields", []);
		let valids = [];
        const fields = {
           "AUTOLOANCRITERIA":["LoanPurpose","VehicleClassification","InterestedinJNGIProgramme"],
            "UNSECUREDLOANCRITERIA":["mygroup"],
            "CREDITCARDCRITERIA":["CollateralTypeCredit"],
            "LINEOFCREDITCRITERIA":["CollateralTypeLineofCredit","Ispropertystrata1"],
            
            "KYCCOMPLIANCESTATUS":["MembershipStatusApplicant"],
            "mycheckboxgroupkyc":["mygroupkyc"]
        };
        for (const field in fields) {
            const foundCmp = cmp.find(field);
            if(foundCmp && !$A.util.hasClass(foundCmp, "slds-hide")){
                // check validity for the fields
                const validComps = this.findComponents(cmp, fields[field]);
                const allValid = this.validateComponents(validComps);
                valids.push(allValid);
            }
        } 

        // APPLICANT SECTION
        let checkboxGroupapplicant = cmp.get("v.checkboxGroupValueapplicant");
        if(checkboxGroupapplicant.includes("Salaried")) {
            this.compileInValidatedComponents(cmp, ["Doesreceivepayslips"]);
            if(cmp.find("Doesreceivepayslips").get("v.value") == 1){
                this.compileInValidatedComponents(cmp, ["Isincomereflectedonthepayslip","mygrouppayslip"]);
            }
        } 
        const generalFields = ["Selectcombination","officerLocation","mygroupapp"];
        this.compileInValidatedComponents(cmp, generalFields);
        console.warn('pile',cmp.get("v.requiredFields"))
        for (const comp of this.findComponents(cmp, cmp.get("v.requiredFields"))) {
            valids.push(comp.get("v.validity").valid);            
            comp.showHelpMessageIfInvalid();
        }
        console.info(valids)
        return valids.reduce((validSoFar, current) => validSoFar && current, true);
    },
    findComponents: function (cmp, list) {
        return list.map(function (comp) {
            return cmp.find(comp);
        }).filter(function (comp) {
            return comp != null && !$A.util.hasClass(comp, "slds-hide")
        });
    },
    validateComponents: function (comps) {
        return comps.reduce(function (validSoFar, inputCmp) {
                          // Displays error messages for invalid fields
                          inputCmp.showHelpMessageIfInvalid();
                          return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
    },
    compileInValidatedComponents: function (cmp, fields) {
        let requiredFields = cmp.get("v.requiredFields");
        for (const field of fields) {
            requiredFields.push(field);
            console.info('pushing',field )
        }
        cmp.set("v.requiredFields", Array.from(new Set(requiredFields)));
    }
})
