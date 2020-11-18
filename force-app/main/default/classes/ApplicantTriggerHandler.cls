public class ApplicantTriggerHandler {
  private static String Tag = 'ApplicantTriggerHandler';
  private static List<Applicant__c> newRecords;
  private static List<Applicant__c> oldRecords;
  private static Map<Id, Applicant__c> oldMap;
  private static Map<Id, Applicant__c> newMap;
  public static void init(
    List<Applicant__c> newRecords,
    Map<Id, Applicant__c> oldMap,
    Map<Id, Applicant__c> newMap,
    List<Applicant__c> oldRecords
  ) {
    ApplicantTriggerHandler.newRecords = newRecords;
    ApplicantTriggerHandler.oldMap = oldMap;
    ApplicantTriggerHandler.newMap = newMap;
    ApplicantTriggerHandler.oldRecords = oldRecords;
  }

  public static void maximumApplicantsOpportunity() {
    if (!Util.IsExecuted('maximumApplicantsOpportunity')) {
      String err = 'You are only allowed to add three (3) applicants to an Opportunity. Please delete a current applicant before adding this new applicant."';
      List<Id> ids = new List<Id>();

      Map<Id, Integer> mappedOpp = new Map<Id, Integer>();

      for (Applicant__c app : newRecords) {
        ids.add(app.Opportunity__c);
      }

      AggregateResult[] results = [
        SELECT COUNT(Account__c) total, Opportunity__c currentId
        FROM Applicant__c
        WHERE Opportunity__c IN :ids
        GROUP BY Opportunity__c
      ];

      for (AggregateResult result : results) {
        Integer total = Integer.valueOf(result.get('total'));
        mappedOpp.put((Id) result.get('currentId'), total);
      }

      for (Applicant__c app : newRecords) {
        Integer count = mappedOpp.get(app.Opportunity__c);
        if (count != null) {
          if (count >= 3) {
            app.addError(err);
          }
        }
      }
    }
  }
  public static void setOverallCreditRating() {
    String veryLowRisk = 'Very Low Risk';
    String lowRisk = 'Low Risk';
    String averageRisk = 'Average Risk';
    String veryHighRisk = 'Very High Risk';
    String scoreLow = 'Score too low to rate';
    String newApplicant = 'Applicant too new to rate';
    String highRisk = 'High Risk';
    for (Applicant__c record : newRecords) {
      if (
        record.CRIF_Rating__c != null &&
        record.CreditInfo_Rating__c != null
      ) {
        if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = veryLowRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == veryLowRisk &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == lowRisk &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == averageRisk &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == averageRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == averageRisk &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == averageRisk &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == averageRisk &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == highRisk &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == veryHighRisk &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = veryHighRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == scoreLow &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == veryLowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == lowRisk
        ) {
          record.Overall_Rating__c = lowRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == averageRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == highRisk
        ) {
          record.Overall_Rating__c = averageRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == veryHighRisk
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == scoreLow
        ) {
          record.Overall_Rating__c = highRisk;
        } else if (
          record.CRIF_Rating__c == newApplicant &&
          record.CreditInfo_Rating__c == newApplicant
        ) {
          record.Overall_Rating__c = averageRisk;
        }
      }
    }
  }
}
