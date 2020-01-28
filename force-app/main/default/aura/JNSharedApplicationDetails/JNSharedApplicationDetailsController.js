({
  doInit: function(component, event, helper) {
    helper.getPickListValues(component);
    helper.getApplicant(component);
    component.set("v.validate", function() {
      if (helper.validateFields(component)) {
        helper.updateApplicant(component);
        return { isValid: true };
      } else {
        return {isValid: false,  errorMessage: 'Please fill all the required fields on the page.' }
      }
    });
  },
  getCRIFRating: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.CRIF_Rating__c", selected);
  },
  getCreditInfoRating: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.CreditInfo_Rating__c", selected);
  },
  getCreditHistory24Months: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Credit_History_in_last_24_Months__c", selected);
  },
  getAssessmentNetworth: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Assessment_of_Applicant_Net_Worth__c", selected);
  },
  getJudgementsFiled: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Judgements_Filed__c", selected);
  },
  getBankrupt7Years: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Bankrupt_in_Last_7_Years__c", selected);
  },
  getLawsuitClaims: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Lawsuits_or_Claims__c", selected);
  },
  getKYCCompliant: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Is_applicant_KYC_Compliant__c", selected);
  },
  getAffiliationType: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Affiliation_Type__c", selected);
  },
  getPrimaryRelationshipType: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Primary_Relationship_Tier__c", selected);
  },
  getSanctionScreening: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Sanction_Screening_Completed__c", selected);
  },
  getJNGroupEmployee: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.JN_Group_Employee__c", selected);
  },
  getAssessmentofBusiness: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.employment.Assessment_of_Business__c", selected);
  },
  getAssessmentofStatement: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.employment.Assessment_of_Statement__c", selected);
  },
  getAssessmentofBusinessWorkingCapita: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.employment.Assessment_of_Business_Working_Capita__c", selected);
  },
  getSanctionScreeningResult: function(component, event, helper) {
    const selected = event.getSource().get("v.value");
    component.set("v.applicant.Sanction_Screening_has_Negative_Trace__c", selected);
  }
})