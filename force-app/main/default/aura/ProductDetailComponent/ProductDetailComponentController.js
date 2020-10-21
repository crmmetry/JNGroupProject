({
    onProductChange: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
       console.log(selected);
    },
    
    onLoanPurposeChange: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
       console.log(selected);
    }
})
