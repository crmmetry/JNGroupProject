public with sharing class LeadAssignmentSchedulable implements Schedulable {
   private BusinessHours businessHours;
   public LeadAssignmentSchedulable(String businessHoursName){
    this.businessHours = Util.GetActiveBusinessHours(businessHoursName);
   }
   public LeadAssignmentSchedulable(){
       this.businessHours = Util.GetActiveBusinessHours('JN Default Business Hours');
   }
    public void execute(SchedulableContext ctx){
        Datetime currentTime = System.now();
        if(BusinessHours.isWithin(this.businessHours.Id, currentTime) != null){
            //instantiate queueable here
        }
    }
}
