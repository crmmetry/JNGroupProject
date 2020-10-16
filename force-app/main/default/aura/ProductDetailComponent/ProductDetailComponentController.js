({
    doinit: function(component, event, helper) {
        // let products = ['Auto', 'Unsecured Loan', 'Credit Card', 'Line of Credit'];
        // component.set('v.products');
        helper.updateProductSelection(component);
    },

    onLoanPurposeChange: function(component, event, helper) {
        const selected = event.getSource().get("v.value");
       console.log(selected);
    }
})
