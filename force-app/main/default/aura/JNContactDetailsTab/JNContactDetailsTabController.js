({
    doInit: function(component, event, helper) {
        const siteLead = {
            MobilePhone: "",
            Home_Phone__c: "",
            Business_Phone__c: "",
            Other_Number__c: "",
            Email: "",
            Other_Email__c: "",
            Street_1__c: "",
            Street_2__c: "",
            Street_3__c: "",
            City_Town__c: "",
            Residential_Area_District__c: "",
            Post_Office_Zip_Code__c: "",
            Province_Parish_State__c: "",
            Country__c: "Jamaica",
            Status_of_Address__c: "",
            Address_Type__c: "",
            Years_at_Residence__c: 0,
            Mailing_Street_1__c: "",
            Mailing_Street_2__c: "",
            Mailing_Street_3__c: "",
            Mailing_City_Town__c: "",
            Mailing_Residential_Area_District__c: "",
            Mailing_Post_Office_Zip_Code__c: "",
            Mailing_Province_Parish_State__c: "",
            Mailing_Country__c: "Jamaica",
            Mailing_Status_of_Address__c: "",
            Mailing_Address_Type__c: "",
            Mailing_Years_at_Residence__c: 0,
            Preferred_Contact_Method__c: ""
            
        };
        component.set("v.SiteLead", siteLead);
        helper.getPickListValues(component);
    },
    validateTabFields: function(component, event, helper) {
        return component.find("validation").reduce(function(validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
    },
    getCountry: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Country__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getCountryMailing: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Mailing_Country__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getAddressStatus: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Status_of_Address__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getPreferredContactMethod: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Preferred_Contact_Method__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getAddresstatusMailing: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Mailing_Status_of_Address__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getAddressType: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Address_Type__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    getAddressTypeMailing: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
        let siteLead = component.get("v.SiteLead");
        siteLead["Mailing_Address_Type__c"] = selected;
        component.set("v.SiteLead", siteLead);
    },
    setMailingAddress: function(component, event, helper) {
        let siteLead = component.get("v.SiteLead");
        const validKeys = {Street_1__c: "",
                           Street_2__c: "",
                           Street_3__c: "",
                           City_Town__c: "",
                           Residential_Area_District__c: "",
                           Post_Office_Zip_Code__c: "",
                           Province_Parish_State__c: "",
                           Country__c: "",
                           Status_of_Address__c: "",
                           Address_Type__c: "",
                           Years_at_Residence__c: ""}
        if(!component.get("v.shouldShow")){
            for (let key in siteLead){
                if(siteLead.hasOwnProperty(key) && validKeys.hasOwnProperty(key)){
                    if(!key.startsWith('Mailing')){
                        siteLead[`Mailing_${key}`] = siteLead[key];
                    } else {
                        break;
                    }
                }
            }
        }
    },
     createDetails: function(component, event, helper) {
         helper.updateApplicant(component);
     }
});