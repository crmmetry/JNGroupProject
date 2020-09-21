public with sharing class LeadAssignmentSchedulable implements Schedulable {
  private BusinessHours businessHours;
  private Datetime currentTime;
  public LeadAssignmentSchedulable(
    String businessHoursName,
    Datetime currentTime
  ) {
    this.businessHours = Util.GetActiveBusinessHours(businessHoursName);
    this.currentTime = currentTime;
  }
  public LeadAssignmentSchedulable() {
    this.businessHours = Util.GetActiveBusinessHours(
      'JN Default Business Hours'
    );
    this.currentTime = System.now();
  }
  public void execute(SchedulableContext ctx) {
    if (BusinessHours.isWithin(this.businessHours.Id, currentTime) != null) {
      System.enqueueJob(new TrackLeadCallsController(this.businessHours));
    }
  }
}
