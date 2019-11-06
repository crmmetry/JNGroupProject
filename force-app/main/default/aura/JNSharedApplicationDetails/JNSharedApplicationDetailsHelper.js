({
    getApplicant: function(component) {
        let action = component.get("c.getApplicantDetails");
        action.setParams({
            applicantId: component.get("v.applicantId")
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const data = response.getReturnValue();
                component.set("v.applicant", data['applicant']);
                component.set("v.employment", data['employment']);
            } else {
                console.info(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    updateApplicant: function(component) {
        let action = component.get("c.updateApplicantDetails");
        action.setParams({
            "applicant": component.get("v.applicant"),
            "employment": component.get("v.employment"),
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.applicant", response.getReturnValue());
            } else {
                console.info(response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    validateFields: function(component) {
        return component.find("validation").reduce(function(validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
    },
    getPickListValues: function(component) {
        const action = component.get("c.getMultiPickListValuesList");
        action.setParams({
            objectApiNames: ["Applicant__c","FinServ__Employment__c"],
            fieldApiNames: [
                "CRIF_Rating__c",
                "CreditInfo_Rating__c",
                "Judgements_Filed__c",
                "Lawsuits_or_Claims__c",
                "Affiliation_Type__c",
                "Primary_Relationship_Tier__c",
                "Sanction_Screening_Completed__c",
                "JN_Group_Employee__c",
                "Credit_History_in_last_24_Months__c",
                "Assessment_of_Applicant_Net_Worth__c",
                "Bankrupt_in_Last_7_Years__c",
                "Is_applicant_KYC_Compliant__c",
                "Assessment_of_Business__c",
                "Assessment_of_Statement__c",
                "Assessment_of_Business_Working_Capita__c"
            ]
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === "SUCCESS") {
                const mappedList = response.getReturnValue();
                console.log(mappedList)
                component.set("v.crifRatings", mappedList["CRIF_Rating__c"]);
                component.set("v.creditInfoRatings", mappedList["CreditInfo_Rating__c"]);
                component.set("v.judgementsFiled", mappedList["Judgements_Filed__c"]);
                component.set("v.lawsuitsorClaims", mappedList["Lawsuits_or_Claims__c"]);
                component.set("v.affiliationTypes", mappedList["Affiliation_Type__c"]);
                component.set("v.primaryRelationshipTiers", mappedList["Primary_Relationship_Tier__c"]);
                component.set("v.sanctionScreenings", mappedList["Sanction_Screening_Completed__c"]);
                component.set("v.creditHistory24Months", mappedList["Credit_History_in_last_24_Months__c"]);
                component.set("v.assessmentApplicantNetWorth", mappedList["Assessment_of_Applicant_Net_Worth__c"]);
                component.set("v.bankruptLast7Years", mappedList["Bankrupt_in_Last_7_Years__c"]);
                component.set("v.KYCCompliants", mappedList["Is_applicant_KYC_Compliant__c"]);
				component.set("v.JNGroupEmployee", mappedList["JN_Group_Employee__c"]);
				component.set("v.assessmentofBusinesses", mappedList["Assessment_of_Business__c"]);
				component.set("v.assessmentofStatements", mappedList["Assessment_of_Statement__c"]);
				component.set("v.AssessmentofBusinessWorkingCapitas", mappedList["Assessment_of_Business_Working_Capita__c"]);

            } else {
            }
        });
        $A.enqueueAction(action);
    },
});