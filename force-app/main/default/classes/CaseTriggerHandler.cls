/**
 * @description       :
 * @author            : Ishwari Gaikwad(Thinqloud)
 * @group             :
 * @last modified on  : 05-18-2021
 * @last modified by  : Ishwari Gaikwad(Thinqloud)
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   05-18-2021   Ishwari Gaikwad(Thinqloud)   Initial Version
 **/
public class CaseTriggerHandler {
  private static List<Case> newRecords;
  private static Map<Id, Case> oldMap;
  private static Map<Id, Case> newMap;

  public static void init(
    List<Case> newRecords,
    Map<Id, Case> oldMap,
    Map<Id, Case> newMap
  ) {
    CaseTriggerHandler.newRecords = newRecords;
    CaseTriggerHandler.oldMap = oldMap;
    CaseTriggerHandler.newMap = newMap;
  }

  /**
   * @description : When Case will be created assign entitlement record to it.
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  public static void addEntitlementToCase() {
    List<Entitlement> entitlementList = [
      SELECT Id, Name, AccountId
      FROM Entitlement
      WHERE Status = 'Active' AND Name = :Constants.ENTITLEMENT_RECORD_NAME
      WITH SECURITY_ENFORCED
    ];
    if (entitlementList.size() > 0) {
      for (Case cases : newRecords) {
        if (cases.EntitlementId == null) {
          cases.EntitlementId = entitlementList[0].Id;
        }
      }
    }
  }

  /**
   * @description : When application is reassigned in that case the milestone on case should be reset
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   **/
  public static void restartMilestone() {
    List<String> milestoneName = new List<string>();
    List<Id> caseIdList = new List<Id>();
    for (Case cases : newRecords) {
      if (
        cases.Status == Constants.ASSIGNED_STATUS &&
        oldMap.get(cases.Id).Status != cases.Status &&
        oldMap.get(cases.Id).Status != Constants.OPEN_STATUS
      ) {
        milestoneName.add(Constants.ADJUDICATOR_MILESTONE);
        caseIdList.add(cases.Id);
      }
      if (
        cases.Status == Constants.DEFERRED_STATUS &&
        oldMap.get(cases.Id).Status != cases.Status
      ) {
        milestoneName.add(Constants.ADJUDICATOR_MILESTONE);
        caseIdList.add(cases.Id);
      }
      if (
        cases.Status == Constants.ASSIGNED_STATUS &&
        oldMap.get(cases.Id).Status != cases.Status &&
        oldMap.get(cases.Id).Status != Constants.DEFERRED_STATUS
      ) {
        milestoneName.add(Constants.DEFERRAL_MILESTONE);
        caseIdList.add(cases.Id);
      }
      if (
        cases.Status == Constants.CLOSED_STATUS &&
        oldMap.get(cases.Id).Status != cases.Status
      ) {
        if (oldMap.get(cases.Id).Status == Constants.IN_PROGRESS_STATUS) {
          milestoneName.add(Constants.ADJUDICATOR_MILESTONE);
        } else if (oldMap.get(cases.Id).Status == Constants.DEFERRED_STATUS) {
          milestoneName.add(Constants.DEFERRAL_MILESTONE);
        }
        caseIdList.add(cases.Id);
      }
    }
    completeMilestone(caseIdList, milestoneName, DateTime.now());
  }

  /**
   * @description : Close the milestones attached to case
   * @author Ishwari Gaikwad(Thinqloud) | 05-18-2021
   * @param caseIds
   * @param milestoneName
   * @param completionDate
   **/
  private static void completeMilestone(
    List<Id> caseIds,
    list<String> milestoneName,
    DateTime completionDate
  ) {
    if (caseIds.size() > 0 && milestoneName.size() > 0) {
      List<CaseMilestone> cmsToUpdate = [
        SELECT Id, completionDate
        FROM CaseMilestone cm
        WHERE
          caseId IN :caseIds
          AND cm.MilestoneType.Name IN :milestoneName
          AND completionDate = NULL
        WITH SECURITY_ENFORCED
      ];
      if (cmsToUpdate.isEmpty() == false) {
        for (CaseMilestone cm : cmsToUpdate) {
          cm.completionDate = completionDate;
        }
        update cmsToUpdate;
      }
    }
  }
}
