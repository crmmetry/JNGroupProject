public with sharing class LeadAssignmentSchedulable implements Schedulable {
  private BusinessHours businessHoursInstance;
  private Datetime currentTime;
  public LeadAssignmentSchedulable(
    String businessHoursName,
    Datetime currentTime
  ) {
    this.businessHoursInstance = Util.GetActiveBusinessHours(businessHoursName);
    this.currentTime = currentTime;
  }
  public LeadAssignmentSchedulable() {
    this.businessHoursInstance = Util.GetActiveBusinessHours(
      'JN Default Business Hours'
    );
    this.currentTime = System.now();
  }
  public void execute(SchedulableContext ctx) {
    if (BusinessHours.isWithin(this.businessHoursInstance.Id, currentTime)) {
      System.enqueueJob(
        new TrackLeadCallsController(this.businessHoursInstance)
      );
    }
  }
}
