public with sharing class ProductDetailController {
    @AuraEnabled
    public static Object getSingleProductFamilySelection (Id oppId){
        System.debug('Controller');
        OpportunityLineItem oppProduct = Util.getOpportunityProducts(oppId);
        if(oppProduct != null){
            Wrappers.ProductSelectionWrapper selection = new Wrappers.ProductSelectionWrapper(oppProduct); 
            return selection;
        }  
        return 'None';
    }
    
}