/**
 * @description       :
 * @author            : Trupti Zende (Thinqloud)
 * @group             :
 * @last modified on  : 06-03-2021
 * @last modified by  : Trupti Zende (Thinqloud)
 * Modifications Log
 * Ver   Date         Author                     Modification
 * 1.0   05-28-2021   Trupti Zende (Thinqloud)   Initial Version
 **/
trigger ContactContactTrigger on FinServ__ContactContactRelation__c(
  after insert,
  before delete
) {
  if (Util.canTriggerExecute()) {
    Set<Id> ids = new Set<Id>();
    List<FinServ__ContactContactRelation__c> records;
    if (Trigger.isDelete) {
      records = [
        SELECT Id, FinServ__Role__r.Name, FinServ__Contact__c
        FROM FinServ__ContactContactRelation__c
        WHERE Id IN :Trigger.Old
        WITH SECURITY_ENFORCED
      ];
      for (FinServ__ContactContactRelation__c record : records) {
        if (!record.FinServ__Role__r.Name.contains('Dependent')) {
          ids.add(record.FinServ__Contact__c);
          Util.affiliations.put(record.Id, true);
        }
      }
    } else {
      records = [
        SELECT Id, FinServ__Role__r.Name, FinServ__Contact__c
        FROM FinServ__ContactContactRelation__c
        WHERE Id IN :Trigger.New
        WITH SECURITY_ENFORCED
      ];
      for (FinServ__ContactContactRelation__c record : records) {
        if (!record.FinServ__Role__r.Name.contains('Dependent')) {
          ids.add(record.FinServ__Contact__c);
        }
      }
    }

    List<Account> accounts = [
      SELECT Id, PersonContactId
      FROM Account
      WHERE PersonContactId IN :ids
      WITH SECURITY_ENFORCED
    ];
    update accounts;
  }
}
