public inherited sharing class DocumentChecklistController {
    @AuraEnabled
    Public static List<string> getLocationValues(){
        List<string> optionlist= new list<string>();
        Schema.DescribeFieldResult F = Lead.Preferred_Location__c.getDescribe();
        Schema.sObjectField T = F.getSObjectField();
        List<PicklistEntry> entries = T.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry pv : entries) {
            optionlist.add(pv.getValue());
        }
        optionlist.add('Choose one...');
        return optionlist;
    }
}
