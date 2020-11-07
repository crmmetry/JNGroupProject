public class crmm_massestimateval {
  public static void autofillEst() {
    List<lead> estLead = [
      SELECT Estimated_Amount__c
      FROM Lead
      WHERE Estimated_Amount__c = NULL
    ];
    for (Lead estL : estLead) {
      estL.Estimated_Amount__c = Integer.valueof((Math.random() * 10000000));
    }
    update estLead;
  }
}
