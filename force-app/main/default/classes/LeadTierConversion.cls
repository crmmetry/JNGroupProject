global with sharing class LeadTierConversion implements Schedulable {
  public static final String TAG = 'LeadTierConversion';
  global LeadTierConversion() {
    //get Sales Development queue id
    Group salesDevQueue = [
      SELECT Id
      FROM Group
      WHERE Type = 'Queue' AND Name = 'Sales Development Team'
    ];
    //get Sales team queue id
    Group salesTeamQueue = [
      SELECT Id
      FROM Group
      WHERE Type = 'Queue' AND Name = 'Sales Team'
    ];
    //query leads that are tier 1 and not converted
    Map<Id, Lead> leads = new Map<Id, Lead>(
      [
        SELECT
          Id,
          Last_Contact_Made__c,
          OwnerId,
          Time_Escalated_tier_one__c,
          Status,
          Time_Escalated_to_Tier_2__c
        FROM Lead
        WHERE
          IsConverted = FALSE
          AND OwnerId IN (:salesDevQueue.Id, :salesTeamQueue.Id)
          AND LeadSource IN ('Online Application Form', 'Lead Portal')
      ]
    );
    //next get elapsed time
    Map<Id, Long> elapsedHours = new Map<Id, Long>();
    DateTime currentTimeStamp = DateTime.now();
    Map<String, Long> times;
    Set<id> leadsToUpdate = new Set<Id>();
    String tierOne5Uncontacted = '5 Days old';
    String tierOne24Uncontacted = 'Tier 1 - 24 Hours';
    String tierOne36Uncontacted = 'Tier 1 - 36 hours';
    String tierTwo24Uncontacted = 'Tier 2 - 24 Hours';
    String tierTwo36Uncontacted = 'Tier 2 - 36 Hours';
    List<Lead> leadsToConvert = new List<Lead>();
    String owner, salesDevId, salesTeamId;
    for (Lead record : leads.values()) {
      owner = String.valueOf(record.OwnerId);
      salesDevId = String.valueOf(salesDevQueue.Id);
      salesTeamId = String.valueOf(salesTeamQueue.Id);

      if (record.Time_Escalated_tier_one__c == null) {
        record.Time_Escalated_tier_one__c = record.CreatedDate; // update lead
        leadsToUpdate.add(record.Id);
      }
      if (record.Last_Contact_Made__c == null) {
        times = calculateTimeDiff(
          record.Time_Escalated_tier_one__c,
          currentTimeStamp
        );
        elapsedHours.put(record.Id, times.get('hours'));
      }
      if (record.Last_Contact_Made__c != null) {
        times = calculateTimeDiff(
          record.Time_Escalated_tier_one__c,
          currentTimeStamp
        );
        if (times.get('days') >= 5 && record.Status != 'Qualified') {
          record.Status = 'Disqualified';
          record.SLA_Violation__c = tierOne5Uncontacted;
          leadsToUpdate.add(record.Id);
        }
        if (record.Status == 'Qualified') {
          record.Escalate_to_Tier2__c = true;
          record.User_who_Converted__c = record.OwnerId;
          record.Time_Escalated_to_Tier_2__c = Datetime.now();
          record.Last_Contact_Made__c = null; //contact is not made yet
          leadsToUpdate.add(record.Id);
        }
      }
      if (record.Time_Escalated_to_Tier_2__c != null) {
        if (record.Last_Contact_Made__c != null) {
          leadsToConvert.add(record);
        } else {
          times = calculateTimeDiff(
            record.Time_Escalated_to_Tier_2__c,
            currentTimeStamp
          );
          // uncontacted
          if (times.get('hours') >= 36) {
            record.SLA_Violation__c = tierTwo36Uncontacted;
            leadsToUpdate.add(record.Id);
          } else if (times.get('hours') >= 24) {
            record.SLA_Violation__c = tierTwo24Uncontacted;
            leadsToUpdate.add(record.Id);
          }
        }
      }
    }
    // some leads were not contacted
    Lead record;
    if (elapsedHours.size() > 0) {
      Long elapsed;
      for (Id recordId : elapsedHours.keySet()) {
        record = leads.get(recordId);
        elapsed = elapsedHours.get(recordId);
        if (elapsed >= 36 && record.SLA_Violation__c == tierOne24Uncontacted) {
          record.SLA_Violation__c = tierOne36Uncontacted;
          leadsToUpdate.add(record.Id);
        } else if (elapsed >= 24) {
          record.SLA_Violation__c = tierOne24Uncontacted;
          leadsToUpdate.add(record.Id);
        }
      }
    }
    // convert leads
    convertLeads(leadsToConvert);
  }
  global void execute(SchedulableContext ctx) {
    //query leads here
  }

  private Map<String, Long> calculateTimeDiff(DateTime d1, DateTime d2) {
    Long dt1Long = d1.getTime();
    Long dt2Long = d2.getTime();
    Long milliseconds = dt2Long - dt1Long;
    Map<String, Long> times = new Map<String, Long>();
    times.put('seconds', milliseconds / 1000);
    times.put('minutes', times.get('seconds') / 60);
    times.put('hours', times.get('minutes') / 60);
    times.put('days', times.get('hours') / 24);
    return times;
  }

  private static void convertLeads(List<Lead> records) {
    List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
    for (Lead record : records) {
      if (!record.isConverted) {
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(record.id);
        lc.convertedStatus = 'Qualified';
        leadConverts.add(lc);
      }
    }

    Database.LeadConvertResult[] results = Database.convertLead(
      leadConverts,
      true
    );
    for (Database.LeadConvertResult result : results) {
      if (result.isSuccess()) {
        System.debug(TAG + ' Converted Account Id: ' + result.getAccountId());
        System.debug(TAG + ' Converted Contact Id: ' + result.getContactId());
        System.debug(
          TAG +
          ' Converted Opportunity Id: ' +
          result.getOpportunityId()
        );
      } else {
        for (Database.Error err : result.getErrors()) {
          System.debug(TAG + ' Fields affected ' + err.getFields());
          System.debug(TAG + ' Error Message ' + err.getMessage());
        }
      }
    }
  }
}
