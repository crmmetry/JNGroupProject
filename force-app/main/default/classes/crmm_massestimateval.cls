public class crmm_massestimateval {
	
    public static void autofillEst(){
        		List<lead> estLead  =  [select Estimated_Amount__c  from Lead where Estimated_Amount__c =null];
        for(Lead estL:estLead){
            estL.Estimated_Amount__c = Integer.valueof((Math.random() * 10000000));
        }
        update estLead;
    }
}