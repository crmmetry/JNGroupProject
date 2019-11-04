({
	getPickListValues : function(component) {
		const action = component.get("c.getPickListValues");
        action.setParams({
            'objectApiName': 'Lead',
            'fieldApiName' : 'Supplementary_Applicant_Relationship__c'
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const values = response.getReturnValue();
               	component.set("v.applicantRelationships", values);                
            } else {
                
            }
        });
        $A.enqueueAction(action);
	}
})