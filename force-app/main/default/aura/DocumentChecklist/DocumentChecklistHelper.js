({
	validateForm : function(cmp) {
		const fields = {
			"AUTOLOANCRITERIA":["LoanPurpose","VehicleClassification","InterestedinJNGIProgramme"],
			"UNSECUREDLOANCRITERIA":["mygroup"],
			"CREDITCARDCRITERIA":["CollateralTypeCredit"],
			"LINEOFCREDITCRITERIA":["CollateralTypeLineofCredit","Ispropertystrata1"],
			"INCOMECRITERIA":["mygroupapp","Doesreceivepayslips","Isincomereflectedonthepayslip","mygrouppayslip"],
			"KYCCOMPLIANCESTATUS":["MembershipStatusApplicant"],
			"mycheckboxgroupkyc":["mygroupkyc"]
		};
		const generalFields = ["Selectcombination","officerLocation"];
		let valids = [];
		for (const field in fields) {
			const foundCmp = cmp.find(field);
			if(foundCmp && !$A.util.hasClass(foundCmp, "slds-hide")){
				// check validity for the fields
				const validComps = this.findComponents(cmp, fields[field]);
				const allValid = this.validateComponents(validComps);
				valids.push(allValid);
			}
		}
		for (const comp of this.findComponents(cmp, generalFields)) {
			valids.push(comp.get("v.validity").valid);
			comp.showHelpMessageIfInvalid();
		}
		
		return valids.reduce((validSoFar, current) => validSoFar && current, true);
	},
	findComponents: function (cmp, list) {
		return list.map(function (comp) {
			return cmp.find(comp);
		}).filter(function (comp) {
			return comp != null;
		});
	},
	validateComponents: function (comps) {
		return comps.reduce(function (validSoFar, inputCmp) {
					      // Displays error messages for invalid fields
						  inputCmp.showHelpMessageIfInvalid();
						  return validSoFar && inputCmp.get("v.validity").valid;
		}, true);
	}
})