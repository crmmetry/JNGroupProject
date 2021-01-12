public class EmploymentTriggerHandler {
  private static String Tag = 'EmploymentTriggerHandler';
  private static List<FinServ__Employment__c> newRecords;
  private static List<FinServ__Employment__c> oldRecords;
  private static Map<Id, FinServ__Employment__c> oldMap;
  private static Map<Id, FinServ__Employment__c> newMap;
  public static void init(
    List<FinServ__Employment__c> newRecords,
    Map<Id, FinServ__Employment__c> oldMap,
    Map<Id, FinServ__Employment__c> newMap,
    List<FinServ__Employment__c> oldRecords
  ) {
    EmploymentTriggerHandler.newRecords = newRecords;
    EmploymentTriggerHandler.oldMap = oldMap;
    EmploymentTriggerHandler.newMap = newMap;
    EmploymentTriggerHandler.oldRecords = oldRecords;
  }

  /*public static void creditScoreOnEmployment(
    Boolean isDelete,
    Boolean isUpdate
  ) {
    if (!Util.IsExecuted('creditScoreOnEmployment')) {
      set<Id> oppIdSet = new Set<Id>();
      set<Id> accIdSet = new Set<Id>();
      if (isDelete) {
        for (FinServ__Employment__c emp : [
          SELECT id, account__c
          FROM FinServ__Employment__c
          WHERE Id = :oldRecords
        ]) {
          accIdSet.add(emp.account__c);
        }
        for (Opportunity opp : [
          SELECT id
          FROM Opportunity
          WHERE AccountId = :accIdSet
        ]) {
          oppIdSet.add(opp.Id);
        }
        for (Applicant__c app : [
          SELECT id, Opportunity__c
          FROM Applicant__c
          WHERE Account__c = :accIdSet
        ]) {
          oppIdSet.add(app.Opportunity__c);
        }
      }
      if (isUpdate) {
        for (FinServ__Employment__c emp : [
          SELECT id, account__c
          FROM FinServ__Employment__c
          WHERE Id = :newRecords
        ]) {
          accIdSet.add(emp.account__c);
        }
        for (Opportunity opp : [
          SELECT id
          FROM Opportunity
          WHERE AccountId = :accIdSet
        ]) {
          oppIdSet.add(opp.Id);
        }
        for (Applicant__c app : [
          SELECT id, Opportunity__c
          FROM Applicant__c
          WHERE Account__c = :accIdSet
        ]) {
          oppIdSet.add(app.Opportunity__c);
        }
      }
      system.debug('oppIdSet======' + oppIdSet);
      if (oppIdSet.size() > 0) {
        CreditScoreHelper cs = new CreditScoreHelper();
        cs.CreditScoreFromOpp(oppIdSet);
      }
    }
  }*/
  // makes sure only employment record can be current
  public static void checkCurrentEmployments() {
    if (!Util.IsExecuted('checkCurrentEmployments')) {
      String err = 'You can only have One Employment record marked as "Current Employment". Please update your employment records before proceeding';
      List<Id> ids = new List<Id>();
      for (FinServ__Employment__c emp : newRecords) {
        ids.add(emp.Account__c);
      }
      List<FinServ__Employment__c> results = [
        SELECT Id, Account__C, Current_Employment__c
        FROM FinServ__Employment__c
        WHERE Account__c IN :ids AND Current_Employment__c = TRUE
      ];
      System.debug('Results: ' + results);
      Map<Id, FinServ__Employment__c> mappedEmployment = new Map<Id, FinServ__Employment__c>();

      if (!results.isEmpty()) {
        for (FinServ__Employment__c employment : results) {
          mappedEmployment.put(employment.Account__c, employment);
        }

        FinServ__Employment__c record;
        for (FinServ__Employment__c employment : newRecords) {
          record = mappedEmployment.get(employment.Account__c);

          if (
            record != null &&
            employment.Current_Employment__c == true &&
            record.Id != employment.Id
          ) {
            System.debug(' EMP Id 1: ' + record.Id);
            System.debug(' EMP Id 1: ' + employment.Id);
            employment.addError(err);
          }
        }
      }
    }
  }
}
