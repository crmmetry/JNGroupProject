public with sharing class ProductDetailController {
    @AuraEnabled
    public static String opportunityProductSelector (Id oppId, List<String> productSelections){
        System.debug('Controller');
        List<OpportunityLineItem> oppProducts = Util.getOpportunityProducts(oppId);
        if(oppProducts.size()>0){
        OpportunityLineItem opportunityProduct = oppProducts[0];
            for(String selection : productSelections){
                if(opportunityProduct.Product_Family__c.contains(selection)){
                    System.debug('Selection' + selection);
                    return selection;
                }
            }
        } 
        return 'No products found';
    }
    
}