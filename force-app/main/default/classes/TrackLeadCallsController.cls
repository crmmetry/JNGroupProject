public with sharing class TrackLeadCallsController implements Queueable {
    public void execute(QueueableContext context) {
       List<Lead> leads = [SELECT Id FROM Lead WHERE Disqualified_Flag = false AND Disqualified_Timestamp = null];       
    }
}
