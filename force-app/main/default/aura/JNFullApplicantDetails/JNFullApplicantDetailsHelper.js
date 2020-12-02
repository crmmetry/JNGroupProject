/**
 * Ver  Ticket#      Date            Author                 Purpose
 * 1.0  JN1-4045     2/12/2020      Ishwari G.(thinqloud)  bases on source of income showing fields
 **/
({
  getApplicant: function (component) {
    let action = component.get("c.getFullApplicantDetails");
    action.setParams({
      applicantId: component.get("v.applicantId")
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.applicant", response.getReturnValue());
        /*JN1-4030: START*/
        var applicant = response.getReturnValue();
        var source = applicant.Applicable_sources_of_income__c;
        var sourceOfIncome = [];
        if (source.includes(";")) {
          sourceOfIncome = source.split(";");
        } else {
          sourceOfIncome.push(applicant.Applicable_sources_of_income__c);
        }
        component.set("v.sourceOfIncome", sourceOfIncome);
        /*JN1-4030: END */
      } else {
        console.info(response.getError());
      }
    });
    $A.enqueueAction(action);
  },
  updateApplicant: function (component) {
    let action = component.get("c.updateApplicantDetails");
    console.info("current applicant", component.get("v.applicant"));
    /*JN1-4030: START*/
    var applicant = component.get("v.applicant");
    applicant.Applicable_sources_of_income__c = component
      .find("sourceOfIncome")
      .get("v.value");
    /*JN1-4030: END*/
    action.setParams({
      applicant: applicant
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.applicant", response.getReturnValue());
      } else {
        console.info(response.getError());
      }
    });
    $A.enqueueAction(action);
  },
  validateFields: function (component, event, helper) {
    return component.find("validation").reduce(function (validSoFar, inputCmp) {
      // Displays error messages for invalid fields
      inputCmp.showHelpMessageIfInvalid();
      return validSoFar && inputCmp.get("v.validity").valid;
    }, true);
  },
  getPickListValues: function (component) {
    const action = component.get("c.getPickListValuesList");
    action.setParams({
      objectApiName: "Applicant__c",
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
        "Is_applicant_KYC_Compliant__c"
      ]
    });
    action.setCallback(this, function (response) {
      const state = response.getState();
      if (state === "SUCCESS") {
        const mappedList = response.getReturnValue();
        console.log(mappedList);
        component.set("v.crifRatings", mappedList["CRIF_Rating__c"]);
        component.set(
          "v.creditInfoRatings",
          mappedList["CreditInfo_Rating__c"]
        );
        component.set("v.judgementsFiled", mappedList["Judgements_Filed__c"]);
        component.set(
          "v.lawsuitsorClaims",
          mappedList["Lawsuits_or_Claims__c"]
        );
        component.set("v.affiliationTypes", mappedList["Affiliation_Type__c"]);
        component.set(
          "v.primaryRelationshipTiers",
          mappedList["Primary_Relationship_Tier__c"]
        );
        component.set(
          "v.sanctionScreenings",
          mappedList["Sanction_Screening_Completed__c"]
        );
        component.set(
          "v.creditHistory24Months",
          mappedList["Credit_History_in_last_24_Months__c"]
        );
        component.set(
          "v.assessmentApplicantNetWorth",
          mappedList["Assessment_of_Applicant_Net_Worth__c"]
        );
        component.set(
          "v.bankruptLast7Years",
          mappedList["Bankrupt_in_Last_7_Years__c"]
        );
        component.set(
          "v.KYCCompliants",
          mappedList["Is_applicant_KYC_Compliant__c"]
        );
        component.set("v.JNGroupEmployee", mappedList["JN_Group_Employee__c"]);
      } else {
      }
    });
    $A.enqueueAction(action);
  }
});
