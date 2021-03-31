/**
 * @description       :
 * @author            : Remario Richards
 * @group             :
 * @last modified on  : 03-31-2021
 * @last modified by  : Remario Richards
 * Modifications Log
 * Ver   Date         Author             Modification
 * 1.0   03-31-2021   Remario Richards   Initial Version
 **/
public class OpportunityTriggerHandler {
  private static String Tag = 'OpportunityTriggerHandler';
  private static List<Opportunity> newRecords;
  private static Map<Id, Opportunity> oldMap;
  private static Map<Id, Opportunity> newMap;
  private static Map<Id, Opportunity> mappedRecords;
  private static boolean FirstRun = true;
  private static Map<String, String> excludedFields = new Map<String, String>{
    'Id' => 'Id',
    'IsDeleted' => 'IsDeleted',
    'CreatedById' => 'CreatedDate',
    'LastModifiedById' => 'LastModifiedById',
    'LastModifiedDate' => 'SystemModstamp'
  };
  public static void init(
    List<Opportunity> newRecords,
    Map<Id, Opportunity> oldMap,
    Map<Id, Opportunity> newMap
  ) {
    OpportunityTriggerHandler.newRecords = newRecords;
    OpportunityTriggerHandler.oldMap = oldMap;
    OpportunityTriggerHandler.newMap = newMap;
  }

  public static void setOpportunityAmountOnLead(
    Boolean isAfter,
    Boolean isUpdate,
    Boolean isInsert
  ) {
    // can only execute only per execution context
    if (!Util.IsExecuted('setOpportunityAmountOnLead')) {
      Set<id> oppid = new Set<id>();
      Map<id, Double> oppMap = new Map<id, Double>();
      String oppsID;
      Double oppAMT;
      system.debug('Trigger called=====================>');
      if (isAfter) {
        if (isInsert) {
          for (Opportunity opp : newRecords) {
            if (opp.StageName == 'Closed Won') {
              oppid.add(opp.ID);
              oppMap.put(opp.id, opp.Amount);
              oppsID = opp.ID;
              oppAMT = opp.Amount;
            }
          }
        }
        if (isUpdate) {
          system.debug('oppid=====================>' + Trigger.new);
          for (Opportunity opp : newRecords) {
            Opportunity oppOld = oldMap.get(opp.id);
            if (
              (oppOld.StageName != opp.StageName &&
              opp.StageName == 'Closed Won')
            ) {
              oppid.add(opp.ID);
              oppMap.put(opp.id, opp.Amount);
              oppsID = opp.ID;
              oppAMT = opp.Amount;
            }
          }
        }
        system.debug('oppid=====>' + oppid);

        if (oppAMT > 0) {
          List<Lead> lstlead = [
            SELECT
              id,
              Actual_Amount_From_Opportunity__c,
              Opportunity__c,
              ConvertedAccountId
            FROM lead
            WHERE
              ConvertedAccountId IN (
                SELECT accountId
                FROM opportunity
                WHERE Id = :oppsID
              )
          ];
          if (lstlead.size() > 0) {
            for (lead l : lstlead) {
              l.Actual_Amount_From_Opportunity__c = oppAMT;
            }
            update lstlead;
            system.debug('lstlead=====>' + lstlead);
          }
        }
      }
    }
  }
  public static void assignOpportunityRecordTypeName() {
    List<Id> ids = new List<Id>();
    Boolean match = false;
    String recordTypeName = '';
    for (Opportunity opp : newRecords) {
      ids.add(opp.AccountId);
    }
    Map<Id, Account> accountMap = new Map<Id, Account>(
      [SELECT Name FROM Account WHERE Id IN :ids]
    );

    for (Opportunity opp : newRecords) {
      recordTypeName = getRecordTypeDeveloperName(getRecordTypeName(opp));
      switch on recordTypeName {
        when 'Credit_Facility' {
          match = true;
        }
        when 'Mortgage' {
          match = true;
        }
        when 'Savings_Chequing' {
          match = true;
        }
      }
      if (match == true) {
        opp.Name =
          accountMap.get(opp.AccountId).Name +
          ' - ' +
          getRecordTypeName(opp);
        match = false;
      }
    }
  }
  public static void lockRecordsForEditing() {
    String errMsg = 'This record is currently LOCKED due to it being in the stage of "Closed Won" or "Closed Lost". Click Reactivate button to enable record edit.';
    List<String> changedFields = getChangedFields();
    Boolean lockClicked = Util.Some(changedFields, 'Record_Lock__c');
    for (Opportunity opp : newRecords) {
      // if lock is active, throw error preventing subsequent edits
      if (opp.Record_Lock__c && lockClicked == false) {
        opp.addError(errMsg);
      }
      if (
        (opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won') &&
        lockClicked == false
      ) {
        opp.Record_Lock__c = true;
      }
    }
  }
  private static String getRecordTypeName(Opportunity opp) {
    return Schema.SObjectType.Opportunity.getRecordTypeInfosById()
      .get(opp.recordTypeId)
      .getname();
  }
  private static String getRecordTypeDeveloperName(String name) {
    return Schema.SObjectType.Opportunity.getRecordTypeInfosByName()
      .get(name)
      .getDeveloperName();
  }
  public static void validateApplicantProfileCompletion() {
    if (!Util.IsExecuted('validateApplicantProfileCompletion')) {
      List<String> changedFields = getChangedFields();
      Map<Id, Opportunity> mappedRecords = new Map<Id, Opportunity>(newRecords);
      List<Applicant__c> applicants = [
        SELECT Id, Opportunity__c
        FROM Applicant__c
        WHERE Opportunity__c IN :mappedRecords.keySet()
      ];
      Map<Id, Applicant__c> mappedApplicants = new Map<Id, Applicant__c>(
        applicants
      );
      List<Application_Asset_Liability__c> applicantAssets = [
        SELECT Id
        FROM Application_Asset_Liability__c
        WHERE
          Application__c IN :mappedApplicants.keySet()
          AND Assets_and_Liabilities__c != NULL
      ];
      String err1 = 'You must complete the Create Application flow before selecting "Yes" for this field';
      String err2 = 'You must complete the Financial Information flow before selecting "Yes" for this field';

      for (Opportunity record : newRecords) {
        if (record.Loan_Path__c != null) {
          if (record.Loan_Path__c.equals('Complete Applicant Profile(s)')) {
            if (
              record.Personal_Details_Complete_PK__c != null &&
              record.Personal_Details_Complete_PK__c.equals('Yes') &&
              applicants.isEmpty()
            ) {
              record.Personal_Details_Complete_PK__c.addError(err1);
            }
            if (
              record.Financial_Information_Complete_PK__c != null &&
              record.Financial_Information_Complete_PK__c.equals('Yes') &&
              applicantAssets.isEmpty()
            ) {
              record.Financial_Information_Complete_PK__c.addError(err2);
            }
          }
        }
      }
    }
  }
  /**
   * validates if a opportunity can be closed given the close date
   * @param {integer} backdatedDays - the maximum number of (business)days in the previous month the close date can be backdated
   * @param {Integer} maxPrevDays - the maximum number of (business)days in the current month the close date can be backdated
   * @param {Date} now - represents the current date and time
   * @param {String} bh - business hours name
   * @return Void
   */
  public static void validateCloseBackDate(
    Integer backdatedDays,
    Integer maxPrevDays,
    Date now,
    String bhName
  ) {
    Map<Date, Holiday> mappedHolidays = Util.getHolidays();
    BusinessHours bh = Util.GetActiveBusinessHours(bhName);
    Date minDate = Date.newinstance(now.year(), now.month(), now.day());
    Date todayDate = Date.newinstance(now.year(), now.month(), now.day());
    Integer currentMonth = minDate.month();
    System.debug('M ' + minDate);
    minDate = Util.GetBackDatedDate(minDate, maxPrevDays, bh, mappedHolidays);
    System.debug('Min ' + minDate);
    for (Opportunity record : newRecords) {
      if (
        record.StageName == Constants.CLOSED_LOST_STATUS ||
        record.StageName == Constants.CLOSED_WON_STATUS
      ) {
        Date closeDate = Date.newinstance(
          record.CloseDate.year(),
          record.CloseDate.month(),
          record.CloseDate.day()
        );
        Integer closeDateMonth = record.CloseDate.month();
        if (Util.checkHoliday(closeDate, mappedHolidays)) {
          record.CloseDate.addError(Constants.CLOSE_DATE_ERR5);
        } else if (closeDate.year() < todayDate.year()) {
          record.CloseDate.addError(Constants.CLOSE_DATE_ERR4);
        } else {
          if (closeDate > todayDate) {
            // close date is greater than today
            record.CloseDate.addError(Constants.CLOSE_DATE_ERR3);
          } else if (closeDate < todayDate) {
            // close date month != current month
            if (closeDateMonth == currentMonth) {
              //check if closedate is less than maxPrevDays
              if (closeDate < minDate) {
                record.CloseDate.addError(Constants.CLOSE_DATE_ERR1);
              }
            } else {
              // close date is in previous month
              Date lastMonthDate = Date.newInstance(
                todayDate.year(),
                closeDateMonth,
                1
              );
              System.debug('Prev ' + Util.GetPrevMonthLastDay(lastMonthDate));
              Date acceptedDate = Util.GetBackDatedDate(
                Util.GetPrevMonthLastDay(lastMonthDate),
                backdatedDays,
                bh,
                mappedHolidays
              );
              System.debug(' acceptedDate ' + acceptedDate);
              if (closeDate < acceptedDate) {
                record.CloseDate.addError(Constants.CLOSE_DATE_ERR2);
              }
            }
          }
        }
      }
    }
  }

  public static List<String> getChangedFields() {
    List<String> changedFields = new List<String>();
    for (Opportunity opp : newRecords) {
      SObject o1 = oldMap.get(opp.id);
      SObject o2 = newMap.get(opp.Id);
      Map<String, Object> fieldList = o2.getPopulatedFieldsAsMap();
      for (String field : fieldList.keySet()) {
        if (!excludedFields.containsKey(field)) {
          Object v1 = o1.get(field);
          Object v2 = o2.get(field);
          if (Util.DidFieldChange(v1, v2)) {
            changedFields.add(field);
          }
        }
      }
    }
    return changedFields;
  }
  public static void ProductsFamiliyValidation() {
    if (!Util.IsExecuted('ProductsFamiliyValidation')) {
      OpportunityTriggerHandler.mappedRecords = new Map<Id, Opportunity>(
        newRecords
      );
      Opportunity updatedOpportunity;
      for (Opportunity newRecord : [
        SELECT Id, (SELECT Id, Product_Family__c FROM OpportunityLineItems)
        FROM Opportunity
        WHERE Id IN :newRecords
      ]) {
        Boolean autoLoan = false;
        Boolean lineOfCredit = false;
        Boolean unsecureLoan = false;
        Boolean creditCard = false;
        Boolean mortgage = false;
        Boolean savingsChequing = false;
        for (OpportunityLineItem lineItem : newRecord.OpportunityLineItems) {
          switch on lineItem.Product_Family__c {
            when 'JN Bank Auto Loan' {
              autoLoan = true;
            }
            when 'JN Bank Line Of Credit' {
              lineOfCredit = true;
            }
            when 'JN Bank Term Share Loan',
              'JN Bank Unsecured Loan',
              'JN Bank 12 to 1 Loan (Supersize Loan)' {
              unsecureLoan = true;
            }
            when 'JN Bank Credit Card' {
              creditCard = true;
            }
            when 'JN Bank Deposit Account' {
              savingsChequing = true;
            }
            when 'JN Bank Insurance Premium Financing',
              'JN Bank Cash Secured Loan',
              'JN Bank Commercial Auto Loan' {
              mortgage = true;
            }
          }
          if (lineItem.Product_Family__c.contains('JN Bank Mortgage')) {
            mortgage = true;
          }
        }
        updatedOpportunity = mappedRecords.get(newRecord.Id);
        if (autoLoan) {
          updatedOpportunity.Auto_Loan__c = true;
        } else {
          updatedOpportunity.Auto_Loan__c = false;
        }
        if (lineOfCredit) {
          updatedOpportunity.Line_Of_Credit__c = true;
        } else {
          updatedOpportunity.Line_Of_Credit__c = false;
        }
        if (unsecureLoan) {
          updatedOpportunity.Unsecure_Loan__c = true;
        } else {
          updatedOpportunity.Unsecure_Loan__c = false;
        }
        if (creditCard) {
          updatedOpportunity.Credit_Card__c = true;
        } else {
          updatedOpportunity.Credit_Card__c = false;
        }
        if (savingsChequing) {
          updatedOpportunity.Savings_and_Chequing__c = true;
        } else {
          updatedOpportunity.Savings_and_Chequing__c = false;
        }
        if (mortgage) {
          updatedOpportunity.Mortgage__c = true;
        } else {
          updatedOpportunity.Mortgage__c = false;
        }
      }
    }
  }
}
