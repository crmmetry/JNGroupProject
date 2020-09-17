global with sharing class LeadAssignmentSchedulable implements Schedulable {
   private BusinessHours businessHours;
   private Datetime currentTime;
   global LeadAssignmentSchedulable(String businessHoursName, Datetime currentTime){
    this.businessHours = Util.GetActiveBusinessHours(businessHoursName);
    this.currentTime = currentTime;
   }
   global LeadAssignmentSchedulable(){
       this.businessHours = Util.GetActiveBusinessHours('JN Default Business Hours');
       this.currentTime = System.now();
   }
    global void execute(SchedulableContext ctx){
        if(BusinessHours.isWithin(this.businessHours.Id, currentTime) != null){
            //instantiate queueable here
        }
    }
}