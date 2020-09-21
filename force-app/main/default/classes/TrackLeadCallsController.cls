public with sharing class TrackLeadCallsController implements Queueable {
  private static final String TAG = 'TrackLeadCallsController';
  private BusinessHours businessHours;
  public TrackLeadCallsController(BusinessHours businessHours) {
    this.businessHours = businessHours;
  }
  public void execute(QueueableContext context) {
    Map<Id, Lead> mappedLeadsToUpdate;
    List<Lead> leads = [
      SELECT Id, Assignment_Timestamp__c
      FROM Lead
      WHERE
        Disqualified_Flag__c = FALSE
        AND Disqualified_Timestamp__c = NULL
        AND Owner.Profile.Name = 'Call Centre - Sales'
    ];
    mappedLeadsToUpdate = updateDisqualifiedLeads(leads, System.now());
    try {
      if (!mappedLeadsToUpdate.isEmpty()) {
        update mappedLeadsToUpdate.values();
      }
    } catch (Exception e) {
      System.debug(TAG + ' ' + e.getMessage());
    }
  }

  private Map<Id, Lead> updateDisqualifiedLeads(
    List<Lead> leads,
    Datetime currentTime
  ) {
    Integer hours = 8;
    Map<Id, Lead> mappedLeads = new Map<Id, Lead>(leads);
    Map<Id, Lead> mappedDisqualifiedLeads = new Map<Id, Lead>();
    Map<Id, Lead> mappedLeadsWithTask = new Map<Id, Lead>();
    Boolean timeLimitExceeded;
    List<AggregateResult> aggregateResults = [
      SELECT Result__c, WhoId, count(Id) numberOfCalls
      FROM Task
      GROUP BY
        WhoId,
        Result__c

        HAVING
          WhoId IN :mappedLeads.keySet()
          AND Result__C IN ('No Contact', 'No Contact - Left Voicemail', NULL)
    ];
    for (AggregateResult record : aggregateResults) {
      Lead leadWithTask = mappedLeads.get((Id) record.get('WhoId'));
      mappedLeadsWithTask.put(leadWithTask.Id, leadWithTask);
      timeLimitExceeded = Util.LeadWithinTimeLimit(
        hours,
        leadWithTask.Assignment_Timestamp__c,
        currentTime,
        this.businessHours
      );
      if (timeLimitExceeded || (Integer) record.get('numberOfCalls') >= 3) {
        leadWithTask.Disqualified_Flag__c = true;
        leadWithTask.Disqualified_Timestamp__c = Datetime.now();
        mappedDisqualifiedLeads.put(leadWithTask.Id, leadWithTask);
      }
    }
    for (Id id : mappedLeads.keySet()) {
      if (!mappedLeadsWithTask.containsKey(id)) {
        Lead leadWithNoTask = mappedLeads.get(id);
        timeLimitExceeded = Util.LeadWithinTimeLimit(
          hours,
          leadWithNoTask.Assignment_Timestamp__c,
          currentTime,
          this.businessHours
        );
        if (timeLimitExceeded) {
          leadWithNoTask.Disqualified_Flag__c = true;
          leadWithNoTask.Disqualified_Timestamp__c = Datetime.now();
          mappedDisqualifiedLeads.put(leadWithNoTask.Id, leadWithNoTask);
        }
      }
    }
    return mappedDisqualifiedLeads;
  }
}
