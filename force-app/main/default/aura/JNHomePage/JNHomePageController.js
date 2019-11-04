({
    doInit: function(component, event, helper) {
        const appPageView = component.find("AppPageView");
        helper.addCss(appPageView, "dnone");        
    },
    toggleActiveService : function(component, event, helper) {
        const cardTypes = {
            'unsecured_loan': false,
            'credit_card': false,
        };
        
        const id = event.currentTarget.id;
        const toggleClass ="active";
        let cmpTarget = component.find(id);
        $A.util.toggleClass(cmpTarget, toggleClass);
        delete cardTypes[id];
        const has = $A.util.hasClass(cmpTarget, toggleClass);
        component.set("v.invalid", !has);
        for (const key in cardTypes){
            cmpTarget = component.find(key);
            if(has) {               
                $A.util.removeClass(cmpTarget, toggleClass);
            }           
        }
        component.set("v.loan_type", id);
    },
    navigateToComponent: function(component, event, helper) {
        const appPageView = component.find("AppPageView");
        const homePageView = component.find("HomePageView");
        helper.removeCss(appPageView, "dnone");
        helper.addCss(appPageView, "slds-transition-show");
        helper.addCss(homePageView, "dnone");
    },
    showHomePage: function(component, event, helper) {
        const eventAction = event.getParam("action");
        const eventComponent = event.getParam("component");
        if(eventComponent == 'JNHomePage') {
            if(eventAction == 'showHomePage') {
                const appPageView = component.find("AppPageView");
                const homePageView = component.find("HomePageView");
                helper.removeCss(homePageView, "dnone");
                helper.addCss(appPageView, "dnone");
                helper.addCss(appPageView, "slds-transition-show");
            }
        }        
    }
})