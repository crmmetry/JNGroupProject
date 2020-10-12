({
    openModal : function(component, event, helper) {
        //find modal using aura id
         var modal = component.find("myModal");
         var modalBackdrop = component.find("myModal-Back");
     
        // Now add and remove class
         $A.util.addClass(modal, 'slds-fade-in-open');
         $A.util.addClass(modalBackdrop, 'slds-fade-in-open');
     },
     
     closeModal : function(component, event, helper) {
        //find modal using aura id
         var modal = component.find("myModal");
         var modalBackdrop = component.find("myModal-Back");
         
         // Now add and remove class
         $A.util.removeClass(modal, 'slds-fade-in-open');
         $A.util.removeClass(modalBackdrop, 'slds-backdrop_open');
     }
})
