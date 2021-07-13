trigger OneJNOutputEventTrigger on One_JN_Output__e (after insert) {
    for(One_JN_Output__e evt: Trigger.New) {
        List<String> documentList = new List<String>{'Last three (3) months\u2019 pay slips', 	
            'bank statements or negotiated cheques AND Pay slips for December of the last calendar year'};
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartObject();
        jsonGen.writeStringField('ApplicationID','TEST ' + Integer.valueof((Math.random() * 1000)));
        jsonGen.writeFieldName('ConsolidatedReport');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('FinalAssessmentReport', 'test');
        jsonGen.writeFieldName('GeneralInformation');
        jsonGen.writeStartObject();
        jsonGen.writeStringField('ApplicationID','TEST ' + Integer.valueof((Math.random() * 1000)));
        jsonGen.writeStringField('PreAssessmentDecision','Pass');
         if(evt.Name__c == Constants.SUBMIT_CREDIT_CARD_MANUAL_DECISION ){
            jsonGen.writeStringField('FinalAssessmentDecision','Approved');
         }
        else if(evt.Name__c == Constants.SUBMIT_UNSECURED_LOAN_MANUAL_DECISION ){
            jsonGen.writeStringField('FinalAssessmentDecision','Denied');
        }
        else if(evt.Name__c == Constants.GET_CREDITCARD_FINAL_ASSESSMENT || evt.Name__c == Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT){
            jsonGen.writeStringField('FinalAssessmentDecision','Referred');
        }
        jsonGen.writeEndObject();
        
        jsonGen.writeFieldName('ApplicantDetailsPrimary');
        jsonGen.writeStartObject();
        jsonGen.writeFieldName('DocumentRequirements');
        jsonGen.writeObject(documentList);
       // jsonGen.writeStartArray();
        //jsonGen.writeStartObject();
        //jsonGen.writeFieldName('Documents');
        
        //jsonGen.writeStringField('Documents', 'Last three (3) months’ pay slips OR bank statements OR negotiated cheques evidencing your salary and allowances');
        //jsonGen.writeEndObject();
        //jsonGen.writeStartObject();
        //jsonGen.writeStringField('Documents', 'Current Employment Letter inclusive of your salary and allowances');
       //jsonGen.writeEndObject();
       
        //jsonGen.writeEndArray();
        jsonGen.writeEndObject();
        jsonGen.writeEndObject();
        jsonGen.writeEndObject();
        String jsonData = jsonGen.getAsString(); 
        One_JN_Input__e requestPlatformEvent = new One_JN_Input__e();
        requestPlatformEvent.SfRecordId__c = evt.SfRecordId__c;
        requestPlatformEvent.Body__c = jsonData;
        requestPlatformEvent.ExternalId__c = '';
        
        if(evt.Name__c == Constants.GET_LOAN_APPLICATION_ID){
            requestPlatformEvent.Name__c = Constants.RETURN_LOAN_APPLICATION_ID;
        }else if(evt.Name__c == Constants.GET_CREDITCARD_PRE_ASSESSMENT){
            requestPlatformEvent.Name__c = Constants.RETURN_CREDITCARD_PRE_ASSESSMENT;
        }else if(evt.Name__c == Constants.GET_UNSECURED_LOAN_PRE_ASSESSMENT){
            requestPlatformEvent.Name__c = Constants.RETURN_UNSECURED_LOAN_PRE_ASSESSMENT;
        }
        else if(evt.Name__c ==Constants.SUBMIT_CREDIT_CARD_MANUAL_DECISION ){
            requestPlatformEvent.Name__c = Constants.RETURN_CREDIT_CARD_MANUAL_DECISION_RESPONSE;
        }
        else if(evt.Name__c ==Constants.SUBMIT_UNSECURED_LOAN_MANUAL_DECISION ){
            requestPlatformEvent.Name__c = Constants.RETURN_UNSECURED_LOAN_MANUAL_DECISION_RESPONSE;
        }
        else if(evt.Name__c ==Constants.GET_CREDITCARD_FINAL_ASSESSMENT ){
            requestPlatformEvent.Name__c = Constants.RETURN_CREDITCARD_FINAL_ASSESSMENT;
        }
        else if(evt.Name__c ==Constants.GET_UNSECURED_LOAN_FINAL_ASSESSMENT ){
            requestPlatformEvent.Name__c = Constants.RETURN_UNSECURED_LOAN_FINAL_ASSESSMENT;
        }
        Database.SaveResult result = EventBus.publish(requestPlatformEvent);
        if (result.isSuccess()) {
            System.debug('Input Platform event published successfully.');
        } else {
            for(Database.Error err : result.getErrors()) {
                System.debug('Input Error returned: ' + err.getStatusCode() );
            }
        }
        
    }
}