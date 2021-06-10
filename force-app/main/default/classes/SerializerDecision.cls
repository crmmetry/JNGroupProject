/**
 * @description       : to decide serialization fields based on event type value
 * @author            : Trupti Zende (Thinqloud)
 * @group             : 
 * @last modified on  : 06-10-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log 
 * Ver   Date         Author                     Modification
 * 1.0   06-10-2021   Trupti Zende (Thinqloud)   Initial Version
**/
public class SerializerDecision {
    
    /**
    * @description Chnage serializer data based on event type value
    * @author Trupti Zende (Thinqloud) | 06-10-2021 
    * @param serialiser 
    * @param eventType 
    * @return Map<String, Object> 
    **/
    public static Map<String,Object> setSerializer(OneJNSerializer serialiser, String eventType){
        Map<String,Object> JSONToSerialize = new Map<String,Object>();
        
        if(eventType == Constants.GET_LOAN_APPLICATION_ID){
            JSONToSerialize.put('productType',serialiser.appData.productType);
            JSONToSerialize.put('rim',serialiser.applicant.rim);
        }else if(eventType == Constants.GET_MANUAL_DESICION_APPROVED || eventType == Constants.GET_MANUAL_DESICION_REJECT ){
            JSONToSerialize.put('applicationId',serialiser.appData.applicationId);
            JSONToSerialize.put('interestRate',serialiser.appData.interestRate);
            JSONToSerialize.put('tenure',serialiser.appData.tenure);
            JSONToSerialize.put('loanAmount',serialiser.appData.loanAmount);
            JSONToSerialize.put('rim',serialiser.applicant.rim);
            JSONToSerialize.put('adjudicationDecision',serialiser.appData.adjudicationDecision);
        }else{
            String SerializeObj = JSON.serialize(serialiser);
			JSONToSerialize =  (Map<String,Object>) JSON.deserializeUntyped(SerializeObj);
        }
        
        return JSONToSerialize;
    }
}